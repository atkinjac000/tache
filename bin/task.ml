open Core

type t = {
  name:string;
  priority:int;
  complete:bool;
}
[@@deriving sexp]

let create name priority complete = { name; priority; complete; }

let update_priority new_priority t = { t with priority=new_priority }

let is_complete t = if t.complete then true else false

let complete t = { t with complete=true; priority= -1 }

let compare t1 t2 =
  if t1.priority > t2.priority then -1
    else if t1.priority = t2.priority then 0
  else 1

let string_of_t t =
  let completion = if t.complete then "Completed"
    else "Incomplete" in
  t.name ^ " : " ^ " " ^ completion
