class TilePoint {
  TilePoint(this.x, this.y, this.z);
  int x;
  int y;
  int z;

  @override
  String toString() {
    return 'x: $x, y: $y, z: $z';
  }

  String get key {
    final map = {'x': x, 'y': y, 'z': z};
    return map.toString();
  }

  String get fileName {
    return 'x_${x}_y_${y}_z_$z.png';
  }

  @override
  bool operator ==(Object other) =>
      other is TilePoint &&
      other.runtimeType == runtimeType &&
      other.x == x &&
      other.y == y &&
      other.z == z;

  @override
  int get hashCode => Object.hash(x, y, z);
}
