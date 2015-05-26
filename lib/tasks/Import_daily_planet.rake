task import_daily_planet: :environment do

  path = "#{Rails.root}/script/data/daily_planet_export.txt"
  f = File.open(path, "r")
    publisher = Publisher.create(name: "Daily Planet")
    f.each_line do |line|
      next if line.start_with? 'Merchant  Date  Ends  Deal  Price Value'
      data = line.split(' ')
      if data.present?
        
        # for name of advertiser
        name = data.shift(1).first
        data.each_with_index do |d, i|
          next_name = DateTime.parse(d) rescue nil
          if next_name.nil?
            name += " #{d}" 
          else
            @data_index = i
            break
          end
        end
        advertiser = publisher.advertisers.build(name: name)
        advertiser.save(validate: false)
        data.shift(@data_index)

        # for deal dates
        start_at = DateTime.parse(data[0]) rescue nil
        end_at = DateTime.parse(data[1]) rescue nil
        data.shift(2)

        # for proposition of deal
        description = data.shift(1).first
        data.each_with_index do |d, i|
          next_description = !/\A\d+\z/.match(d) rescue nil
          if next_description.present?
            description += " #{d}" 
          else
            @data_index = i
            break
          end
        end  
        data.shift(@data_index)

        # for deal price and value
        price = data[0].to_i
        value = data[1].to_i
        
        deal = advertiser.deals.build({
          start_at: start_at,
          end_at: end_at,
          description: description,
          price: price,
          value: value
        })
        deal.save(validate: false)
      end
    end

    f.close

end  # end of environment