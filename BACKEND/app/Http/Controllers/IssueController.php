<?php

namespace App\Http\Controllers;

use App\Models\Issue;
use App\Http\Requests\IssueRequests\IssueStoreRequest;
use App\Http\Requests\IssueRequests\IssueUpdateRequest;
use App\Http\Resources\IssueResources\IssueResource;
use App\Http\Resources\IssueResources\IssueCollection;
use App\Services\IssueServices\IssueService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

class IssueController extends Controller
{

    public function __construct(private IssueService $issueService) {}

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {

        $issues = $this->issueService->all($request->all());

        return response()->json(
            new IssueCollection($issues)
        );
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return JsonResponse
     */
    public function store(IssueStoreRequest $request): JsonResponse
    {
        $issue = $this->issueService
            ->create($request->validated());

        return response()->json(
            [
                'message' => __('actions.success'),
                'data' => new IssueResource($issue)
            ],
            201
        );
    }

    /**
     * Display the specified resource.
     *
     * @return JsonResponse
     */
    public function show($id, Request $request): JsonResponse
    {
        $issue = $this->issueService->findById($id, $request->input('with', []));
        if (!$issue) {
            return response()->json(['message' => 'issue ' . __('Not Found')], 404);
        }

        return response()->json(new IssueResource($issue));
    }

    /**
     * Update the specified resource in storage.
     *
     * @return JsonResponse
     */
    public function update(IssueUpdateRequest $request, int $id): JsonResponse
    {
        $issue = $this->issueService->findById($id);
        if (!$issue) {
            return response()->json(['message' => 'Issue not found'], 404);
        }

        $issue = $this->issueService->update($issue, $request->validated());

        return response()->json([
            'message' => __('actions.success'),
            'data' => new IssueResource($issue)
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @return JsonResponse
     */
    public function destroy(int $id): JsonResponse
    {
        $issue = $this->issueService->findById($id);
        if (!$issue) {
            return response()->json(['message' => 'Issue not found'], 404);
        }

        $this->issueService->delete($issue);

        return response()->json(['message' => __('actions.success')], 204);
    }
}
