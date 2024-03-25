class Kepala::Context
  @data = Hash(Int32, Pointer(Void)).new

  def add(val) : Nil
    @data[val.class.crystal_type_id] = Box.box(val)
  end

  def delete(cls : T.class) : T? forall T
    ptr = @data.delete(cls.crystal_type_id)
    return if ptr.nil?
    Box(T).unbox(ptr)
  end

  def []?(cls : T.class) : T? forall T
    ptr = @data[cls.crystal_type_id]?
    return if ptr.nil?
    Box(T).unbox(ptr)
  end

  def [](cls : T.class) : T forall T
    ptr = @data[cls.crystal_type_id]?

    raise KeyError.new("No value for class #{cls}") if ptr.nil?
    Box(T).unbox(ptr)
  end
end
