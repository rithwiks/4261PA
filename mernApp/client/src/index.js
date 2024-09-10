const token = localStorage?.getItem("token");

root.render(
    <React.StrictMode>
    {token ? <App /> : <Login />}
    </React.StrictMode>
);