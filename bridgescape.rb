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


canvas_width = 1000
canvas_height = 1000

mountain_points = []



p left_point = [0, rand((0.25 * canvas_height)..(0.75 * canvas_height))]
p right_point = [canvas_width, rand((0.25 * canvas_height)..(0.75 * canvas_height))]

p guide_slope = (right_point[1] - left_point[1]) / (canvas_width - 0)


create_points(5, canvas_width, guide_slope, left_point, right_point, mountain_points)


mountain_points.unshift(left_point)
mountain_points.push(right_point)
mountain_points.push([canvas_width, canvas_height], [0, canvas_height])
mountain_points


mountain_points = mountain_points.flatten



require 'rmagick'

imgl = Magick::ImageList.new
imgl.new_image(1000, 1000)


gc = Magick::Draw.new
gc.stroke('rgb(197, 235, 195)').stroke_width(3)
gc.fill_opacity(1)
gc.fill('rgb(197, 235, 195)')
gc.polyline(*mountain_points)

gc.draw(imgl)



imgl.write("polyline.gif")
