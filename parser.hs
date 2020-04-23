import Control.Monad
import Data.Char

-- "∧" - "^"
-- "∨" - "|"
-- "⇒" - "=>"
-- "⇔" - "<=>"

brackets = 0

type Parser a = String -> [(String, String)]

parse :: Parser Char
parse [] = []
parse x = initial [("", x)]

initial [(a, (x:xs))] = interp reqVal [(a, (x:xs))]

interp f [(a, "")] = [(a, "")]
interp f [(a, (x:xs))] = f [(a, (x:xs))]

-- require value (a, b, c, x, y...) or negation(s) with ending value
reqVal [(a, "")] = revert [(a, "")]  

reqVal [(a, (x:xs))]
   | ([x] == "-" || [x] == "(") && xs /= ""   = reqVal [(a ++ [x], xs)]
   | ([x] == "-" || [x] == "(") && xs == ""   = revert [(a, [x] ++ xs)]
   | isLetter x == True                      = reqOp [(a ++ [x], xs)]
   | otherwise                               = revert [(a, [x] ++ xs)]
   --else [(a, [x] ++ xs)]

-- require operator
reqOp [(a, "")] = [(a, "")]

reqOp [(a, (x:xs))]
   | [x] == "^" || [x] == "|"    = reqVal [(a ++ [x], xs)]
   | [x] == ")"                  = reqOp [(a ++ [x], xs)]
   | [x] == "<"                  = reqIff [(a ++ [x], xs)] "<"
   | [x] == "="                  = reqImp [(a ++ [x], xs)]
   | otherwise                   = [(a, [x] ++ xs)]

-- require "if and only if"
reqIff [(a, (x:xs))] p =
   if p == "<"
      then if [x] == "="
         then reqIff [(a ++ [x], xs)] "="
         else revert [(a, (x:xs))]
      else if p == "="
         then if [x] == ">"
            then reqVal [(a ++ [x], xs)]
            else revert [(a, (x:xs))]
         else revert [(a, (x:xs))]

-- require "implication"
reqImp [(a, (x:xs))]
   | [x] == ">"   = reqVal [(a ++ [x], xs)]
   | otherwise    = revert [(a, (x:xs))]
         
-- go back to the last correct variable
revert [("", x)] = [("", x)]
revert [(a, x)]
   | isLetter (last a) == True   = [(a, x)]
   | otherwise                   = revert [(init a, (last a) : x)]