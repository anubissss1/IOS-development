import Playgrounds

#Playground {
    // =============================================================
    //  Station ALMA-7: Rescue Protocol
    //  iOS Mobile Development · Module 3 · Lab Assignment
    //
    //  How to use:
    //   • Xcode: File → New → Playground → Blank, replace everything
    //     with this file's contents.
    //   • Terminal: swift ALMA7_Starter.swift
    //
    //  Rules:
    //   • Do NOT modify the STARTER CODE section.
    //   • `!` (force unwrap) is forbidden: −0.5 points each.
    //   • No map / filter / reduce / compactMap.
    //   • Use the exact function names from the assignment PDF.
    // =============================================================


    // MARK: - =================== STARTER CODE ===================
    // MARK: - Do not modify anything in this section

    typealias Reading = (sensor: String, value: Int)

    /// Splits a string at the first occurrence of the separator.
    /// splitOnce("O2:87", by: ":") -> ("O2", "87")
    /// splitOnce("hello", by: ":") -> nil
    func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
        guard let index = line.firstIndex(of: separator) else { return nil }
        let left = String(line[..<index])
        let right = String(line[line.index(after: index)...])
        return (left, right)
    }

    let rawLog = [
        "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
        "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
        "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
    ]

    class Tank {
        var level: Int
        init(level: Int) { self.level = level }
    }

    class Module {
        let name: String
        var oxygenTank: Tank?
        init(name: String, oxygenTank: Tank?) {
            self.name = name
            self.oxygenTank = oxygenTank
        }
    }

    class CrewMember {
        let name: String
        let role: String
        let priority: Int      // 1 = evacuated first
        var module: Module?    // nil = in open space
        init(name: String, role: String, priority: Int, module: Module?) {
            self.name = name
            self.role = role
            self.priority = priority
            self.module = module
        }
    }

    let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
    let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
    let dock = Module(name: "Dock", oxygenTank: nil)

    let crew = [
        CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
        CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
        CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
        CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
    ]

    var roster: [String: CrewMember] = [:]
    for member in crew { roster[member.name] = member }

    print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

    // MARK: - ================= END OF STARTER CODE =================

    // MARK: - =================== YOUR SOLUTION ===================

    // Level 1
    func parseReading(_ raw: String) -> Reading? {
        guard let parts = splitOnce(raw, by: ":"),
              !parts.0.isEmpty,
              let value = Int(parts.1),
              parts.0 == "TEMP" || value >= 0 else {
            return nil
        }
        return (sensor: parts.0, value: value)
    }

    func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
        var valid: [Reading] = []
        var invalidCount = 0

        for line in lines {
            if let reading = parseReading(line) {
                valid.append(reading)
            } else {
                invalidCount += 1
            }
        }

        return (valid: valid, invalidCount: invalidCount)
    }

    let parsedTest1 = parseReading("O2:87")
    let parsedTest2 = parseReading("RAD:-1")
    print("parseReading tests:", parsedTest1 as Any, parsedTest2 as Any)

    let logResult = parseLog(rawLog)
    print("Valid readings:", logResult.valid)
    print("Invalid count:", logResult.invalidCount)

    let A = logResult.invalidCount

    // Level 2
    func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
        var result: [Reading] = []
        for reading in readings {
            if isIncluded(reading) {
                result.append(reading)
            }
        }
        return result
    }

    func values(of readings: [Reading]) -> [Int] {
        var result: [Int] = []
        for reading in readings {
            result.append(reading.value)
        }
        return result
    }

    let o2Readings = select(logResult.valid) { $0.sensor == "O2" }
    let tempReadings = select(logResult.valid) { $0.sensor == "TEMP" }
    print("O2 readings:", o2Readings)
    print("TEMP readings:", tempReadings)
    print("O2 values:", values(of: o2Readings))
    print("TEMP values:", values(of: tempReadings))

    func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
        guard let first = values.first else {
            return nil
        }

        var minValue = first
        var maxValue = first
        var total = 0

        for value in values {
            if value < minValue { minValue = value }
            if value > maxValue { maxValue = value }
            total += value
        }

        return (min: minValue, max: maxValue, average: Double(total) / Double(values.count))
    }

    func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
        stats(of: values)
    }

    let o2Stats = stats(of: values(of: o2Readings))
    let emptyStats = stats()
    print("O2 stats:", o2Stats as Any)
    print("Empty stats:", emptyStats as Any)
    print("Variadic stats:", stats(3, 8, 1) as Any)

    let B = Int(o2Stats?.average ?? 0)

    // Level 2.3 - Closure Ladder
    let sorted1 = logResult.valid.sorted(by: { (a: Reading, b: Reading) -> Bool in
        return a.value > b.value
    })

    let sorted2 = logResult.valid.sorted(by: { (a, b) in
        return a.value > b.value
    })

    let sorted3 = logResult.valid.sorted(by: { a, b in a.value > b.value })

    let sorted4 = logResult.valid.sorted(by: { $0.value > $1.value })

    let sorted5 = logResult.valid.sorted { $0.value > $1.value }

    func sameReadings(_ first: [Reading], _ second: [Reading]) -> Bool {
        guard first.count == second.count else { return false }
        for index in 0..<first.count {
            if first[index].sensor != second[index].sensor || first[index].value != second[index].value {
                return false
            }
        }
        return true
    }

    print("Closure ladder matches:", sameReadings(sorted1, sorted2) && sameReadings(sorted2, sorted3) && sameReadings(sorted3, sorted4) && sameReadings(sorted4, sorted5))
    print("Sorted readings:", sorted5)

    // Level 3
    func heatUp(_ t: Int) -> Int {
        t + 5
    }

    func coolDown(_ t: Int) -> Int {
        t - 3
    }

    func hold(_ t: Int) -> Int {
        t
    }

    func chooseProtocol(for temp: Int) -> (Int) -> Int {
        if temp < 18 {
            return heatUp
        } else if temp > 24 {
            return coolDown
        } else {
            return hold
        }
    }

    func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
        var temperature = start
        var steps = 0

        while temperature < 18 || temperature > 24, steps < maxSteps {
            let action = chooseProtocol(for: temperature)
            temperature = action(temperature)
            steps += 1
        }

        return (finalTemp: temperature, steps: steps, isStable: temperature >= 18 && temperature <= 24)
    }

    print("heatUp tests:", heatUp(10), heatUp(18))
    print("coolDown tests:", coolDown(30), coolDown(24))
    print("hold tests:", hold(20), hold(-5))
    print("chooseProtocol tests:", chooseProtocol(for: 10)(10), chooseProtocol(for: 30)(30))
    print("runUntilStable tests:", runUntilStable(from: 31), runUntilStable(from: -100, maxSteps: 5))

    let lowestTemperature = stats(of: values(of: tempReadings))?.min ?? 0
    let C = runUntilStable(from: lowestTemperature).steps

    // Level 4
    func oxygenLevel(of member: CrewMember) -> Int? {
        member.module?.oxygenTank?.level
    }

    func status(of member: CrewMember) -> String {
        guard let module = member.module else {
            return "\(member.name): no data (open space)"
        }

        let level = oxygenLevel(of: member) ?? -1

        guard level >= 0 else {
            return "\(member.name): no data (\(module.name))"
        }

        if level < 20 {
            return "\(member.name): \(level)% CRITICAL"
        } else {
            return "\(member.name): \(level)% OK"
        }
    }

    print("Oxygen tests:", oxygenLevel(of: crew[0]) as Any, oxygenLevel(of: crew[1]) as Any)
    print("Crew status:")
    for member in crew {
        print(status(of: member))
    }

    @discardableResult
    func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
        guard amount > 0 else {
            return 0
        }

        let availableSpace = max(0, 100 - target)
        let transferred = min(amount, min(source, availableSpace))

        source -= transferred
        target += transferred

        return transferred
    }

    var labOxygen = lab.oxygenTank?.level ?? 0
    var habOxygen = hab.oxygenTank?.level ?? 0
    let transferTest1 = transferOxygen(from: &labOxygen, to: &habOxygen, amount: 30)
    let transferTest2 = transferOxygen(from: &labOxygen, to: &habOxygen, amount: -5)
    print("Transfer tests:", transferTest1, transferTest2)
    print("Lab/Hab after tests:", labOxygen, habOxygen)

    // Reset to the station's original values before calculating D.
    var labForD = lab.oxygenTank?.level ?? 0
    var habForD = hab.oxygenTank?.level ?? 0
    let _ = transferOxygen(from: &labForD, to: &habForD, amount: 30)
    let D = habForD

    func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
        var found: [CrewMember] = []

        for name in names {
            guard let member = roster[name] else {
                print("Unknown crew member: \(name)")
                continue
            }
            found.append(member)
        }

        found.sort { $0.priority < $1.priority }

        var result: [String] = []
        for member in found {
            result.append(member.name)
        }

        return result
    }

    print("Evacuation test 1:", evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
    print("Evacuation test 2:", evacuationOrder("Nurlan", "Timur", roster: roster))

    // Level 5 - Saboteur's Logbook
    // Problems in reportOxygen:
    // 1. member.module! crashes if the crew member has no module (for example Nurlan).
    // 2. oxygenTank! crashes if the module exists but has no tank (for example Dana's Dock).
    //
    // Problems in firstCritical:
    // 3. oxygenLevel(of: member)! crashes if the member has no oxygen data.
    // 4. result! crashes if nobody is critical, because result is still nil.
    // 5. The loop keeps going after finding a critical member, so it returns the LAST
    //    critical member, not the FIRST one.

    func reportOxygen(for member: CrewMember) -> String {
        guard let level = oxygenLevel(of: member) else {
            return "\(member.name): no data"
        }
        return "\(member.name): \(level)%"
    }

    func firstCritical(in crew: [CrewMember]) -> String? {
        for member in crew {
            guard let level = oxygenLevel(of: member) else {
                continue
            }

            if level < 20 {
                return member.name
            }
        }

        return nil
    }

    print("reportOxygen tests:", reportOxygen(for: crew[0]), reportOxygen(for: crew[1]))
    print("firstCritical tests:", firstCritical(in: crew) as Any, firstCritical(in: [crew[0], crew[3]]) as Any)

    // Test that proves the "first" logic bug is fixed.
    let secondCriticalMember = CrewMember(name: "TestSecond", role: "Test", priority: 5, module: Module(name: "Test", oxygenTank: Tank(level: 10)))
    let twoCriticalCrew = [crew[2], secondCriticalMember]
    print("First critical logic test:", firstCritical(in: twoCriticalCrew) as Any)

    // Finale
    let launchCode = "\(A)-\(B)-\(C)-\(D)"
    print("LAUNCH CODE: \(launchCode)")

    // Bonus
    func makeAlarm(threshold: Int) -> (Int) -> Bool {
        var count = 0

        return { oxygenLevel in
            if oxygenLevel < threshold {
                count += 1
                print("Alarm #\(count)")
                return true
            }
            return false
        }
    }

    let alarm = makeAlarm(threshold: 20)
    print("Alarm tests:", alarm(12), alarm(40), alarm(5))
}
