open DataStructure

type exchange_purpose = EXNew | EXUpdate

type intended_usage = IUOverview | IUGeneral | IUCoastal
        | IUApproach | IUHarbor | IUBerthing | IUUnknown 

type application_profile = APElecNavChart | APElecNavRevision | APIhoObjCatalog

type month = September | October | November | December | January
        | February | March | April | May | June | July | August 

type data_struct_type = DSCartSpaghetti | 
        DSChainNode | DSPlanarGraph | DSFullTopo | DSIrrelevent


type lexical_level = LLASCII | LLLatin | LLUnicode

type coordinate_units = CULatLong | CUEastNorth | CUUnitsOnChartMap 

type vector_type = 
       VIsolatedNode | VConnectedNode | VEdge | VFace | VUnknown

type record_type = 
       |RGeoReference | RGenInfo | RDSHistory | RDSAccuracy
       |RCatalogDir | RCatalogCrossReference 
       |RDataDictDefn | RDataDictDomain | RDataDictSchema
       |RVector of vector_type  

type topology_indicator =
        | TIBeginNode | TIEndNode | TILeftFace | TIRightFace
        | TIContainingFace | TIIrrelevent 

type mask_type =
        |MMask | MShow | MIrrelevent 

type usage_indicator = 
        | UIExterior | UIInterior | UIExteriorTrunc | UIIrrelevent

type update_instruction = 
        | USInsert | USDelete | USModify | USUnknown

type orientation =
        | ORForward | ORReverse | ORIrrelevent


type mask = 
        | MKShow | MKMask | MKIrrelevent

type foreign_ptr = record_type*int 

type date = month*int*int 

type iho_object_id = int

type depth_unit = 
        | DUMeters | DUFathomsAndFeet | DUFeet | DUFathomsAndFractions
 
type height_unit = 
        | HUMeters | HUFeet

(*resolution 0.1 or 0.1 mm*)
type pos_accuracy_unit = 
        | PUMeters | PUDegreesOfArc | PUMillimeters | PUFeet
                |PUCables

              

type horiz_ref = HRWGS84  

type vert_ref =  VRMLWaterSprings | VRMLLWaterSprings | VRMSeaLevel
        | VRLLWater | VRMLWater | VRLLWaterSprings | VRAMLWaterSprings
        | VRIndianSpringLowWater | VRLWaterSprings | VRALAstroTide 
        | VRNLLWater | VRMLLWater | VRLWater | VRAMLWater | VRAMLLWater
        | VRMHWater | VRMHWaterSprings | VRHWater

type coord = 
        | Vect3D of (float*float*float) list
        | Vect2D of (float*float) list 

type side = Left | Right 
type ending = Start | End 
 
type geom_typed_id = 
        | GTIsolatedNode of int
        | GTConnectedNode of int
        | GTEdge of int
        | GTFace of int

type geom_data = 
        | GDCoord of coord
        | GDEmpty of unit 


type geom_rel = 
        | GRFIsolatedNode of int
        | GRFEdge of int        
        | GREConnNode of ending*int
        | GREFace of side*int
        
      
type dataset_coord_info = {
        mutable  horiz : horiz_ref;
        mutable  vert : vert_ref;
        mutable  sounding : vert_ref;
        mutable  compilation_scale: int;
        mutable  depth_units : depth_unit;
        mutable  height_units : height_unit;
        mutable  positional_accuracy : pos_accuracy_unit;
        mutable  coord_units : coordinate_units;
        mutable  coord_mult_factor : int;
        mutable  sound_mult_factor : int;
        mutable  comment: string;
}
type lexical_levels = {
        mutable attf_lex : lexical_level;
        mutable natf_lex : lexical_level;
}
type dataset_stats = {
        mutable n_meta : int;
        mutable n_cartographic : int;
        mutable n_geo : int;
        mutable n_collection : int;
        mutable n_isolated_node : int;
        mutable n_connected_node : int;
        mutable n_edge : int;
        mutable n_face : int;
}
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
        mutable structure : data_struct_type;
}

type dataset  = {
        info : dataset_info;
        (*temporary information*)
        mutable geometry: (geom_typed_id,geom_data) map;
        mutable spatial_relations : (geom_typed_id,geom_rel list) map;

}

type output_type = 
        | OutTypJson
        | OutTypRaw

type vector_record_info = {
        mutable typ : vector_type;
        mutable id : int;
        mutable op : update_instruction;  
}

type geom_ptr = {
        ptr : foreign_ptr;
        topology : topology_indicator;
        orientation : orientation;
        mask : mask_type;
        usage: usage_indicator;
}

 

let stmt f r = let _ = f in r
