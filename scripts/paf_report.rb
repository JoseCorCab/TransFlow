#!/usr/bin/env ruby

require 'optparse'
QUERY_NAME = 0
QUERY_LENGTH = 1
QUERY_START = 2
QUERY_END = 3
STRAND = 4
TARGET_NAME = 5
TARGET_START = 7
TARGET_END = 8
NT_MATCHED = 9
NT_MATCHED_WITH_GAP = 10
MIN = 0
MAX = 1
QUERY_NAME_BED = 3
EXON_NUMBER = 9

##############################################################################################################################
## METHODS
##############################################################################################################################

def load_file(file) #files is an array of files
	queries_array = []
	File.open(file).each do |line|
		line.chomp!
		if !line.empty?
			fields = line.split("\t")
			fields[QUERY_LENGTH] = fields[QUERY_LENGTH].to_i
			fields[QUERY_START] = fields[QUERY_START].to_i
			fields[QUERY_END] = fields[QUERY_END].to_i
			fields[TARGET_START] = fields[TARGET_START].to_i
			fields[TARGET_END] = fields[TARGET_END].to_i
			fields[NT_MATCHED] = fields[NT_MATCHED].to_i.abs
			fields[NT_MATCHED_WITH_GAP] = fields[NT_MATCHED_WITH_GAP].to_i
			queries_array << fields
		end
	end
	return queries_array
end

def find_cigar_index(queries)
	cigar_index = nil
	random_hit = queries[queries.keys.sample].last
	random_hit.each_with_index do |field, i|
		if field.to_s.include?('cg:Z:')
			cigar_index = i
			break
		end
	end
	return cigar_index
end

def format_queries(queries_array)
	queries = {}
	queries_array.each do |all_fields| # primera linea
		query_name = all_fields[QUERY_NAME]
		queries[query_name] =  [nil, nil, nil, all_fields] #ident, coverage
	end
	return queries
end

# def did_overlap?(control_hsp, target_hsp, start_position, end_position, return_positions = false)
# 	overlap = false
# 	overlapping_positions = nil
# 	if control_hsp[start_position] <= target_hsp[start_position] && 
# 		control_hsp[end_position] > target_hsp[start_position] 
		
# 		if control_hsp[end_position] < target_hsp[end_position]
# 			overlapping_positions = [target_hsp[start_position], control_hsp[end_position]]
# 		else 
# 			overlapping_positions = [target_hsp[start_position], target_hsp[end_position]]
# 		end

# 	elsif control_hsp[start_position] >= target_hsp[start_position] &&
# 		control_hsp[start_position] < target_hsp[end_position] 

# 		if control_hsp[end_position] > target_hsp[end_position]
# 			overlapping_positions = [control_hsp[start_position], target_hsp[end_position]] 
# 		else
# 			overlapping_positions = [control_hsp[start_position], control_hsp[end_position]]
# 		end
# 	end
	
# 	if return_positions
# 		overlap = overlapping_positions
# 	else
# 		overlap = true if !overlapping_positions.nil?
# 	end

# 	return overlap
# end


# def find_overlaping_queries(queries, min_overlapping_length)
# 	#this method is for group the queries by alignment overlapping 
# 	scaffolds = {}
# 	query_name = 0
# 	start_position = 1
# 	end_position = 2
# 	all_targets = group_by_target(queries)
# 	all_targets.each do |target_name, formatted_queries|
# 		formatted_loci = {}
# 		raw_loci = find_overlapping(formatted_queries, min_overlapping_length)
		
# 		locus_number = 1
# 		raw_loci.each do |locus|
# 			locus_name = "#{target_name}:#{locus_number}"
# 			formatted_loci[locus_name] = locus
# 			locus_number += 1
# 		end

# 		scaffolds[target_name] = formatted_loci 	
# 	end
# 	return scaffolds
# end
	
# def find_overlapping(queries, min_overlapping_length)
# 	query_name = 0
# 	start_position = 1
# 	end_position = 2
# 	queries.sort_by! { |query_name, start_position, end_position, attributes| 
# 		[start_position, end_position]
# 	}
# 	last_query = queries.shift
# 	loci = [[last_query]]
# 	queries_left = queries.length

# 	queries_left.times do
# 		last_query = queries.shift
# 		overlapping_positions = nil
# 		loci.each do |locus|
# 			locus.each do |saved_query|
# 				overlapping_coords = did_overlap?(last_query, saved_query, start_position, end_position, true)
# 				next if overlapping_coords.nil?
# 				overlapping_positions = overlapping_coords[1] - overlapping_coords[0]
# 				if overlapping_positions < min_overlapping_length
# 					overlapping_positions = nil
# 					next
# 				else 
# 					break
# 				end
# 			end
# 			if !overlapping_positions.nil?
# 				locus << last_query
# 				break
# 			end
# 		end
# 		loci << [last_query] if overlapping_positions.nil?
# 	end
# 	return loci
# end

# def group_by_target(queries)
# 	targets = {}
# 	queries.each do |query_name, hits|
# 		hits.each do |target_name, attributes|
# 			ident, cover, hsps = attributes
# 			sorted_hsps = hsps.sort_by { |hsp| hsp[TARGET_START] }
# 			hit_start = sorted_hsps.first[TARGET_START]
# 			hit_end = sorted_hsps.last[TARGET_END]
# 			hit_name = target_name.split(":").first
# 			if !targets[hit_name].nil?
# 				targets[hit_name] << [query_name, hit_start, hit_end, attributes]
# 			else
# 				targets[hit_name] = [[query_name, hit_start, hit_end, attributes]]
# 			end
# 		end	

# 	end
# 	return targets
# end

# def report_overlaping(scaffolds, filename)
# 	File.open(filename, 'w') do |file|
# 		scaffolds.each do |scaffold_name, loci|
# 			loci.each do |locus_name, hits|
# 				hits.sort_by! { |hit_name, target_start, target_end, attributes| target_start }
# 				locus_start = hits.first[1]
# 				locus_end = hits.last[2]
# 				hits_names = []
# 				hits.each do |hit| 
# 					hits_names << hit[0]
# 				end
# 				hits_count = hits_names.length
# 				hits_names = hits_names.join(";")
# 				file << "#{locus_name}\t#{locus_start}\t#{locus_end}\t#{hits_count}\t#{hits_names}\n"
# 			end
# 		end
# 	end
# end

def calculate_stats(queries) 
	cigar_index = find_cigar_index(queries)
	queries.each do |query_name, attributes|
		hit = attributes.last
		attributes[0] = calculate_identity(hit)
		attributes[1] = calculate_coverage(hit)
		if !cigar_index.nil?
			attributes[2] = hit[cigar_index].split("cg:Z:").last.split("N").length
		else 
			attributes[2] = 1
		end
	end
end

def calculate_identity(hit)
	nt_matched = hit[NT_MATCHED]
	aligment_length = hit[NT_MATCHED_WITH_GAP]
	return nt_matched.fdiv(aligment_length)
end

def calculate_coverage(hit)
	nt_matched = hit[NT_MATCHED]
	query_length = hit[QUERY_LENGTH]
	return nt_matched.fdiv(query_length)
end

def print_paf(queries, filename)
	filename = "#{filename}.paf" if !filename.include?('.paf')
	File.open("#{filename}", 'w') do |file|
		queries.each do |query_name, attributes|
			hit = attributes.last
			file << "#{hit.join("\t")}\n"
		end
	end
end

def filter_queries(queries, options)
	queries.reject! do |query, attributes|
		identity, coverage, exons, hit = attributes

		( coverage < options[:coverage][MIN] || coverage > options[:coverage][MAX] ) ||   
		( identity < options[:identity][MIN] ||  identity > options[:identity][MAX] ) ||
  		( exons < options[:exons][MIN] ||  exons > options[:exons][MAX] ) 
	
	end
	return queries
end
	
def print_results(queries, print_header, tag)
	if print_header
		if ! tag.nil?
			puts %w(query identity coverage exons tag).join("\t")
		else 	
			puts %w(query identity coverage exons).join("\t")
		end
	end
	queries.each do |query, attributes|
		identity, coverage, exons, hit = attributes
		if !tag.nil?
			puts "#{query}\t#{[identity, coverage, exons, tag].join("\t")}"
		else
			puts "#{query}\t#{[identity, coverage, exons].join("\t")}"
		end
	end
end

#############################################################################################################################
## INPUT PARSING
##################################################################################################################################3
options = {}

OptionParser.new do  |opts|
	options[:input] = nil 
	opts.on("-i FILE", "--file", "Select the file to extract info.") do |i|
		options[:input] = i	
	end

	options[:identity] = [0, 1]
	opts.on("-I 'MIN,MAX'", "--filter-identity 'MIN,MAX'", "Discard mapped sequences with a lower identity than MIN and sequences with higher identity than MAX. DEFAULT 0,1") do |i|
		options[:identity] = i.split(',').map {|coord| coord.to_f}
	end

	options[:coverage] = [0, 1]
	opts.on("-C 'MIN,MAX'", "--filter-coverage 'MIN,MAX'", "Discard mapped sequences with a lower coverage than MIN and sequences with higher coverage than MAX. DEFAULT 0,1") do |c|
		options[:coverage] = c.split(',').map {|coord| coord.to_f}
	end

	options[:header] = false
	opts.on("-H", "--header", "Print header") do
		options[:header] = true
	end

	options[:exons] = [0,1]
	opts.on("-E 'MIN,MAX'", "--exons 'MIN,MAX'", "Valorate filters only on alignments with exons between MIN adn MAX. CIGAR 'cg' is needed. DEFAULT 0,1") do |e|
		options[:exons] = e.split(',').map {|coord| coord.to_i}
	end

	options[:paf] = nil
	opts.on("-p STRING", "--paf  STRING", "Return filtered PAF") do |p| 
		options[:paf] = p
	end
	
	options[:tag] = nil
	opts.on("-t string", "--tag string", "Set tag for all entries") do |tag|
		options[:tag] = tag
	end

	# options[:overlap] = nil
	# opts.on("-o INTEGER", "--overlap INTEGER", "Report groups of overlaping hits in INTEGER positions. '0' for any overlapping") do |i| 
	# 	options[:overlap] = i.to_i
	# end
	
	opts.on("-h", "--help", "Displays helps") do 
		puts opts
		abort()
	end
end.parse!

#############################################################################################################################
## MAIN PROGRAM
##################################################################################################################################3

abort("ERROR: You must load a more recent version o f Ruby [ > 1.9.3 ]") if RUBY_VERSION.to_f <= 2
queries_array = load_file(options[:input])
queries = format_queries(queries_array)



calculate_stats(queries)


filtered_queries = filter_queries(queries, options)


# if !options[:overlap].nil?
# 	scaffolds = find_overlaping_queries(filtered_queries, options[:overlap])
# 	report_overlaping(scaffolds, "#{options[:input].first.split(".").first}_overlapping")
# end


print_paf(filtered_queries, options[:paf]) if !options[:paf].nil?

print_results(filtered_queries, options[:header], options[:tag])
