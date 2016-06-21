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


module ENCJSONExporter =
struct
        
        let export_dataset_info (s:Data.dataset_info) : json = 
                let assoc = `Assoc [
                        ("id",`Int s.id);
                        ("purpose",`String (DataLib.exchange_purpose_to_string
                        s.exchange));
                        ("kind",`String (DataLib.intended_usage_to_string
                        s.usage)); 
                        ("name",`String s.name);
                        ("edition",`Int s.edition);
                        ("update",`Int s.update);
                        ("comment",`String s.comment);
                ] in 
               assoc 

        let export_dataset (s:dataset) : json = 
                let json_info = export_dataset_info s.info in 
                `Assoc [("info",json_info)]
        
        let json_to_string (s:json) = 
                Yojson.to_string s
end

