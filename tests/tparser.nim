import ../src/parser
import ../src/lexer

proc printAssumption(want, got: auto): string =
  result = "Want: " & $want & " Got: " & $got

block: # Top-Level Suite
  block: # getTokenLiteral
    var tok = Token(literal: "a", tkType: tkIdentifier)
    var nod = Node(nType: nExpression, token: tok)
    let want = "a"
    var got = getTokenLiteral(nod)
    assert got == want, printAssumption(want, got)

  block: # program
    var tok1 = Token(literal: "a", tkType: tkIdentifier)
    var tok2 = Token(literal: "b", tkType: tkIdentifier)
    var nod1 = Node(nType: nExpression, token: tok1)
    var nod2 = Node(nType: nExpression, token: tok2)
    var prog = Program(statements: @[nod1, nod2])
    let want = "ab"
    var got = getTokenLiteral(prog)
    assert got == want, printAssumption(want, got)
