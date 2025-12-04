def count_free_rolls(grid):
  count = 0
  for x in range(len(grid)):
    for y in range(len(grid)):
      if is_free_roll(x, y, grid):
        count = count + 1
  return count

def count_free_rolls_iter(grid, acc=0):
  count = 0
  free_rolls = []
  for x in range(len(grid)):
    for y in range(len(grid)):
      if is_free_roll(x, y, grid):
        free_rolls.append((x, y))
        count = count + 1
  if count == 0: return acc
  return count_free_rolls_iter(update_grid(grid, free_rolls), acc+count)

def is_free_roll(x, y, grid):
  if not is_roll(x, y, grid): return False
  return len([coord for coord in neighbours(x, y, grid) if is_roll(coord[0], coord[1], grid)]) < 4

def is_roll(x, y, grid):
  return grid[y][x] == "@"

def neighbours(x, y, grid):
  neighbours = []
  for nx in range(max(0, x-1), min(x+1, len(grid)-1)+1):
    for ny in range(max(0, y-1), min(y+1, len(grid)-1)+1):
      if not (nx == x and ny == y):
        neighbours.append((nx, ny))
  return neighbours

def update_grid(grid, free_rolls):
  for coord in free_rolls:
    grid[coord[1]][coord[0]] = "."
  return grid


if __name__ == "__main__":
  with open("input/day04") as f:
    grid = [list(line.strip()) for line in f.readlines()]
    print('Part 1: {}'.format(count_free_rolls(grid)))
    print('Part 1: {}'.format(count_free_rolls_iter(grid)))