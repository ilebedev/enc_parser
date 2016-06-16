open Data

exception ENCLibParseError of string*string


let msg (str:string) = 
                print_string (str^"\n")
        
let error k msg =  raise (ENCLibParseError(k,msg))

module ENCParseLib = 
struct
        let make_lexical_levels () = {
                        attf_lex = LLASCII;
                        natf_lex = LLASCII;
                }

        let make_dataset_stats () =
        {
                n_meta = 0;
                n_cartographic=0;
                n_geo=0;
                n_collection=0;
                n_isolated_node=0;
                n_connected_node=0;
                n_edge=0;
                n_face=0;
        }

        let make_dataset_info () = 
                {
                        id=0;
                        (*wheter it is new or updated*)
                        exchange=EXNew;
                        edition=1;
                        update=0;
                        (*all changes before this one have been applied*)
                        update_app_date=(January,1,1995);
                        (*date on which this was made available*)
                        issue_date=(January,1,1995);
                        name="(no name)";
                        (*the intended usage*)
                        usage=IUUnknown;
                        agency_id=(0,None);
                        comment="";
                        stats=make_dataset_stats ();
                        lex=make_lexical_levels ();
                }
        let init_state () : parse_state = 
                {
                        record_id = None;
                        dataset_info = make_dataset_info ();
                }
        
        let upd_dataset (s:parse_state) (f:dataset_info->dataset_info) =
               s.dataset_info <- (f s.dataset_info)
 
        let upd_dataset_stats (s:parse_state) (f:dataset_stats->dataset_stats) =
               s.dataset_info.stats <- (f s.dataset_info.stats)

        let upd_lexical_levels (s:parse_state) (f:lexical_levels->lexical_levels) =
               s.dataset_info.lex <- (f s.dataset_info.lex)
 
        let set_record (s:parse_state) (i:int) = 
                let _ = s.record_id <- Some i in
                ()
        

        let int_to_exchange_purpose (i:int) = match i with
                |1 -> EXNew 
                |2 -> EXUpdate 
                |_ -> error "int_to_dataset_kind" "no dataset kind of that number"

        let int_to_intended_usage (i:int) = match i with
                | 1 -> IUOverview
                | 2 -> IUGeneral
                | 3 -> IUCoastal
                | 4 -> IUApproach
                | 5 -> IUHarbor
                | 6 -> IUBerthing
                | _ -> error "int_to_intended_usage" "no intended usage" 
 
        let int_to_data_struct_type (i:int) = match i with 
        | 1 -> DSCartographicSpaghetti (*cartographic spaghetti*)
        | 2 -> DSChainNode (*chain node*)
        | 3 -> DSPlanarGRaph (*planar graph*)
        | 4 -> DSFullTopology (*full topologu*)
        | 255 -> DSNotRelevent (*topology not relevent*)
        
        let int_to_lexical_level (i:int) = match i  with 
        | 0 -> LLASCII 
        | 1 -> LLLatin
        | 2 -> LLUnicode
        | _ -> error "int_to_lexical_level" "unknown lexical level"
        
        let int_to_coordinate_unit (i:int) = match i with 
        | 1 -> CULatLong
        | 2 -> CUEastNorth 
        | 3 -> CUUnitsOnChartMap
        | _ -> error "int_to_coordinate_unit" "unkonwn coordinate unit"

        let month_of_int (i:int) = match i with 
                | 1 -> January
                | 2 -> February
                | 3 -> March
                | 4 -> April
                | 5 -> May
                | 6 -> June
                | 7 -> July
                | 8 -> August
                | 9 -> September
                | 10 -> October
                | 11 -> November
                | 12 -> December 

        let int_to_date (i:int) = 
                let istr = string_of_int i in 
                let year = int_of_string (String.sub istr 0 4) in 
                let month = month_of_int (int_of_string (String.sub istr 4 2)) in
                let day = int_of_string (String.sub istr 6 2) in
                (month,day,year) 
        
end
