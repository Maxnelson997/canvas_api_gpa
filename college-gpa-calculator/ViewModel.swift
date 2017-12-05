//
//  ViewModel.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/10/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class ViewModel {
    let model = GPModel.sharedInstance
    
    let letters:[String:Double] = [
        "A+":4.0,
        "A":4.0,
        "A-":3.7,
        "B+":3.33,
        "B":3.00,
        "B-":2.7,
        "C+":2.3,
        "C":2.0,
        "C-":1.7,
        "D+":1.3,
        "D":1.0,
        "D-":0.70,
        "F":0]
    
    func calculate_class_gpa(grade:String, hour:Int) -> String {
        let grade_value:Double = letters[grade]!
        let gpa = grade_value/Double(hour)
        var r = String(format: "%.2f", gpa)
        if r == "nan" {
            r = "0.00"
        }
        return r
    }
    
    func calculate_semester_gpa() -> String {
        if !model.semesters.isEmpty {
            let classes = model.semesters[model.selected_semester_index].classes
            var points:Double = 0.0
            var hours_attempted:Double = 0.0
            var grade_points = classes.map { letters[$0.grade]! }
            var hours = classes.map { $0.hours! }
            _ = classes.map { hours_attempted += Double($0.hours!) }
            for i in 0 ..< grade_points.count {
                points += grade_points[i] * Double(hours[i])
            }
            print("\npoints \(points)")
            print("hours attempted: \(hours_attempted)\n")
            let gpa = points / hours_attempted
            var r = String(format: "%.2f", gpa)
            if r == "nan" {
                r = "0.00"
            }
            return r
        }
        return "0.00"
    }
    
    func calculate_all_semester_gpa() -> String {
        var points:Double = 0.0
        var hours_attempted:Double = 0.0
        for i in 0 ..< model.semesters.count {
            let classes = model.semesters[i].classes
            var grade_points = classes.map { letters[$0.grade]! }
            var hours = classes.map { $0.hours! }
            _ = classes.map { hours_attempted += Double($0.hours!) }
            for i in 0 ..< grade_points.count {
                points += grade_points[i] * Double(hours[i])
            }
        }
        print("\npoints \(points)")
        print("hours attempted: \(hours_attempted)\n")
        let gpa = points / hours_attempted
        var r = String(format: "%.2f", gpa)
        if r == "nan" {
            r = "0.00"
        }
        return r
    }
}
