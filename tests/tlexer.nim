import ../src/lexer

# Empty input should return Invalid
var input: char
assert toToken(input).tkType == tkInvalid

# Map tokens to their string representation
let pairs = @[
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
