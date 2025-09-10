type elt = node ref and node = Root of int | Link of elt

let singleton () : elt = ref (Root 0)

let rec find (x : elt) : elt =
  match !x with
  | Root _ -> x
  | Link node ->
      let parent = find node in
      x := Link parent;
      parent

let union (x : elt) (y : elt) : unit =
  let root_x = find x in
  let root_y = find y in
  if root_x != root_y then
    match !root_x, !root_y with
    | Root rx, Root ry ->
        if rx < ry then
          root_y := Link root_x
        else begin
          root_x := Link root_y;
          if rx = ry then x := Root (rx + 1)
        end
    | _ -> failwith ""
  else
    ()

let print_uf (uf : elt array) : unit =
  Printf.printf "[|";
  Array.iteri
    (fun i x ->
      let root_x = find x in
      match !root_x with
      | Root r -> Printf.printf " %d:%d;" i r
      | Link _ -> Printf.printf " %d:Link;" i
    )
    uf;
  Printf.printf "|]\n"

let test () =
  let uf = Array.init 8 (fun _ -> singleton ()) in
  print_uf uf;
  union uf.(3) uf.(4);
  union uf.(2) uf.(5);
  (* union uf.(5) uf.(7);
  union uf.(4) uf.(5);
  union uf.(4) uf.(3); *)
  print_uf uf

let () = test ()
