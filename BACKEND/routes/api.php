<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\IssueController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
############################### issue ###############################
Route::prefix('issues')->group(function () {
    Route::post('/', [IssueController::class, 'store']);
    Route::get('/', [IssueController::class, 'index']);
    Route::get('/{id}', [IssueController::class, 'show']);
    Route::put('/{id}', [IssueController::class, 'update']);
    Route::delete('/{id}', [IssueController::class, 'destroy']);
});
