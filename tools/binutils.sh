import()
{
	source "$1" $(dirname -- "$1")
}

nls()
{
	local flag=
	local root="$1"

	shift

	for f in $@; do
		flag+="-not -name $f "
	done

	find "$root" -mindepth 1 -maxdepth 1 $flag
}
