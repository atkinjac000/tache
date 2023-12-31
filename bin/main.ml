open Core
open Cmdliner

let task_file = Sys.getenv_exn "TACHE_FILE"

let save_new_task name priority complete =
  let new_task = Tache.Task.create name priority complete in
  Tache.Task.save task_file new_task
;;

let get_highest_priority_task file =
  Tache.Task.load file
  |> Tache.Task.get_highest_priority
  |> Tache.Task.string_of_t
  |> printf "%s\n"
;;

let list_tasks file = Tache.Task.load file |> Tache.Task.show_tasks

let complete_task file n =
  let tasks = Tache.Task.load file |> Array.of_list in
  Array.set tasks n (Tache.Task.complete (Array.get tasks n));
  let new_tasks = Array.to_list tasks in
  Tache.Task.save_and_overwrite file new_tasks
;;

let clean_tasks file =
    let tasks = Tache.Task.load file in
  let new_tasks = List.filter tasks ~f:(fun x -> not (Tache.Task.is_complete x)) in
  Tache.Task.save_and_overwrite file new_tasks
;;

(* Subcommands to be run *)

let list_tasks_cmd =
  let doc = "Lists all your tasks, ordered by priority." in
  let info = Cmd.info "list" ~doc in
  let file =
    Arg.(
      value
      & opt string task_file
      & info ~env:(Cmd.Env.info task_file) ~docv:"FILENAME" [ "f" ])
  in
  Cmd.v info Term.(const list_tasks $ file)
;;

let new_task_cmd =
  let task_name = Arg.(value & pos 0 string "" & info ~docv:"NAME" []) in
  let priority = Arg.(value & pos 1 int 0 & info ~docv:"PRIORITY" []) in
  let complete = Arg.(value & pos 2 bool false & info ~docv:"COMPLETED?" []) in
  let doc = "Save a new task." in
  let info = Cmd.info "new" ~doc in
  Cmd.v info Term.(const save_new_task $ task_name $ priority $ complete)
;;

let highest_priority_cmd =
  let doc = "Get the highest priority task." in
  let info = Cmd.info "first" ~doc in
  let file =
    Arg.(
      value
      & opt string task_file
      & info ~env:(Cmd.Env.info task_file) ~docv:"FILENAME" [ "f" ])
  in
  Cmd.v info Term.(const get_highest_priority_task $ file)
;;

let complete_task_cmd =
  let doc = "Complete a task, default is the 0 task." in
  let info = Cmd.info "complete" ~doc in
  let file =
    Arg.(
      value
      & opt string task_file
      & info ~env:(Cmd.Env.info task_file) ~docv:"FILENAME" [ "f" ])
  in
  let num = Arg.(value & opt int 0 & info ~docv:"INDEX" [ "n" ]) in
  Cmd.v info Term.(const complete_task $ file $ num)
;;

let clean_task_cmd =
  let doc = "Clean all completed tasks from the list." in
  let info = Cmd.info "clean" ~doc in
  let file =
    Arg.(
      value
      & opt string task_file
      & info ~env:(Cmd.Env.info task_file) ~docv:"FILENAME" [ "f" ])
  in
  Cmd.v info Term.(const clean_tasks $ file)
;;

let tache_cmd =
  let doc = "Simple CLI task manager" in
  let info = Cmd.info "tache" ~version:"0.1" ~doc in
  Cmd.group
    info
    [ new_task_cmd
    ; highest_priority_cmd
    ; list_tasks_cmd
    ; complete_task_cmd
    ; clean_task_cmd
    ]
;;

let () = exit (Cmd.eval tache_cmd)
