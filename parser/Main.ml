(*Ocaml Libraries*)
open Sys
open Core
open Data
open Compile



exception MainException of string*string;;

let raise_error header msg = 
        raise (MainException(header,msg))

let gen_output (kap:string) (bsb:string) (out_file:string) (out_type:output_type) : unit =
        let _ = print_string "== Parsing BSB ==\n" in
        let bsb_data = Parser.parse_bsb bsb in 
        let _ = print_string "== Parsing KAP ==\n" in
        let kap_data = Parser.parse_kap kap in 
        ()

let command =
  Command.basic
    ~summary:"parse ENC files"
    Command.Spec.(
      empty
      +> flag "-kap" (optional string) ~doc:"kap file."
      +> flag "-bsb" (optional string) ~doc:"bsb file."
      +> flag "-output" (optional string) ~doc:"output."
      +> flag "-filetype" (optional string) ~doc:"output filetype."
    )
    (fun kap bsb output filetype () ->
      let kap,bsb = match kap,bsb with
        | Some(k),Some(b)-> k,b
        | None,Some(_)-> raise_error "cmd" "must provide kap file."
        | Some(_),None-> raise_error "cmd" "must provide bsb file"
        | _ -> raise_error "cmd" "must provide kap and bsb file"
      in
      let outfile = match output with 
        |Some(name) -> name
        |None -> "out.txt"
      in
      let outtype = match filetype with
        |Some("json") -> OutTypJson 
        |Some("raw") -> OutTypRaw
        | None -> OutTypJson
      in
      let _ = gen_output kap bsb outfile outtype in 
      ()
    )

let main () = Command.run command;;

if !Sys.interactive then () else main ();;
