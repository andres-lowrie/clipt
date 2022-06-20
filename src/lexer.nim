#import strutils

type TokenType* = enum
  tkInvalid, tkEof, tkIdentifier, tkNewline, tkIndent, tkColon, tkAssign,
  tkDollar, tkHyphen, tkUnderscore, tkSingleQuote, tkDoubleQuote, tkBackslash,
  tkForwardslash, tkLParen, tkRParen, tkLBrace, tkRBrace, tkLBracket,
  tkRBracket, tkLAngleBracket, tkRAngleBracket, tkPipe, tkAmpersand,
  tkSemiColon, tkHash

type Token* = object
  tkType*: TokenType

type Lexer* = object
  input*: string
  curPos: int
  readPos: int
  lookingAt*: char

proc initLexer*(input: string): Lexer =
  result = Lexer(input: input)

proc readChar*(l: var Lexer) =
  # are we done reading? If so then we need to set some state so that another
  # process can check to know where' done
  if l.readPos >= len(l.input):
    l.lookingAt = '\0' # which should result to EOF
  else:
    l.lookingAt = l.input[l.readPos]

  l.curPos = l.readPos
  l.readPos += 1

proc toToken*(input: char): Token =
  case input
  of '\n':
    result = Token(tkType: tkNewline)
  of '\t':
    result = Token(tkType: tkIndent)
  of ':':
    result = Token(tkType: tkColon)
  of '=':
    result = Token(tkType: tkAssign)
  of '$':
    result = Token(tkType: tkDollar)
  of '-':
    result = Token(tkType: tkHyphen)
  of '_':
    result = Token(tkType: tkUnderscore)
  of '\'':
    result = Token(tkType: tkSingleQuote)
  of '"':
    result = Token(tkType: tkDoubleQuote)
  of '\\':
    result = Token(tkType: tkBackslash)
  of '/':
    result = Token(tkType: tkForwardslash)
  of '(':
    result = Token(tkType: tkLParen)
  of ')':
    result = Token(tkType: tkRParen)
  of '{':
    result = Token(tkType: tkLBrace)
  of '}':
    result = Token(tkType: tkRBrace)
  of '[':
    result = Token(tkType: tkLBracket)
  of ']':
    result = Token(tkType: tkRBracket)
  of '<':
    result = Token(tkType: tkLAngleBracket)
  of '>':
    result = Token(tkType: tkRAngleBracket)
  of '|':
    result = Token(tkType: tkPipe)
  of '&':
    result = Token(tkType: tkAmpersand)
  of ';':
    result = Token(tkType: tkSemiColon)
  of '#':
    result = Token(tkType: tkHash)
  of '\0':
    result = Token(tkType: tkEof)
  else:
    result = Token(tkType: tkInvalid)

