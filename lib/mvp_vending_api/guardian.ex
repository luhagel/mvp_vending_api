defmodule MvpVendingApi.Guardian do
  @moduledoc """
  Custom guardian configuration to handle JWT auth
  """
  use Guardian,
    otp_app: :mvp_vending_api,
    permissions: %{
      default: [:full],
      users: [:create, :read, :update, :delete, :deposit, :reset],
      products: [:create, :read, :update, :delete, :buy]
    }

  use Guardian.Permissions, encoding: Guardian.Permissions.AtomEncoding

  alias MvpVendingApi.Accounts
  alias Guardian.Permissions

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :no_serializable_resource_provided}

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      %Accounts.User{} = user -> {:ok, user}
      _ -> {:error, :invalid_sub}
    end
  end

  def resource_from_claims(_), do: {:error, :no_valid_sub_in_token}

  def build_claims(claims, user, _opts) do
    claims = encode_permissions_into_claims!(claims, build_permissions_for_user(user))

    {:ok, claims}
  end

  def build_permissions_for_user(%MvpVendingApi.Accounts.User{role: role}), do: user_grants(role)

  defp user_grants(:seller),
    do: %{
      default: Permissions.max(),
      users: [:read, :update, :delete],
      products: crud()
    }

  defp user_grants(:buyer),
    do: %{
      default: Permissions.max(),
      users: [:read, :update, :delete, :deposit, :reset],
      products: [:read, :buy]
    }

  defp crud, do: [:create, :read, :update, :delete]
end
