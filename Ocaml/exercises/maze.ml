type direction = RIGHT | DOWN
type door = int * int * direction
type uf = { parent : int array ; rank : int array ; mutable nb_classes : int }

let uf_create n =
  {
    parent = Array.init n (fun i -> i);
    rank = Array.make n 0;
    nb_classes = n
  }

let rec uf_find uf x =
  if uf.parent.(x) = x then x
  else
    let root = uf_find uf uf.parent.(x) in
    uf.parent.(x) <- root;
    root

let uf_union uf a b =
  let root_a = uf_find uf a in
  let root_b = uf_find uf b in
  if root_a <> root_b then
    if uf.rank.(root_a) < uf.rank.(root_b) then
      uf.parent.(root_a) <- root_b
    else if uf.rank.(root_a) > uf.rank.(root_b) then
      uf.parent.(root_b) <- root_a
    else begin
      uf.parent.(root_b) <- root_a;
      uf.rank.(root_a) <- uf.rank.(root_a) + 1
    end;
  uf.nb_classes <- uf.nb_classes - 1


let knuth_shuffle tab =
  Random.self_init ();
  let n = Array.length tab in
  for i = n - 1 downto 1 do
    let r = Random.int (i + 1) in
    let temp = tab.(i) in
    tab.(i) <- tab.(r);
    tab.(r) <- temp
  done

let doors n : door array =
  let door_list = ref [] in
  for i = 0 to n - 1 do
    for j = 0 to n - 2 do
      door_list := (i, j, RIGHT) :: !door_list;
      door_list := (j, i, DOWN) :: !door_list
    done
  done;
  let arr = Array.of_list !door_list in
  knuth_shuffle arr;
  arr

let kruskal_maze n =
  let horizontal_array = Array.make_matrix n n true in
  let vertical_array = Array.make_matrix n n true in
  let uf = uf_create (n * n) in
  let f (i, j, dir) =
    let k = n * i + j in
    let k' = if dir = RIGHT then k + 1 else k + n in
    if uf_find uf k <> uf_find uf k' then begin
      if dir = RIGHT then
        horizontal_array.(i).(j) <- false
      else
        vertical_array.(i).(j) <- false;
      uf_union uf k k'
    end
  in
  let door_array = doors n in
  Array.iter f (door_array);
  (horizontal_array, vertical_array)

let moves (horizontale, verticale) (i,j) =
  let res = ref [] in
  let n = Array.length horizontale in
  if i > 0 && not verticale.(i-1).(j) then res := (i-1,j) :: !res; (* up *)
  if i < n-1 && not verticale.(i).(j) then res := (i+1,j) :: !res; (* down *)
  if j > 0 && not horizontale.(i).(j-1) then res := (i,j-1) :: !res; (* left *)
  if j < n-1 && not horizontale.(i).(j) then res := (i,j+1) :: !res; (* right *)
  !res
open Printf
let solve maze start target =
  let visited = Hashtbl.create 100 in
  let parent = Hashtbl.create 100 in
  let queue = Queue.create () in
  Queue.push start queue;
  Hashtbl.add visited start true;
  let rec bfs () =
    if Queue.is_empty queue then None
    else
      let (i, j) = Queue.pop queue in
      if (i, j) = target then Some parent
      else begin
      List.iter (fun (ni, nj) ->
        if not (Hashtbl.mem visited (ni, nj)) then begin
          Hashtbl.add visited (ni, nj) true;
          Hashtbl.add parent (ni, nj) (i, j);
          Queue.push (ni, nj) queue
        end
      ) (moves maze (i, j));
      bfs ()
    end
  in
  bfs ()

let rec reconstruct_path parent target =
  try let p = Hashtbl.find parent target in
    reconstruct_path parent p @ [target]
  with Not_found -> [target]

let random_border_cell n =
  match Random.int 4 with
  | 0 -> (0, Random.int n)    (* top row *)
  | 1 -> (n-1, Random.int n)  (* bottom row *)
  | 2 -> (Random.int n, 0)    (* left col *)
  | _ -> (Random.int n, n-1)  (* right col *)

let open_border (horizontal_array, vertical_array) (i, j) =
  let n = Array.length horizontal_array in
  if i = 0 then ()
  else if i = n-1 then vertical_array.(i).(j) <- false
  else if j = 0 then ()
  else if j = n-1 then horizontal_array.(i).(j) <- false


let print_maze_with_path (horizontal_array, vertical_array) path start target =
  let path_set = Hashtbl.create 100 in
  List.iter (fun (i, j) -> Hashtbl.add path_set (i, j) true) path;
  let n = Array.length horizontal_array in
  for j = 0 to n - 1 do
    if (0, j) = start || (0, j) = target then
      print_string " "
    else
      print_string " _"
  done;
  print_newline ();
  for i = 0 to n - 1 do
    for j = 0 to n - 1 do
      if j = 0 then
        if (i, 0) = start || (i, 0) = target then
          print_string " "
        else
          print_string "|";
      let in_path = Hashtbl.mem path_set (i,j) in
      let cell_char = if in_path then "x" else "_" in
      let bottom =
        if i < n-1 && not vertical_array.(i).(j) then begin
          if in_path then "x"
          else " "
        end
        else cell_char
      in
      let right =
        if j < n-1 && not horizontal_array.(i).(j) then
          (if in_path then "x" else " ")
        else if (i,j) = start || (i,j) = target then " "
        else "|"
      in
      print_string bottom;
      print_string right
    done;
    print_newline ()
  done

let n = 32
let () =
  Random.self_init ();
  let maze = kruskal_maze n in
  let start = random_border_cell n in
  let rec pick_target () =
    let t = random_border_cell n in
    if t <> start then t else pick_target ()
  in
  let target = pick_target () in
  open_border maze start;
  open_border maze target;
  match solve maze start target with
  | None -> printf "No path found from %s to %s\n"
              (Printf.sprintf "(%d,%d)" (fst start) (snd start))
              (Printf.sprintf "(%d,%d)" (fst target) (snd target))
  | Some parent ->
      let path = reconstruct_path parent target in
      print_maze_with_path maze path start target;
      printf "Start: %s\n" (Printf.sprintf "(%d,%d)" (fst start) (snd start));
      printf "Target: %s\n" (Printf.sprintf "(%d,%d)" (fst target) (snd target));
