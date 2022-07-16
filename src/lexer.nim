import tables

type TokenType* = enum
  tkInvalid, tkEof, tkIdentifier, tkNewline, tkIndent, tkColon, tkAssign,
  tkDollar, tkHyphen, tkUnderscore, tkSingleQuote, tkDoubleQuote, tkBackslash,
  tkForwardslash, tkLParen, tkRParen, tkLBrace, tkRBrace, tkLBracket,
  tkRBracket, tkLAngleBracket, tkRAngleBracket, tkPipe, tkAmpersand,
  tkSemiColon, tkHash, tkSpace, tkNumber, tkPeriod, tkAt
  # Keywords
  tkSetup, tkRun, tkTest,
  # Operator
  tkEQ, tkNEQ, tkRgxEQ, tkRgxLit

type Token* = object
  literal*: string
  tkType*: TokenType

type Lexer* = object
  input*: string
  curPos*: int
  readPos: int
  lookingAt*: char

const keywords = {"setup": tkSetup, "run": tkRun, "test": tkTest}.toTable

proc readChar*(l: var Lexer) =
  # are we done reading? If so then we need to set some state so that another
  # process can check to know we're done
  if l.readPos >= len(l.input):
    l.lookingAt = '\0' # which should result to EOF
  else:
    l.lookingAt = l.input[l.readPos]

  l.curPos = l.readPos
  l.readPos += 1

proc peekChar*(l: var Lexer): char =
  if l.readPos >= len(l.input):
    result = '\0' # not sure what to return here
  else:
    result = l.input[l.readPos]

proc initLexer*(input: string): Lexer =
  result = Lexer(input: input)

proc isValidIdOrKey(input: char): bool =
  if input in {'A'..'Z', 'a'..'z', '_', '-'}:
    true
  else:
    false

proc isNumber(input: char): bool =
  if input in {'0'..'9'}:
    true
  else:
    false

proc nextToken*(l: var Lexer): Token =
  readChar(l)
  case l.lookingAt
  of ' ':
    result = Token(tkType: tkSpace, literal: $l.lookingAt)
  of '\n':
    result = Token(tkType: tkNewline, literal: $l.lookingAt)
  of '\t':
    result = Token(tkType: tkIndent, literal: $l.lookingAt)
  of '=':
    if peekChar(l) == '=':
      let cur = l.lookingAt
      readChar(l)
      let literal = $cur & l.lookingAt
      result = Token(tkType: tkEQ, literal: literal)
    else:
      result = Token(tkType: tkAssign, literal: $l.lookingAt)
  of '!':
    if peekChar(l) == '=':
      let cur = l.lookingAt
      readChar(l)
      let literal = $cur & l.lookingAt
      result = Token(tkType: tkNEQ, literal: literal)
    else:
      result = Token(tkType: tkAssign, literal: $l.lookingAt)
  of '~':
    if peekChar(l) == '=':
      let cur = l.lookingAt
      readChar(l)
      let literal = $cur & l.lookingAt
      result = Token(tkType: tkRgxEQ, literal: literal)
    else:
      result = Token(tkType: tkAssign, literal: $l.lookingAt)
  of ':':
    result = Token(tkType: tkColon, literal: $l.lookingAt)
  of '@':
    result = Token(tkType: tkAt, literal: $l.lookingAt)
  of '.':
    result = Token(tkType: tkPeriod, literal: $l.lookingAt)
  of '$':
    result = Token(tkType: tkDollar, literal: $l.lookingAt)
  of '-':
    result = Token(tkType: tkHyphen, literal: $l.lookingAt)
  of '_':
    result = Token(tkType: tkUnderscore, literal: $l.lookingAt)
  of '\'':
    result = Token(tkType: tkSingleQuote, literal: $l.lookingAt)
  of '"':
    result = Token(tkType: tkDoubleQuote, literal: $l.lookingAt)
  of '\\':
    result = Token(tkType: tkBackslash, literal: $l.lookingAt)
  of '/':
    result = Token(tkType: tkForwardslash, literal: $l.lookingAt)
  of '(':
    result = Token(tkType: tkLParen, literal: $l.lookingAt)
  of ')':
    result = Token(tkType: tkRParen, literal: $l.lookingAt)
  of '{':
    result = Token(tkType: tkLBrace, literal: $l.lookingAt)
  of '}':
    result = Token(tkType: tkRBrace, literal: $l.lookingAt)
  of '[':
    result = Token(tkType: tkLBracket, literal: $l.lookingAt)
  of ']':
    result = Token(tkType: tkRBracket, literal: $l.lookingAt)
  of '<':
    result = Token(tkType: tkLAngleBracket, literal: $l.lookingAt)
  of '>':
    result = Token(tkType: tkRAngleBracket, literal: $l.lookingAt)
  of '|':
    result = Token(tkType: tkPipe, literal: $l.lookingAt)
  of '&':
    result = Token(tkType: tkAmpersand, literal: $l.lookingAt)
  of ';':
    result = Token(tkType: tkSemiColon, literal: $l.lookingAt)
  of '#':
    result = Token(tkType: tkHash, literal: $l.lookingAt)
  of '\0':
    result = Token(tkType: tkEof, literal: $l.lookingAt)
  else:
    # More complex ones
    if isNumber(l.lookingAt):
      result = Token(tkType: tkNumber, literal: $l.lookingAt)
      return

    # discern if keyword or identifier
    if not isValidIdOrKey(l.lookingAt):
      result = Token(tkType: tkInvalid, literal: $l.lookingAt)
    else:
      let fromPos = l.curPos
      while isValidIdOrKey(l.lookingAt):
        readChar(l)
      let toPos = l.curPos-1

      let rng = l.input[fromPos..toPos]
      if keywords.hasKey(rng):
        result = Token(tkType: keywords[rng], literal: rng)
      else:
        result = Token(tkType: tkIdentifier, literal: rng)

      # have to move the positions back so that we don't eat a token
      l.curPos -= 1
      l.readPos -= 1
