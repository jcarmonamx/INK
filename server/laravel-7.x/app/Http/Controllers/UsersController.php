<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\Auth;
use App\User;
use Validator;
use JWTAuth;

class UsersController extends Controller
{
    //
    public function health () {

        $user = JWTAuth::parseToken()->authenticate();

        $peso_ideal = $user->estatura - 100;

        $factor_salud = $peso_ideal - $user->peso;

        if ($factor_salud >= -10 && $factor_salud <= 10) {
            return response()->json([
                'salud' => 'Saludable',
                'video' => 'https://www.youtube.com/watch?v=MY_gyv3ZDLE',
                'alimentacion' => 'Evitar comida chatarra y tomar 2 litros de agua diario.',
                'ejercicio' => 'Realizar 20 minutos de cardio 3 días a la semana y 30 minutos de ejercicios de fuerza muscular 4 días a la semana.'
            ], 200);
        }

        if ($factor_salud > 10) {
            return response()->json([
                'salud' => 'Bajo en peso',
                'video' => 'https://www.youtube.com/watch?v=pVFChSGmLt4',
                'alimentacion' => 'Procurar consumo alto en carbohidratos y proteinas.',
                'ejercicio' => 'Realizar 10 minutos de cardio 3 días a la semana y 30 minutos de ejercicios de fuerza muscular con peso extra 4 días a la semana.'
            ], 200);
        }

        if ($factor_salud < -10) {
            return response()->json([
                'salud' => 'Alto en peso',
                'video' => 'https://www.youtube.com/watch?v=NncmQk5a9Dg',
                'alimentacion' => 'Consumir principalmente frutas y verduras y evitar comida chatarra y azúcares, así como también tomar 2 litros de agua diario.',
                'ejercicio' => 'Realizar 30 minutos de cardio 4 días a la semana, 15 minutos de ejercicios de resistencia 3 días a la semana.'
            ], 200);
        }

    }
}
