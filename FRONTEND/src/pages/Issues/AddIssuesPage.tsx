import IssueForm from "@/features/forms/IssueForm";
import { useCreateIssue } from "@/services/Issues.service";
import { IssueModel } from "@/types/IssueModel";
import { useState } from "react";
import { useNavigate } from "react-router-dom";

const AddIssuesPage = () => {
  const navigate = useNavigate();
  const [issue, setIssue] = useState<Partial<IssueModel>>({
    title: "",
    description: "",
  });
  const createIssueMutation = useCreateIssue();
  const handleAction = async () => {
    try {
      await createIssueMutation.mutateAsync(issue);
      navigate("/issues");
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <IssueForm handleAction={handleAction} issue={issue} setIssue={setIssue} />
  );
};

export default AddIssuesPage;
