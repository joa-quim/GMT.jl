"""
    imshow(input; fmt="", kwargs...)

Is a simple front end to the [`grdimage`](@ref) program that accepts GMTgrid, GMTimage, 2D array 
of floats or strings with file names of grids or images. The normal options of the *grdimage* program
also apply here but some clever guessing of suitable necessary parameters is done if they are not
provided. Contrary to other image producing modules the "show' keyword is not necessary to display the
image. Here it is set by default. If user wants to use *imshow* to create layers of a more complex fig
he can use *show=false* for the intermediate layers.

# Examples
```julia-repl
# Plot vertical shaded illuminated view of the Mexican hat
julia> G = gmt("grdmath -R-15/15/-15/15 -I0.3 X Y HYPOT DUP 2 MUL PI MUL 8 DIV COS EXCH NEG 10 DIV EXP MUL =");
julia> imshow(G, frame="a", shade="+a45")

# Plot a random heat map
julia> imshow(rand(128,128))

# Display a web downloaded jpeg image wrapped into a sinusoidal projection
julia> imshow("http://larryfire.files.wordpress.com/2009/07/untooned_jessicarabbit.jpg", region="d", frame="g", proj="I15", img_in="r", fmt="jpg") 
```
See also: [`grdimage`](@ref)
"""
# -----------------------------------------------------------------------------------------------------
function imshow(arg1::GMTgrid; extra="", data=[], fmt="", K=false, O=false, first=true, kw...)
	# Here the default is to show, but if a 'show' was used let it rule
	d = KW(kw)
	if (!haskey(d, :show))
		grdimage("", arg1; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, show=true, kw...)
	else
		grdimage("", arg1; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, kw...)
	end
end
imshow!(arg1::GMTgrid; extra="", data=[], fmt="", K=false, O=false, first=true, kw...) =
	grdimage(extra, arg1; caller="grdimage", data=data, fmt=fmt, K=K, O=O, first=first, kw...)

function imshow(arg1::GMTimage; extra="", data=[], fmt="", K=false, O=false, first=true, kw...)
	# Here the default is to show, but if a 'show' was used let it rule
	d = KW(kw)
	if (!haskey(d, :show))
		grdimage("", arg1; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, D=[], show=true, kw...)
	else
		grdimage("", arg1; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, D=[], kw...)
	end
end
imshow!(arg1::GMTimage; extra="", data=[], fmt="", K=false, O=false, first=true, kw...) =
	grdimage(extra, arg1; caller="grdimage", data=data, fmt=fmt, K=K, O=O, first=first, kw...)

function imshow(arg1; fmt="", K=false, O=false, first=true, kw...)
	# Take a 2D array of floats and turn it into a GMTgrid or if input is a string assume it's a file name
	# In this later case try to figure if it's a grid or an image and act accordingly.
	is_image = false
	if (isa(arg1, String))		# If it's string it has to be a file name. Check extension to see if is an image
		ffname, ext = splitext(arg1)
		ext = lowercase(ext)
		if (ext == ".jpg" || ext == ".tif" || ext == ".tiff" || ext == ".png" || ext == ".bmp" || ext == ".gif")
			is_image = true
		end
		G = arg1
	else
		G = mat2grid(arg1)
	end

	d = KW(kw)
	if (!haskey(d, :show))  see = true			# No explicit 'show' keyword, so we set it to true here
	else                    see = d[:show]		# OK, there was one. Use whatever the user decided
	end

	if (is_image)
		if (haskey(d, :D) || haskey(d, :img_in) || haskey(d, :image_in))	# OK, user set -D so don't repeat
			grdimage(G; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, show=see, kw...)
		else
			grdimage(G; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, D=1, show=see, kw...)
		end
	else
		grdimage(G; caller="grdimage", data=[], fmt=fmt, K=K, O=O, first=first, show=see, kw...)
	end
end
imshow!(arg1; fmt="", K=true, O=true, first=false, kw...) = imshow(arg1; fmt="", K=K, O=O, first=first, kw...)