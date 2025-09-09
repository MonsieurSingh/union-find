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

let print_union uf =
  Printf.printf "[|";
  Array.iteri (fun i root -> Printf.printf "%d:%d;" i uf
    .parent.(root)) uf.parent;
  Printf.printf "|]\n"

let test () =
  let uf = uf_create 6 in
  uf_union uf 1 3;
  uf_union uf 2 2;
  uf_union uf 3 3;
  uf_union uf 4 3;
  uf_union uf 5 0;
  print_union uf;
  Printf.printf "Number of disjoint sets: %d\n" uf.nb_classes

let () = test ()