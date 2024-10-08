<?php

namespace App\Http\Resources\IssueResources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class IssueCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        if ($request->paginated) {
            return [
                'current_page' => $this->currentPage(),
                'data' => $this->collection,
                'first_page_url' => $this->url(1),
                'from' => $this->firstItem(),
                'last_page' => $this->lastPage(),
                'last_page_url' => $this->url($this->lastPage()),
                'next_page_url' => $this->nextPageUrl(),
                'total' => $this->total(),
                'per_page' => $this->perPage(),
            ];
        }
        return parent::toArray($request);
    }
}
