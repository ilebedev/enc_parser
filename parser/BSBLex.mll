{
        open BSBParse
        open Data
}



rule token = parse
| [' ' '\t'] {token lexbuf}
| '\n'[' ']+ as ind {token lexbuf}
| '\n'       {EOC}
| "CRR"      {CRR}
| "CHF"      {CHF}
| "CED"      {CED}
| "NTM"      {NTM}
| "VER"      {VER}
