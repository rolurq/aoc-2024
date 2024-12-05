import tables, strutils, algorithm, sequtils

proc readInput(): (Table[string, seq[string]], seq[string]) =
    var
        orderLines = newSeq[string]()
        pages = newSeq[string]()
        current = addr(orderLines)
        table = initTable[string, seq[string]]()

    for line in stdin.lines:
        if line == "":
            current = addr(pages)
            continue
        current[].add(line)

    for entry in orderLines:
        let values = entry.split("|")
        if table.hasKeyOrPut(values[0], @[values[1]]):
            table[values[0]].add(values[1])

    return (table, pages)

let (order, pages) = readInput()

proc cmpPage(a, b: string): int =
    if order.getOrDefault(a, @[]).contains(b): -1 else: 1

proc Part1(): int =
    for items in pages.mapIt(it.split(",")).filterIt(it.isSorted(cmpPage)):
        inc(result, parseInt items[items.len /% 2])

proc Part2(): int =
    for items in pages.mapIt(it.split(",")).filterIt(not it.isSorted(cmpPage)):
        let sorted = items.sorted(cmpPage)
        inc(result, parseInt sorted[sorted.len /% 2])

echo "Part 1: " & $Part1()
echo "Part 2: " & $Part2()
