# rubocop:disable Metrics/MethodLength, Style/FrozenStringLiteralComment, Lint/UselessAssignment

class Rubocop
  def bad?
    false
  end

  # Layout/AlignParameters
  def align_parameters
    # bad
    one = {
            first_name: 'John',
            last_name: 'Snow',
            age: 23
          }

    have_fun(one,
             two
    )

    # good
    one = {
      first_name: 'John',
      last_name: 'Snow',
      age: 23
    }

    have_fun(
      one,
      two
    )
  end

  # Layout/IndentHash
  def indent_hash
    # bad
    one = {
            first_name: 'John',
            last_name: 'Snow',
            age: 23
          }

    # good
    one = {
      first_name: 'John',
      last_name: 'Snow',
      age: 23
    }

    one = if fun?
      have_fun
    else
      try_again
    end
  end

  # Style/IndentationWidth
  def indentation_width
    # bad
    fun? do
        have_fun
    end

    # good
    fun? do
      have_fun
    end
  end

  # Style/PercentLiteralDelimiters
  def percent_literal_delimiters
    %w(one two)
    %w{one two}
  end

  # Style/BlockDelimiters
  def block_delimiters
    # bad
    fun? {
      have_fun
    }

    # good
    fun? do
      have_fun
    end

    # bad
    expect do
      have_fun
    end.change(:mood)

    # good
    expect {
      have_fun
    }.change(:mood)
  end

  # Style/IndentHash
  def indent_hash
    options = {
        one: 1,
        two: 2,
      three: 3
    }

    have_fun(options)

    have_fun(
      one: 1,
      two: 2,
      three: 3
    )
  end

  # Style/MultilineMethodCallBraceLayout
  def multiline_method_call_brace_layout
    # bad
    have_fun(
      one)

    # good
    have_func(
      one
    )
  end
end
