import ../src/parser

proc printAssumption(want, got: auto): string =
  result = "Want: " & $want & " Got: " & $got

block: # Top-Level Suite
  assert true == false
