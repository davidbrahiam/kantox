defmodule KantoxWeb.Controllers.ChartControllerTest do
  use KantoxWeb.ConnCase, async: false

  setup do
    Mox.stub_with(Kantox.Store.Mock, Kantox.Store.ETS)

    chart_id = :chart_id

    Kantox.Chart.Worker.start_link(name: chart_id)
    :ok = :persistent_term.put(:charts_users, ["#{chart_id}"])
    :ok = Kantox.Store.clear_data()
    %{chart_id: "#{chart_id}"}
  end

  describe "GET /charts/basket" do
    @tag :charts_basket
    test "when the chart_id doesn't exist", %{conn: conn} do
      params = %{"chart_id" => "error"}
      %{status: 400, resp_body: response} = get(conn, Routes.charts_path(conn, :basket), params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :charts_basket
    test "when the chart is empty", %{conn: conn, chart_id: chart_id} do
      params = %{"chart_id" => chart_id}
      %{status: 200, resp_body: response} = get(conn, Routes.charts_path(conn, :basket), params)

      assert Jason.decode!(response) == %{"basket" => []}
    end

    @tag :charts_basket1
    test "when charts has items returns them", %{conn: conn, chart_id: chart_id} do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}


      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :add_product), params)


      assert Jason.decode!(response) == %{"basket" => ["GR1"]}

      params = %{"chart_id" => chart_id}
      %{status: 200, resp_body: response} = get(conn, Routes.charts_path(conn, :basket), params)

      assert Jason.decode!(response) == %{"basket" => ["GR1"]}
    end
  end

  describe "GET /charts/total_price" do
    @tag :total_price
    test "when the chart_id doesn't exist", %{conn: conn} do
      params = %{"chart_id" => "error"}

      %{status: 400, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :total_price
    test "when requested it returns the total amount to pay in the chart", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id}

      %{status: 200, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == %{"total" => "6.22"}
    end

    @tag :total_price
    test "when requested it returns the total amount to pay in the chart(GR1,SR1,GR1,GR1,CF1)", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "SR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "CF1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id}

      %{status: 200, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == %{"total" => "22.45"}
    end

    @tag :total_price
    test "when requested it returns the total amount to pay in the chart(GR1,GR1)", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id}

      %{status: 200, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == %{"total" => "3.11"}
    end

    @tag :total_price
    test "when requested it returns the total amount to pay in the chart(SR1,SR1,GR1,SR1)", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "SR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "SR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "SR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id}

      %{status: 200, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == %{"total" => "16.61"}
    end

    @tag :total_price
    test "when requested it returns the total amount to pay in the chart(GR1,CF1,SR1,CF1,CF1)", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "CF1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "SR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "CF1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)
      params = %{"chart_id" => chart_id, "product_id" => "CF1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id}

      %{status: 200, resp_body: response} =
        get(conn, Routes.charts_path(conn, :total_price), params)

      assert Jason.decode!(response) == %{"total" => "30.57"}
    end
  end

  describe "POST /charts/products/remove_product" do
    @tag :remove_product
    test "when the chart_id doesn't exist", %{conn: conn} do
      params = %{"chart_id" => "error"}

      %{status: 400, resp_body: response} =
        get(conn, Routes.charts_path(conn, :remove_product), params)

      assert Jason.decode!(response) == "Bad Request"
    end

    @tag :remove_product
    test "when requested removes item product from the chart", %{conn: conn, chart_id: chart_id} do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :add_product), params)

      assert Jason.decode!(response) == %{"basket" => ["GR1"]}

      params = %{"chart_id" => chart_id, "product_id" => "GR1", "amount" => 4}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :remove_product), params)

      assert Jason.decode!(response) == %{"basket" => []}
    end

    @tag :remove_product
    test "when requested removes it moves x amount of that item from the chart", %{
      conn: conn,
      chart_id: chart_id
    } do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}
      %{status: 200} = post(conn, Routes.charts_path(conn, :add_product), params)

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :add_product), params)

      assert Jason.decode!(response) == %{"basket" => ["GR1", "GR1", "GR1", "GR1"]}

      params = %{"chart_id" => chart_id, "product_id" => "GR1", "amount" => 4}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :remove_product), params)

      assert Jason.decode!(response) == %{"basket" => []}
    end

    @tag :remove_product
    test "when requested and it's not specified the amount ir removes default value from chart",
         %{conn: conn, chart_id: chart_id} do
      :ok = Kantox.Warmers.Product.execute()

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :add_product), params)

      assert Jason.decode!(response) == %{"basket" => ["GR1"]}

      params = %{"chart_id" => chart_id, "product_id" => "GR1"}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :remove_product), params)

      assert Jason.decode!(response) == %{"basket" => []}
    end

    @tag :remove_product
    test "when requested and the item doesn't exists returns success", %{
      conn: conn,
      chart_id: chart_id
    } do
      params = %{"chart_id" => chart_id, "product_id" => "GR1", "amount" => 1}

      %{status: 200, resp_body: response} =
        post(conn, Routes.charts_path(conn, :remove_product), params)

      assert Jason.decode!(response) == %{"basket" => []}
    end
  end
end
