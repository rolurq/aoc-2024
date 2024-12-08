import nre, sugar, math, sequtils, strutils

const debug = false

template `->` (text: string, pattern: Regex, filter: proc (
        m: RegexMatch): bool = nil): seq[int] =
    collect(newSeq):
        for match in text.findIter pattern:
            when debug: echo $match
            when not filter.isNil:
                if not filter match:
                    continue
            match.captures.toSeq.mapIt(parseInt it.get).prod

let
    input = stdin.readAll
    all = input -> re"mul\((\d{1,3}),(\d{1,3})\)"

echo "Part 1: " & $all.sum

var dont = false
let scoped = input -> re"mul\((\d{1,3}),(\d{1,3})\)|do(?:n't)?\(\)" do (
    m: RegexMatch) -> bool:
    if (let isDo = $m == "do()"; isDo) or $m == "don't()":
        dont = not isDo
        return false
    not dont

echo "Part 2: " & $scoped.sum
