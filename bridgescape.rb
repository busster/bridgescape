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






canvas_width = 1000
canvas_height = 1000





# mountains = []
# 5.times do
# 	mountains << mountain_shape
# end





color_1 = 'rgb(197, 235, 195)'
color_2 = 'rgb(183, 200, 181)'


require 'rmagick'

imgl = Magick::ImageList.new
imgl.new_image(canvas_width, canvas_height)


gc = Magick::Draw.new

mountain_points = mountain_shape(canvas_width, canvas_height)
gc.stroke(color_1).stroke_width(3)
gc.fill_opacity(1)
gc.fill(color_1)
gc.polyline(*mountain_points)


mountain_points = mountain_shape(canvas_width, canvas_height)
gc.stroke(color_2).stroke_width(3)
gc.fill_opacity(1)
gc.fill(color_2)
gc.polyline(*mountain_points)

gc.draw(imgl)



imgl.write("polyline.gif")
