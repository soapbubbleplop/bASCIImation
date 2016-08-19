#!/bin/bash

set_values () {

terminal_width=$(tput cols)
terminal_height=$(tput lines)

# crop_top crop_bottom expand_top expand_bottom

if (($terminal_height < $movie_height && (($terminal_height%2 || $movie_height%2)) ))&&(( ! (( $terminal_height%2 && $movie_height%2 )) ))
then	
	let "crop_top=($movie_height-$terminal_height)/2+1"
	let "crop_bottom=($movie_height-$terminal_height)/2+($movie_height%2)+($terminal_height%2)+1"
	let "local_movie_height=$movie_height-$crop_top-$crop_bottom"
	expand_top=2
	expand_bottom=0
	case_y=1
elif (($terminal_height < $movie_height))
then
	let "crop_top=($movie_height-$terminal_height)/2+1"
	let "crop_bottom=($movie_height-$terminal_height)/2+1"
	let "local_movie_height=$movie_height-$crop_top-$crop_bottom"
	expand_top=2
	expand_bottom=0
	case_y=2
elif (($terminal_height > $movie_height && (($[$terminal_height-$movie_height] >= 2)) && (($terminal_height%2 || $movie_height%2)) ))&&(( ! (( $terminal_height%2 && $movie_height%2 )) ))
then
	let "expand_top=($terminal_height-$movie_height)/2+1"
	let "expand_bottom=($terminal_height-$movie_height)/2+($movie_height%2)+($terminal_height%2)-1"
	local_movie_height=$movie_height
	crop_top=0
	crop_bottom=0
	case_y=3
elif (( $[$terminal_height - $movie_height] == 1 ))
then
	let "expand_top=($terminal_height-$movie_height)/2"
	let "expand_bottom=($terminal_height-$movie_height)/2" # add one blank line
	local_movie_height=$movie_height
	crop_top=1
	crop_bottom=0
	case_y=4
elif (($terminal_height >= $movie_height))
then
	let "expand_top=($terminal_height-$movie_height)/2+1"
	let "expand_bottom=($terminal_height-$movie_height)/2-1"
	local_movie_height=$movie_height
	crop_top=0
	crop_bottom=0
	case_y=5
fi

# crop_left crop_right expand_left expand_right

if (($terminal_width < $movie_width && (($terminal_width%2 || $movie_width%2)) ))&&(( ! (( $terminal_height%2 && $movie_height%2 )) ))
then
	let "crop_left=($movie_width-$terminal_width)/2"
	let "crop_right=(($movie_width-$terminal_width)/2+$terminal_width)+($movie_width%2)+($terminal_width%2)"
	expand_left=0
	expand_right=0
	case_x=1
elif (($terminal_width < $movie_width))
then
	let "crop_left=($movie_width-$terminal_width)/2"
	let "crop_right=(($movie_width-$terminal_width)/2+$terminal_width)"
	expand_left=0
	expand_right=0
	case_x=2
elif (($terminal_width > $movie_width && (( $[$terminal_width-$movie_width] >= 2)) ))&&(($terminal_width%2 || $movie_width%2))&&(( ! (( $terminal_width%2 && $movie_width%2 )) ))
then
	let "expand_left=($terminal_width-$movie_width)/2+1"
	let "expand_right=($terminal_width-$movie_width)/2+($movie_width%2)+($terminal_width%2)-1"
	crop_left=0
	crop_right=0
	case_x=3
elif (($terminal_width >= $movie_width && $[$terminal_width-$movie_width] == 1 ))
then
	let "expand_left=($terminal_width-$movie_width)/2"
	let "expand_right=($terminal_width-$movie_width)/2+1" # add one blank charackter
	crop_left=0
	crop_right=0
	case_x=4
elif (($terminal_width >= $movie_width))
then
	let "expand_left=($terminal_width-$movie_width)/2"
	let "expand_right=($terminal_width-$movie_width)/2"
	crop_left=0
	crop_right=0
	case_x=5
fi

# thick_horizontal_left thick_horizontal_right thick_horizontal_middle
# thin_horizontal_left thin_horizontal_right thin_horizontal_middle $thin_horizontal_top_start $thin_horizontal_bottom_start

if (($terminal_height > $movie_height && $[$terminal_height-$movie_height] >= 4 ))
then
	let "thick_horizontal_left=$terminal_width/2"
	let "thick_horizontal_right=$terminal_width/2+2*($terminal_width%2)"
	let "thick_horizontal_middle=$terminal_width/2+($terminal_width%2)"
	
	let "thin_horizontal_left=1"
	let "thin_horizontal_right=$terminal_width"
	let "thin_horizontal_top_start=$expand_top-1"
	let "thin_horizontal_bottom_start=$terminal_height-$expand_bottom"
	let "thin_horizontal_middle=$terminal_width/2+($terminal_width%2)"
	case_th=1

elif (($terminal_height <= $movie_height))||(($[$terminal_height-$movie_height] >= 3))
then
	let "thick_horizontal_left=$terminal_width/2"
	let "thick_horizontal_right=$terminal_width/2+2*($terminal_width%2)"
	let "thick_horizontal_middle=$terminal_width/2+($terminal_width%2)"

	thin_horizontal_left=0
	thin_horizontal_right=0
	thin_horizontal_middle=0
	thin_horizontal_top_start=0
	thin_horizontal_bottom_start=0
	case_th=2
fi;

# thick_vertical_top thick_vertical_bottom thick_vertical_middle 
# thin_vertical_top thin_vertical_bottom thin_vertical_middle $thin_vertical_left_start $thin_vertical_right_start

if (($terminal_width > $movie_width && $(expr $terminal_width - $movie_width) >= 2))
then
	let "thick_vertical_top=1"
	let "thick_vertical_bottom=$terminal_height"
	let "thick_vertical_middle=$terminal_height/2+($terminal_height%2)"

	let "thin_vertical_top=1"
	let "thin_vertical_bottom=$terminal_height"
	let "thin_vertical_left_start=$expand_left-1"
	let "thin_vertical_right_start=$terminal_width-$expand_right"
	let "thin_vertical_middle=$terminal_height/2+($terminal_height%2)"
	case_tv=1

elif (($terminal_width <= $movie_width))||(($(expr $terminal_width - $movie_width) == 1))
then
	let "thick_vertical_top=1"
	let "thick_vertical_bottom=$terminal_height"
	let "thick_vertical_middle=$terminal_height/2+($terminal_height%2)"

	thin_vertical_top=0
	thin_vertical_bottom=0
	thin_vertical_left_start=0
	thin_vertical_right_start=0
	thin_vertical_middle=0
	case_tv=2
fi;
}
