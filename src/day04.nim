import sequtils


iterator `**`* (n, m: Slice[int]): (int, int) =
    for i in n:
        for j in m:
            yield (i, j)

template `**` (n, m: int): untyped =
    (0..<n) ** (0..<m)

let
    matrix = stdin.lines.toSeq
    rows = matrix.len
    cols = matrix[0].len

proc Part1(): int =
    const  word = "XMAS"
    let dirs = toSeq((-1..1) ** (-1..1)).filter do (t: (int, int)) -> bool:
        let (x, y) = t
        x != 0 or y != 0

    for (row, col) in rows ** cols:
        for (dx, dy) in dirs:
            var (x, y) = (row, col)
            block search:
                for character in word:
                    if x notin 0..<rows or y notin 0..<cols or character != matrix[x][y]:
                        break search
                    inc(x, dx)
                    inc(y, dy)
                inc(result)

proc Part2(): int =
    const word = "MAS"

    template findWord =
        for character in word:
            if x notin 0..<rows or y notin 0..<cols or character != matrix[x][y]:
                break search
            inc(x, dx)
            inc(y, dy)

    for (row, col) in rows ** cols:
        var (x, y) = (row, col)
        for dy in [1, -1]:
            block search:
                x = row
                for dx in [1 * dy, -1 * dy]:
                    y = col
                    findWord()
                    dec(x, dx)
                inc(result)
        for dx in [1, -1]:
            block search:
                y = col
                for dy in [-1 * dx, 1 * dx]:
                    x = row
                    findWord()
                    dec(y, dy)
                inc(result)
        

echo "Part 1: " & $Part1()
echo "Part 2: " & $Part2()
