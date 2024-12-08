import sugar, tables, strutils

type
    AntennaTable = Table[(int, int), char]
    Visited = Table[(int, int), bool]

template `+`(a, b: (int, int)): (int, int) =
    (a[0] + b[0], a[1] + b[1])

template `-`(a, b: (int, int)): (int, int) =
    (a[0] - b[0], a[1] - b[1])

proc readInput(antennas: var AntennaTable): seq[string] =
    result = stdin.readAll.splitLines
    antennas = collect(initTable()):
        for i in 0 ..< result.len:
            for j in 0 ..< result[i].len:
                let c = result[i][j]
                if c == '.':
                    continue
                {(i, j): c}

template place(antenna: char, pos: (int, int), map: var seq[string],
        visited: var Visited): bool =
    var (i, j) = pos
    if i notin 0 ..< map.len or j notin 0 ..< map[i].len:
        false
    else:
        if map[i][j] != '#' and map[i][j] != antenna and
                not visited.getOrDefault(pos, false):
            if map[i][j] == '.':
                map[i][j] = '#'
            else:
                visited[pos] = true
            inc(result)
        true

proc Part1(antennas: AntennaTable, map: seq[string]): int =
    var
        visited: Visited
        mark = map

    for firstPos in antennas.keys:
        let (i0, j0) = firstPos
        for secondPos in antennas.keys:
            let
                (i1, j1) = secondPos
                vec = (i1 - i0, j1 - j0)
            if antennas[firstPos] != antennas[secondPos] or i1 <= i0:
                continue

            discard antennas[firstPos].place(secondPos + vec, mark, visited)
            discard antennas[firstPos].place(firstPos - vec, mark, visited)

proc Part2(antennas: AntennaTable, map: seq[string]): int =
    var
        visited: Visited
        mark = map

    for firstPos in antennas.keys:
        let (i0, j0) = firstPos
        for secondPos in antennas.keys:
            let
                (i1, j1) = secondPos
                vec = (i1 - i0, j1 - j0)
            if antennas[firstPos] != antennas[secondPos] or i1 <= i0:
                continue

            var pos = secondPos + vec
            while antennas[firstPos].place(pos, mark, visited):
                pos = pos + vec
            pos = firstPos - vec
            while antennas[firstPos].place(pos, mark, visited):
                pos = pos - vec
    inc(result, antennas.len - visited.len)

var antennas: AntennaTable
let map = readInput(antennas)

echo "Part 1: " & $Part1(antennas, map)
echo "Part 2: " & $Part2(antennas, map)
