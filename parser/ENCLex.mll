{
        open ENCParse
        open Data

        exception Eof
        
        exception ENCLexerError of string*string

        let error s n = raise (ENCLexerError(s,n))

        let report lexbuf q = 
                let offset : string = string_of_int (Lexing.lexeme_start lexbuf) in 
                let chr : string = Char.escaped q in 
                error "ENC Lexer Error" ("At offset "^offset^": unexpected character <"^chr^">")
}

rule token = parse
| ['\n''\r']['\t'' ']+          {Lexing.new_line lexbuf; token lexbuf}
| ['\n''\r']                    {Lexing.new_line lexbuf; EOC}

