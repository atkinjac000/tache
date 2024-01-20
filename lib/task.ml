open Core
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type t =
  { name : string
  ; priority : int
  ; complete : bool
  }
[@@deriving yojson]

let create name priority complete = { name; priority; complete }
let update_priority new_priority t = { t with priority = new_priority }
let is_complete t = if t.complete then true else false
let complete t = { t with complete = true; priority = -1 }

let compare t1 t2 =
  if t1.priority > t2.priority then -1 else if t1.priority = t2.priority then 0 else 1
;;

let string_of_t t =
  let completion = if t.complete then "\x1b[32m" else "\x1b[31m" in
  completion ^ t.name ^ "\x1b[0m"
;;

let save filename t =
  let oc = Out_channel.create ~append:true filename in
  Out_channel.output_string oc (Yojson.Safe.to_string (yojson_of_t t) ^ "\n");
  Out_channel.close oc
;;

let save_and_overwrite filename tasks =
  let oc = Out_channel.create filename in
  List.iter tasks ~f:(fun t ->
    Out_channel.output_string oc (Yojson.Safe.to_string (yojson_of_t t) ^ "\n"));
  Out_channel.close oc
;;

let load filename =
  let lines = In_channel.read_lines filename in
  List.map lines ~f:Yojson.Safe.from_string |> List.map ~f:t_of_yojson |> List.sort ~compare
;;

let get_highest_priority tasks =
  match tasks with
  | [] -> failwith "No tasks have been loaded"
  | hd :: _ -> hd
;;

let show_tasks tasks =
  List.iteri tasks ~f:(fun i t -> string_of_t t |> (printf "%d : %s\n") i)
;;
