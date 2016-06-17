
%token <int> Int
%token <string> String
%token <string> Hex
%token <float> Decimal
%token <string> Token 
%token <char>  Byte 

%token EOF
%token EOL
%token FIELD, RECORD, BYTES 
%token OPARAN, CPARAN, FSLASH, COLON, EQ 

%token DSID,DSDATASET
%token RCNM, RCID, EXPP, INTU, DSNM, EDTN UPDN, UADT,
ISDT,STED,PRSP,PSDN,PRED,PROF,AGEN,COMT

%token DSSI,DSDATASTRUCT
%{
        open Data
        open ENCParseLib
        
        exception ENCParseError of string*string
        
        let _state = ENCParseLib.init_state();;
        
        let msg (str:string) = 
                print_string (str^"\n")
        
        let error k msg = 
                raise (ENCParseError(k,msg))
%}
%token DSTR, AALL, NALL, NOMR, NOCR, NOGR, NOLR, NOIN, 
NOCN, NOED, NOFA

%token DSPM,DSPARAM
%token HDAT, VDAT, SDAT, CSCL, DUNI, HUNI, PUNI, COUN, COMF, SOMF

%token VRID, DSVECTID
%token RVER,RUIN

%token SG3D,DS3DCOORDS
%token YC00,XC00,VE3D

%token SG2D, DS2DCOORD

%token DSVECTATTR, ATTV
%token ATTL, ATVL

%token DSVECTPTR, VRPT
%token NAME, ORNT, USAG, TOPI, MASK

%token DSFEATID, FRID
%token OBJL, GRUP, PRIM

%token DSFEATOBJID, FOID
%token FIDN, FIDS

%token DSFEATATTR, ATTF 

%token DSFEATSPAT, FSPT

%token DSFEATOBJPTR, FFPT
%token LNAM, RIND

%token RECORDID

%start toplevel

%type <unit> toplevel
%%

eol:
| EOL                                           {()}
(* dataset identification field structure*)
dsi_stmt:
(*record name*)
|  RCNM EQ Int eol {                                
        let _ = assert($3=10) in ()
}
(*record identificatio number*)
|  RCID EQ Int eol {
        let id = $3 in
        let _ = ENCParseLib.upd_dataset _state 
                (fun ds -> stmt (ds.id <- id) ds) in  
        ()
}
(*exchange purpose*)
|  EXPP EQ Int eol  {
        let expp = ENCParseLib.int_to_exchange_purpose $3 in
        let _ = ENCParseLib.upd_dataset _state 
                (fun ds -> stmt (ds.exchange <- expp) ds)
        in
        ()        
}
(*intended usage*)
|  INTU EQ Int eol {
        let intu = ENCParseLib.int_to_intended_usage $3 in
        let _ = ENCParseLib.upd_dataset _state 
                (fun ds -> stmt (ds.usage <- intu) ds)
        in
        ()
}
(*data set name*)
|  DSNM EQ String eol { 
         let name = $3 in 
         let _ = ENCParseLib.upd_dataset _state
                (fun ds -> stmt (ds.name <- name) ds) 
         in 
         ()
}
(*edition number*)
|  EDTN EQ String eol  {
         let edition_no = int_of_string $3 in  
         let _ = ENCParseLib.upd_dataset _state
                (fun ds -> stmt (ds.edition <- edition_no) ds) 
         in 
         ()
}
(*update number, the index of the update*)
|  UPDN EQ String eol  {
        let update_no = int_of_string $3 in  
        let _ = ENCParseLib.upd_dataset _state
                (fun ds -> stmt (ds.update <- update_no) ds) 
        in 
        ()
}
(*update application date, the application date*)
|  UADT EQ String eol  {
        let uadt = int_of_string $3 in 
        let upd_app_date = ENCParseLib.int_to_date uadt in
        let _ = ENCParseLib.upd_dataset _state 
                (fun ds -> stmt (ds.update_app_date <- upd_app_date) ds )
        in
        ()
}
(*issue date*)
|  ISDT EQ String eol {
        let uadt = int_of_string $3 in 
        let upd_issue_date = ENCParseLib.int_to_date uadt in
        let _ = ENCParseLib.upd_dataset _state 
                (fun ds -> stmt (ds.issue_date <- upd_issue_date) ds )
        in
        ()
}
(*edition number of the S-57 spec*)
|  STED EQ Decimal eol {
        let _ = assert($3 = 3.1) in 
        ()
}
(*produce specification*)
|  PRSP EQ Int eol {
        let _ = assert($3 = 1) in 
        ()
}
(*a string identifying a non-standad product specification*)
|  PSDN EQ String eol  {
        let _ = assert ($3 = "") in 
        ()
}
(*a string identifying the dition number of th eproduct specifciation*)
|  PRED EQ String eol   {
        let _ = assert ($3 = "2.0") in 
        ()
}
(*application profile information.*)
|  PROF EQ Int eol   {
        let _ = assert($3 = 1) in 
        ()
}
(*agency code*)
|  AGEN EQ Int eol    {
        let code = $3 in
        let _ = ENCParseLib.upd_dataset _state
                (fun ds -> stmt (ds.agency_id <- (code,None)) ds)
        in 
        ()
}
(*a comment*)
|  COMT EQ String eol {
        let comment = $3 in 
        let _ = ENCParseLib.upd_dataset _state
                (fun ds -> stmt (ds.comment <- comment ) ds)
        in 
        ()
}

dsi_stmts:
| dsi_stmt {()}
| dsi_stmts dsi_stmt {()}

dsst_stmt:
| DSTR EQ Int eol  {
        let data_structure = ENCParseLib.int_to_data_struct_type $3 in 
        ()
}        

(*lexical level used for AATF fields*)
| AALL EQ Int eol {
        let lexical_level = ENCParseLib.int_to_lexical_level $3 in 
        let _ = assert (lexical_level != LLUnicode) in 
        let _ = ENCParseLib.upd_lexical_levels _state
                (fun st -> stmt (st.attf_lex <- lexical_level) st)
        in
        ()
}
(*lexical level used for NATF fields*)
| NALL EQ Int eol {
        let lexical_level = ENCParseLib.int_to_lexical_level $3 in 
        let _ = ENCParseLib.upd_lexical_levels _state
                (fun st -> stmt (st.natf_lex <- lexical_level) st)
        in
        ()
}
(*number of meta records in dataset*)
| NOMR EQ Int eol {
        let n_meta = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_meta <- n_meta) st)
        in
        ()
}
(*number of cartographic records in dataset*)
| NOCR EQ Int eol  {
        let n_cart = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_cartographic <- n_cart) st)
        in
        ()
}

(*number of geo records in dataset*)
| NOGR EQ Int eol  {
        let n_geo = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_geo <- n_geo) st)
        in
        ()
}
(*number of collection records in dataset*)
| NOLR EQ Int eol  {
        let n_coll = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_collection <- n_coll) st)
        in
        ()
}

(*number of isolated node records in dataset*)
| NOIN EQ Int eol {
        let n_isol = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_isolated_node <- n_isol) st)
        in
        ()
}

(*number of connected node records in dataset*)
| NOCN EQ Int eol {
        let n_conn = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_connected_node <- n_conn) st)
        in
        ()
}

(*number of edge records in dataset*)
| NOED EQ Int eol {
        let n_edge = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_edge <- n_edge) st)
        in
        ()
} 
(*number of face records in dataset*)
| NOFA EQ Int eol {
        let n_face = $3 in 
        let _ = ENCParseLib.upd_dataset_stats _state
                (fun st -> stmt (st.n_face <- n_face) st)
        in
        ()
}

dsst_stmts:
| dsst_stmts dsst_stmt {()}
| dsst_stmt  {()}

(*Data set parameter field structure. 7.3.2.1*)
dspar_stmt:
|  RCNM EQ Int eol                                
        {let _ = assert($3 == 20) in ()}

|  RCID EQ Int eol {
        let id = $3 in 
        ()
}
(*horizontal geodetic datum*)
|  HDAT EQ Int eol {
        let horiz_val = $3 in
        () 
}
(*vertical geodetic datum*)
|  VDAT EQ Int eol { 
        let vert_val = $3 in
        () 
}

(*sounding datum*)
|  SDAT EQ Int eol  { 
        let snd_val = $3 in
        () 
}

(*compilation scale of the data. for example 1:x is encoded as x.*)
|  CSCL EQ Int eol   { 
        let comp_scale = $3 in
        () 
}

(*units of depth measurement*)
|  DUNI EQ Int eol {
        let depth_units = $3 in 
        ()
}
(*units of height measurement*)
|  HUNI EQ Int eol {
        let height_unit = $3 in 
        ()
}
(*units of positional accuracy *)
|  PUNI EQ Int eol {
        let pos_accuracy_unit = $3 in 
        ()
}      
(*coordinate units *)
|  COUN EQ Int eol {
        let coordinate_units = $3 in 
        ()
}
(*floating point to integer multiplication factor for coordinate*)
|  COMF EQ Int eol {
        let coordinate_mult_factor = $3 in 
        ()
}
(*floating point to integer multiplication factor for sounding values*)
|  SOMF EQ Int eol {
        let sounding_mult_factor = $3 in 
        ()
}
(*comment*)
|   COMT EQ String eol  {
        let comment = $3 in 
        ()
}

dspar_stmts:
| dspar_stmt {()}
| dspar_stmts dspar_stmt {()}

vcid_stmt:
| RCNM EQ Int eol  {
        let _ = $3 in 
        ()
}
| RCID EQ Int eol  {
        let _ = $3 in 
        ()
}
| RVER EQ Int eol  {
        let _ = $3 in 
        ()
} 
| RUIN EQ Int eol  {
        let _ = $3 in 
        ()
}

vcid_stmts:
| vcid_stmt {()}
| vcid_stmts vcid_stmt {()}

coord3d_stmt:
| YC00 EQ Int eol 
  XC00 EQ Int eol                                       
  VE3D EQ Int eol  {
        let y:int = $3 in 
        let x:int = $7 in 
        let z:int = $11 in 
        ()
}

coord3d_stmts:
| coord3d_stmt {()}
| coord3d_stmts coord3d_stmt {()}

coord2d_stmt:
| YC00 EQ Int eol 
  XC00 EQ Int eol  {
        let y:int = $3 in 
        let x:int = $7 in 
        ()
}


coord2d_stmts:
| coord2d_stmt {()}
| coord2d_stmts coord2d_stmt {()}

vectattr_stmt:
| ATTL EQ Int eol {
        let code = $3 in 
        ()
}
| ATVL EQ String eol {
        let desc = $3 in 
        ()
}

vectattr_stmts:
| vectattr_stmt {()}
| vectattr_stmts vectattr_stmt {()}

vectptr_stmt:
| NAME EQ Hex eol
  ORNT EQ Int eol 
  USAG EQ Int eol
  TOPI EQ Int eol
  MASK EQ Int eol {
        let foreign_ptr = ENCParseLib.name_to_foreign_ptr $3 in 
        let orientation  = ENCParseLib.int_to_orientation $7 in
        let usage_indicator  = ENCParseLib.int_to_usage_indicator $11 in  
        let topology_indicator  = ENCParseLib.int_to_topology_indicator $15 in
        let mask = $18 in 
       () 
}

vectptr_stmts:
| vectptr_stmt {()}
| vectptr_stmts vectptr_stmt {()}

featid_stmt:
|        RCNM EQ Int eol                                {()}
|        RCID EQ Int eol                                {()}
|        PRIM EQ Int eol                                {()}
|        GRUP EQ Int eol                                {()}
|        OBJL EQ Int eol                                {()}
|        RVER EQ Int eol                                {()}
|        RUIN EQ Int eol                                {()}

featid_stmts:
| featid_stmt                   {()}
| featid_stmts featid_stmt      {()}

featobjid_stmt:
| AGEN EQ Int eol {()}
| FIDN EQ Int eol {()}
| FIDS EQ Int eol {()}

featobjid_stmts:
| featobjid_stmt                {()}
| featobjid_stmts featobjid_stmt {()}

featattr_stmt:
| ATTL EQ Int eol               {()}
| ATVL EQ String eol               {()}

featattr_stmts:
| featattr_stmt                 {()}
| featattr_stmts featattr_stmt {()}

featspat_stmt:
| NAME EQ Hex eol  {
        let foreign_ptr = ENCParseLib.name_to_foreign_ptr $3 in 
        ()
}
| ORNT EQ Int  eol {
        let orientation = ENCParseLib.int_to_orientation $3 in
        () 
}
| USAG EQ Int  eol  {
        let usage = ENCParseLib.int_to_usage_indicator $3 in 
        ()
}
| MASK EQ Int  eol  {
        let mask = ENCParseLib.int_to_mask $3 in 
        ()
}       

featspat_stmts:
| featspat_stmt                               {()}
| featspat_stmts featspat_stmt                {()}

featobjptr_stmt:
| LNAM EQ Hex eol                                   {()}
| RIND EQ Int eol                                    {()}
| COMT EQ String eol                                 {()}

featobjptr_stmts:
| featobjptr_stmt                              {()}
| featobjptr_stmts featobjptr_stmt             {()}

stmt:
|        RECORD Int OPARAN Int BYTES CPARAN eol              {
                let index : string  =string_of_int $2 in 
                let nbytes : string = string_of_int $4 in 
                ()
        }
|        FIELD Int COLON RECORDID eol                        {
                let record_id = $2 in 
                let _ = ENCParseLib.set_record _state record_id in 
                ()
        }
|        FIELD DSID COLON DSDATASET eol dsi_stmts            {
                let elem = $6 in 
                ()
        }
|        FIELD DSSI COLON DSDATASTRUCT eol dsst_stmts        {
                let elem = $6 in 
                ()
        }
|        FIELD DSPM COLON DSPARAM eol dspar_stmts            {
                let elem = $6 in 
                ()
        }
|        FIELD VRID COLON DSVECTID eol vcid_stmts  {

}
|        FIELD SG3D COLON DS3DCOORDS eol coord3d_stmts {
  
}
|        FIELD SG2D COLON DS2DCOORD eol coord2d_stmts   {
    
} 
|        FIELD ATTV COLON DSVECTATTR eol vectattr_stmts  {
     
}
|        FIELD VRPT COLON DSVECTPTR eol vectptr_stmts  {
    
}   
|        FIELD FRID COLON DSFEATID eol featid_stmts   {
   
}
|        FIELD FOID COLON DSFEATOBJID eol featobjid_stmts  {
  
} 
|        FIELD ATTF COLON DSFEATATTR eol featattr_stmts   {
   
} 
|        FIELD FSPT COLON DSFEATSPAT eol featspat_stmts  {
  
}
|        FIELD FFPT COLON DSFEATOBJPTR eol featobjptr_stmts  {
  
};

stmts:
|        stmts stmt {()}
|        stmt {()}
;

toplevel:
|        stmts EOF {()}
|        EOF {()}
;
