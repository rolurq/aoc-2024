import unicode, strutils, sequtils

const debug = false

var reports: seq[seq[int]] = @[]

for line in stdin.lines:
    var
        numbers = line.split.map parseInt
        diffs = zip(numbers[0 .. ^2], numbers[1 .. ^1]).mapIt it[0] - it[1]

    when debug: echo $numbers & " " & $diffs
    reports.add(diffs)

proc isSafe(diffs: seq[int]): bool =
    return (diffs.allIt(it > 0) and max(diffs) <= 3) or (diffs.allIt(it < 0) and
            min(diffs) >= -3)

proc isRecoverable(d: seq[int]): bool =
    if d[1 .. ^1].isSafe: return true

    for n in 1 ..< d.len:
        if isSafe d[0 ..< n - 1] & @[d[n - 1] + d[n]] & d[n + 1..^1]:
            result = true
            return

    return d[0 ..< ^1].isSafe

let
    safe = reports.filter isSafe
    unsafe = reports.filterIt it notin safe

echo "Part 1: " & $safe.len

let unsafeRecoverable = unsafe.filter(isRecoverable)

echo "Part 2: " & $(unsafeRecoverable.len + safe.len)
