<?php

    namespace App\ModelFilters;
    use Illuminate\Database\Eloquent\Builder;
    use EloquentFilter\ModelFilter;


    class IssueFilter extends ModelFilter
    {
        /**
        * Related Models that have ModelFilters as well as the method on the ModelFilter
        *
        */
        public function search($value)
        {
            $query = $this;
            $fillableColumns = $query->getModel()->getFillable();
            return $query->where(function (Builder $query) use ($fillableColumns, $value) {
                foreach ($fillableColumns as $column) {
                    $query->orWhere($column, 'LIKE', '%' . $value . '%');
                }
            });
        }
    }
