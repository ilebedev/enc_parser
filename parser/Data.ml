
type exchange_purpose = EXNew | EXUpdate

type intended_usage = IUOverview | IUGeneral | IUCoastal
        | IUApproach | IUHarbor | IUBerthing | IUUnknown 


type month = September | October | November | December | January
        | February | March | April | May | June | July | August 

type data_struct_type = DSCartographicSpaghetti | 
        DSChainNode | DSPlanarGRaph | DSFullTopology | DSNotRelevent

type lexical_level = LLASCII | LLLatin | LLUnicode

type coordinate_units = CULatLong | CUEastNorth | CUUnitsOnChartMap 


type date = month*int*int 

type iho_object_id = int


type dataset_parameter = {
        horiz : int;
        vert : int;
        sounding : int;

        coordinate_units : coordinate_units;

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
        mutable update_app_date : date;
        mutable issue_date : date;
        mutable agency_id : (int*(iho_object_id option));
        mutable comment : string;
        mutable stats : dataset_stats;
        mutable lex : lexical_levels; 
}


type output_type = 
        | OutTypJson
        | OutTypRaw

type parse_state = {
        mutable record_id: int option;
        mutable dataset_info : dataset_info;
}

let stmt f r = let _ = f in r
