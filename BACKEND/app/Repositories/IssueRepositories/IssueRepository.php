<?php

namespace App\Repositories\IssueRepositories;

use App\Models\Issue;
use App\Repositories\IssueRepositories\IssueRepositoryInterface;

class IssueRepository implements IssueRepositoryInterface
{

    public function __construct(private Issue $issue) {}

    public function all($filters = [])
    {
        $issue = $this->issue->filter($filters);

        if (isset($filters['select'])) {
            $issue->select($filters['select']);
        }

        if (isset($filters['order_by'])) {
            $issue->orderBy($filters['order_by'], $filters['order'] ?? 'asc');
        }

        if (isset($filters['with'])) {
            $issue->with($filters['with']);
        }
        return $filters['paginated'] ?? false
            ? $issue->paginate($filters['page_size'] ?? 10)
            : $issue->get();
    }

    public function findById($id, $with)
    {
        return $this->issue->with($with)->find($id);
    }

    public function create(array $data)
    {
        return $this->issue->create($data);
    }

    public function update(Issue $issue, array $data)
    {
        $issue->update($data);
        return $issue;
    }

    public function delete(Issue $issue)
    {
        $issue->delete();
    }
}
