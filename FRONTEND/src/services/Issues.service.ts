import axiosClient from "@/axiosClient";
import { IssueModel } from "@/types/IssueModel";
import { queryBuilder } from "@/utils/utils";
import {
  useMutation,
  UseMutationOptions,
  UseMutationResult,
  useQuery,
  useQueryClient,
  UseQueryResult,
} from "@tanstack/react-query";
import { AxiosResponse } from "axios";

type CreateIssueModelVariables = Partial<IssueModel>;
type CreateIssueModelResponse = AxiosResponse<IssueModel>;

type FetchIssueModelResponse = AxiosResponse<IssueModel>;

type FetchIssueModelVariables = string | undefined;

type UpdateIssueModelVariables = {
  issueId: string | undefined;
  values: Partial<IssueModel>;
};

type UpdateIssueModelResponse = AxiosResponse<IssueModel>;

type DeleteIssueModelResponse = AxiosResponse<IssueModel>;

type DeleteIssueModelVariables = string | undefined;

const fetchIssues = async (
  params: Record<string, string>,
): Promise<FetchIssueModelResponse> => {
  const queryString = queryBuilder(params);

  const parsed = await axiosClient.get(`issues${queryString}`);
  return parsed.data;
};

const useGetIssues = (
  params: Record<string, string>,
): UseQueryResult<FetchIssueModelResponse, Error> =>
  useQuery<FetchIssueModelResponse, Error>({
    queryKey: ["issues", params],
    queryFn: () => fetchIssues(params),
  });

const fetchIssue = async (
  issueId: FetchIssueModelVariables,
): Promise<FetchIssueModelResponse> => {
  const parsed = await axiosClient.get(`issues/${issueId}`);
  return parsed.data;
};

const useGetIssue = (
  issueId: FetchIssueModelVariables,
): UseQueryResult<FetchIssueModelResponse, Error> =>
  useQuery<FetchIssueModelResponse, Error>({
    queryKey: ["issue", issueId],
    queryFn: () => fetchIssue(issueId),
  });

const updateIssue = async ({
  issueId,
  values,
}: UpdateIssueModelVariables): Promise<UpdateIssueModelResponse> => {
  const parsed = await axiosClient.put(`issues/${issueId}`, values);
  return parsed.data;
};

const useUpdateIssue = (): UseMutationResult<
  UpdateIssueModelResponse,
  Error,
  UpdateIssueModelVariables,
  unknown
> => {
  const mutationConfig: UseMutationOptions<
    UpdateIssueModelResponse,
    Error,
    UpdateIssueModelVariables,
    unknown
  > = {
    mutationFn: ({ issueId, values }) => updateIssue({ issueId, values }),
    onSuccess: () => {},
  };

  return useMutation(mutationConfig);
};

const createIssue = async (
  values: CreateIssueModelVariables,
): Promise<CreateIssueModelResponse> => {
  const parsed = await axiosClient.post("issues", values);
  return parsed.data;
};

const useCreateIssue = (): UseMutationResult<
  CreateIssueModelResponse,
  Error,
  CreateIssueModelVariables,
  unknown
> => {
  const mutationConfig: UseMutationOptions<
    CreateIssueModelResponse,
    Error,
    CreateIssueModelVariables,
    unknown
  > = {
    mutationFn: (values) => createIssue(values),
    onSuccess: () => {},
  };

  return useMutation(mutationConfig);
};

const deleteIssue = async (
  issueId: DeleteIssueModelVariables,
): Promise<DeleteIssueModelResponse> => {
  const parsed = await axiosClient.delete(`issues/${issueId}`);
  return parsed.data;
};

const useDeleteIssue = (): UseMutationResult<
  DeleteIssueModelResponse,
  Error,
  DeleteIssueModelVariables,
  unknown
> => {
  const queryClient = useQueryClient();

  const mutationConfig: UseMutationOptions<
    DeleteIssueModelResponse,
    Error,
    DeleteIssueModelVariables,
    unknown
  > = {
    mutationFn: (issueId) => deleteIssue(issueId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["issues"] });
    },
  };

  return useMutation(mutationConfig);
};

export {
  useGetIssues,
  useGetIssue,
  useUpdateIssue,
  useCreateIssue,
  useDeleteIssue,
};
