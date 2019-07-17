#!/usr/bin/env ruby
puts "USAGE: merge_paf_ciga.rb file.paf file.sam out_file.paf"
def load_paf(file)
	paf_file = {}
	File.open(file).each do |line|
		fields = line.chomp.split("\t")
		paf_file[fields[0]] = fields
	end
	return paf_file
end

def merge_cigar(paf_file, sam_file)
	File.open(sam_file).each do |line|
		next if line =~ /^@/
		fields = line.chomp.split("\t")
		paf_file[fields[0]] << "cg:Z:#{fields[5]}"
	end
	return paf_file
end

def export_paf(paf_file, output_file)
	File.open(output_file, 'w') do |out_file|
		paf_file.each do |query_name, fields|
			out_file.puts fields.join("\t")
		end
	end
end


#########################################################################################

paf_file = load_paf(ARGV[0])
paf_file = merge_cigar(paf_file, ARGV[1])
export_paf(paf_file, ARGV[2])
