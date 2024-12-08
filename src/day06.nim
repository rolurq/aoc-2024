import sequtils, re, tables

template rotate(t: (int, int)): (int, int) =
    (t[1], -t[0])

template `+`(a, b: (int, int)): (int, int) =
    (a[0] + b[0], a[1] + b[1])

template toChar(dir: (int, int)): char =
    if dir == (-1, 0): '^'
    elif dir == (0, 1): '>'
    elif dir == (1, 0): 'v'
    else: '<'

let map = stdin.lines.toSeq

proc findGuard(): ((int, int), (int, int)) =
    var
        i, j: int
        dir: (int, int)
    while i in 0 ..< len(map):
        j = map[i].find(re"\^|>|v|<")
        if j != -1:
            dir = case map[i][j]
                of '^': (-1, 0)
                of '>': (0, 1)
                of 'v': (1, 0)
                else: (0, -1) # <
            break
        inc(i)
    return ((i, j), dir)

proc hasLoop(map: var seq[string], start, dir: var (int, int), steps: var int,
        visited: var Table[(int, int), bool]): bool =
    while true:
        visited[start] = true

        var (i, j) = start + dir
        if i notin 0 ..< len(map) or j notin 0 ..< len(map[i]):
            return false

        case map[i][j]:
            of '#':
                dir = dir.rotate
                continue
            of '.':
                inc(steps)
                map[i][j] = dir.toChar
            elif map[i][j] == dir.toChar:
                return true
        start = (i, j)

proc Part1(start, firstDir: (int, int), visited: var Table[(int, int), bool]): int =
    result = 1
    var
        (pos, dir) = (start, firstDir)
        mark = map

    discard mark.hasLoop(pos, dir, result, visited)

proc Part2(start, firstDir: (int, int), visited: Table[(int, int), bool]): int =
    for visitedPos in visited.keys:
        if visitedPos == start:
            continue

        var
            pos = start
            dir = firstDir
            mark = map
            steps: int
            tmpVisited: Table[(int, int), bool]

        let (i, j) = visitedPos
        mark[i][j] = '#'
        if mark.hasLoop(pos, dir, steps, tmpVisited):
            inc(result)

let (guardPos, guardDir) = findGuard()
var visited = initTable[(int, int), bool]()

echo "Part 1: " & $Part1(guardPos, guardDir, visited)
echo "Part 2: " & $Part2(guardPos, guardDir, visited)
