# - set canvas size (w,h)
# - set guide line
# 	- (x=0, .25h...75h)  (x=w,.25h...75h)
# 	- (0,y1)  (w,y2)
# 	- get slope
# 		- m = (y2 - y1)/ (w-0)
# 		- y = mx + y1
# - divide w into n number of x-regions   (0 > w)/n
# 	- for n in x-region
# 	- get rand x value inside n/n.tot > n+1/n.tot
# 	- get y value on guide line
# 		- y = m(x) + y1
# 		- get rand y value in range of y+ factor y- factor
# 	- put (x,y) into array


# *********** Notes to add **************
# random inspirational quotes
# fog - just another line same color different opacity
# write loop to keep generating mo\t line until it is below previous or has crossed it



CANVAS_WIDTH = 5000
CANVAS_HEIGHT = 2500
NUMBER_OF_DIVISIONS = 21
NUMBER_OF_MOUNTAINS = 3

##################################################################################
##################################################################################

class Mountain
	attr_accessor :line_list, :line_check, :point_list

	def initialize
		@line_list = []
		@line_check = false
		@point_list = []
	end
	def check_line(i)
		cur_line = line_list[i]
		length = line_list.length - 1
		if length == 0
			@line_check = true
		else
			length.times do |n|
				prev_line = @line_list[n]
				@line_check = false
				if (cur_line[0][1] > prev_line[0][1]) || (cur_line[1][1] > prev_line[1][1])
					@line_check = true
				else
					break
				end
			end
		
		end
		line_check
	end

	def create_line
		left_point = [0, rand((0.25 * CANVAS_HEIGHT)..(0.75 * CANVAS_HEIGHT))]
		right_point = [CANVAS_WIDTH, rand((0.25 * CANVAS_HEIGHT)..(0.75 * CANVAS_HEIGHT))]
		guide_slope = (right_point[1] - left_point[1]) / (CANVAS_WIDTH - 0)
		return left_point, right_point, guide_slope
	end

	def create_points_on_slope(line_data)
		left_point = line_data[0]
		right_point = line_data[1]
		guide_slope = line_data[2]
		NUMBER_OF_DIVISIONS.times do |n|
			divisions = NUMBER_OF_DIVISIONS.to_f
			n = n.to_f
			x_value = rand(((n / divisions) * CANVAS_WIDTH)..(((n + 1.0) / divisions) * CANVAS_WIDTH))
			
			y_guide = guide_slope * x_value + left_point[1]
			y_range = (0.25 * ((1 / divisions) * CANVAS_WIDTH))
			y_range_max = y_guide + y_range 
			y_range_min = y_guide - y_range 
			
			y_value = rand(y_range_min..y_range_max)
			@point_list << [x_value, y_value]
		end
	end

	def add_base_points(line_data)
		left_point = line_data[0]
		right_point = line_data[1]
		@point_list.unshift(left_point)
		@point_list.push(right_point)
		@point_list.push([CANVAS_WIDTH, CANVAS_HEIGHT], [0, CANVAS_HEIGHT])
		@point_list = @point_list.flatten
	end

end

##################################################################################
##################################################################################

def draw_mountain(color, gc, list_of_points)
	gc.stroke(color).stroke_width(0)
	gc.fill(color)
	gc.polyline(*list_of_points)
end

##################################################################################
##################################################################################




def b
	p "-" * 50
end

##################################################################################
##################################################################################




require 'rmagick'

imgl = Magick::ImageList.new
imgl.new_image(CANVAS_WIDTH, CANVAS_HEIGHT)


gc = Magick::Draw.new



test_colors = ['red','green','blue','yellow','white','black','red','green','blue','yellow']
mountain = Mountain.new


NUMBER_OF_MOUNTAINS.times do |i|
	mountain.line_check = false
	while !mountain.line_check
		mountain.line_list[i] = mountain.create_line

		mountain.check_line(i)

	end
end
p mountain.line_list
color_counter = 0
mountain.line_list.each do |line|
	mountain.create_points_on_slope(line)
	list_of_points = mountain.add_base_points(line)

	draw_mountain(test_colors[color_counter], gc, list_of_points)
	mountain.point_list = []
	color_counter += 1
end


gc.draw(imgl)
imgl.write("polyline.png")

##################################################################################
##################################################################################






##############################################################################

# class Mountain
# 	attr_accessor :point_list
# 	attr_reader :good_line, :lines_array

# 	def initialize
# 		@point_list = []
# 		@left_point = []
# 		@right_point = []
# 		@lines_array = []
# 		@guide_slope = 0
# 		@line = 0
# 	end

# 	def create_rand_line(i)
# 		@left_point = [0, rand((0.25 * CANVAS_HEIGHT)..(0.75 * CANVAS_HEIGHT))]
# 		@right_point = [CANVAS_WIDTH, rand((0.25 * CANVAS_HEIGHT)..(0.75 * CANVAS_HEIGHT))]
# 		@guide_slope = (@right_point[1] - @left_point[1]) / (CANVAS_WIDTH - 0)
# 		@lines_array[i] = {left_point: @left_point, right_point: @right_point, guide_slope: @guide_slope}
# 	end
# 	def add_base_points
# 		@point_list.unshift(@left_point)
# 		@point_list.push(@right_point)
# 		@point_list.push([CANVAS_WIDTH, CANVAS_HEIGHT], [0, CANVAS_HEIGHT])
# 		@point_list = @point_list.flatten
# 	end
# 	def create_points_on_slope(divisions)
# 		divisions.times do |n|
# 			n = n.to_f
# 			divisions = divisions.to_f
# 			x_value = rand(((n / divisions) * CANVAS_WIDTH)..(((n + 1.0) / divisions) * CANVAS_WIDTH))
			
# 			y_guide = @guide_slope * x_value + @left_point[1]
# 			y_range = (0.25 * ((1 / divisions) * CANVAS_WIDTH))
# 			y_range_max = y_guide + y_range 
# 			y_range_min = y_guide - y_range 
			
# 			y_value = rand(y_range_min..y_range_max)
# 			@point_list << [x_value, y_value]
# 		end
# 	end

# 	def check_line(i)
# 		@good_line = false
# 		# if the slopes are the same
# 		if @lines_array[i][:guide_slope] != @lines_array[i - 1][:guide_slope]

# 			y_intercept_difference = @lines_array[i][:left_point][1] - @lines_array[i - 1][:left_point][1]
			
# 			# if the slope of the line is a positive int
# 			if @lines_array[i][:guide_slope] > 0
# 				# make it a negative int
# 				slope_difference = @lines_array[i - 1][:guide_slope] + @lines_array[i][:guide_slope]
# 			else
# 				slope_difference = @lines_array[i - 1][:guide_slope] - @lines_array[i][:guide_slope]
# 			end

# 			x_value = y_intercept_difference / slope_difference
# 			y_value = @lines_array[i][:guide_slope] * x_value + @lines_array[i][:left_point][1]

# 			if x_value.between?(0, CANVAS_WIDTH) && y_value.between?(0, CANVAS_HEIGHT)
# 				@good_line = true
# 			else
# 				if @lines_array[i][:left_point][1] > @lines_array[i - 1][:left_point][1]
# 					@good_line = true
# 				end
# 			end
# 		else
# 			 if @lines_array[i][:left_point][1] > @lines_array[i - 1][:left_point][1]
# 			 	@good_line = true
# 			 end
# 		end
# 		@good_line
# 	end

# 	def create_mountain_points
# 		create_points_on_slope(NUMBER_OF_DIVISIONS)
# 		add_base_points
# 	end

# end



##############################################################################









# 10.times do |i|
# if line array (i - 1) is nil
# 	creat a line x
# elsif
# 	while good line is false
# 		create line y
# 		check line y against line x
# 			if line y ok 
# 				good line is true
# 				line y = line x
# create points for the line
# add the base points
# draw the line



##############################################################################

# def draw_mountain(color, gc, mount_inst)
# 	mountain_points = mount_inst.create_mountain_points
# 	gc.stroke(color).stroke_width(0)
# 	gc.fill(color)
# 	gc.polyline(*mountain_points)
# end

# def generate_color
# 	random_color = []
# 	3.times do 
# 		random_color << rand(0..255)
# 	end
# 	random_color
# end
# def generate_complimentary_colors(number_of_colors, constant_color)
# 	colors = []
# 	number_of_colors.times do
# 		random_color = generate_color
# 		new_color = []
# 		3.times do |i|
# 			new_rgb_value = (random_color[i] + constant_color[i]) / 2
# 			new_color << new_rgb_value
# 		end
# 		colors << new_color
# 	end
# 	colors
# end

# def rgb_format_color_array(colors)
# 	color_list = []
# 	colors.each do |color|
# 		format = color.join(', ').prepend('rgb(') << ')'
# 		color_list << format
# 	end
# 	color_list
# end

# def rgba_format_color_array(colors)
# 	color_list = []
# 	colors.each do |color|
# 		opacity = rand(0.0..0.15).to_s
# 		format = color.join(', ').prepend('rgba(') << ', ' + opacity + ')'
# 		color_list << format
# 	end
# 	color_list
# end


##############################################################################













##############################################################################



# require 'rmagick'

# imgl = Magick::ImageList.new
# imgl.new_image(CANVAS_WIDTH, CANVAS_HEIGHT)


# gc = Magick::Draw.new





# n_mountains = 3

# test_colors = ['red','green','blue','yellow','white','black','red','green','blue','yellow']

# colors = generate_complimentary_colors(n_mountains, generate_color)

# rgb_color_list = rgb_format_color_array(colors)
# rgba_color_list = rgba_format_color_array(colors)

# master_color_list = rgba_color_list.zip(rgb_color_list).flatten!



# gc.fill(rgba_color_list[0])
# gc.rectangle(0,0,CANVAS_WIDTH,CANVAS_HEIGHT)



# mt = Mountain.new

# n_mountains.times do |i|
# 	puts "on: #{i} iteration"
# 	if mt.lines_array[0] == nil
# 		mt.create_rand_line(i)
# 		p mt.lines_array
# 		puts "made #{i} line"
# 	else
# 		counter = 0
# 		while !mt.good_line
# 			mt.create_rand_line(i)
# 			p mt.lines_array
# 			mt.check_line(i)
# 			puts "attempt: #{counter}"
# 			counter += 1
# 		end
# 	end
# 	puts "-" * 50
# 	draw_mountain(test_colors[i], gc, mt)
# 	mt.point_list = []
# end



# gc.draw(imgl)



# imgl.write("polyline.png")

##############################################################################



######################
######## OLD #########
######################


# color_list = []
# 50.times do
# 	color_list << generate_color
# end



# color_1 = 'rgb(197, 235, 195,)'
# color_1a = fog_mountain_color(color_1)
# color_2 = 'rgb(183, 200, 181,)'
# color_2a = fog_mountain_color(color_2)

# color_list = [color_1a,color_1,color_2a,color_2]
