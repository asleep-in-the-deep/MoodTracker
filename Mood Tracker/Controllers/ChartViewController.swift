//
//  ChartViewController.swift
//  Mood Tracker
//
//  Created by Arina on 13.07.2021.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var records: [Record] = []
    
    var moods: [Int] = []
    var dates: [Date] = []
    
    lazy var moodChartView: LineChartView = {
        let chartView = LineChartView(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        return chartView
    }()
    
    var moodDataEntry: [ChartDataEntry] = []
    weak var axisFormatDelegate: IAxisValueFormatter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        lineChartSetup()
        view.addSubview(moodChartView)
        
        formatData()
        setLineChart(dataPoints: dates, values: moods)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func lineChartSetup() {
        moodChartView.backgroundColor = UIColor.white
        
        moodChartView.legend.enabled = true
        
        moodChartView.xAxis.labelPosition = .bottom
        moodChartView.xAxis.drawGridLinesEnabled = false
        moodChartView.xAxis.avoidFirstLastClippingEnabled = true

        moodChartView.rightAxis.enabled = false
        
        moodChartView.leftAxis.drawGridLinesEnabled = false
        moodChartView.leftAxis.axisMaximum = 6.0
        moodChartView.leftAxis.axisMinimum = 0.0
    }
    
    func formatData() {
        for record in records {
            moods.append(record.mood)
            dates.append(record.date)
        }
    }
    
    func setLineChart(dataPoints: [Date], values: [Int]) {
        moodChartView.noDataText = "No data for the chart."
        
        for i in 0..<dataPoints.count {
            let timeIntervalForDate: TimeInterval = dataPoints[i].timeIntervalSince1970
            let dataPoint = ChartDataEntry(x: Double(timeIntervalForDate), y: Double(values[i]), data: dates)
            moodDataEntry.append(dataPoint)
        }
        
        moodDataEntry.sort(by: { $0.x < $1.x })
        
        let chartDataSet = LineChartDataSet(entries: moodDataEntry, label: "Mood")
        chartDataSet.colors = [UIColor.systemIndigo]
        chartDataSet.setCircleColor(UIColor.systemIndigo)
        chartDataSet.circleHoleColor = UIColor.systemIndigo
        chartDataSet.circleRadius = 5.0
        
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false)
        
        moodChartView.data = chartData
        
        let XAxis = moodChartView.xAxis
        XAxis.valueFormatter = axisFormatDelegate
    }
    
}

extension ChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
