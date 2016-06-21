
type exchange_purpose = EXNew | EXUpdate

type intended_usage = IUOverview | IUGeneral | IUCoastal
        | IUApproach | IUHarbor | IUBerthing | IUUnknown 

type application_profile = APElecNavChart | APElecNavRevision | APIhoObjCatalog

type month = September | October | November | December | January
        | February | March | April | May | June | July | August 

type data_struct_type = DSCartographicSpaghetti | 
        DSChainNode | DSPlanarGraph | DSFullTopology | DSNotRelevent

type lexical_level = LLASCII | LLLatin | LLUnicode

type coordinate_units = CULatLong | CUEastNorth | CUUnitsOnChartMap 

type vector_type = 
       VIsolatedNode | VConnectedNode | VEdge | VFace

type record_type = 
       |RGeoReference | RGenInfo | RDSHistory | RDSAccuracy
       |RCatalogDir | RCatalogCrossReference 
       |RDataDictDefn | RDataDictDomain | RDataDictSchema
       |RVector of vector_type  

type topology_indicator =
        | TIBeginNode | TIEndNode | TILeftFace | TIRightFace
        | TIContainingFace 

type usage_indicator = 
        | UIExterior | UIInterior | UIExteriorTrunc | UIIrrelevent

type update_instruction = 
        | USInsert | USDelete | USModify

type orientation =
        | ORForward | ORReverse | ORIrrelevent

type mask = 
        | MKShow | MKMask | MKIrrelevent

type foreign_ptr = record_type*int 

type date = month*int*int 

type iho_object_id = int


type dataset_coord_info = {
        mutable  horiz : int;
        mutable  vert : int;
        mutable  sounding : int;
        mutable  compilation_scale: int;
        mutable  depth_units : int;
        mutable  height_units : int;
        mutable  positional_accuracy : int;
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
}


type dataset  = {
        info : dataset_info;
}

type output_type = 
        | OutTypJson
        | OutTypRaw

type vector_ident = int

type vector_2d = int
type vector_3d = int

type parse_state = {
        mutable record_id: int option;
        mutable dataset_info : dataset_info;
}


let stmt f r = let _ = f in r
