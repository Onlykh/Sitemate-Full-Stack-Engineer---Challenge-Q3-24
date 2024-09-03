import IssueForm from "@/features/forms/IssueForm";
import { useGetIssue, useUpdateIssue } from "@/services/Issues.service";
import { IssueModel } from "@/types/IssueModel";
import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

const EditIssuesPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [issue, setIssue] = useState<Partial<IssueModel>>({
    title: "",
    description: "",
  });
  const { data: issueData, isSuccess } = useGetIssue(id);
  const useUpdateIssueMutation = useUpdateIssue();
  useEffect(() => {
    if (isSuccess) {
      setIssue(issueData);
    }
  }, [isSuccess]);
  const handleAction = async () => {
    try {
      await useUpdateIssueMutation.mutateAsync({
        issueId: id,
        values: issue,
      });
      navigate("/issues");
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <IssueForm handleAction={handleAction} issue={issue} setIssue={setIssue} />
  );
};

export default EditIssuesPage;
