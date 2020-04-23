# haskell-logic-parser
Zeroth-order logic parser in Haskell

Use command ```parse "FORMULA"``` where FORMULA is a zeroth-order logic formula.

- negation: ```-```
- alternative: ```|```
- conjunction: ```^```
- implication: ```=>```
- if and only if: ```<=>```
- brackets: ```( )```

Output: ```[("ELEMENTS PARSED CORRECTLY", "INVALID ELEMENTS")]```

Given formula is correct if the second string in the tuple is empty, i.e. ```""```.

### Examples
```
> parse "^"
[("","^")]

> parse "a"
[("a","")]

> parse "a|b"
[("a|b","")]

> parse "-a^b"
[("-a^b","")]

> parse "(--a|b=>-c)"
[("(--a|b=>-c)","")]

> parse "a=>"
[("a","=>")]

> parse "a^bc"
[("a^b","c")]

> parse "(-(p^q))<=>((-p)|(-q))"
[("(-(p^q))<=>((-p)|(-q))","")]

> parse "x^-y=>" 
[("x^-y","=>")]

> parse "((a|b)^(b"
[("","((a|b)^(b")]
comment: if numbers of opening and closing brackets are not equal, whole formula is treated as invalid.
```

### Known issues
For the example below the incorrect part should look like ```"=>"``` and instead it is ```")=>"```.
```
> parse "-(x^-y)=>"
```

### Additional comments
- There is no point to keep function ```interp``` in code, but it is still used in one place as a proxy for another function; currently I don't have time to check if a removal makes unexpected mess.