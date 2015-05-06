//: Recipe to compute the length of an array.

:(scenario array_length)
recipe main [
  1:integer <- copy 3:literal
  2:integer <- copy 14:literal
  3:integer <- copy 15:literal
  4:integer <- copy 16:literal
  5:integer <- length 1:array:integer
]
+run: instruction main/4
+mem: storing 3 in location 5

:(before "End Primitive Recipe Declarations")
LENGTH,
:(before "End Primitive Recipe Numbers")
Recipe_number["length"] = LENGTH;
:(before "End Primitive Recipe Implementations")
case LENGTH: {
  reagent x = canonize(current_instruction().ingredients[0]);
  if (x.types[0] != Type_number["array"]) {
    raise << "tried to calculate length of non-array " << x.to_string() << '\n';
    break;
  }
  vector<long long int> result;
//?   cout << "length: " << x.value << '\n'; //? 1
  result.push_back(Memory[x.value]);
  write_memory(current_instruction().products[0], result);
  break;
}
