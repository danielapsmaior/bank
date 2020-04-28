defmodule Bank.ValidationHandler do
  def parse_result(%Ecto.Changeset{valid?: true} = result),
    do: {:ok, Ecto.Changeset.apply_changes(result)}

  def parse_result(%Ecto.Changeset{valid?: false} = result),
    do: {:error, %{errors: Ecto.Changeset.traverse_errors(result, &parse_error_msg/1)}}

  def parse_error_msg({msg, opts}) do
	  Enum.reduce(opts, msg, fn {key, value}, acc ->
	    String.replace(acc, "%{#{key}}", to_string(value))
	  end)
	end


end
