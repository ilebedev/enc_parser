open Common;;
open Yojson;;
open Data;;
open DataLib;;
open DataStructure;;

module ENCJSONExporter =
struct
        let date_to_json (s:date option) = match s with
        | Some(m,d,y) -> `Assoc [
                ("month",`Int (DataLib.month_to_int m));
                ("day",`Int d);
                ("year",`Int y);
        ]
        | None -> `Null
        
        let export_dataset_stats (s:dataset_stats) = 
                let assoc = `Assoc [
                 ("n_metadata",`Int s.n_meta);
                 ("n_cartographic",`Int s.n_cartographic);
                 ("n_geographic",`Int s.n_geo);
                 ("n_collection",`Int s.n_collection);
                 ("n_isolated_nodes",`Int s.n_isolated_node);
                 ("n_connected_nodes",`Int s.n_connected_node);
                 ("n_edges",`Int s.n_edge);
                 ("n_faces",`Int s.n_face);
                ] in
                assoc
        let export_dataset_info (s:Data.dataset_info) : json = 
                let assoc = `Assoc [
                        ("id",`Int s.id);
                        ("purpose",`String (DataLib.exchange_purpose_to_string
                        s.exchange));
                        ("kind",`String (DataLib.intended_usage_to_string
                        s.usage)); 
                        ("name",`String s.name);
                        ("edition",`Int s.edition);
                        ("issue_date", date_to_json s.issue_date);
                        ("update",`Int s.update);
                        ("update_date", date_to_json s.update_app_date);
                        ("type",`String (DataLib.application_profile_to_string
                        s.app_profile));
                        ("structure",`String (DataLib.dataset_structure_to_string
                        s.structure));
                        ("comment",`String s.comment);
                        ("stats",export_dataset_stats s.stats);
                ] in 
               assoc 
        
        let export_geom_data_to_json data =
                match data with
                | GDCoord(vt) ->
                     begin
                        match vt with
                        | Vect3D(lst) ->
                            let x,y,d = List.fold_left (fun (xl,yl,dl) (x,y,d) ->
                                    ((`Float x)::xl,(`Float y)::yl,(`Float d)::dl)
                             ) ([],[],[]) lst
                            in
                            `Assoc [("x",`List x);("y",`List y);("depth",`List d)]
                        | Vect2D(lst) -> 
                            let x,y = List.fold_left (fun (xl,yl) (x,y) ->
                                    ((`Float x)::xl,(`Float y)::yl)
                             ) ([],[]) lst
                            in
                            `Assoc [("x",`List x);("y",`List y)]

                     end
               | GDEmpty() -> `Null
        
        let export_geom_rels_to_json rels =
               `Null

        let export_dataset_geometry (geo:(geom_typed_id,geom_data) map)
        (rels:(geom_typed_id,geom_rel list) map) : json = 
                let add_el k v lst =
                        (string_of_int k, v)::lst        
                in
                let f,e,c,i = MAP.fold geo (fun k v (f,e,c,i) ->
                        let data = v in
                        let rels :geom_rel list= if MAP.has rels k 
                                then MAP.get rels k 
                                else []
                        in
                        let data_json:json = export_geom_data_to_json data in
                        let rel_json:json = export_geom_rels_to_json rels in
                        let elem:json = `Assoc [("data",data_json);("rels",rel_json)] 
                        in
                        match k with 
                        | GTIsolatedNode(id) -> (f,e,c,add_el id elem i)
                        | GTConnectedNode(id) ->(f,e,add_el id elem c,i)
                        | GTEdge(id) ->(f,add_el id elem e, c,i)
                        | GTFace(id) ->(add_el id elem f, e, c, i)
                ) ([],[],[],[]) 
                in
                `Assoc
                [("faces",`Assoc f);("edges",`Assoc e);("conn_nodes",`Assoc c);("isol_nodes",`Assoc i)]

        let export_dataset (s:dataset) : json = 
                let json_info = export_dataset_info s.info in
                let geom = export_dataset_geometry s.geometry
                        s.spatial_relations 
                in  
                `Assoc [("info",json_info);("spatial",geom)]
        
        let json_to_string (s:json) = 
                Yojson.to_string s
end

