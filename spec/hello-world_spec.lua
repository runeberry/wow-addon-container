describe("Hello World", function()
  it("can make words", function()
    local word1, word2 = "Hello", "World"
    local result = word1.." "..word2
    assert.equals("Hello World", result)
  end)
  it("can do math", function()
    local sum = 2 + 2
    assert.equals(4, sum)
  end)
end)