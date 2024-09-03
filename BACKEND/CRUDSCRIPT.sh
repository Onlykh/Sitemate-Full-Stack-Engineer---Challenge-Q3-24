#!/bin/bash

pluralize() {
    local word="$1"
    if [[ "$word" =~ [sxz]$ ]] || [[ "$word" =~ [^aeioudgkprt]h$ ]]; then
        echo "${word}es"
    elif [[ "$word" =~ [aeiou]y$ ]]; then
        echo "${word}s"
    elif [[ "$word" =~ y$ ]]; then
        echo "${word%y}ies"
    else
        echo "${word}s"
    fi
}

echo "Enter model names separated by space (DTest):"
read -a models

for model in "${models[@]}"; do
    # Extract the first character
    dataType=$(echo "${model:0:1}" | tr '[:upper:]' '[:lower:]')

    # Extract the rest of the string
    ModelName="${model:1}"

    # change model first caracter to lower case
    firstCharModel=$(echo "${ModelName:0:1}" | tr '[:upper:]' '[:lower:]')

    lowerModel="${firstCharModel}${ModelName:1}"

    ModelToDisplay=$(echo "$ModelName" | sed -r 's/(.)([A-Z])/\1 \2/g' | tr '[:upper:]' '[:lower:]')

    # Replace spaces with hyphens
    ModelRoute=$(echo "$ModelToDisplay" | tr ' ' '-')
    ModelRoute=$(pluralize "$ModelRoute")
    # Table name
    TableName="${dataType}_$(echo "$ModelToDisplay" | tr ' ' '_')"
    TableName=$(pluralize "$TableName")

    # Create the model
    php artisan make:model "$ModelName" --factory --seed --controller --quiet
    php artisan make:migration create_"$TableName"_table --create="$TableName" --quiet


    echo "<?php

    namespace App\Models;


    use EloquentFilter\Filterable;
    use Illuminate\Database\Eloquent\Factories\HasFactory;
    use Illuminate\Database\Eloquent\Model;

    class ${ModelName} extends Model
    {
        use HasFactory, Filterable;
        /**
        * The table associated with the model.
        *
        * @var string
        */
        protected \$table = '$TableName';

        /**
        * The attributes that are mass assignable.
        *
        * @var array<int, string>
        */
        protected \$fillable = [
        ];

    }" > "app/Models/${ModelName}.php"

    # sucess message
    echo -e "\e[32mModel \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Create Repositories and Interfaces
    modelRepoInterface="${ModelName}RepositoryInterface"
    modelRepo="${ModelName}Repository"

    mkdir -p "app/Repositories/${ModelName}Repositories"

    # Create Repository interface file with content
    cat <<EOL > "app/Repositories/${ModelName}Repositories/${modelRepoInterface}.php"
<?php

    namespace App\Repositories\\${ModelName}Repositories;

    use App\Models\\${ModelName};

    interface ${modelRepoInterface} {
        public function all(\$filters = []);
        public function findById(\$id, \$with);
        public function create(array \$data);
        public function update(${ModelName} \$${lowerModel}, array \$data);
        public function delete(${ModelName} \$${lowerModel});
    }
EOL

    # Create Repository file with content
    cat <<EOL > "app/Repositories/${ModelName}Repositories/${modelRepo}.php"
<?php

    namespace App\Repositories\\${ModelName}Repositories;

    use App\Models\\${ModelName};
    use App\Repositories\\${ModelName}Repositories\\${modelRepoInterface};

    class ${modelRepo} implements ${modelRepoInterface} {

        public function __construct(private ${ModelName} \$${lowerModel})
        {
        }

        public function all(\$filters = [])
        {
            \$${lowerModel} = \$this->${lowerModel}->filter(\$filters);

            if (isset(\$filters['select'])) {
                \$${lowerModel}->select(\$filters['select']);
            }

            if (isset(\$filters['order_by'])) {
                \$${lowerModel}->orderBy(\$filters['order_by'], \$filters['order'] ?? 'asc');
            }

            if (isset(\$filters['with'])) {
                \$${lowerModel}->with(\$filters['with']);
            }

            return \$filters['paginated'] ?? false
                ? \$${lowerModel}->paginate(\$filters['page_size'] ?? 10)
                : \$${lowerModel}->get();
        }

        public function findById(\$id, \$with)
        {
            return \$this->${lowerModel}->with(\$with)->find(\$id);
        }

        public function create(array \$data)
        {
            return \$this->${lowerModel}->create(\$data);
        }

        public function update(${ModelName} \$${lowerModel}, array \$data)
        {
            \$${lowerModel}->update(\$data);
            return \$${lowerModel};
        }

        public function delete(${ModelName} \$${lowerModel})
        {
            \$${lowerModel}->delete();
        }
    }
EOL

    echo -e "\e[32mRepository \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Create Services
    modelServiceInterface="${ModelName}ServiceInterface"
    modelService="${ModelName}Service"

    mkdir -p "app/Services/${ModelName}Services"


    # Create Service interface file with content

    cat <<EOL > "app/Services/${ModelName}Services/${modelServiceInterface}.php"
<?php

    namespace App\Services\\${ModelName}Services;

    use App\Models\\${ModelName};

    interface ${modelServiceInterface} {
        public function all(\$filters = []);
        public function findById(\$id, \$with = []);
        public function create(array \$data);
        public function update(${ModelName} \$${lowerModel}, array \$data);
        public function delete(${ModelName} \$${lowerModel});
    }
EOL

    cat <<EOL > "app/Services/${ModelName}Services/${modelService}.php"
<?php

    namespace App\Services\\${ModelName}Services;

    use App\Services\\${ModelName}Services\\${modelServiceInterface};
    use App\Repositories\\${ModelName}Repositories\\${modelRepo};
    use App\Models\\${ModelName};

    class ${modelService} implements ${modelServiceInterface} {

        public function __construct(private ${modelRepo} \$${lowerModel}Repository)
        {
        }

        public function all(\$filters = [])
        {
            return \$this->${lowerModel}Repository->all(\$filters);
        }

        public function findById(\$id, \$with= [])
        {
            return \$this->${lowerModel}Repository->findById(\$id, \$with);
        }

        public function create(array \$data)
        {
            return \$this->${lowerModel}Repository->create(\$data);
        }

        public function update(${ModelName} \$${lowerModel}, array \$data)
        {
            return \$this->${lowerModel}Repository->update(\$${lowerModel}, \$data);
        }

        public function delete(${ModelName} \$${lowerModel})
        {
            return \$this->${lowerModel}Repository->delete(\$${lowerModel});
        }
    }
EOL

    echo -e "\e[32mService \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"



    # create Requests
    mkdir -p "app/Http/Requests/${ModelName}Requests"
    php artisan make:request "${ModelName}Requests/${ModelName}StoreRequest" --quiet
    php artisan make:request "${ModelName}Requests/${ModelName}UpdateRequest" --quiet

    echo -e "\e[32mRequests \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"


    # Create Resources
    mkdir -p "app/Http/Resources/${ModelName}Resources"
    php artisan make:resource "${ModelName}Resources/${ModelName}Resource" --quiet
    php artisan make:resource "${ModelName}Resources/${ModelName}Collection" --collection --quiet

    echo -e "\e[32mResources \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Create Policies
    php artisan make:policy "${ModelName}Policy" --model="${ModelName}" --quiet

    echo -e "\e[32mPolicy \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Update controller file
echo "<?php

    namespace App\Http\Controllers;

    use App\Models\\${ModelName};
    use App\Http\Requests\\${ModelName}Requests\\${ModelName}StoreRequest;
    use App\Http\Requests\\${ModelName}Requests\\${ModelName}UpdateRequest;
    use App\Http\Resources\\${ModelName}Resources\\${ModelName}Resource;
    use App\Http\Resources\\${ModelName}Resources\\${ModelName}Collection;
    use App\Services\\${ModelName}Services\\${ModelName}Service;
    use Illuminate\Http\JsonResponse;
    use Illuminate\Http\Request;
    use Illuminate\Support\Facades\Gate;

    class ${ModelName}Controller extends Controller
    {

        public function __construct(private ${ModelName}Service \$${lowerModel}Service)
        {
        }

        /**
        * Display a listing of the resource.
        *
        * @return \Illuminate\Http\Response
        */
        public function index(Request \$request)
        {
            Gate::authorize('viewAny', ${ModelName}::class);

            \$$(pluralize "$lowerModel") = \$this->${lowerModel}Service->all(\$request->all());

            return response()->json(
                new ${ModelName}Collection(\$$(pluralize "$lowerModel"))
            );
        }

        /**
        * Store a newly created resource in storage.
        *
        * @return JsonResponse
        */
        public function store(${ModelName}StoreRequest \$request): JsonResponse
        {
            \$${lowerModel}= \$this->${lowerModel}Service
                ->create(\$request->validated());

            return response()->json(
                [
                    'message' => __('actions.success'),
                    'data' => new ${ModelName}Resource(\$${lowerModel})
                ],
                201
            );
        }

        /**
        * Display the specified resource.
        *
        * @return JsonResponse
        */
        public function show(\$id, Request \$request): JsonResponse
        {
            \$${lowerModel} = \$this->${lowerModel}Service->findById(\$id, \$request->input('with',[]));
            if (!\$$lowerModel) {
                return response()->json(['message' => '${ModelToDisplay} '.__('Not Found')], 404);
            }
            Gate::authorize('view', \$${lowerModel});

            return response()->json(new ${ModelName}Resource (\$${lowerModel}));
        }

        /**
         * Update the specified resource in storage.
        *
        * @return JsonResponse
        */
        public function update(${ModelName}UpdateRequest \$request, int \$id): JsonResponse
        {
            \$${lowerModel} = \$this->${lowerModel}Service->findById(\$id);
            if (!\$${lowerModel}) {
                return response()->json(['message' => '${ModelName} not found'], 404);
            }

            \$${lowerModel} = \$this->${lowerModel}Service->update(\$${lowerModel}, \$request->validated());

            return response()->json([
                'message' => __('actions.success'),
                'data' => new ${ModelName}Resource(\$${lowerModel})
            ], 200);
        }

        /**
        * Remove the specified resource from storage.
        *
        * @return JsonResponse
        */
        public function destroy(int \$id): JsonResponse
        {
            \$${lowerModel} = \$this->${lowerModel}Service->findById(\$id);
            if (!\$${lowerModel}) {
                return response()->json(['message' => '${ModelName} not found'], 404);
            }

            \$this->${lowerModel}Service->delete(\$${lowerModel});

            return response()->json(['message' => __('actions.success')], 204);
        }
    }" > "app/Http/Controllers/${ModelName}Controller.php"

    echo -e "\e[32mController \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Model Filter
    php artisan model:filter $ModelName

        cat <<EOL > "app/ModelFilters/${ModelName}Filter.php"
<?php

    namespace App\ModelFilters;
    use Illuminate\Database\Eloquent\Builder;
    use EloquentFilter\ModelFilter;


    class ${ModelName}Filter extends ModelFilter
    {
        /**
        * Related Models that have ModelFilters as well as the method on the ModelFilter
        *
        */
        public function search(\$value)
        {
            \$query = \$this;
            \$fillableColumns = \$query->getModel()->getFillable();
            return \$query->where(function (Builder \$query) use (\$fillableColumns, \$value) {
                foreach (\$fillableColumns as \$column) {
                    \$query->orWhere(\$column, 'LIKE', '%' . \$value . '%');
                }
            });
        }
    }
EOL

    echo -e "\e[32mModel Filter \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # BINDING

    provider_path="app/Providers/AppServiceProvider.php"
    # Define the interface and implementation
    interfaceRepo="\\\\App\\\\Repositories\\\\${ModelName}Repositories\\\\${modelRepoInterface}"
    implementationRepo="\\\\App\\\\Repositories\\\\${ModelName}Repositories\\\\${modelRepo}"
    interfaceService="\\\\App\\\\Services\\\\${ModelName}Services\\\\${modelService}"
    implementationService="\\\\App\\\\Services\\\\${ModelName}Services\\\\${modelServiceInterface}"
    # Create the binding line
    binding_reposotory_line="\$this->app->bind(${modelRepoInterface}::class, ${modelRepo}::class);"
    binding_service_line="\$this->app->bind(${modelServiceInterface}::class, ${modelService}::class);"
    # binding_service="\$this->app->bind(\\\\App\\\\Services\\\\${model}Services\\\\${model}Service::class, function (\$app) {return new \\\\App\\\\Services\\\\${model}Services\\\\${model}Service(\$app->make(${interface}::class));});"

    sed -i "5 a use ${interfaceRepo};" "$provider_path"
    sed -i "5 a use ${implementationRepo};" "$provider_path"
    sed -i "5 a use ${interfaceService};" "$provider_path"
    sed -i "5 a use ${implementationService};" "$provider_path"
    # Insert the binding lines at the placeholders
    sed -i "/BINDING REPOSITORIES PLACEHOLDER/a\\
        ${binding_reposotory_line}" "$provider_path"
    sed -i "/BINDING SERVICES PLACEHOLDER/a\\
        ${binding_service_line}" "$provider_path"

    echo -e "\e[32mBinding \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"

    # Routes

    #  Add routes for CRUD operations in your routes file (e.g., api.php)
    # Prompt for operations
    read -p "Enter the operations you want to generate (CRUD): " operations

    # Start of the route definition
    # if any of the crud operations import controller to th line 4 of the api file
    if [[ $operations == *"C"* ]] || [[ $operations == *"c"* ]] || [[ $operations == *"R"* ]] || [[ $operations == *"r"* ]] || [[ $operations == *"U"* ]] || [[ $operations == *"u"* ]] || [[ $operations == *"D"* ]] || [[ $operations == *"d"* ]]; then
        sed -i "4 a use App\\\\Http\\\\Controllers\\\\${ModelName}Controller;" routes/api.php
        echo "############################### ${ModelToDisplay} ###############################" >> routes/api.php
        echo "Route::prefix('${ModelRoute}')->group(function () {" >> routes/api.php
    fi
    # Check for Create operation
    if [[ $operations == *"C"* ]] || [[ $operations == *"c"* ]]; then
        echo "Route::post('/', [${ModelName}Controller::class, 'store']);" >> routes/api.php
    fi
    # Check for Read operation
    if [[ $operations == *"R"* ]] || [[ $operations == *"r"* ]]; then
        echo "Route::get('/', [${ModelName}Controller::class, 'index']);" >> routes/api.php
        echo "Route::get('/{id}', [${ModelName}Controller::class, 'show']);" >> routes/api.php
    fi
    # Check for Update operation
    if [[ $operations == *"U"* ]] || [[ $operations == *"u"* ]]; then
        echo "Route::put('/{id}', [${ModelName}Controller::class, 'update']);" >> routes/api.php
    fi
    # Check for Delete operation
    if [[ $operations == *"D"* ]] || [[ $operations == *"d"* ]]; then
        echo "Route::delete('/{id}', [${ModelName}Controller::class, 'destroy']);" >> routes/api.php
    fi
    # End of the route definition
    if [[ $operations == *"C"* ]] || [[ $operations == *"c"* ]] || [[ $operations == *"R"* ]] || [[ $operations == *"r"* ]] || [[ $operations == *"U"* ]] || [[ $operations == *"u"* ]] || [[ $operations == *"D"* ]] || [[ $operations == *"d"* ]]; then
        echo "});" >> routes/api.php
    fi



    echo -e "\e[32mRoutes \033[1m$ModelName\033[0m \e[32mcreated successfully\e[0m"


done

