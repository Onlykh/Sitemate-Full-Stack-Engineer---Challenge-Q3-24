import { IssueModel } from "@/types/IssueModel";
import { Button, Container, Textarea, TextInput } from "@mantine/core";

type IssueFormProps = {
  issue: Partial<IssueModel>;
  setIssue: React.Dispatch<React.SetStateAction<Partial<IssueModel>>>;
  handleAction: () => void;
};

const IssueForm = ({ issue, setIssue, handleAction }: IssueFormProps) => {
  const handleInputChange =
    (field: keyof Partial<IssueModel>) =>
    (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
      setIssue((prevIssue: Partial<IssueModel>) => ({
        ...prevIssue,
        [field]: event.target.value,
      }));
    };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    handleAction();
  };

  return (
    <Container size="sm">
      <form onSubmit={handleSubmit}>
        <TextInput
          label="Title"
          placeholder="Enter issue title"
          value={issue?.title || ""}
          onChange={handleInputChange("title")}
          required
        />
        <Textarea
          label="Description"
          placeholder="Enter issue description"
          value={issue?.description || ""}
          onChange={handleInputChange("description")}
          required
          minRows={4}
          mt="md"
        />
        <Button type="submit" mt="md">
          Save
        </Button>
      </form>
    </Container>
  );
};

export default IssueForm;
