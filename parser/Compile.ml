
open BSBLex
open BSBParse
open KAPLex
open KAPParse
open ENCLex
open ENCParse
open Data

exception ParserException of string;;

module Parser : 
sig
        val parse_kap : string -> unit
        val parse_bsb : string -> unit
        val parse_enc : string -> dataset 
end = 
struct

        exception ParseError of string
        
        let raise_parse_exception ex line col tok =
                let line_str = string_of_int line in 
                let col_str = string_of_int col in 
                let enc_ex = Printexc.to_string ex in 
                let msg = (line_str^":"^col_str^" : Parse Error at <"
                ^tok^">\n"^enc_ex^"\n") in 
                let _ = print_string msg in 
                let _ = flush_all () in 
                raise ex 

        let parse_except lexbuf fn = 
                try
                        fn lexbuf
                with ex ->
                        begin
                                let curr = lexbuf.Lexing.lex_curr_p in
                                let line = curr.Lexing.pos_lnum in 
                                let col = curr.Lexing.pos_cnum -curr.Lexing.pos_bol in 
                                let tok = Lexing.lexeme lexbuf in 
                                raise_parse_exception ex line col tok
                        end

                        
        let parse_file (filename:string) (fn) = 
                let in_stream = open_in filename in 
                let lexbuf = Lexing.from_channel in_stream in 
                let result = parse_except lexbuf fn in 
                result
        
        let parse_kap (filename:string) =
                let do_parse chan = KAPParse.toplevel KAPLex.token chan in 
                parse_file filename do_parse
        
        let parse_bsb (filename:string) =
                let do_parse chan = BSBParse.toplevel BSBLex.token chan in 
                parse_file filename do_parse

        let _parse_enc (filename:string) =
                let do_parse chan = ENCParse.toplevel ENCLex.token chan in 
                match parse_file filename do_parse with
                | Some(data) -> data
                | None -> raise (ParserException "could not parse ENC file")
        
        let parse_enc(filename:string) = 
                let tmpfile = "__tmp__.txt" in 
                let _ = Sys.command ("c-src/s57parse "^filename^" > "^tmpfile) in
                let result = _parse_enc tmpfile in 
                result

end
