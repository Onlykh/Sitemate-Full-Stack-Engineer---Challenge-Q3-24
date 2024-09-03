<?php

namespace App\Services\IssueServices;

use App\Services\IssueServices\IssueServiceInterface;
use App\Repositories\IssueRepositories\IssueRepository;
use App\Models\Issue;

class IssueService implements IssueServiceInterface
{

    public function __construct(private IssueRepository $issueRepository) {}

    public function all($filters = [])
    {
        return $this->issueRepository->all($filters);
    }

    public function findById($id, $with = [])
    {
        return $this->issueRepository->findById($id, $with);
    }

    public function create(array $data)
    {
        return $this->issueRepository->create($data);
    }

    public function update(Issue $issue, array $data)
    {
        return $this->issueRepository->update($issue, $data);
    }

    public function delete(Issue $issue)
    {
        return $this->issueRepository->delete($issue);
    }
}
