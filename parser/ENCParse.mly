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



dsi_stmt:
|        RCNM EQ Int eol                                {()}
|        RCID EQ Int eol                                {()}
|        EXPP EQ Int eol                                {()}
|        INTU EQ Int eol                                {()}
|        DSNM EQ String eol                             {()}
|        EDTN EQ String eol                             {()}
|        UPDN EQ String eol                             {()}
|        UADT EQ String eol                             {()}
|        ISDT EQ String eol                             {()}
|        STED EQ Decimal eol                            {()}
|        PRSP EQ Int eol                                {()}
|        PSDN EQ String eol                             {()}
|        PRED EQ String eol                             {()}
|        PROF EQ Int eol                                {()}
|        AGEN EQ Int eol                                {()}
|        COMT EQ String eol                             {()}

dsi_stmts:
| dsi_stmt {()}
| dsi_stmts dsi_stmt {()}

dsst_stmt:
| DSTR EQ Int eol                                       {()}
| AALL EQ Int eol                                       {()}
| NALL EQ Int eol                                       {()}
| NOMR EQ Int eol                                       {()}
| NOCR EQ Int eol                                       {()}
| NOGR EQ Int eol                                       {()}
| NOLR EQ Int eol                                       {()}
| NOIN EQ Int eol                                       {()}
| NOCN EQ Int eol                                       {()}
| NOED EQ Int eol                                       {()}
| NOFA EQ Int eol                                       {()}

dsst_stmts:
| dsst_stmts dsst_stmt {()}
| dsst_stmt  {()}

dspar_stmt:
|        RCNM EQ Int eol                                {()}
|        RCID EQ Int eol                                {()}
|        HDAT EQ Int eol                                {()}
|        VDAT EQ Int eol                                {()}
|        SDAT EQ Int eol                                {()}
|        CSCL EQ Int eol                                {()}
|        DUNI EQ Int eol                                {()}
|        HUNI EQ Int eol                                {()}
|        PUNI EQ Int eol                                {()}
|        COUN EQ Int eol                                {()}
|        COMF EQ Int eol                                {()}
|        SOMF EQ Int eol                                {()}
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
