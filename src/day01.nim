import strutils, sequtils, algorithm, math, tables

let
    pairs = stdin
        .readAll
        .splitLines
        .mapIt(it.split.map parseInt)
        .mapIt (it[0], it[1])
    (first, second) = pairs.unzip

let distance = zip(first.sorted, second.sorted)
    .mapIt(abs(it[0] - it[1]))
    .sum

echo "Part 1: " & $distance

var count = initCountTable[int]()
for n in second:
    count.inc(n)

let similarity = first.mapIt(it * count[it]).sum

echo "Part 2: " & $similarity
