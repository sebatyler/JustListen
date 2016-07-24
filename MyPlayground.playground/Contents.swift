//: Playground - noun: a place where people can play

import UIKit

let label = "width: "
let w = 94
let labelW = label + String(w)

let apples = 3
let oranges = 5
let appleSum = "I have \(apples) apples."
let fruitSum = "I have \(apples + oranges) pieces of fruit."
let floatSum = "test: \(Float(apples) / Float(oranges))."
let name = "Sebatyler"
let hello = "Hello, \(name)!"
var shopList = ["apple", "orange", "watermelon"]
shopList[1] = "mango"

var first = 0
for i in 0...3 {
    first += i
}
first

for i in 0..<100 {
    sin(Double(i) / 2)
}

var langs: [String] = ["Swift", "Python", "Ruby"]
var capitals: [String: String] = [
    "Korea": "서울",
    "일본": "도쿄"
]

var languages = [String]()
var capital = [String: String]()

if capital.isEmpty {
    print("capital empty")
}

for _ in 0..<10 {
    print("Hi!")
}

var email: String?
email = "seba@seba.com"
