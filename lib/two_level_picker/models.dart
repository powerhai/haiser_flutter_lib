
class LevelA<T,P>{
  P data;
  T id;
  LevelA(T this.id, P this.data);
  List<LevelB> list= new List<LevelB>();
}

class LevelB<T,P>{
  T id;
  P data;
  LevelB(T this.id, P this.data);
}
