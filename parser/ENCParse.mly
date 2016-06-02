%token <int> Int
%token <float> Decimal
%token <string> Token 
%token <char>  Byte 

%token EOF
%token EOC

%token BANG

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
