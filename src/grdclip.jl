"""
	grdclip(cmd0::String="", arg1=nothing, kwargs...)

Clip the range of grid values. will set values < low to below and/or values > high to above.
You can also specify one or more intervals where all values should be set to ``between``,
or replace individual values.

Full option list at [`grdclip`](http://gmt.soest.hawaii.edu/doc/latest/grdclip.html)

Parameters
----------

- **cmd0** -- Str --

    Either the input file name or the full monolitic options string. Do not use this
    when the grid (a GMTgrid type) is passed via the ``arg1`` argument.
- **G** : **outgrid** : -- Str --

    Output grid file name. Note that this is optional and to be used only when saving
    the result directly on disk. Otherwise, just use the G = grdclip(....) form.
    [`-G`](http://gmt.soest.hawaii.edu/doc/latest/grdclip.html#g)
- $(GMT.opt_R)
- **above** : **high** -- Array or Str --

    Two elements array with ``high`` and ``above`` or a string with "high/above".
    It sets all data[i] > ``high`` to ``above``.
- **below** : **low** -- Array or Str --

    Two elements array with ``low`` and ``below`` or a string with "low/below".
    It sets all data[i] < ``low`` to ``below``.
- **between** -- Array or Str --

    Three elements array with ``low, high`` and ``between`` or a string with "low/high/between".
    It sets all data[i] >= ``low`` and <= ``high`` to ``between``.
- **old** : **new** -- Array or Str --

    Two elements array with ``old`` and ``new`` or a string with "old/new".
    It sets all data[i] == ``old`` to ``new``.
- **S** -- Str --

    Condense all replacement options above in a single string.
    [`-S`](http://gmt.soest.hawaii.edu/doc/latest/grdclip.html#t)
- $(GMT.opt_V)

-   Examples:

        G=gmt("grdmath", "-R0/10/0/10 -I1 X");
        G2=grdclip(G, above=[5 6], low=[2 2], between="3/4/3.5")

    or (note the use of -S for second on options because we can't repeat a kwarg name)

        G2=grdclip(G, S="a5/6 -Sb2/2 -Si3/4/3.5")
"""
function grdclip(cmd0::String="", arg1=nothing; kwargs...)

	length(kwargs) == 0 && return monolitic("grdclip", cmd0, arg1)

	d = KW(kwargs)
	cmd = parse_common_opts(d, "", [:R :V_params])
	cmd = add_opt(cmd, 'G', d, [:G :outgrid])
	cmd = add_opt(cmd, 'S', d, [:S])
	cmd = opt_S(d, cmd, [:high :above], 'a')
	cmd = opt_S(d, cmd, [:low :below], 'b')
	cmd = opt_S(d, cmd, [:old :new], 'r')
	cmd = opt_S(d, cmd, [:between], 'i')

	cmd, got_fname, arg1 = find_data(d, cmd0, cmd, 1, arg1)
	if (isa(arg1, Array{<:Number}))		arg1 = mat2grid(arg1)	end
	return common_grd(d, "grdclip " * cmd, got_fname, 1, arg1)	# Finish build cmd and run it
end

# ---------------------------------------------------------------------------------------------------
grdclip(arg1, cmd0::String=""; kw...) = grdclip(cmd0, arg1; kw...)

# ---------------------------------------------------------------------------------------------------
function opt_S(d::Dict, cmd::String, symbs, flag::Char)
	# This is common to the 4 cases
	val, symb = find_in_dict(d, symbs)
	if (val !== nothing)
		cmd = string(cmd, " -S", flag)
		if (isa(val, String))
			cmd *= val
		elseif (isa(val, Array) || isa(val, Tuple))
			if (symb == :between && length(val) == 3)
				cmd = @sprintf("%s%.12g/%.12g/%.12g", cmd, val[1], val[2], val[3])
			elseif (length(val) == 2)
				cmd = @sprintf("%s%.12g/%.12g", cmd, val[1], val[2])
			else
				error("Wrong number of elements in S option")
			end
		else
			error("OPT_S: argument must be a string or a two elements array.")
		end
	end
	return cmd
end