import ../src/lexer

proc printAssumption(want, got: auto): string =
  result = "Want: " & $want & " Got: " & $got


block: # Traversing
  block: # readChar
    var lex = initLexer("abc")
    assert lex.input == "abc"

    readChar(lex) # the initLexer function doesn't move the cursors forward
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
      (tkSpace, ' '),
    ]
    for p in pairs:
      let (t, s) = p
      var lex = initLexer($s)
      let got = nextToken(lex)
      assert got.tkType == t, printAssumption(t, got.tkType)

  block: # nextToken
    let input = ":=$|"
    var lex = initLexer(input)

    let want = @[tkColon, tkAssign, tkDollar, tkPipe, tkEof]
    for w in want:
      let got = nextToken(lex)
      assert got.tkType == w, printAssumption(w, got.tkType)

  block: # identider
    let input = "foobar"
    var lex = initLexer(input)

    let want = Token(literal: "foobar", tkType: tkIdentifier)
    let got = nextToken(lex)

    assert got.literal == want.literal, printAssumption(want.literal, got.literal)
    assert got.tkType == want.tkType, printAssumption(want.tkType, got.tkType)

  block: # keyword
    let input = "setup"
    var lex = initLexer(input)

    let want = Token(literal: "setup", tkType: tkSetup)
    let got = nextToken(lex)

    assert got.literal == want.literal, printAssumption(want.literal, got.literal)
    assert got.tkType == want.tkType, printAssumption(want.tkType, got.tkType)

  block: # handle non significant whitespace
    let input = "foo bar"
    var lex = initLexer(input)

    let want = @[
      Token(literal: "foo", tkType: tkIdentifier),
      Token(literal: " ", tkType: tkSpace),
      Token(literal: "bar", tkType: tkIdentifier),
    ]

    var got: seq[Token]
    var cont = true
    while cont:
      let g = nextToken(lex)
      if g.tkType == tkEof:
        cont = false
        continue
      else:
        got.add(g)

    assert got == want, printAssumption(want, got)
