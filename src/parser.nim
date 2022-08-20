type NodeType* = enum
  nStatement,
  nExpresion

type Node* = object
  nType: NodeType


type Program* = object
  statements: seq[Node]
