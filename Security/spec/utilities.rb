
def replace_report_title
  ENV['TITLE']="SECURITY AUTOMATION REPORT" if ENV['TITLE'].nil?
   # report_file = File.absolute_path("#{ENV['SPEC_HOST_NAME']}_#{ENV['ROLE']}.html","reports")
   report_file = File.absolute_path("#{ENV['SPEC_HOST_NAME']}_security_report.html","reports")
  puts report_file
  doc = File.read(report_file)
  new_doc = doc.sub("RSpec Code Examples", "#{ENV['TITLE']}")
  File.open(report_file, "w") {|file|
    file.puts new_doc
  }

end