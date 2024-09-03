import IssuesTable from "@/features/tables/IssuesTable";
import { useGetIssues } from "@/services/Issues.service";
import { Button, Flex } from "@mantine/core";
import { useNavigate } from "react-router-dom";

const IssuesPage = () => {
  const { data: issuesData, isSuccess: issueDataIsSuccess } = useGetIssues({
    paginated: "true",
    page: "1",
  });
  const navigate = useNavigate();

  if (issueDataIsSuccess) {
    return (
      <div>
        <Flex justify="flex-end" style={{ marginBottom: "1rem" }}>
          <Button
            onClick={() => {
              navigate("/issues/create");
            }}
          >
            Add Issue
          </Button>
        </Flex>
        <IssuesTable
          data={issuesData?.data || []}
          totalPages={issuesData?.last_page}
          currentPage={issuesData?.current_page}
          itemsPerPage={issuesData?.per_page}
          setCurrentPage={() => {}}
          setItemsPerPage={() => {}}
          totalItems={issuesData?.total}
        />
      </div>
    );
  }

  return <div>Loading...</div>;
};

export default IssuesPage;
