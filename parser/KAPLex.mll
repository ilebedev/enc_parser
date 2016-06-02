{
        open KAPParse
        open Data

        exception Eof
        
        exception KAPLexerError of string*string

        let error s n = raise (KAPLexerError(s,n))

        let report lexbuf q = 
                let offset : string = string_of_int (Lexing.lexeme_start lexbuf) in 
                let chr : string = Char.escaped q in 
                error "KAP Lexer Error" ("At offset "^offset^": unexpected character <"^chr^">")
}

let token = ['A'-'Z''a'-'z']+
let decimal = '-'?['0'-'9']+'.'['0'-'9']+
let intgr = ['0'-'9']+
let header_term = '\x1A''\x00'

(*
rule binary = parse
| _ as c {Byte(c)}
*)

rule token = parse
| ['\n''\r']['\t'' ']+          {Lexing.new_line lexbuf; token lexbuf}
| ['\n''\r']                    {Lexing.new_line lexbuf; EOC}
| [' ' '\t']                    {token lexbuf}
| "!"                           {BANG}
| "\\"                          {BSLASH}
| "/"                           {FSLASH}
| "|"                           {VBAR}
| ","                           {COMMA}
| "VER"                         {VER}
| "BSB"                         {BSB}
| "OST"                         {OST}
| "IFM"                         {IFM}
| "RGB"                         {RGB}
| "KNP"                         {KNP}
| "ERR"                         {ERR}
| decimal as d                  {Decimal(float_of_string d)}
| intgr as i                    {Int(int_of_string i)}
| token as t                    {Token(t)}
(*| header_term     {binary lexbuf}*)
| eof                           {raise Eof}
| _ as q                        {report lexbuf q}
