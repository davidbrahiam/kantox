defmodule KantoxWeb.Controllers.ProductControllerTest do
  use KantoxWeb.ConnCase, async: true

  describe "GET /products/list" do
    @tag :prodcuts_list
    test "when requested returns products available products to purchase", %{conn: conn} do
      %{status: 200, resp_body: response} = get(conn, Routes.products_path(conn, :index))

      assert Jason.decode!(response) == []
    end
  end

  describe "POST /products/purchase" do
    @tag :products_purchase
    test "when requested returns the total amount to pay given a basket", %{conn: conn} do
      body_params = %{
        "basket" => ["GR1", "SR1", "CF1"]
      }

      %{status: 200, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.products_path(conn, :purchase), body_params)

      assert Jason.decode!(response) == %{"total" => 0}
    end

    @tag :products_purchase
    test "when requested returns the total amount to pay", %{conn: conn} do
      body_params = %{
        "basket" => []
      }

      %{status: 200, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.products_path(conn, :purchase), body_params)

      assert Jason.decode!(response) == %{"total" => 0}
    end

    @tag :products_purchase
    test "when requested with wrong params returns error", %{conn: conn} do
      body_params = %{
        "baskets" => []
      }

      %{status: 400, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(Routes.products_path(conn, :purchase), body_params)

      assert Jason.decode!(response) == "Bad Request"
    end
  end

  describe "PUT /products/upsert" do
    @tag :products_upsert
    test "when requested it updates the product if it exists", %{conn: conn} do
      body_params = %{
        "id" => "GR1",
        "name" => "Green tea",
        "price" => "4.2",
        "promotion" => %{
          "elements" => 3,
          "discount" => 0.1,
          "condition" => "equal_to"
        }
      }

      %{status: 200, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) ==
               %{
                 "id" => "GR1",
                 "name" => "Green tea",
                 "price" => "4.2",
                 "promotion" => %{
                   "elements" => 3,
                   "discount" => "0.1",
                   "condition" => "equal_to"
                 }
               }
    end

    @tag :products_upsert
    test "when requested it inserts the product if it doesn't exists", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk",
        "price" => "1.2",
        "promotion" => %{
          "elements" => 3,
          "discount" => 0.1,
          "condition" => "equal_to"
        }
      }

      %{status: 200, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == %{
               "id" => "MP1",
               "name" => "Milk",
               "price" => "1.2",
               "promotion" => %{"condition" => "equal_to", "discount" => "0.1", "elements" => 3}
             }
    end

    @tag :products_upsert
    test "when requested a promotion that exceeds price limit returns error", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk",
        "price" => "1.2",
        "promotion" => %{
          "elements" => 3,
          "discount" => 3.1,
          "condition" => "equal_to"
        }
      }

      %{status: 400, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :products_upsert
    test "when requested without promotion returns success", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk",
        "price" => "1.2"
      }

      %{status: 200, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == %{
               "id" => "MP1",
               "name" => "Milk",
               "price" => "1.2",
               "promotion" => nil
             }
    end

    @tag :products_upsert
    test "when requested with missing params returns error", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk"
      }

      %{status: 400, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :products_upsert
    test "when requested with wrong params returns error", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk",
        "price" => -1
      }

      %{status: 400, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :products_upsert
    test "when requested a promotion with wrong params returns error", %{conn: conn} do
      body_params = %{
        "id" => "MP1",
        "name" => "Milk",
        "price" => "1.2",
        "promotion" => %{
          "elements" => 3,
          "discount" => 0.1,
          "condition" => "equals_to"
        }
      }

      %{status: 400, resp_body: response} =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(Routes.products_path(conn, :upsert), body_params)

      assert Jason.decode!(response) == "Bad Request"
    end
  end
end
