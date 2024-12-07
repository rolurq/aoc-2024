import strutils, sequtils, math

type Operations = seq[seq[int]]

proc readInput(): Operations =
    for line in stdin.lines:
        var list = newSeq[int]()
        for (token, isSep) in line.tokenize({':'} + Whitespace):
            if isSep:
                continue
            list.add(token.parseInt)
        result.add(list)

proc calculate(numbers: seq[int], current, target: int): bool =
    if numbers.len == 0:
        return current == target

    let slice = numbers[1 .. ^1]
    if slice.calculate(current * numbers[0], target) or
        slice.calculate(current + numbers[0], target):
            return true

    return false

proc concatenate(numbers: seq[int], current, target: int): bool =
    if numbers.len == 0:
        return current == target

    let slice = numbers[1 .. ^1]
    if slice.concatenate(parseInt($current & $numbers[0]), target) or
        slice.concatenate(current * numbers[0], target) or
        slice.concatenate(current + numbers[0], target):
            return true

    return false

proc solve(input: Operations, f: proc (numbers: seq[int], current, target: int): bool): int =
    input.filterIt(it[2 .. ^1].f(it[1], it[0])).mapIt(it[0]).sum

let operations = readInput()

echo "Part 1: " & $solve(operations, calculate)
echo "Part 2: " & $solve(operations, concatenate)
