open Core

let save filename t =
  let oc = Out_channel.create ~append:true filename in
  Out_channel.output_string oc ((Sexp.to_string (Task.sexp_of_t t)) ^ "\n");
  Out_channel.close oc

let save_and_overwrite filename tasks =
  let oc = Out_channel.create filename in
  List.iter tasks ~f:(fun t ->
    Out_channel.output_string oc ((Sexp.to_string (Task.sexp_of_t t)) ^ "\n");
    );
  Out_channel.close oc
  
let load filename =
  let lines = In_channel.read_lines filename in
  List.map lines ~f:Sexp.of_string
  |> List.map ~f:Task.t_of_sexp
  |> List.sort ~compare:Task.compare

let get_highest_priority tasks =
  match tasks with
    | [] -> failwith "No tasks have been loaded"
    | hd :: _ -> hd

let show_tasks tasks =
  List.iteri tasks ~f:(fun i t ->
    Task.string_of_t t |> (printf "%d: %s\n") i)

