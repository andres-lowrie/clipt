import "./lexer"

const banner = """
CLIPT Repl
"""

const prompt = ">>> "

proc main() =
  echo(banner)

  var shouldExit = false
  while shouldExit != true:
    stdout.write(prompt)
    let input = stdin.readline()
    var lex = initLexer(input)

    var doneLexing = false
    while not doneLexing:
      let nt = nextToken(lex)
      if (nt.tkType == tkEof):
        doneLexing = true
      else:
        echo($nt)

    echo("prompt again")


when isMainModule:
  main()
