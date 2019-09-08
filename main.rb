class Doctor
  attr_reader :grade_title, :hourly_rate

  def initialize(grade_title:, hourly_rate:)
    @grade_title = grade_title
    @hourly_rate = hourly_rate
  end
end

class Hospital
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def rate_multiplier
    1.0
  end
end

class Agency
  attr_reader :name, :rate_multiplier

  def initialize(name:, rate_multiplier:)
    @name = name
    @rate_multiplier = rate_multiplier
  end
end

class Department
  attr_reader :name

  def initialize(name:)
    @name = name
  end
end

class ReportLine
  def initialize(date_and_time)
    @date_and_time = date_and_time
  end

  def starts_at
    @date_and_time.strftime("%Y-%m-%d %R")
  end

  def ends_at
    (@date_and_time + total_hours*60*60).strftime("%Y-%m-%d %R")
  end

  def total_hours
    if day_shift?
      6
    else
      12
    end
  end

  def hourly_rate
    doctor.hourly_rate
  end

  def total_payment
    hourly_rate * total_hours *
      agency_multiplier * shift_department_multiplier
  end

  def agency_multiplier
    agency_or_hospital.rate_multiplier
  end

  def agency_or_hospital_name
    agency_or_hospital.name
  end

  def department_name
    if day_shift?
      "General Medicine"
    else
      "Accident and Emergency"
    end
  end

  def shift_department_multiplier
    if night_shift?
      1.5
    else
      1
    end
  end

  private

  def agency_or_hospital
    if mwf? && day_shift?
      Hospital.new("MWF Hospital")
    elsif mwf? && night_shift?
      Agency.new(name: "MWF Agency", rate_multiplier: 1.8)
    elsif tt? && day_shift?
      Agency.new(name: "TT Agency", rate_multiplier: 1.3)
    else tt? && night_shift?
      Hospital.new("TT Hospital")
    end
  end

  def day_shift?
    @date_and_time.hour == 9
  end

  def night_shift?
    @date_and_time.hour == 20
  end

  def mwf?
    @date_and_time.monday? ||
    @date_and_time.wednesday? ||
    @date_and_time.friday?
  end

  def tt?
    @date_and_time.tuesday? ||
    @date_and_time.thursday?
  end

  def doctor
    if mwf?
      Doctor.new(grade_title: "GP", hourly_rate: 45)
    else
      Doctor.new(grade_title: "Surgeon", hourly_rate: 60)
    end
  end
end

class Report
  def initialize(file_name = "/tmp/report.csv")
    @report_lines = []
   # take a date and time and extract all informations from that
    @file_name = file_name
  end

  def append(date_and_time)
    @report_lines << ReportLine.new(date_and_time)
  end

  def to_s
    header = "Shift Start,Shift End,Total Hours,Hourly_rate,Total Payment,Agency/Hospital name,Department\n"

    body = @report_lines.map { |line|
      [
        line.starts_at,
        line.ends_at,
        line.total_hours,
        line.hourly_rate,
        line.total_payment,
        line.agency_or_hospital_name,
        line.department_name,
      ].join(',')
    }.join("\n") + "\n"

    header + body
  end

  #report class is reponsible to print a report the report line is the one that takes the date_and_time and retrieve all the data linked to it

  def to_csv
    File.write(@file_name, to_s)
  end
end
