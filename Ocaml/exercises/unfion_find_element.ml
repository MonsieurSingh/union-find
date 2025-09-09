type elt = node ref and node = Root of int | Link of elt

let singleton x = ref (Root x)

let rec find (x : elt) : int =
  match !x with
  | Root r -> r
  | Link y ->
      let root = find y in
      x := Link (singleton root);
      root

let union (x : elt) (y : elt) : unit =
  let root_x = find x in
  let root_y = find y in
  if root_x <> root_y then
    x := Link (singleton root_y)
  else
    ()

let print_uf (uf : elt array) : unit =
  Printf.printf "[|";
  Array.iteri (fun i node -> Printf.printf "%d:%d;" i (find node)) uf;
  Printf.printf "|]\n"

let test () =
  let uf = Array.init 6 singleton in
  union uf.(1) uf.(3);
  union uf.(2) uf.(2);
  union uf.(3) uf.(3);
  union uf.(4) uf.(3);
  union uf.(5) uf.(0);
  print_uf uf

let () = test ()
