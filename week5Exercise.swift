import Playgrounds

#Playground {
    // ============================================================
    // ALMA-7 PART III — THE REPAIR FLEET
    // ============================================================


    // ============================================================
    // LEVEL 1 — ENCAPSULATION
    // ============================================================

    final class PowerCell {

        private var charge: Int

        init(charge: Int) {
            self.charge = min(max(charge, 0), 100)
        }

        func level() -> Int {
            return charge
        }

        func spend(_ amount: Int) -> Bool {
            guard amount > 0 else {
                return false
            }

            guard charge >= amount else {
                return false
            }

            charge -= amount
            return true
        }

        func recharge(by amount: Int) {
            guard amount > 0 else {
                return
            }

            charge = min(100, charge + amount)
        }
    }


    // Encapsulation proof:
    //
    // cell.charge = 100
    //
    // Compiler error:
    // "'charge' is inaccessible due to 'private' protection level"
    //
    // PowerCell is a class because it represents shared mutable
    // state using reference semantics.


    // ============================================================
    // LEVEL 4 — PROTOCOLS
    // ============================================================

    protocol Diagnosable {
        var componentID: String { get }
        var statusCode: Int { get }

        func diagnose() -> String
    }


    protocol Rechargeable {
        mutating func recharge(by amount: Int)
    }


    // ============================================================
    // LEVEL 5 — HEALTH RULE
    // ============================================================

    extension Diagnosable {

        func healthCode(for charge: Int) -> Int {

            if charge < 20 {
                return 2
            }

            if charge < 50 {
                return 1
            }

            return 0
        }

        func diagnose() -> String {
            return "\(componentID): code \(statusCode)"
        }
    }


    // ============================================================
    // LEVEL 2 — INHERITANCE
    // ============================================================

    class Drone: Diagnosable, Rechargeable {

        let id: String
        let cell: PowerCell

        init(id: String, cell: PowerCell) {
            self.id = id
            self.cell = cell
        }

        var powerCost: Int {
            return 10
        }

        var statusLine: String {
            return "\(id): \(cell.level())% \(cell.level().powerBar)"
        }

        func performTask() -> Int {
            return 0
        }

        final func runOnce() -> Int {

            guard cell.spend(powerCost) else {
                return 0
            }

            return performTask()
        }


        // Diagnosable conformance

        var componentID: String {
            return id
        }

        var statusCode: Int {
            return healthCode(for: cell.level())
        }


        // Rechargeable conformance

        func recharge(by amount: Int) {
            cell.recharge(by: amount)
        }
    }


    // ------------------------------------------------------------
    // Welder Drone
    // ------------------------------------------------------------

    final class WelderDrone: Drone {

        override var powerCost: Int {
            return 25
        }

        override func performTask() -> Int {
            return 40
        }

        func weldSeam() -> String {
            return "\(id): seam welded"
        }
    }


    // ------------------------------------------------------------
    // Scanner Drone
    // ------------------------------------------------------------

    class ScannerDrone: Drone {

        override var powerCost: Int {
            return 10
        }

        override func performTask() -> Int {
            return 15
        }

        override var statusLine: String {
            return super.statusLine + " [scanner]"
        }
    }


    // ------------------------------------------------------------
    // Cargo Drone
    // ------------------------------------------------------------

    final class CargoDrone: Drone {

        override var powerCost: Int {
            return 20
        }

        override func performTask() -> Int {
            return 25
        }
    }


    // ------------------------------------------------------------
    // Drone Factory
    // ------------------------------------------------------------

    func makeDrone(
        kind: String,
        id: String,
        charge: Int
    ) -> Drone? {

        let cell = PowerCell(charge: charge)

        switch kind {

        case "welder":
            return WelderDrone(
                id: id,
                cell: cell
            )

        case "scanner":
            return ScannerDrone(
                id: id,
                cell: cell
            )

        case "cargo":
            return CargoDrone(
                id: id,
                cell: cell
            )

        default:
            return nil
        }
    }


    // Build fleet

    var fleet: [Drone] = []

    for record in fleetData {

        if let drone = makeDrone(
            kind: record.kind,
            id: record.id,
            charge: record.charge
        ) {
            fleet.append(drone)
        } else {
            print(
                "Warning: skipped unknown drone \(record.kind) \(record.id)"
            )
        }
    }


    // ============================================================
    // LEVEL 3 — POLYMORPHISM AND SHIFT
    // ============================================================

    func runShift(
        _ fleet: [Drone],
        rounds: Int
    ) -> Int {

        guard rounds > 0 else {
            return 0
        }

        var totalWork = 0

        for _ in 0..<rounds {

            for drone in fleet {
                totalWork += drone.runOnce()
            }
        }

        return totalWork
    }


    // Run exactly 3 rounds

    let A = runShift(
        fleet,
        rounds: 3
    )


    // ------------------------------------------------------------
    // B — Total remaining charge
    // ------------------------------------------------------------

    var B = 0

    for drone in fleet {
        B += drone.cell.level()
    }


    // ------------------------------------------------------------
    // C — Drones that can perform one more task
    // ------------------------------------------------------------

    var C = 0

    for drone in fleet {

        if drone.cell.level() >= drone.powerCost {
            C += 1
        }
    }


    print("A =", A)
    print("B =", B)
    print("C =", C)


    // ============================================================
    // LEVEL 4 — SENSOR MODULE
    // ============================================================

    struct SensorModule: Diagnosable, Rechargeable {

        let componentID: String
        var chargeLevel: Int

        init(id: String, charge: Int) {
            self.componentID = id
            self.chargeLevel = min(max(charge, 0), 100)
        }

        var statusCode: Int {
            return healthCode(for: chargeLevel)
        }

        mutating func recharge(by amount: Int) {

            guard amount > 0 else {
                return
            }

            chargeLevel = min(
                100,
                chargeLevel + amount
            )
        }
    }


    // ============================================================
    // LEVEL 5 — LEGACY BEACON
    // ============================================================

    // The original LegacyBeacon declaration stays unchanged.
    // We add protocol conformance using an extension.

    extension LegacyBeacon: Diagnosable {

        var componentID: String {
            return name
        }

        var statusCode: Int {
            return healthCode(for: signalStrength)
        }

        func diagnose() -> String {
            return "LEGACY \(name): signal \(signalStrength) -> code \(statusCode)"
        }
    }


    // ============================================================
    // LEVEL 5 — POWER BAR
    // ============================================================

    extension Int {

        var powerBar: String {

            let clamped = min(
                max(self, 0),
                100
            )

            let filled = clamped / 10
            let empty = 10 - filled

            return String(
                repeating: "#",
                count: filled
            )
            +
            String(
                repeating: ".",
                count: empty
            )
        }
    }


    // ============================================================
    // DIAGNOSTIC REPORT
    // ============================================================

    var diagnosticComponents: [Diagnosable] = []


    // Add drones

    for drone in fleet {
        diagnosticComponents.append(drone)
    }


    // Add sensors

    for sensor in sensorData {

        let module = SensorModule(
            id: sensor.id,
            charge: sensor.charge
        )

        diagnosticComponents.append(module)
    }


    // Add legacy beacon

    diagnosticComponents.append(beacon)


    // Print report

    print("")
    print("DIAGNOSTIC REPORT")

    for component in diagnosticComponents {
        print(component.diagnose())
    }


    // ============================================================
    // D — TOTAL STATUS CODE
    // ============================================================

    var D = 0

    for component in diagnosticComponents {
        D += component.statusCode
    }

    print("D =", D)


    // ============================================================
    // FINAL MISSION CODE
    // ============================================================

    let missionCode = "\(A)-\(B)-\(C)-\(D)"

    print("")
    print("MISSION CODE:", missionCode)
}
