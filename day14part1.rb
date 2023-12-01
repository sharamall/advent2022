file = File.open "day14in.txt"
rocks = []
min_x = 1e10
min_y = 1e10
max_x = -1e10
max_y = -1e10
file.collect do |l|
  sections = l.split '->'
  rocks << sections.collect do |s|
    raw = s.chomp.scan /(\d+),(\d+)/
    result = [raw[0][0].to_i, raw[0][1].to_i]
    min_x = [min_x, result[0]].min
    max_x = [max_x, result[0]].max
    min_y = [min_y, result[1]].min
    max_y = [max_y, result[1]].max
    result
  end
end
file.close

x_width = max_x - min_x
start = [0, 500 - min_x]

grid = []
(max_y + 1).times do
  arr = []
  (x_width + 1).times { arr << nil }
  grid << arr
end
rocks.each do |rock|
  cur_x = rock[0][0]
  cur_y = rock[0][1]
  rock[1..].each do |seg|
    x_arr = [cur_x, seg[0]]
    y_arr = [cur_y, seg[1]]
    (x_arr.min..x_arr.max).each do |x|
      (y_arr.min..y_arr.max).each do |y|
        grid[y][x - min_x] = "#"
      end
    end
    cur_x = seg[0]
    cur_y = seg[1]
  end
end

def print_grid(grid)
  grid.each do |row|
    puts row.inspect
  end
end

abyss = false

def fall(grid, start_point, min)
  return true if start_point[0] >= min
  if grid[start_point[0] + 1][start_point[1]].nil?
    grid[start_point[0]][start_point[1]] = nil
    grid[start_point[0] + 1][start_point[1]] = "O"
    start_point[0] += 1
    fall(grid, start_point, min)
  elsif grid[start_point[0] + 1][start_point[1] - 1].nil? # left
    grid[start_point[0]][start_point[1]] = nil
    grid[start_point[0] + 1][start_point[1] - 1] = "O"
    start_point[0] += 1
    start_point[1] -= 1
    fall(grid, start_point, min)
  elsif grid[start_point[0] + 1][start_point[1] + 1].nil? # right
    grid[start_point[0]][start_point[1]] = nil
    grid[start_point[0] + 1][start_point[1] + 1] = "O"
    start_point[0] += 1
    start_point[1] += 1
    fall(grid, start_point, min)
  else
    return false # come to rest
  end
end
sand = 0
until abyss
  grid[start[0]][start[1]] = "O"
  sand += 1
  abyss = fall(grid, start.clone, max_y)
end
puts sand - 1