open Data
open DataLib
open DataStructure

exception ENCLibParseError of string*string


let msg (str:string) = 
                print_string (str^"\n")
        
let error k msg =  raise (ENCLibParseError(k,msg))

type parse_state = {
        mutable record_id: int option;
        mutable dataset_info : dataset_info;
        mutable vector_info : vector_record_info; 
        geometry: (int,geom_entry) map;
        spatial_relations : (vector_type*int,geom_rel list) map;
}


module ENCParseLib = 
struct
       let init_state () : parse_state = 
                {
                        record_id = None;
                        dataset_info = DataLib.make_dataset_info ();
                        vector_info = DataLib.make_vector_info ();
                        geometry = MAP.make ();
                        spatial_relations = MAP.make();        
                }
        
        let upd_dataset (s:parse_state) (f:dataset_info->dataset_info) =
               s.dataset_info <- (f s.dataset_info)
 
        let upd_dataset_stats (s:parse_state) (f:dataset_stats->dataset_stats) =
               s.dataset_info.stats <- (f s.dataset_info.stats)
        
        let upd_dataset_coord_info (s:parse_state) (f:dataset_coord_info ->
                dataset_coord_info) = 
                s.dataset_info.coord_info <- (f s.dataset_info.coord_info)
        
        
        let upd_vector_record_info (s:parse_state) (f:vector_record_info ->
                vector_record_info) = 
                        stmt (s.vector_info <- f s.vector_info) ()

        let upd_lexical_levels (s:parse_state) (f:lexical_levels->lexical_levels) =
               s.dataset_info.lex <- (f s.dataset_info.lex)
        
        let make_dataset (s:parse_state) = 
                {info = s.dataset_info} 
        
        let set_record (s:parse_state) (i:int) = 
                let _ = s.record_id <- Some i in
                ()
        
        let to_hex x = 
                "0x"^x 
        
        let proc_coords (s:parse_state) x y z = 
                let cif = s.dataset_info.coord_info in
                let res = cif.compilation_scale in 
                let xf:float = (float_of_int x) /. (float_of_int cif.coord_mult_factor) in
                let yf:float = (float_of_int y) /. (float_of_int cif.coord_mult_factor) in
                let zf:float = (float_of_int z) /. (float_of_int cif.sound_mult_factor) in                
                match cif.coord_units with
                | CULatLong -> xf,yf,zf
                | CUEastNorth -> xf,yf,zf
                | CUUnitsOnChartMap -> xf,yf,zf
        
        
        
        let clear_vector_info (s) = 
                s.vector_info.op <- USUnknown;
                s.vector_info.typ <- VUnknown;
                s.vector_info.id <- -1;
                ()
                
        let commit_geom_rel (s:parse_state) (ptrs:geom_ptr) = 
                let id = s.vector_info.id in
                let dataset_kind = s.dataset_info.structure in 
                let commit key vl =
                        let arr = 
                                if MAP.has s.spatial_relations key 
                                then MAP.get s.spatial_relations key 
                                else []
                        in 
                        stmt (MAP.put s.spatial_relations key (vl::arr)) ()        
                in
                assert(id >= 0);
                let insert (id:int) ptr =
                        let ptr_type, ptr_id = ptr.ptr in  
                        match s.vector_info.typ with
                        | VIsolatedNode ->
                             begin
                                assert(ptr.topology = TIContainingFace);
                                assert(ptr_type = RVector(VFace));
                                let vl = GFIsolatedNode(id) in
                                let key = (VFace, id) in  
                                ()
                             end
                        | VEdge ->
                                begin 
                                    assert(dataset_kind != DSCartSpaghetti);
                                    assert(ptr_type = RVector(VConnectedNode));
                                    match ptr.topology with
                                        | TIBeginNode ->
                                                let vl =GEConnNode(Start,ptr_id) in 
                                                let key = (VEdge,id) in 
                                                commit key vl;
                                                ()
                                        | TIEndNode ->
                                                let vl = GEConnNode(End,ptr_id) in 
                                                let key = (VEdge,id) in 
                                                commit key vl;
                                                ()
                                        | TILeftFace -> 
                                             begin
                                                assert (dataset_kind = DSFullTopo);
                                                let vl = GEFace(Left,ptr_id) in
                                                let key = (VEdge,id) in
                                                commit key vl;
                                                ()
                                             end
                                        | TIRightFace -> 
                                             begin
                                                assert (dataset_kind = DSFullTopo);
                                                let vl = GEFace(Right,ptr_id) in
                                                let key = (VEdge,id) in 
                                                commit key vl;
                                                () 
                                             end
                                end                                
                        | VFace ->
                             begin
                                assert(dataset_kind != DSCartSpaghetti);
                                assert(ptr.topology = TIIrrelevent);
                                assert(ptr_type = RVector(VEdge));
                                let vl = GFEdge ptr_id in
                                let key = (VFace, id) in 
                                ()
                             end
                                      
                                
                        ;
                        ()
                in
                match (s.vector_info.op) with 
                | USInsert -> insert id ptrs 
                | USModify -> error "modify" "unsupported" 
                | USDelete -> error "remove" "unsupported"
                ;
                clear_vector_info (s);
                ()
        
        let commit_geom_rels (s:parse_state) (rels:geom_ptr list) = 
                stmt (List.iter (fun x -> commit_geom_rel s x) rels) ()

        (*commit coordinate lists*)
        let commit_coords (s:parse_state) coords = 
                let id = s.vector_info.id in
                assert(id >= 0); 
                let insert id coords = 
                        let entry = match s.vector_info.typ with 
                                | VIsolatedNode -> GIsolatedNode(coords) 
                                | VConnectedNode -> GConnectedNode(coords) 
                                | VEdge -> GEdge(coords)  
                                | _ -> error "commit_coords3d" "unexpected coordinate" 
                        in
                        let _ = MAP.put s.geometry id entry in 
                        ()
                in
                match (s.vector_info.op) with 
                | USInsert -> insert id coords 
                | USModify -> error "modify" "unsupported" 
                | USDelete -> error "remove" "unsupported"
                ;
                clear_vector_info(s);
                ()
               

        let name_to_foreign_ptr (x:string) : foreign_ptr = 
                let rcname = DataLib.int_to_record_type (int_of_string
                (to_hex (String.sub x 0 2)) ) in  
                let rcid = int_of_string (to_hex (String.sub x 2 ((String.length x)
                -2))) in 
               (rcname,rcid)
        
        let long_name_to_feature_obj_id (x:string) =
                (*AGEN=3 hex, FIDN=4 bytes (hex 8), FIDS=2 bytes (hex 4)*)
                (*let _ = msg x in*)
                let agen = int_of_string(to_hex (String.sub x 0 3)) in 
                let fidn = int_of_string (to_hex (String.sub x 3 8)) in 
                let fids = int_of_string (to_hex (String.sub x 11 4)) in 
                (agen,fidn,fids)
 
end
