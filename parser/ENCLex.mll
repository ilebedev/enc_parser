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

let addr = '0''x'['0'-'9''A'-'F']+
let string_reg = '`'[^'\n']*'\'' 
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

| "DSID"                        {DSID}
| "Data Set Identification"        {DSDATASET}

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
| "Data set structure information field"        {DSDATASTRUCT}

| "DSTR"                        {DSTR}
| "AALL"                        {AALL}
| "NALL"                        {NALL}
| "NOMR"                        {NOMR}
| "NOCR"                        {NOCR}
| "NOGR"                        {NOGR}
| "NOLR"                        {NOLR}
| "NOIN"                        {NOIN}
| "NOCN"                        {NOCN}
| "NOED"                        {NOED}
| "NOFA"                        {NOFA}

| "DSPM"                        {DSPM}
| "Data set parameter field"                        {DSPARAM}
| "HDAT"                        {HDAT}
| "VDAT"                        {VDAT}
| "SDAT"                        {SDAT}
| "CSCL"                        {CSCL}
| "DUNI"                        {DUNI}
| "HUNI"                        {HUNI}
| "PUNI"                        {PUNI}
| "COUN"                        {COUN}
| "COMF"                        {COMF}
| "SOMF"                        {SOMF}


| "Vector record identifier field"      {DSVECTID}
| "VRID"                        {VRID}
| "RVER"                        {RVER}
| "RUIN"                        {RUIN}

| "3-D coordinate (sounding array) field" {DS3DCOORDS}
| "SG3D"                        {SG3D}
| "YCOO"                        {YC00}
| "XCOO"                        {XC00}
| "VE3D"                        {VE3D}

| "2-D coordinate field"        {DS2DCOORD}
| "SG2D"                        {SG2D}

| "Vector record attribute field"       {DSVECTATTR}
| "ATTV"                                {ATTV}
| "ATTL"                                {ATTL}
| "ATVL"                                {ATVL}

| "Vector record pointer field"         {DSVECTPTR}
| "VRPT"                                {VRPT}
| "NAME"                                {NAME}
| "USAG"                                {USAG}
| "ORNT"                                {ORNT}
| "TOPI"                                {TOPI}
| "MASK"                                {MASK}

| "Feature record identifier field"     {DSFEATID}
| "FRID"                                {FRID}
| "PRIM"                                {PRIM}
| "GRUP"                                {GRUP}
| "OBJL"                                {OBJL}

| "Feature object identifier field"     {DSFEATOBJID}
| "FOID"                                {FOID}
| "FIDN"                                {FIDN}
| "FIDS"                                {FIDS}

| "Feature record attribute field"      {DSFEATATTR}
| "ATTF"                                {ATTF}

| "Feature record to spatial record pointer field"      {DSFEATSPAT}
| "FSPT"                                                {FSPT}

| "Feature record to feature object pointer field"      {DSFEATOBJPTR}
| "FFPT"                                                {FFPT}
| "LNAM"                                                {LNAM}
| "RIND"                                                {RIND}

| "bytes"                       {BYTES}
| "="                           {EQ}
| ":"                           {COLON}
| "/"                           {FSLASH}
| "("                           {OPARAN}
| ")"                           {CPARAN}
| string_reg as s              {String(s)}
| addr as i                  {Hex(i)}
| decimal as d                  {Decimal(float_of_string d)}
| integer as i                  {Int(int_of_string i)}
| eof                           {EOF}
| _       as q                  {report lexbuf q}

