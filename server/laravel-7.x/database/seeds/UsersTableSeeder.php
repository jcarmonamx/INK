<?php

use Illuminate\Database\Seeder;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        DB::table('users')->insert([
            [
                'name'=>'Juan Manuel García',
                'email'=>'zonademanel@gmail.com',
                'password'=>Hash::make('12345'),
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
                'fecha_nacimiento' => '1984-11-06',
                'telefono' => '461 600 2835',
                'genero' => 'hombre',
                'estatura' => '169',
                'peso' => '101',
                'complexion' => 'endomorfo',
                'fruta' => '0',
                'agua' => '1',
                'carne_roja' => '1',
                'cereales' => '0',
                'carne_blanca' => '1',
                'verduras' => '0',
                'azucares' => '1',
                'chatarra' => '1',
                'condicion' => 'mala'
            ]
        ]);
    }
}
