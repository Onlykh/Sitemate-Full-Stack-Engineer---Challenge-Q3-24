<?php

    namespace App\Repositories\IssueRepositories;

    use App\Models\Issue;

    interface IssueRepositoryInterface {
        public function all($filters = []);
        public function findById($id, $with);
        public function create(array $data);
        public function update(Issue $issue, array $data);
        public function delete(Issue $issue);
    }
