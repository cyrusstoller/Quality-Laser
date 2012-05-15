require 'yaml'

def main
  retrieve_settings
  
  File.open(@@settings[:output],"w").close #clearing the output file
  
  min = @@settings[:min_phrase_length].to_i
  max = @@settings[:max_phrase_length].to_i
  
  (min..max).each do |num_words|
    @@settings[:sources].each do |source|
      @@settings[:responses].each do |response|
        analyze(num_words, source, response)
      end
    end
  end
  
end

def retrieve_settings
  tmp = YAML.load_file("manifest.yml")
  tmp = tmp.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  # tmp[:num_sources] = tmp[:sources].size
  # tmp[:num_responses] = tmp[:responses].size
  tmp[:sources] = get_filenames(tmp[:sources])
  tmp[:responses] = get_filenames(tmp[:responses])
  @@settings = tmp
end

def get_filenames(dir)
  res = Dir.entries(dir)
  res.delete(".")
  res.delete("..")
  res.delete(".DS_Store")
  res.map do |m|
    "#{dir}/#{m}"
  end
end

def analyze(num_words, source, response)
  puts "\n================================================="
  puts "Looking for #{num_words} word matches"
  puts "Source:" + "\t\t#{source}"
  puts "Response:" + "\t#{response}"
  
  source_text = File.open(source, "r")
  response_text = File.open(response, "r")

  response_tokens = response_text.read.split
  results = []
  i = 0
  while i+num_words <= response_tokens.size
    search_text = response_tokens[i...i+num_words].map do |t|
      t.gsub(/\(/,'\(').gsub(/\)/,'\)').gsub(/\./,'\.')
    end.join("\s+")
    
    regex = Regexp.new "#{search_text}", Regexp::IGNORECASE
    # output_file << search_text + "\n"

    if source_text.grep(regex).count > 0
      matched_text = response_tokens[i...i+num_words].join(" ")
      results << "matched: '#{matched_text}'\n"
      puts "match"
    end
    i += 1
    source_text.rewind
  end
  
  unless results.empty?
    output_file = File.open(@@settings[:output], "a")
  
    output_file << "#{num_words} word matches\n"
    output_file << "Source:" + "\t\t#{source}\n"
    output_file << "Response:" + "\t#{response}\n"
    output_file << "=====================================\n"

    results.each do |r|
      output_file << r
    end
  
    output_file << "\n"
    output_file.close()
  end
  
  source_text.close()
  response_text.close()
end

if __FILE__ == $PROGRAM_NAME
  main
end