require 'mechanize'
require 'nokogiri'

class Quiz
  def run
    agent = Mechanize.new { |a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE }
    page = agent.get("https://staqresults.staq.com")

    form = page.form_with(id: 'form-signin')
    form.email = "test@example.com"
    form.password = "secret"
    page_reports = form.submit

    doc = page_reports.parser

    result = {}
    doc.search("//table/tbody/tr").each do |row|
      date     = row.at("td[1]").text.strip
      tests    = row.at("td[2]").text.strip
      passes   = row.at("td[3]").text.strip
      failures = row.at("td[4]").text.strip
      pending  = row.at("td[5]").text.strip
      coverage = row.at("td[6]").text.strip

      result.store(date,
        {
          tests: tests,
          passes: passes,
          failures: failures,
          pending: pending,
          coverage: coverage
        }
      )
    end
    result
  end
end
