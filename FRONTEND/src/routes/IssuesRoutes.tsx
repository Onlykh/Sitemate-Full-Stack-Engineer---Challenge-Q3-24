import AddIssuesPage from "@/pages/Issues/AddIssuesPage";
import EditIssuesPage from "@/pages/Issues/EditIssuesPage";
import IssuesPage from "@/pages/Issues/IssuesPage";
import ViewIssuesPage from "@/pages/Issues/ViewIssuesPage";

const issuesRoutes: any[] = [
  {
    path: "/issues",
    name: "issues page",
    element: <IssuesPage />,
  },
  {
    path: "/issues/create",
    name: "add issues page",
    element: <AddIssuesPage />,
  },
  {
    path: "/issues/:id/edit",
    name: "edit issues page",
    element: <EditIssuesPage />,
  },
  {
    path: "/issues/:id/view",
    name: "view issues page",
    element: <ViewIssuesPage />,
  },
];

export default issuesRoutes;
