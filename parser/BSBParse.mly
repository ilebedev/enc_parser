%token <int> INT
%token EOF
%token EOC

%token BSLASH
%token FSLASH

%token CHF
%token VER
%token CRR 
%token CED
%token NTM

%start toplevel

%type <unit> toplevel
%%

toplevel:
        EOF {()}
