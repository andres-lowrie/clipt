import ../src/lexer

# Map tokens to their string representation
let pairs = @[
  (tkEof, '\0'),
  (tkInvalid, '!'),
  (tkNewline, '\n'),
  (tkIndent, '\t'),
  (tkColon, ':'),
  (tkAssign, '='),
  (tkDollar, '$'),
  (tkHyphen, '-'),
  (tkUnderscore, '_'),
  (tkSingleQuote, '\''),
  (tkDoubleQuote, '"'),
  (tkBackslash, '\\'),
  (tkForwardslash, '/'),
  (tkLParen, '('),
  (tkRParen, ')'),
  (tkLBrace, '{'),
  (tkRBrace, '}'),
  (tkLBracket, '['),
  (tkRBracket, ']'),
  (tkLAngleBracket, '<'),
  (tkRAngleBracket, '>'),
  (tkPipe, '|'),
  (tkAmpersand, '&'),
  (tkSemiColon, ';'),
  (tkHash, '#'),
]
for p in pairs:
  let (t, s) = p
  let got = toToken(s)
  assert got.tkType == t, "Want: " & $t & " Got: " & $got.tkType


# Basic input traversal
var lex = initLexer("abc")
assert lex.input == "abc"

readChar(lex)
assert lex.lookingAt == 'a'
readChar(lex)
assert lex.lookingAt == 'b'
readChar(lex)
assert lex.lookingAt == 'c'
readChar(lex)
assert lex.lookingAt == '\0'
