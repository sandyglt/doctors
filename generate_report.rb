#script
require "./main"

report = Report.new

report.append Time.new(2018, 10, 22, 9, 0) #=> create a report line (with all informations linked to date_and_time)
report.append Time.new(2018, 10, 22, 20, 0)
report.append Time.new(2018, 10, 23, 9, 0)
report.append Time.new(2018, 10, 24, 9, 0)
report.append Time.new(2018, 10, 25, 20, 0)

report.to_csv
