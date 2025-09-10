let knuth_shuffle (tab : int array) (n : int) : int array =
  let rec aux i =
    if i >= n then
      ()
    else
      let j = Random.int (i + 1) in
      let temp = tab.(i) in
      tab.(i) <- tab.(j);
      tab.(j) <- temp;
      aux (i + 1)
  in
  aux 0;
  tab

let test() =
  Random.self_init ();
  let n = 10 in
  let tab = Array.init n (fun i -> i) in
  let shuffled_tab = knuth_shuffle tab n in
  Array.iter (Printf.printf "%d ") shuffled_tab;
  Printf.printf "\n"

let () = test ()