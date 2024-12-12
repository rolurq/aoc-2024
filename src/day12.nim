import std/strutils
import std/sugar
import std/strformat

const dirs = collect(newSeq):
    for di in -1 .. 1:
        for dj in -1 .. 1:
            if di == 0 xor dj == 0:
                (di, dj)

proc measure(start: (int, int), garden: seq[string], visited: var seq[seq[
        bool]], perimeter, sides: var int): int =
    var
        queue = @[start]
        (i, j) = start
    let plant = garden[i][j]

    visited[i][j] = true
    while queue.len > 0:
        (i, j) = queue.pop
        inc(result)

        for (di, dj) in dirs:
            let
                (ni, nj) = (i + di, j + dj)
                isOut = ni notin 0 .. garden.high or nj notin 0 .. garden[ni].high
            if isOut or garden[ni][nj] != plant:
                if dj == 0 and j >= 0:
                    if j == 0 or garden[i][j - 1] != plant:
                        inc(sides)
                    elif not isOut and garden[ni][j - 1] == plant:
                        inc(sides)
                elif i >= 0:
                    if i == 0 or garden[i - 1][j] != plant:
                        inc(sides)
                    elif not isOut and garden[i - 1][nj] == plant:
                        inc(sides)
                inc(perimeter)
            elif not isOut and garden[ni][nj] == plant and not visited[ni][nj]:
                visited[ni][nj] = true
                queue.add((ni, nj))

type Region = tuple[area: int, perimiter: int, sides: int]

proc Part1(garden: seq[string], regions: var seq[Region]): int =
    var visited = collect(newSeq):
        for i in 0 .. garden.high:
            newSeq[bool](garden[i].len)

    for i in 0 .. garden.high:
        for j in 0 .. garden[i].high:
            if visited[i][j]:
                continue
            var sides, perimeter: int
            let area = measure((i, j), garden, visited, perimeter, sides)
            inc(result, area * perimeter)
            regions.add((area, perimeter, sides))

proc Part2(regions: seq[Region]): int =
    for region in regions:
        inc(result, region.area * region.sides)

let garden = stdin.readAll.splitLines
var regions: seq[Region] = @[]

echo fmt"Part 1: {garden.Part1(regions)}"
echo fmt"Part 2: {regions.Part2}"
