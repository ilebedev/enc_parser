open Core
open Camlp4
open Common


type ('a,'b) map = ('a, 'b) Hashtbl.t




exception UtilError of string
let error n m = raise (UtilError (n^":"^m))


module MAP =
struct
  let max = 25;;


  let make (type a) (type b) () : (a,b) map =
    Hashtbl.create max

  let copy (type a) (type b) a : (a,b) map =
    Hashtbl.copy a

  let put (type a) (type b) (x:(a,b) map) (k:a) (v:b) : (a,b) map =
    Hashtbl.replace x k v;
    x

  let rm  (type a) (type b) (x:(a,b) map) (k:a) : (a,b) map =
    Hashtbl.remove x k;
    x

  let has (type a) (type b) x k : bool =
    Hashtbl.mem x k

  let get (type a) (type b) (x:(a,b) map) (k:a) : b =
    Hashtbl.find x k

  let upd (type a) (type b) (x:(a,b) map) (f:b->b) (k:a) : (a,b) map =
    let va = get x k in
    let vap = f va in
    put x k vap

  let size (type a) (type b) (x:(a,b) map) :int =
    Hashtbl.length x

   let empty x =
    size x = 0

  let clear x =
    Hashtbl.clear x

  let fold (type a) (type b) (type c) (x:(a,b) map) (f: a -> b -> c -> c) (iv: c) : c =
    Hashtbl.fold f x iv


  let to_values (type a) (type b) (x:(a,b) map) : b list =
    fold x (fun k v rst -> v::rst) []

  let to_keys (type a) (type b) (x:(a,b) map) : a list =
      fold x (fun k v rst -> k::rst) []


  let iter (type a) (type b) (x:(a,b) map) (f: a -> b -> unit) : unit =
    Hashtbl.iter f x

  let str (type a) (type b) (x:(a,b) map) (kf: a -> string) (vf: b->string):string =
    Hashtbl.fold (fun k v r -> r^(kf k)^" = "^(vf v)^"\n") x ""


  let repl (type a) (type b) (type c)  (x:(a,b) map) (f: a -> b -> b) : (a,b) map =
    let _repl k v = let _ = put x k (f k v) in () in
    let _ = iter x _repl in
    x

  let map_vals (type a) (type b) (type c)  (x:(a,b) map) (f: a -> b -> c) : (a,c) map =
    let xn = make () in
    let repl k v = let _ = put xn k (f k v) in () in
    let _ = iter x repl in
    xn

  let map_keys (type a) (type b) (type c)  (x:(a,b) map) (f: a -> b -> c) : (c,b) map =
    let xn = make () in
    let repl k v = let _ = put xn (f k v) v in () in
    let _ = iter x repl in
    xn

  let map (type a) (type b) (type c)  (x:(a,b) map) (f: a -> b -> c) : c list =
    let repl k v r = (f k v)::r in
    let res = fold x repl [] in
    res

  let filter (type a) (type b) (x:(a,b) map) (f: a->b->bool) : (a*b) list =
    fold x (fun q v k -> if f q v then (q,v)::k else k) []

   let to_list (type a) (type b) (x:(a,b) map) : (a*b) list =
    fold x (fun q v k -> (q,v)::k) []
   
   
  let keys (type a) (type b) (x:(a,b) map) : (a) list =
    fold x (fun q v k -> (q)::k) []

  let from_list (type a) (type b) (x:(a*b) list) : (a,b) map =
    let mp = make() in
    let _ = List.iter (fun (k,v) -> let _ = put mp k v in ()) x in
    mp
  
  let filter_map (type a) (type b) (x:(a,b) map) (f: a->b->bool) : (a,b) map = 
    from_list (filter x f)


  let set (type a) (type b) (x: (a,b) map) (y: (a,b) map) =
    let _ = clear x in
    let _ = iter y (fun a b -> let _ = put x a b in ()) in
    ()

  let singleton (type a) (type b) (x:(a,b) map): (a*b) =
    if size x <> 1 then
      error "MAP.singleton" "must have exactly one element."
    else
      let r = match fold x (fun x y r -> Some(x,y)) None with
        | Some(v) -> v
        | None ->
          error "MAP.singleton" "must have exactly one element."
      in
      r

end

