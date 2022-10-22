import lexer

# need to think about this.
# Given that nim doesn't use "concepts" ie I can't have a "node" interface; I
# need to see how I group the statements and expressions into a type so that
# the Program type can operate on a single type
#
# perhaps this is where Generics come into play?
type NodeType* = enum
  nStatement,
  nExpression

type Node* = object
  nType*: NodeType
  token*: Token
# ###

type Program* = object
  statements*: seq[Node]

type AssignStatement* = object
  # don't know how to narrow these down...
  name*: Node # ...should only be able to be TokenType.tkIdentifier
  value*: Node # and this should only be NodeType.nExpression

proc getTokenLiteral*(n: Node): string =
  n.token.literal

proc getTokenLiteral*(p: Program): string =
  for n in p.statements:
    add(result, getTokenLiteral(n))
