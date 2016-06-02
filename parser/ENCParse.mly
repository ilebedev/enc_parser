
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
        exception ENCParseError of string*string

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
|        RCNM EQ Int eol                                
        {let _ = assert($3=10) in ()}
(*record identificatio number*)
|  RCID EQ Int eol                                
        {let id = $3 in ()}
(*exchange purpose*)
|  EXPP EQ Int eol                                
        {
                let exch = $3 in match exch with
                | 1 -> () (*new dataset*)
                | 2 -> () (*update dataset*)
                | _ -> error "DSI.EXPP" "unknown exchange value"
        }
(*intended usage*)
|  INTU EQ Int eol                                
        {()}
(*data set name*)
|  DSNM EQ String eol                             
        { 
         let name = $3 in 
         ()
        }
(*edition number*)
|  EDTN EQ String eol                             
        {()}
(*update number, the index of the update*)
|  UPDN EQ String eol                             {()}
(*update application date, the application date*)
|  UADT EQ String eol                             {()}
(*issue date*)
|  ISDT EQ String eol                             {()}
(*edition number of the S-57 spec*)
|  STED EQ Decimal eol                            {()}
(*produce specification*)
|  PRSP EQ Int eol                                
        { match $3 with
        | 1 -> () (*electronic navigational chart*)
        | 2 -> () (* IHO object catalogue data dictionary*)
        }
(*a string identifying a non-standad product specification*)
|  PSDN EQ String eol                             {()}
(*a string identifying the dition number of th eproduct specifciation*)
|  PRED EQ String eol                             {()}
(*application profile information.*)
|  PROF EQ Int eol                                
        {match $3 with
        | 1 -> () (*new nav chart*)
        | 2 -> () (*revised nav chart*)
        | 3 -> () (*IHO dictionary*)
        }
(*agency code*)
|        AGEN EQ Int eol                                {()}
(*a comment*)
|        COMT EQ String eol                             {()}

dsi_stmts:
| dsi_stmt {()}
| dsi_stmts dsi_stmt {()}

dsst_stmt:
| DSTR EQ Int eol                                       
        { match $3 with
        | 1 -> () (*cartographic spaghetti*)
        | 2 -> () (*chain node*)
        | 3 -> () (*planar graph*)
        | 4 -> () (*full topologu*)
        | 255 -> () (*topology not relevent*)
        }
(*lexical level used for AATF fields*)
| AALL EQ Int eol                                       {()}
(*lexical level used for NATF fields*)
| NALL EQ Int eol                                       {()}
(*number of meta records in dataset*)
| NOMR EQ Int eol                                       {()}
(*number of cartographic records in dataset*)
| NOCR EQ Int eol                                       {()}
(*number of geo records in dataset*)
| NOGR EQ Int eol                                       {()}
(*number of collection records in dataset*)
| NOLR EQ Int eol                                       {()}
(*number of isolated node records in dataset*)
| NOIN EQ Int eol                                       {()}
(*number of connected node records in dataset*)
| NOCN EQ Int eol                                       {()}
(*number of edge records in dataset*)
| NOED EQ Int eol                                       {()}
(*number of face records in dataset*)
| NOFA EQ Int eol                                       {()}

dsst_stmts:
| dsst_stmts dsst_stmt {()}
| dsst_stmt  {()}

(*Data set parameter field structure. 7.3.2.1*)
dspar_stmt:
|        RCNM EQ Int eol                                
        {let _ = assert($3 == 20) in ()}
|        RCID EQ Int eol                                
        {let id = $3 in ()}
(*horizontal geodetic datum*)
|        HDAT EQ Int eol                                
        {()}
(*vertical geodetic datum*)
|        VDAT EQ Int eol                                {()}
(*sounding datum*)
|        SDAT EQ Int eol                                {()}
(*compilation scale of the data. for example 1:x is encoded as x.*)
|        CSCL EQ Int eol                                {()}
(*units of depth measurement*)
|        DUNI EQ Int eol                                {()}
(*units of height measurement*)
|        HUNI EQ Int eol                                {()}
(*units of positional accuracy *)
|        PUNI EQ Int eol                                {()}
(*coordinate units *)
|        COUN EQ Int eol                                
        {
        match $3 with 
        | 1 -> () (*latitude/longitude*)
        | 2 -> () (*easting/northing*)
        | 3 -> () (*units on chart or map.*)
        }
(*floating point to integer multiplication factor for coordinate*)
|        COMF EQ Int eol                                {()}
(*floating point to integer multiplication factor for sounding values*)
|        SOMF EQ Int eol                                {()}
(*comment*)
|        COMT EQ String eol                                {()}

dspar_stmts:
| dspar_stmt {()}
| dspar_stmts dspar_stmt {()}

vcid_stmt:
| RCNM EQ Int eol                                       {()}
| RCID EQ Int eol                                       {()}
| RVER EQ Int eol                                       {()}
| RUIN EQ Int eol                                       {()}

vcid_stmts:
| vcid_stmt {()}
| vcid_stmts vcid_stmt {()}

coord3d_stmt:
| YC00 EQ Int eol 
  XC00 EQ Int eol                                       
  VE3D EQ Int eol                                       {()}

coord3d_stmts:
| coord3d_stmt {()}
| coord3d_stmts coord3d_stmt {()}

coord2d_stmt:
| YC00 EQ Int eol 
  XC00 EQ Int eol                                        {()}

coord2d_stmts:
| coord2d_stmt {()}
| coord2d_stmts coord2d_stmt {()}

vectattr_stmt:
| ATTL EQ Int eol {()}
| ATVL EQ String eol {()}

vectattr_stmts:
| vectattr_stmt {()}
| vectattr_stmts vectattr_stmt {()}

vectptr_stmt:
| NAME EQ Hex eol
  ORNT EQ Int eol 
  USAG EQ Int eol
  TOPI EQ Int eol
  MASK EQ Int eol {()}

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
| NAME EQ Hex eol                            {()}
| ORNT EQ Int  eol                            {()}
| USAG EQ Int  eol                            {()}
| MASK EQ Int  eol                            {()}

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
|        RECORD Int OPARAN Int BYTES CPARAN eol              {()}
|        FIELD Int COLON RECORDID eol                        {()}
|        FIELD DSID COLON DSDATASET eol dsi_stmts            {()}
|        FIELD DSSI COLON DSDATASTRUCT eol dsst_stmts        {()}
|        FIELD DSPM COLON DSPARAM eol dspar_stmts            {()}
|        FIELD VRID COLON DSVECTID eol vcid_stmts             {()}
|        FIELD SG3D COLON DS3DCOORDS eol coord3d_stmts       {()}
|        FIELD SG2D COLON DS2DCOORD eol coord2d_stmts       {()}
|        FIELD ATTV COLON DSVECTATTR eol vectattr_stmts     {()}
|        FIELD VRPT COLON DSVECTPTR eol vectptr_stmts      {()}
|        FIELD FRID COLON DSFEATID eol featid_stmts        {()}
|        FIELD FOID COLON DSFEATOBJID eol featobjid_stmts        {()}
|        FIELD ATTF COLON DSFEATATTR eol featattr_stmts        {()}
|        FIELD FSPT COLON DSFEATSPAT eol featspat_stmts        {()}
|        FIELD FFPT COLON DSFEATOBJPTR eol featobjptr_stmts        {()}
;

stmts:
|        stmts stmt {()}
|        stmt {()}
;

toplevel:
|        stmts EOF {()}
|        EOF {()}
;
