require 'sidekiq'
require 'zip'

Sidekiq.configure_client do |config|
  config.redis = { db: 1}
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1}
end

class VPLastEventWorker
  include Sidekiq::Worker

  def perform()
    puts "Hello from worker"

    # get datas
      # unzip file
      Zip::File.open("2263270.zip") do |zipfile|
        zipfile.each do |file|
          # read file
          if (File.exist?("2263270"))
          else
            file.extract("2263270")
          end

          result = "["

          #content = file.get_input_stream.read
          File.open("2263270").each_line do |line|
            data = line.split(";")
            ref_vp = data[0]
            tracking_number_part_1 = data[1]
            tracking_number_part_2 = data[2]
            code_vp = data[3]
            event_code_part_1 = data[4]
            event_code_part_2 = data[5]
            date = data[6]

          # calc racking number
            # on extrait tous les chiffres pairs et on les additionne
            round2 = controlNumber(tracking_number_part_2)

            tracking_number = tracking_number_part_1 << tracking_number_part_2 << round2.to_s
            code_event = event_code_part_1 << event_code_part_2
            myElem = "{"<< tracking_number << "," << date << "," << code_event << "," << ref_vp << "},"

            result = result << myElem
          end

            result[result.length-1] ="]"

          puts "#{result}"

        end
      end
    # output result
  end

  def controlNumber(s)
    even = 0
    odd = 0

    for pos in 0..s.length-1
      if (Integer(s[pos])%2 == 1)
        odd = odd + Integer(s[pos])
      else
      # on extrait tous les chiffres impairs et on les additionne
        even = even + Integer(s[pos])
      end
    end

    # on effectue le calcul suivant
    sum = (3 * odd + even)
    # round1
    round1 = ((sum/10).round.to_i)*10
    # maywecalc
    maywecalc  = (round1+1)*10 - sum
    #round2
    round2 = maywecalc - ((maywecalc/10).round.to_i)*10

    return round2
  end

end
