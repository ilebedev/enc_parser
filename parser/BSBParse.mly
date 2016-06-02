%token <int> Int
%token <float> Decimal
%token <string> Token
%token EOF
%token EOC

%token BSLASH
%token FSLASH
%token COMMA
%token COLON
%token EQ

%token CHT
%token NA
%token NU

%token CHF

%token CED
%token SE
%token RE
%token ED

%token VER
%token CRR 

%token NTM
%token NE
%token ND

%token CHK
%token CGD
%token ORG
%token MFR
%token RGN

%token FN
%token TY

%start toplevel

%type <unit> toplevel
%%

word:
| Token {$1}
| CHF   {"CHF"}
| CHT   {"CHT"}

phrase:
| word   {[$1]}
| word phrase {$1::$2}

any:
| word   {$1}
| FSLASH {"/"}
| COMMA  {","}
| EQ     {"="}
| COLON  {":"}
;

eoc:
| EOC {()}
| EOF {()}

restofline:
| any            {[$1]}
| any restofline {$1::$2}

date:
| Int FSLASH Int FSLASH Int {()}

stmt:
|        CRR FSLASH restofline eoc                      {()}
|        CHT FSLASH NA EQ phrase COMMA NU EQ Int eoc    {()}
|        CHF FSLASH Token eoc                           {()}
|        CED FSLASH SE EQ Int COMMA RE EQ Int COMMA ED EQ date eoc  {()}
|        NTM FSLASH NE EQ Decimal COMMA ND EQ date eoc     {()}
|        VER FSLASH Decimal eoc                         {()}
|        CHK FSLASH Int COMMA Int eoc                    {()}
|        CGD FSLASH Int eoc                             {()}
|        ORG FSLASH Token FSLASH Token eoc              {()}
|        MFR FSLASH Token FSLASH Token eoc              {()}
|        RGN FSLASH Int eoc                             {()}
|        Token FSLASH NA EQ phrase COMMA NU EQ Int COMMA TY EQ Token COMMA FN
EQ Token eoc 
{()}

stmts:
|        stmts stmt      {()}
|        stmt            {()}

toplevel:
        stmts EOF {()}
