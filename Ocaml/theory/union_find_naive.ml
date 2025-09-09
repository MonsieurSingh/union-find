let uf_create n =
  Array.init n (fun i -> i)

let rec uf_find uf x =
  if uf.(x) = x then x
  else uf_find uf uf.(x)

let uf_union uf a b =
  let root_a = uf.(a) in
  let root_b = uf.(b) in
  if (root_a <> root_b) then
    uf.(root_b) <- root_a

let print_union uf =
  Printf.printf "[|";
  Array.iteri (fun i root -> Printf.printf "%d:%d;" i root) uf;
  Printf.printf "|]\n"

let test () =
  let uf = uf_create 6 in
  uf_union uf 1 3;
  uf_union uf 2 2;
  uf_union uf 3 3;
  uf_union uf 4 3;
  uf_union uf 5 0;
  print_union uf

let () = test ()