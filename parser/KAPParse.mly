%token <int> Int
%token <float> Decimal
%token <string> Token 
%token <char>  Byte 

%token EOF
%token EOC

%token BANG
%token COMMA
%token VBAR
%token BSLASH
%token FSLASH

%token KNP
%token ERR
%token RGB
%token IFM
%token OST
%token VER
%token BSB 

%start toplevel

%type <unit> toplevel
%%

stmt:
|        BANG EOC {()}
;
stmts:
|        stmts stmt {()}
|        stmt {()}
;

toplevel:
|        stmts {()}
|        EOF {()}
;
