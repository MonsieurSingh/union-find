let rec ackermann m n =
  if m = 0 then n + 1
  else if m > 0 && n = 0 then ackermann (m - 1) 1
  else if m > 0 && n > 0 then ackermann (m - 1) (ackermann m (n - 1))
  else 0