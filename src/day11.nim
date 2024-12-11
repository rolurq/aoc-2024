import std/strutils
import std/sugar
import std/tables

template readInput(): seq[int] =
    collect(newSeq):
        for s in stdin.readAll.split(" "):
            s.parseInt

proc count(n, r: int, visited: var Table[(int, int), int]): int =
    if (let v = visited.getOrDefault((n, r), 0); v > 0):
        return v
    if r == 0:
        result = 1
    elif n == 0:
        result = count(1, r - 1, visited)
    elif (let s = $n; s.len %% 2 == 0):
        let middle = s.len /% 2
        result = count(parseInt(s[0 ..< middle]), r - 1, visited) + count(
                parseInt(s[middle .. ^1]), r - 1, visited)
    else:
        result = count(n * 2024, r - 1, visited)
    visited[(n, r)] = result

proc Part1(numbers: seq[int], visited: var Table[(int, int), int],
        reps = 25): int =
    for n in numbers:
        inc(result, count(n, reps, visited))

let numbers = readInput
var visited = initTable[(int, int), int]()

echo "Part 1: " & $Part1(numbers, visited)
echo "Part 2: " & $Part1(numbers, visited, 75)
