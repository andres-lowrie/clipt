#import strutils

type TokenType* = enum
  tkInvalid, tkEof, tkIdentifier, tkNewline, tkIndent, tkColon, tkAssign,
  tkDollar, tkHyphen, tkUnderscore, tkQuote, tkBackslash, tkForwardslash,
  tkLParen, tkRParen, tkLBrace, tkRBrace, tkLBracket, tkRBracket,
  tkLAngleBracket, tkRAngleBracket, tkPipe, tkAmpersand, tkSemiColon, tkHash

type Token* = object
  tkType*: TokenType

proc toToken*(input: string): Token =
  case input
  of "":
    result = Token(tkType: tkEof)

