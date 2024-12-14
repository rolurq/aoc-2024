import std/re
import std/strutils
import std/sequtils
import std/strformat
import std/syncio

import nimPNG

const
    width = 101
    height = 103

type Robot = tuple[p: (int, int), v: (int, int)]

template predict(robot: Robot, seconds: int): (int, int) =
    let
        (x0, y0) = robot.p
        (vx, vy) = robot.v
        (x, y) = ((width + ((x0 + seconds * vx) mod width)) mod width, (height +
                ((y0 + seconds * vy) mod height)) mod height)
    (x, y)

template readInput(robots: var seq[Robot]) =
    let reParams = re"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)"
    for line in stdin.lines:
        var matches = newSeq[string](4)
        if line.match(reParams, matches):
            let
                numbers = matches.mapIt(it.parseInt)
                robot: Robot = ((numbers[0], numbers[1]), (numbers[2], numbers[3]))
            robots.add(robot)

proc Part1(robots: seq[Robot]): int =
    var q1, q2, q3, q4: int
    for robot in robots:
        let (x, y) = robot.predict(100)
        if x < width div 2 and y < height div 2:
            inc(q1)
        elif x > width div 2 and y < height div 2:
            inc(q2)
        elif x < width div 2 and y > height div 2:
            inc(q3)
        elif x > width div 2 and y > height div 2:
            inc(q4)
    return q1 * q2 * q3 * q4

proc Part2(robots: seq[Robot]) =
    template save_image(seconds: int) =
        var pngData = newSeq[uint8](width * height * 3)
        for r in robots:
            let
                (x, y) = r.predict(seconds)
                pixelIndex = (y * width + x) * 3
            pngData[pixelIndex] = 255
            pngData[pixelIndex + 1] = 255
            pngData[pixelIndex + 2] = 255
        discard savePNG24("day14/" & $seconds & ".png", pngData, width, height)

    let
        wLoops = countup(2, 10000, width).toSeq
        hLoops = countup(72, 10000, height).toSeq
    for (wSeconds, hSeconds) in zip(wLoops, hLoops):
        save_image(wSeconds)
        save_image(hSeconds)

var robots = newSeq[Robot]()
readInput(robots)

echo fmt"Part 1: {robots.Part1}"

Part2(robots)
echo fmt"Part 2: look at the pretty pictures ¯\_(ツ)_/¯"
