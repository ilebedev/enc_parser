%token <int> Int
%token <string> String
%token <float> Decimal
%token <string> Token 
%token <char>  Byte 

%token EOF
%token EOL
%token FIELD, RECORD, BYTES 
%token OPARAN, CPARAN, FSLASH, COLON, EQ 
%token VRID, SG3D 

%token DSID,DSDATASET
%token RCNM, RCID, EXPP, INTU, DSNM, EDTN UPDN, UADT,
ISDT,STED,PRSP,PSDN,PRED,PROF,AGEN,COMT

%token DSSI,DSDATASTRUCT
%token DSTR, AALL, NALL, NOMR 

%token RECORDID
%token BANG

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

dsst_stmts:
| dsst_stmts dsst_stmt {()}
| dsst_stmt  {()}

stmt:
|        RECORD Int OPARAN Int BYTES CPARAN EOL          {()}
|        FIELD Int COLON RECORDID EOL                    {()}
|        FIELD DSID COLON DSDATASET EOL dsi_stmts        {()}
|        FIELD DSSI COLON DSDATASTRUCT EOL dsst_stmts        {()}
;

stmts:
|        stmts stmt {()}
|        stmt {()}
;

toplevel:
|        stmts {()}
|        EOF {()}
;
