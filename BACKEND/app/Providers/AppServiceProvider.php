<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use \App\Services\IssueServices\IssueServiceInterface;
use \App\Services\IssueServices\IssueService;
use \App\Repositories\IssueRepositories\IssueRepository;
use \App\Repositories\IssueRepositories\IssueRepositoryInterface;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // BINDING REPOSITORIES PLACEHOLDER
        $this->app->bind(IssueRepositoryInterface::class, IssueRepository::class);

        // BINDING SERVICES PLACEHOLDER
        $this->app->bind(IssueServiceInterface::class, IssueService::class);

    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
