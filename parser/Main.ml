(*Ocaml Libraries*)
open Sys
open Core
open Data
open Compile
open JSONExporter
open Printf

exception MainException of string*string;;

let raise_error header msg = 
        raise (MainException(header,msg))

let gen_output_from_bsb (bsb:string) (out_file:string) (out_type:output_type) : unit =
        let _ = print_string "== Parsing BSB ==\n" in
        let data = Parser.parse_bsb bsb in 
        ()

let gen_output_from_enc (enc:string) (out_file:string) (out_type:output_type) : unit =
        let _ = print_string "== Parsing ENC ==\n" in
        let data : dataset = Parser.parse_enc enc in 
        let str = match out_type with 
        | OutTypJson -> 
                print_string "== Generating JSON ==\n";
                let json = ENCJSONExporter.export_dataset data in 
                ENCJSONExporter.json_to_string json
        | _ -> raise_error "gen_output_from_enc" "unsupported output"
        in 
        print_string ("== Outputting to File <"^out_file^"> ==\n");
        let oc = open_out out_file in  
        fprintf oc "%s\n" str;
        close_out oc;
        ()


let command =
  Command.basic
    ~summary:"parse BSB files"
    Command.Spec.(
      empty
      +> flag "-enc" (optional string) ~doc:"enc file."
      +> flag "-bsb" (optional string) ~doc:"bsb file. kap files are
      automatically inferred."
      +> flag "-output" (optional string) ~doc:"output."
      +> flag "-filetype" (optional string) ~doc:"output filetype."
    )
    (fun enc bsb output filetype () ->
      let outfile = match output with 
        |Some(name) -> name
        |None -> "out.txt"
      in
      let outtype = match filetype with
        |Some("json") -> OutTypJson 
        | None -> OutTypJson
      in
      match bsb,enc with
        | Some(_),Some(_) -> raise_error "cmd" "cannot provide both enc and bsb"
        | Some(b),None-> gen_output_from_bsb b outfile outtype
        | None, Some(e)-> gen_output_from_enc e outfile outtype
        | None,None-> raise_error "cmd" "must provide bsb or enc file"
       

    )

let main () = Command.run command;;

if !Sys.interactive then () else main ();;
