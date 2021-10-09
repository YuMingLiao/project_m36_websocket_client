void main(){
  const map = { 'a':1, 'b':2};
//Type inference works well, but care must be paid to the generic expression's surrounding context.
  int folded = map.entries.fold(0,(i,j) => i + j.value);
  print(folded);
}


