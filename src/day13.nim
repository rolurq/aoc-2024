import std/re
import std/strutils
import std/strformat

type Machine = tuple [buttonA: (int, int), buttonB: (int, int), prize: (int, int)]

template readInput(machines: var seq[Machine]) =
    let
        reButton = re"Button (?:A|B): X\+(\d+), Y\+(\d+)"
        rePrize = re"Prize: X=(\d+), Y=(\d+)"
        lines = stdin.readAll.splitLines

    for i in countup(2, lines.high, 4):
        var
            machine: Machine
            matches = newSeq[string](2)
        if lines[i - 2].match(reButton, matches):
            machine.buttonA = (matches[0].parseInt, matches[1].parseInt)
        if lines[i - 1].match(reButton, matches):
            machine.buttonB = (matches[0].parseInt, matches[1].parseInt)
        if lines[i].match(rePrize, matches):
            machine.prize = (matches[0].parseInt, matches[1].parseInt)
        machines.add(machine)

template win(m: Machine): int =
    var minCost = 0
    let
        (prizeX, prizeY) = m.prize
        (aX, aY) = m.buttonA
        (bX, bY) = m.buttonB
        movArea = aX * bY - aY * bX
        bMovArea = bY * prizeX - bX * prizeY
        aMovArea = aY * prizeX - aX * prizeY
    if bMovArea mod movArea == 0 and aMovArea mod movArea == 0:
        minCost = (3 * bMovArea - aMovArea) div movArea
    minCost

proc Part1(machines: seq[Machine]): int =
    for m in machines:
        let minCost = win(m)
        inc(result, minCost)

proc Part2(machines: seq[Machine]): int =
    for m in machines:
        var mCopy = m
        mCopy.prize = (m.prize[0] + 10000000000000, m.prize[1] + 10000000000000)
        inc(result, win(mCopy))

var machines = newSeq[Machine]()
readInput(machines)

echo fmt"Part 1: {machines.Part1}"
echo fmt"Part 2: {machines.Part2}"
