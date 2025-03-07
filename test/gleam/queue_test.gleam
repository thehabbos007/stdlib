import gleam/queue
import gleam/int
import gleam/list
import gleam/should

pub fn from_and_to_list_test() {
  queue.from_list([])
  |> should.equal(queue.new())

  [0, 0]
  |> queue.from_list
  |> queue.push_back(1)
  |> queue.to_list
  |> should.equal([0, 0, 1])

  let test = fn(input) {
    queue.from_list(input)
    |> queue.to_list
    |> list.reverse
    |> should.equal(input)
  }

  test([])
  test([1])
  test([1, 2])
  test([1, 2, 1])
  test([1, 2, 1, 5, 2, 7, 2, 7, 8, 4, 545])
}

pub fn push_back_test() {
  [0, 0]
  |> queue.from_list
  |> queue.push_back(1)
  |> queue.to_list
  |> should.equal([0, 0, 1])
}

pub fn is_empty_test() {
  queue.new()
  |> queue.is_empty
  |> should.be_true

  queue.from_list([""])
  |> queue.is_empty
  |> should.be_false
}

pub fn length_test() {
  let test = fn(input) {
    queue.from_list(input)
    |> queue.length
    |> should.equal(list.length(input))
  }

  test([])
  test([1])
  test([1, 2])
  test([1, 2, 1])
  test([1, 2, 1, 5, 2, 7, 2, 7, 8, 4, 545])
}

pub fn push_test() {
  queue.new()
  |> queue.push_back(7)
  |> queue.push_back(8)
  |> queue.push_back(2)
  |> queue.to_list
  |> should.equal([7, 8, 2])
}

pub fn push_front_test() {
  queue.new()
  |> queue.push_back(7)
  |> queue.push_back(8)
  |> queue.push_back(2)
  |> queue.push_front(4)
  |> queue.push_front(3)
  |> queue.to_list
  |> should.equal([3, 4, 7, 8, 2])

  [0, 0]
  |> queue.from_list
  |> queue.push_front(1)
  |> queue.to_list
  |> should.equal([1, 0, 0])
}

pub fn pop_back_test() {
  // We cannot construct the expected remainaing queue with from_list because
  // it has different internal representation.
  let expected_rest = queue.new()
    |> queue.push_front(1)
    |> queue.push_front(2)
  queue.from_list([1, 2, 3])
  |> queue.pop_back
  |> should.equal(Ok(tuple(3, expected_rest)))

  queue.from_list([])
  |> queue.pop_back
  |> should.equal(Error(Nil))
}

pub fn pop_front_test() {
  queue.from_list([1, 2, 3])
  |> queue.pop_front
  |> should.equal(Ok(tuple(1, queue.from_list([2, 3]))))

  queue.from_list([])
  |> queue.pop_front
  |> should.equal(Error(Nil))
}

pub fn reverse_test() {
  queue.from_list([1, 2, 3])
  |> queue.reverse
  |> queue.to_list
  |> should.equal([1, 2, 3])

  queue.new()
  |> queue.push_back(1)
  |> queue.push_back(2)
  |> queue.push_back(3)
  |> queue.reverse
  |> queue.to_list
  |> should.equal([3, 2, 1])

  queue.new()
  |> queue.push_front(1)
  |> queue.push_front(2)
  |> queue.push_front(3)
  |> queue.reverse
  |> queue.to_list
  |> should.equal([1, 2, 3])

  queue.new()
  |> queue.push_front(1)
  |> queue.push_front(2)
  |> queue.push_back(3)
  |> queue.push_back(4)
  |> queue.reverse
  |> queue.to_list
  |> should.equal([4, 3, 1, 2])
}

pub fn is_equal_test() {
  let should_equal = fn(a, b) {
    a
    |> queue.is_equal(to: b)
    |> should.be_true
  }

  let should_not_equal = fn(a, b) {
    a
    |> queue.is_equal(to: b)
    |> should.be_false
  }

  should_equal(queue.new(), queue.new())

  queue.new()
  |> queue.push_front(1)
  |> should_equal(
    queue.new()
    |> queue.push_back(1),
  )

  queue.new()
  |> queue.push_front(1)
  |> should_equal(
    queue.new()
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(1)
  |> queue.push_back(2)
  |> should_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(1)
  |> should_not_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(2)
  |> queue.push_back(1)
  |> should_not_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )
}

pub fn is_logically_equal_test() {
  let both_even_or_odd = fn(a, b) { int.is_even(a) == int.is_even(b) }

  let should_equal = fn(a, b) {
    a
    |> queue.is_logically_equal(to: b, checking: both_even_or_odd)
    |> should.be_true
  }

  let should_not_equal = fn(a, b) {
    a
    |> queue.is_logically_equal(to: b, checking: both_even_or_odd)
    |> should.be_false
  }

  should_equal(queue.new(), queue.new())

  queue.new()
  |> queue.push_front(3)
  |> should_equal(
    queue.new()
    |> queue.push_back(1),
  )

  queue.new()
  |> queue.push_front(4)
  |> should_equal(
    queue.new()
    |> queue.push_back(2),
  )

  queue.new()
  |> queue.push_front(3)
  |> should_equal(
    queue.new()
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(3)
  |> queue.push_back(4)
  |> should_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(1)
  |> should_not_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(2)
  |> queue.push_back(1)
  |> should_not_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )

  queue.new()
  |> queue.push_back(4)
  |> queue.push_back(3)
  |> should_not_equal(
    queue.new()
    |> queue.push_front(2)
    |> queue.push_front(1),
  )
}
