import { createBrowserRouter, RouterProvider } from "react-router-dom";

import issuesRoutes from "./routes/IssuesRoutes";

const router = createBrowserRouter([...issuesRoutes]);

export function Router() {
  return <RouterProvider router={router} />;
}
