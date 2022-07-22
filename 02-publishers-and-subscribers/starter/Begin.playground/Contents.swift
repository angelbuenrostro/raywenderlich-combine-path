import Foundation
import Combine

// MARK: - NOTION STUDY NOTES LINK - https://sudsy-stocking-559.notion.site/Subscriber-Operators-Subjects-5c4a250ca2c14ce0ad25292ade3e0ea3

var subscriptions = Set<AnyCancellable>()

example(of: "NotificationCenter") {

    let center = NotificationCenter.default
    let myNotification = Notification.Name("MyNotification")

    let publisher = center
        .publisher(for: myNotification, object: nil)

    let subscription = publisher
        .print()
        .sink { _ in
            print("Notification received from a publisher")
        }

    center.post(name: myNotification, object: nil)
    subscription.cancel()
}

example(of: "Just") {

    let just = Just("Hello World")

    just
        .sink(
        receiveCompletion: {
            print("Received Completion", $0)
        },
        receiveValue: {
            print("Received Value", $0)
        })
        .store(in: &subscriptions)
}


example(of: "assign(to:on:)") {
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }

    let object = SomeObject()

    ["Hello", "World!"].publisher
        .assign(to: \.value, on: object)
        .store(in: &subscriptions)
}

example(of: "PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()
    /// this type of publisher needs explicitly declared types because it is initialized without starting values
    /// which the compiler cannot infer as it did with the standard `Publisher` type

    subject
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)

    subject.send("Hello")
    subject.send("World")
    subject.send(completion: .finished)
    subject.send("Still there?")
}

example(of: "CurrentValueSubject") {
    /// initializing a CurrentValueSubject requires an initial value to be specified, an Int of value 0 for example here
    let subject = CurrentValueSubject<Int, Never>(0)

    subject
        .print()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)

    print(subject.value)

    subject.send(1)
    subject.send(2)

    print(subject.value)

    subject.send(completion: .finished)
}

example(of: "Type erasure") {
    let subject = PassthroughSubject<Int, Never>()

    let publisher = subject.eraseToAnyPublisher()

    publisher
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)

    subject.send(0)
}
/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
