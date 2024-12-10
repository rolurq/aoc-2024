template toNumber(c: char): int = ord(c) - ord('0')

template `+..+`(n, d: int): int = (2 * n + d - 1) * d /% 2 # n + (n + 1) + ... + (n + (d - 1))

template lastIt(s, pred: untyped): int =
    var
        result = -1
        i = high(s)
    while i > 0:
        var it {.inject.} = s[i]
        if pred:
            result = i
            break
        dec(i)
    result

template readInput(files, spaces: var seq[int]) =
    let input = stdin.readAll
    for i in countup(0, high(input), 2):
        files.add(input[i].toNumber)
        if i + 1 < input.len:
            spaces.add(input[i + 1].toNumber)

proc Part1(files, spaces: seq[int]): int =
    var
        (cFiles, cSpaces) = (files, spaces)
        right = high(files)
        j = 0
    for i in 0 .. cSpaces.high:
        if i <= right:
            inc(result, i * (j +..+ cFiles[i]))
            inc(j, cFiles[i])

        while right > i and cSpaces[i] > 0:
            var size = min(cFiles[right], cSpaces[i])
            inc(result, right * (j +..+ size))
            inc(j, size)

            dec(cFiles[right], size)
            if cFiles[right] == 0:
                dec(right)
            dec(cSpaces[i], size)

proc Part2(files, spaces: var seq[int]): int =
    var j = 0
    for i in 0 .. spaces.high:
        if files[i] > 0:
            inc(result, i * (j +..+ files[i]))
        inc(j, abs(files[i]))
        files[i] = 0

        while spaces[i] > 0:
            let right = files.lastIt(it > 0 and it <= spaces[i])
            if right < 0:
                inc(j, spaces[i])
                break
            inc(result, right * (j +..+ files[right]))
            inc(j, files[right])

            dec(spaces[i], files[right])
            files[right] *= -1

var files, spaces = newSeq[int]()
readInput(files, spaces)

echo "Part 1: " & $Part1(files, spaces)
echo "Part 2: " & $Part2(files, spaces)
