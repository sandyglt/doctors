require 'spec_helper'

RSpec.describe  do

  it "reports Monday day Shift" do
    report = Report.new
    report.append Time.new(2018, 10, 22, 9, 0)

    expected_value = <<~EOF
      Shift Start,Shift End,Total Hours,Hourly_rate,Total Payment,Agency/Hospital name,Department
      2018-10-22 09:00,2018-10-22 15:00,6,45,270.0,MWF Hospital,General Medicine
    EOF
    #10 header #11 body
    expect(report.to_s).to eql(expected_value)
  end

  it "reports Monday night Shift" do
    report = Report.new
    report.append Time.new(2018, 10, 22, 20, 0)

    expected_value = <<~EOF
      Shift Start,Shift End,Total Hours,Hourly_rate,Total Payment,Agency/Hospital name,Department
      2018-10-22 20:00,2018-10-23 08:00,12,45,1458.0,MWF Agency,Accident and Emergency
    EOF

    expect(report.to_s).to eql(expected_value)
  end

  it "reports Tuesday day Shift" do
    report = Report.new
    report.append Time.new(2018, 10, 23, 9, 0)

    expected_value = <<~EOF
      Shift Start,Shift End,Total Hours,Hourly_rate,Total Payment,Agency/Hospital name,Department
      2018-10-23 09:00,2018-10-23 15:00,6,60,468.0,TT Agency,General Medicine
    EOF

    expect(report.to_s).to eql(expected_value)
  end

  it "reports Thursday night Shift" do
    report = Report.new
    report.append Time.new(2018, 10, 25, 20, 0)

    expected_value = <<~EOF
      Shift Start,Shift End,Total Hours,Hourly_rate,Total Payment,Agency/Hospital name,Department
      2018-10-25 20:00,2018-10-26 08:00,12,60,1080.0,TT Hospital,Accident and Emergency
    EOF
    expect(report.to_s).to eql(expected_value)
  end

  #appending more than one date
end


