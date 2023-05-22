import 'dart:math';

var coins;
var pic;

save(cb){
  coins = cb;
}
get(){
  return coins;
}

savePic(c){
  pic = c;
}

getPic(){
  return pic;
}