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




def create_points(divisions, width, guide_slope, left_point, right_point, mountain_points)
	divisions.times do |n|
		n = n.to_f
		divisions = divisions.to_f
		x_value = rand(((n / divisions) * width)..(((n + 1.0) / divisions) * width))
		
		y_guide = guide_slope * x_value + left_point[1]
		y_range = (0.25 * ((1 / divisions) * width))
		y_range_max = y_guide + y_range 
		y_range_min = y_guide - y_range 
		
		y_value = rand(y_range_min..y_range_max)
		mountain_points << [x_value, y_value]
	end
end

def add_edge_points(left_point, right_point, mountain_points, canvas_width, canvas_height)
	mountain_points.unshift(left_point)
	mountain_points.push(right_point)
	mountain_points.push([canvas_width, canvas_height], [0, canvas_height])
	mountain_points
end

def mountain_shape(canvas_width, canvas_height)
	mountain_points = []

	left_point = [0, rand((0.25 * canvas_height)..(0.75 * canvas_height))]
	right_point = [canvas_width, rand((0.25 * canvas_height)..(0.75 * canvas_height))]

	guide_slope = (right_point[1] - left_point[1]) / (canvas_width - 0)


	create_points(20, canvas_width, guide_slope, left_point, right_point, mountain_points)

	add_edge_points(left_point, right_point, mountain_points, canvas_width, canvas_height)


	mountain_points = mountain_points.flatten
end


def draw_mountain(color, gc, canvas_width, canvas_height)
	mountain_points = mountain_shape(canvas_width, canvas_height)
	gc.stroke(color).stroke_width(0)
	gc.fill(color)
	gc.polyline(*mountain_points)
end

def generate_color
	random_color = []
	3.times do 
		random_color << rand(0..255)
	end
	random_color
end
def generate_complimentary_colors(number_of_colors, constant_color)
	colors = []
	number_of_colors.times do
		random_color = generate_color
		new_color = []
		3.times do |i|
			new_rgb_value = (random_color[i] + constant_color[i]) / 2
			new_color << new_rgb_value
		end
		colors << new_color
	end
	colors
end

def rgb_format_color_array(colors)
	color_list = []
	colors.each do |color|
		format = color.join(', ').prepend('rgb(') << ')'
		color_list << format
	end
	color_list
end

def rgba_format_color_array(colors)
	color_list = []
	colors.each do |color|
		opacity = rand(0.0..0.15).to_s
		format = color.join(', ').prepend('rgba(') << ', ' + opacity + ')'
		color_list << format
	end
	color_list
end





canvas_width = 5000
canvas_height = 2500

colors = generate_complimentary_colors(7, generate_color)

rgb_color_list = rgb_format_color_array(colors)
rgba_color_list = rgba_format_color_array(colors)

master_color_list = rgba_color_list.zip(rgb_color_list).flatten!

require 'rmagick'

imgl = Magick::ImageList.new
imgl.new_image(canvas_width, canvas_height)


gc = Magick::Draw.new


gc.fill(rgba_color_list[0])
gc.rectangle(0,0,canvas_width,canvas_height)


master_color_list.each do |color|
	draw_mountain(color, gc, canvas_width, canvas_height)
end




gc.draw(imgl)



imgl.write("polyline.png")





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
