open Yojson;;
open Data;;
open DataLib;;

type dataset_info = {
        mutable id : int;
        mutable exchange : exchange_purpose;
        mutable usage : intended_usage;
        mutable name : string;
        mutable edition: int;
        mutable update: int;
        mutable update_app_date : date option;
        mutable issue_date : date option;
        mutable app_profile : application_profile;
        mutable agency_id : (int*(iho_object_id option));
        mutable comment : string;
        mutable stats : dataset_stats;
        mutable lex : lexical_levels; 
        mutable coord_info : dataset_coord_info;
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
                        ("comment",`String s.comment);
                        ("stats",export_dataset_stats s.stats);
                ] in 
               assoc 

        let export_dataset (s:dataset) : json = 
                let json_info = export_dataset_info s.info in 
                `Assoc [("info",json_info)]
        
        let json_to_string (s:json) = 
                Yojson.to_string s
end

