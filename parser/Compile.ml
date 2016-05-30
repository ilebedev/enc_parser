
open BSBLex
open BSBParse
open KAPLex
open KAPParse

module Parser : 
sig
        val parse_kap : string -> unit
        val parse_bsb : string -> unit

end = 
struct
        let parse_file (filename:string) (fn) = 
                let in_stream = open_in filename in 
                let lexbuf = Lexing.from_channel in_stream in 
                let result = fn lexbuf in 
                result
        
        let parse_kap (filename:string) =
                let do_parse chan = KAPParse.toplevel KAPLex.token chan in 
                parse_file filename do_parse
        
        let parse_bsb (filename:string) =
                let do_parse chan = BSBParse.toplevel BSBLex.token chan in 
                parse_file filename do_parse


end
