{
        open BSBParse
        open Data
}

rule token = parse
| [' ' '\t'] {token lexbuf}
