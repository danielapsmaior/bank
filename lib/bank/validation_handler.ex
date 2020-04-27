defmodule Bank.ValidationHandler do
  def parse_changeset_result(%Ecto.Changeset{valid?: true} = result),
    do: {:ok, Ecto.Changeset.apply_changes(result)}

  def parse_changeset_result(%Ecto.Changeset{valid?: false} = result),
    do: {:error, %{errors: Ecto.Changeset.traverse_errors(result, &parse_error_msg/1)}}

  def convert_to_string(errors) when is_list(errors),
    do: Keyword.keys(errors) |> Enum.map_join("; ", &Atom.to_string(&1))

  def convert_to_string(errors), do: errors

  def parse_error_msg({msg, opts}) do
	  Enum.reduce(opts, msg, fn {key, value}, acc ->
	    String.replace(acc, "%{#{key}}", to_string(value))
	  end)
	end


end
