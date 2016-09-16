

data = [1,2,3,4,5]
data2 = [6,7,8,9,0]
test = []
10.times do |i|
	puts "#{i}"
	
	if test[i-1] == nil
		puts "first line"
		test[i] = {some: data}
	else
		test[i] = {some: data2}		
	end
	puts "---------"

	p test[i][:some]

	puts "---------"
end
p test

