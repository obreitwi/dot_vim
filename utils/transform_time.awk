{ 
hours=int($1/4);
if (hours > 0) {
    $1=sprintf("% 2dh%02dm", hours, (($1%4)*15));
} else {
    $1=sprintf("   %02dm", (($1%4)*15));
}
print;
}
