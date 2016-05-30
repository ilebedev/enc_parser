%token <int> INT
%token EOF


%start toplevel

%type <unit> toplevel
%%

toplevel:
        EOF {()}
;
