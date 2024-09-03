export const queryBuilder = (params: Record<string, string>) => {
  return params ? `?${new URLSearchParams(params).toString()}` : "";
};
