def format_duration(seconds)
  return 'now' if seconds.zero?

  years, days = seconds.divmod(31536000)
  days, hours = days.divmod(86400)
  hours, minutes = hours.divmod(3600)
  minutes, seconds = minutes.divmod(60)

  years = years.zero? ? nil : years > 1 ? "#{years} years" : '1 year'
  days =  days.zero?  ? nil : days > 1  ? "#{days} days"   : '1 day'
  hours = hours.zero? ? nil : hours > 1 ? "#{hours} hours" : '1 hour'
  minutes = minutes.zero? ? nil : minutes > 1 ? "#{minutes} minutes" : '1 minute'
  seconds = seconds.zero? ? nil : seconds > 1 ? "#{seconds} seconds" : '1 second'

  result = [years, days, hours, minutes, seconds].compact

  return result[0] if result.count == 1
  return result[0..1].join(' and ') if result.count == 2

  result[0..-2].join(', ') + " and #{result[-1]}"
end
