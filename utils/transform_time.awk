
func format_quarters(quarters) {
    hours=int(quarters/4);
    if (hours > 0) {
        return sprintf("% 2dh%02dm", hours, ((quarters%4)*15));
    } else {
        return sprintf("   %02dm", ((quarters%4)*15));
    }
}

{
    total += $1;
    $1=format_quarters($1)
    print;
}

END {
    print "======"
    print format_quarters(total), "TOTAL"
}
