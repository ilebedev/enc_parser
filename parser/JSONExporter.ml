open Yojson;;
open Data;;

module ENCJSONExporter =
struct

        let export_dataset (s:dataset) = 
                `Null
        
        let json_to_string (s:json) = 
                Yojson.to_string s
end

