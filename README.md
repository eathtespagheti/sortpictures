# sortpictures

It's a bash script that order and organize pictures based on the day of shooting (or if not present, on the day of the last edit)

## Usage

Launch `./sortpictures.sh` in the folder where the pictures are, you can use the following options:

- `h`         : print help message
- `i`         : print how many pictures there are inside the folder
- `c`         : process all pictures in folder copying them
- `m`         : process all pictures in folder moving them
- `s pic.jpg` : process a single picture (copying it)

## Requirements

The only dependencies are `imagemagick` and of course `bash`
