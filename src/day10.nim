import std/strutils
import std/sugar

const dirs = collect(newSeq):
    for di in -1 .. 1:
        for dj in -1 .. 1:
            if di == 0 xor dj == 0:
                (di, dj)

proc Part1(map: seq[string], unique = true): int =
    proc walk(i, j: int, map: seq[string], visited: var seq[seq[int]]): int =
        if visited[i][j] > 0:
            return if unique: 0 else: visited[i][j]
        let c = map[i][j]
        if c == '9':
            result = 1
        else:
            for (di, dj) in dirs:
                let (ni, nj) = (i + di, j + dj)
                if ni notin 0 .. map.high or nj notin 0 .. map[ni].high or ord(
                        c) + 1 != ord(map[ni][nj]):
                    continue
                inc(result, walk(ni, nj, map, visited))
        visited[i][j] = result

    for i in 0 .. map.high:
        for j in 0 .. map[i].high:
            if map[i][j] == '0':
                var visited = collect(newSeq):
                    for i in 0 .. map.high:
                        newSeq[int](map[i].len)
                inc(result, walk(i, j, map, visited))

let map = stdin.readAll.splitLines

echo "Part 1: " & $Part1(map)
echo "Part 2: " & $Part1(map, false)
