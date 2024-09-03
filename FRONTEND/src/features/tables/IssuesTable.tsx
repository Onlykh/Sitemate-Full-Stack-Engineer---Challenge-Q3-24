import { myColors } from "@/constants/Colors";
import { useDeleteIssue } from "@/services/Issues.service";
import { IssueModel } from "@/types/IssueModel";
import {
  ActionIcon,
  Group,
  Pagination,
  Select,
  Table,
  Text,
} from "@mantine/core";
import { IconEyeSearch, IconTrash } from "@tabler/icons-react";
import { useNavigate } from "react-router-dom";

type IssuesProps = {
  data: Partial<IssueModel>[];
  totalPages: number;
  currentPage: number;
  itemsPerPage: number;
  setCurrentPage: (value: number) => void;
  setItemsPerPage: (value: number) => void;
  totalItems: number;
};

const IssuesTable = ({
  data,
  totalPages = 0,
  currentPage,
  itemsPerPage,
  setCurrentPage,
  setItemsPerPage,
  totalItems = 0,
}: IssuesProps) => {
  const navigate = useNavigate();
  const deleteIssueMutation = useDeleteIssue();
  const handlePageChange = (value: number) => {
    setCurrentPage(value);
  };

  const handleItemsPerPageChange = (value: string) => {
    setItemsPerPage(parseInt(value, 10));
  };

  const handleDeleteIssue = async (id: any) => {
    try {
      await deleteIssueMutation.mutateAsync(id);
    } catch (error) {
      console.error(error);
    }
  };
  const rows = data?.map((element) => {
    return (
      <Table.Tr key={element?.id}>
        <Table.Td>{element?.title}</Table.Td>
        <Table.Td>{element?.description}</Table.Td>

        <Table.Td>
          <Group>
            <ActionIcon
              variant="subtle"
              onClick={() => navigate(`${element?.id}/edit`)}
            >
              <IconEyeSearch
                style={{ width: "80%", height: "80%" }}
                stroke={1.5}
              />
            </ActionIcon>
            <ActionIcon
              variant="subtle"
              onClick={() => handleDeleteIssue(element?.id)}
              color="red"
            >
              <IconTrash style={{ width: "80%", height: "80%" }} stroke={1.5} />
            </ActionIcon>
          </Group>
        </Table.Td>
      </Table.Tr>
    );
  });

  return (
    <>
      <Table
        mt="lg"
        highlightOnHover
        captionSide="bottom"
        style={{
          border: `2px solid ${myColors.background}`,
        }}
      >
        {!data?.length ? (
          <Table.Caption>No Data Found</Table.Caption>
        ) : (
          <Table.Caption>
            <Group justify="space-between">
              <Group>
                <Text size="xs" c="dimmed">
                  Show result
                </Text>
                <Select
                  w={70}
                  size="xs"
                  radius="md"
                  placeholder="10"
                  data={["10", "15", "20", "25", "30"]}
                  value={itemsPerPage?.toString()}
                  onChange={(value) => handleItemsPerPageChange(value ?? "")}
                />
                <Text size="xs" c="dimmed">
                  Out of {totalItems}
                </Text>
              </Group>
              <Pagination
                total={totalPages}
                value={currentPage}
                onChange={handlePageChange}
                size="sm"
                radius="md"
              />
            </Group>
          </Table.Caption>
        )}
        <Table.Thead
          style={{
            backgroundColor: myColors.background,
          }}
        >
          <Table.Tr>
            <Table.Th>Title</Table.Th>
            <Table.Th>Description</Table.Th>
            <Table.Th />
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>{rows}</Table.Tbody>
      </Table>
    </>
  );
};

export default IssuesTable;
