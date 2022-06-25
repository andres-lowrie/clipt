import ../src/lexer

block: # Traversing
  block: # readChar
    var lex = initLexer("abc")
    assert lex.input == "abc"

    assert lex.lookingAt == 'a'
    readChar(lex)
    assert lex.lookingAt == 'b'
    readChar(lex)
    assert lex.lookingAt == 'c'
    readChar(lex)
    assert lex.lookingAt == '\0'

block: # Tokens
  block: # tokens expected given literals
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

  block: # nextToken
    let input = ":=$|"
    var lex = initLexer(input)

    let want = @[tkColon, tkAssign, tkDollar, tkPipe, tkEof]
    for w in want:
      let got = nextToken(lex)
      assert got.tkType == w, "Want: " & $w & " Got: " & $got.tkType
