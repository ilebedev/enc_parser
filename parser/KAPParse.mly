%token <int> Int
%token <float> Decimal
%token <string> Token 
%token <char>  Byte 

%token EOF
%token EOC

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

toplevel:
        EOF {()}
;
