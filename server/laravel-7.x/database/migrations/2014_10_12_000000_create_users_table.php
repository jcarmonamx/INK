<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->date('fecha_nacimiento');
            $table->string('telefono')->default('');;
            $table->enum('genero', ['hombre', 'mujer']);
            $table->string('estatura');
            $table->string('peso');
            $table->enum('complexion', ['hectomorfo', 'mesomorfo', 'endomorfo']);
            $table->boolean('fruta')->default('false');
            $table->boolean('agua')->default('false');
            $table->boolean('carne_roja')->default('false');
            $table->boolean('cereales')->default('false');
            $table->boolean('carne_blanca')->default('false');
            $table->boolean('verduras')->default('false');
            $table->boolean('azucares')->default('false');
            $table->boolean('chatarra')->default('false');
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');
    }
}
