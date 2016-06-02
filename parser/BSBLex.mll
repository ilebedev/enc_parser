{
        open BSBParse
        open Data
        exception Eof
        
        exception BSBLexerError of string*string

        let error s n = raise (BSBLexerError(s,n))

        let report lexbuf q = 
                let offset : string = string_of_int (Lexing.lexeme_start lexbuf) in 
                let chr : string = Char.escaped q in 
                error "BSB Lexer Error" ("At offset "^offset^": unexpected character <"^chr^">")

}

let comment = '!'[^'\n''\r']*['\n''\r']+
let token = ['A'-'Z''a'-'z''-''.''_']+
let token_or_number = ['0'-'9''A'-'Z''a'-'z''-''.''_']+ 
let integer ='-'? ['0'-'9']+
let inttoken =token_or_number? token token_or_number+
let decimal ='-'? ['0'-'9']+'.'['0'-'9']+
let newline = '\n' | '\r''\n' 
let whitespace = [' ' '\t']

rule token = parse
| comment                     {Lexing.new_line lexbuf; token lexbuf}
| newline whitespace          {Lexing.new_line lexbuf;  token lexbuf}
| newline    +                {Lexing.new_line lexbuf;  EOC}
| whitespace+                 {token lexbuf}
| '/'                         {FSLASH}
| ','                         {COMMA}
| ':'                         {COLON}
| '='                         {EQ}
| "CRR"                       {CRR}

| "NA"                        {NA}
| "NU"                        {NU}

| "NTM"                       {NTM}
| "NE"                        {NE}
| "ND"                        {ND}

| "CHF"                       {CHF}
| "CHT"                       {CHT}
| "CHK"                       {CHK}
| "CGD"                       {CGD}
| "ORG"                       {ORG}
| "MFR"                       {MFR}
| "RGN"                       {RGN}

| "CED"                       {CED}
| "SE"                        {SE}
| "RE"                        {RE}
| "ED"                        {ED}
| "FN"                        {FN}
| "TY"                        {TY}

| "VER"                       {VER}

| decimal as s                {Decimal(float_of_string s)}
| inttoken as s               {Token(s)}
| integer as s                {Int(int_of_string s)}
| token as s                  {Token(s)}
| eof                         {EOF}
| _ as q                      {report lexbuf q}
