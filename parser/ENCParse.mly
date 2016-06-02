%token <int> Int
%token <string> String
%token <string> Addr
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

%token RECORDID

%start toplevel

%type <unit> toplevel
%%

word:
|        Token  {$1}

any:
|        word   {$1}
|        Int    {string_of_int $1}

dsi_stmt:
|        RCNM EQ Int EOL                                {()}
|        RCID EQ Int EOL                                {()}
|        EXPP EQ Int EOL                                {()}
|        INTU EQ Int EOL                                {()}
|        DSNM EQ String EOL                             {()}
|        EDTN EQ String EOL                             {()}
|        UPDN EQ String EOL                             {()}
|        UADT EQ String EOL                             {()}
|        ISDT EQ String EOL                             {()}
|        STED EQ Decimal EOL                            {()}
|        PRSP EQ Int EOL                                {()}
|        PSDN EQ String EOL                             {()}
|        PRED EQ String EOL                             {()}
|        PROF EQ Int EOL                                {()}
|        AGEN EQ Int EOL                                {()}
|        COMT EQ String EOL                             {()}

dsi_stmts:
| dsi_stmt {()}
| dsi_stmts dsi_stmt {()}

dsst_stmt:
| DSTR EQ Int EOL                                       {()}
| AALL EQ Int EOL                                       {()}
| NALL EQ Int EOL                                       {()}
| NOMR EQ Int EOL                                       {()}
| NOCR EQ Int EOL                                       {()}
| NOGR EQ Int EOL                                       {()}
| NOLR EQ Int EOL                                       {()}
| NOIN EQ Int EOL                                       {()}
| NOCN EQ Int EOL                                       {()}
| NOED EQ Int EOL                                       {()}
| NOFA EQ Int EOL                                       {()}

dsst_stmts:
| dsst_stmts dsst_stmt {()}
| dsst_stmt  {()}

dspar_stmt:
|        RCNM EQ Int EOL                                {()}
|        RCID EQ Int EOL                                {()}
|        HDAT EQ Int EOL                                {()}
|        VDAT EQ Int EOL                                {()}
|        SDAT EQ Int EOL                                {()}
|        CSCL EQ Int EOL                                {()}
|        DUNI EQ Int EOL                                {()}
|        HUNI EQ Int EOL                                {()}
|        PUNI EQ Int EOL                                {()}
|        COUN EQ Int EOL                                {()}
|        COMF EQ Int EOL                                {()}
|        SOMF EQ Int EOL                                {()}
|        COMT EQ String EOL                                {()}

dspar_stmts:
| dspar_stmt {()}
| dspar_stmts dspar_stmt {()}

vcid_stmt:
| RCNM EQ Int EOL                                       {()}
| RCID EQ Int EOL                                       {()}
| RVER EQ Int EOL                                       {()}
| RUIN EQ Int EOL                                       {()}

vcid_stmts:
| vcid_stmt {()}
| vcid_stmts vcid_stmt {()}

coord3d_stmt:
| YC00 EQ Int EOL 
  XC00 EQ Int EOL                                       
  VE3D EQ Int EOL                                       {()}

coord3d_stmts:
| coord3d_stmt {()}
| coord3d_stmts coord3d_stmt {()}

coord2d_stmt:
| YC00 EQ Int EOL 
  XC00 EQ Int EOL                                        {()}

coord2d_stmts:
| coord2d_stmt {()}
| coord2d_stmts coord2d_stmt {()}

vectattr_stmt:
| ATTL EQ Int EOL {()}
| ATVL EQ String EOL {()}

vectattr_stmts:
| vectattr_stmt {()}
| vectattr_stmts vectattr_stmt {()}

vectptr_stmt:
| NAME EQ Addr EOL
  ORNT EQ Int EOL 
  USAG EQ Int EOL
  TOPI EQ Int EOL
  MASK EQ Int EOL {()}

vectptr_stmts:
| vectptr_stmt {()}
| vectptr_stmts vectptr_stmt {()}

stmt:
|        RECORD Int OPARAN Int BYTES CPARAN EOL              {()}
|        FIELD Int COLON RECORDID EOL                        {()}
|        FIELD DSID COLON DSDATASET EOL dsi_stmts            {()}
|        FIELD DSSI COLON DSDATASTRUCT EOL dsst_stmts        {()}
|        FIELD DSPM COLON DSPARAM EOL dspar_stmts            {()}
|        FIELD VRID COLON DSVECTID EOL vcid_stmts             {()}
|        FIELD SG3D COLON DS3DCOORDS EOL coord3d_stmts       {()}
|        FIELD SG2D COLON DS2DCOORD EOL coord2d_stmts       {()}
|        FIELD ATTV COLON DSVECTATTR EOL vectattr_stmts     {()}
|        FIELD VRPT COLON DSVECTPTR EOL vectptr_stmts      {()}
;

stmts:
|        stmts stmt {()}
|        stmt {()}
;

toplevel:
|        stmts {()}
|        EOF {()}
;
