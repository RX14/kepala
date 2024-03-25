require "./spec_helper"

private class TestClass
  getter a = 42069
end

private struct TestStruct
  getter a = 69420
end

describe Kepala::Context do
  it "stores and retrieves references" do
    ctx = Kepala::Context.new
    data = TestClass.new

    ctx.add(data)
    ctx[TestClass].a.should eq(42069)
    ctx[TestClass]?.should be(data)
  end

  it "stores and retrieves value types" do
    ctx = Kepala::Context.new
    data = TestStruct.new

    ctx.add(data)
    ctx[TestStruct].a.should eq(69420)
    ctx[TestStruct]?.should eq(data)
  end

  it "stores and retrieves multiple types" do
    ctx = Kepala::Context.new
    foo = TestClass.new
    bar = TestStruct.new

    ctx.add(foo)
    ctx.add(bar)

    ctx[TestClass].a.should eq(42069)
    ctx[TestStruct].a.should eq(69420)
  end

  it "raises on non-existent keys" do
    ctx = Kepala::Context.new
    expect_raises(KeyError, "No value for class TestClass") do
      ctx[TestClass]
    end
  end

  it "deletes keys" do
    ctx = Kepala::Context.new
    data = TestClass.new

    ctx[TestClass]?.should be_nil

    ctx.add(data)

    ctx[TestClass]?.should be(data)

    ctx.delete(TestClass)

    ctx[TestClass]?.should be_nil
  end
end
