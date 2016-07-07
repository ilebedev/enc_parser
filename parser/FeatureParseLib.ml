open DataStructure 
open FeatureData

module FeatureParseLib = 
struct
   
        
   let build (obj_id:int) (attrs:(int,string) map) = 
        match obj_id with 
        | _ -> error "build_feature" ("unknown object type: "^(string_of_int
        obj_id))
        
   let to_entity_type (obj_id:int) = match obj_id with
        | 4 -> ETypAnchorageArea
        | 7 -> ETypBeaconLateral
        | 8 -> ETypBeaconSafeWater
        | _ -> error "to_entity_type" ("unknown object type: "^(string_of_int
        obj_id))
end
