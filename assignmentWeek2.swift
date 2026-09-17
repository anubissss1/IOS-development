import Playgrounds

#Playground {
    let fruits = ["Apple","Banana","Mango","Blueberry","Strawberry"]
    print("Third fruit:",fruits[2])


    ///////


    var favoriteNumbers: Set<Int> = [7,13,21,25]
    favoriteNumbers.insert(100)
    print("Updated favorite numbers:",favoriteNumbers)


    /////


    let programmingLanguages = [
        "Python": 1991,
        "JavaScript": 1995,
        "Swift": 2014
    ]

    print("Swift was released in:", programmingLanguages["Swift"]!)


    //////


    var colors = ["Red", "Blue", "Green", "Yellow"]

    colors[1] = "Purple"

    print("Updated colors:", colors)


    /////


    let firstSet: Set<Int> = [1, 2, 3, 4]
    let secondSet: Set<Int> = [3, 4, 5, 6]

    let intersection = firstSet.intersection(secondSet)

    print("Intersection:", intersection)


    /////////


    var studentScores = [
        "Alex": 85,
        "John": 90,
        "Emma": 95
    ]

    studentScores.updateValue(98, forKey: "John")

    print("Updated student scores:", studentScores)



    /////


    let firstArray = ["apple", "banana"]
    let secondArray = ["cherry", "date"]

    let mergedArray = firstArray + secondArray

    print("Merged array:", mergedArray)


    //////



    var countryPopulations = [
        "Kazakhstan": 20_000_000,
        "Japan": 123_000_000,
        "Germany": 84_000_000
    ]

    countryPopulations["South Korea"] = 51_000_000

    print("Updated country populations:", countryPopulations)



    ////


    let animals1: Set<String> = ["cat", "dog"]
    let animals2: Set<String> = ["dog", "mouse"]

    let union = animals1.union(animals2)

    let finalSet = union.subtracting(animals2)

    print("Final set:", finalSet)


    ////



    let studentGrades = [
        "Alex": [85, 90, 78],
        "John": [92, 88, 95],
        "Emma": [90, 94, 89]
    ]

    print("John's second grade:", studentGrades["John"]![1])

}
