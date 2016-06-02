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

let integer = '-'?['0'-'9']+
let decimal = '-'?['0'-'9']+'.'['0'-'9']*
let letter = ['A'-'Z''a'-'z'] 
let token = letter+

rule token = parse
| ['\t'' ']+                    {token lexbuf}
| ['\n''\r']+                   { Lexing.new_line lexbuf; EOL}
| "ISO/IEC 8211 Record Identifier" {RECORDID}
| "Record"                      {RECORD}
| "Field"                       {FIELD}
| "VRID"                        {VRID}
| "SG3D"                        {SG3D}

| "DSID"                        {DSID}

| "RCNM"                        {RCNM}
| "RCID"                        {RCID}
| "EXPP"                        {EXPP}
| "INTU"                        {INTU}
| "DSNM"                        {DSNM}
| "EDTN"                        {EDTN}
| "UPDN"                        {UPDN}
| "UADT"                        {UADT}
| "ISDT"                        {ISDT}
| "STED"                        {STED}
| "PRSP"                        {PRSP}
| "PSDN"                        {PSDN}
| "PRED"                        {PRED}
| "PROF"                        {PROF}
| "AGEN"                        {AGEN}
| "COMT"                        {COMT}

| "DSSI"                        {DSSI}

| "DSTR"                        {DSTR}

| "Data Set Identification"        {DSDATASET}
| "Data set structure information field"        {DSDATASTRUCT}
| "bytes"                       {BYTES}
| "="                           {EQ}
| ":"                           {COLON}
| "/"                           {FSLASH}
| "("                           {OPARAN}
| ")"                           {CPARAN}
| '`'[^'\'']*'\'' as s              {String(s)}
| decimal as d                  {Decimal(float_of_string d)}
| integer as i                  {Int(int_of_string i)}
| _       as q                  {report lexbuf q}
