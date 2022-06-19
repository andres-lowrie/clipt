import ../src/lexer

# Empty input should return EOF
assert toToken("").tkType == tkEof
