// Importar librerías
import 'package:flutter/material.dart';

// Inicio del programa
void main() {
  runApp(const NeubauerApp());
}

// ==========================================================
// App principal
class NeubauerApp extends StatelessWidget {
//Aquí estoy creando una clase llamada NeubauerApp. extends StatelessWidget significa que esta 
//pantalla  o componente no cambia por sí solo conn el tiempo. Es una estructura fija que solo construye la apariencia inicial de la aplicación.
  const NeubauerApp({super.key});
//Este es el constructor de la clase. const ayuda a que flutter optimice el rendimiento.
//super.key sirve para identificar este widget dentro del árbol de Flutter.

  @override
  Widget build(BuildContext context) {
//Aquí empieza el build. Build, funciona para establecer lo que se debe mostrar en pantalla. 
//BuildContext context es como la ubicación de este widget dentro de la app
    return MaterialApp(
//Material App, es el contenedor principal de una aplicación Flutter con estilo Material Design. Aquí se configuran las
//cosas generales de la app, como el título, tema visual y pantalla inicial.
      debugShowCheckedModeBanner: false,
      title: 'Contador Neubauer',
//Este de arriba es el título de la aplicación.
      theme: ThemeData(
//Aquí empieza la configuración visual de la app: colores, estilo, diseño general, etc.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal
//Esti crea una paleta de colores basada en el color teal.Es decir, Flutter toma ese color como base y genera colores relacionados para todo lo demás-.
        ),
        useMaterial3: true,
//Material 3 está activado. Según esto, es la versión más moderna del diseño visual de flutter.
      ),
      home: const NeubauerCounterPage(),
//el poner home, va a decir cual es la pantalla que va a aparecer.
    );
  }
}

//Antes de seguir. Class = panallas. Según chat, la analogía que me dio fue: 
// class = plano de la casa
// object = construcción de la casa

// ==========================================================
// Pantalla principal
class NeubauerCounterPage extends StatefulWidget {
//Aquí básicamente estoy creando la página que puede cambiar.
  const NeubauerCounterPage({super.key});
// Constructor de la clase. const es para optimización y super.key es para la identificación del widget.
  @override
  State<NeubauerCounterPage> createState() =>
      _NeubauerCounterPageState();
}
//Básicamente se está diciendo que esta pantalla va a usar esta otra clase para manejar sus cambios. 
// ==========================================================
// Estado
//La analogía es que esto es coom el cerebro de mi app.

class _NeubauerCounterPageState
    extends State<NeubauerCounterPage> {
//Aquí estoy definiendo que vive toda la lógica y los datos que cambian de mi pantalla.
//NeubauerCounterPage es a pantalla, mientras que _NeubauerCounterPageState es lo que cambia dentro de esa pantalla
  // Controladores
  final TextEditingController celulasController =
      TextEditingController();

  final TextEditingController tripanoController =
      TextEditingController();

//Estas dos cositas de arriba es para leer lo que el usuario escribe. Los inputs.
//final significa que la variable no cambia de referencia, pero su contenido sí puede cambiar.

// Variables
  int paso = 0;
//Paso es en qué parte del proceso voy.
  int cuadranteActual = 0;
//Cuadrante Actual es el cuadrante en el que estás contando de la cámara de Neubauer
  int contador = 0;
//conteo actual
  List<int> conteos = [0, 0, 0, 0];
//Si te fijas aquí es un corchete, es para guardar los conteos de los 4 cuadrantes


  double factorDilucion = 1;
// la variable de la dilucion.
  double promedio = 0;
//promedio de los cuadrantes.
  double celulasPorMl = 0;
// variable de resutlado final

//TODO ESTÁ EN STATE PORQUE CAMBIARÁ 

// ======================================================
// Calcular dilución
  void calcularDilucion() {
// Aquí estoy creando una función que leera lo que el usuario escribió, lo convertirá a número, y calculará la dilución.
// Al final también actualizará la app.
    double celulas =
        double.tryParse(celulasController.text) ?? 0;
// celulasController.text es lo que el usuario escribió, y utilizamos TryParse para pasarlo a número. 
// los signos de interrogación para demostrar que si falla pues utilizará cero.
    double tripano =
        double.tryParse(tripanoController.text) ?? 0;
//IDEM de lo de arriba. 

    if (celulas <= 0) return;
// SI NO HAY CÉLULAS, REGRESA.
    double volumenTotal = celulas + tripano;
// Aquí pues estoy calculando mi volumen total, sumando los microlitros que puse de células y los microlitros que puse de azul tripano.
    setState(() {
      factorDilucion = volumenTotal / celulas;
      paso = 1;
    });
  }
//setState funciona para que flutter, cuando cambie datos, actualice la pantalla.
//también si te fijas, también estas poniendo lo de paso = 1. Que es para poder cambiar de paso.

  // ======================================================
  // Contador
  void sumarCelula() {
    setState(() {
      contador++;
    });
  }
//Esta es una función para SUMAR, si te fijas tiene como el ++
  void restarCelula() {
    if (contador > 0) {
      setState(() {
        contador--;
      });
    }
  }

  // ======================================================
  // Siguiente cuadrante
  void siguienteCuadrante() {
    setState(() {

      conteos[cuadranteActual] = contador;

      if (cuadranteActual < 3) {
        cuadranteActual++;
        contador = 0;
      } else {
        calcularResultados();
        paso = 2;
      }
    });
  }

  // ======================================================
  // Resultados
  void calcularResultados() {

    int total =
        conteos.reduce((a, b) => a + b);

    promedio = total / 4;

    celulasPorMl =
        promedio * factorDilucion * 10000;
  }

  // ======================================================
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Neubauer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: paso == 0
            ? pantallaDilucion()
            : paso == 1
                ? pantallaConteo()
                : pantallaResultados(),
      ),
    );
  }

  // ======================================================
  // Pantalla 1
  Widget pantallaDilucion() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          const Text(
            'Paso 1: Calcula tu factor de dilución',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: celulasController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'µL de células',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: tripanoController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'µL de azul tripano',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: calcularDilucion,
            child: const Text(
                'Calcular dilución'),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // Pantalla 2
  Widget pantallaConteo() {
    return Column(
      children: [

        Text(
          'Cuadrante ${cuadranteActual + 1}',
        ),

        Text(
          '$contador',
          style: const TextStyle(fontSize: 60),
        ),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: restarCelula,
              child: const Text('-1'),
            ),

            ElevatedButton(
              onPressed: sumarCelula,
              child: const Text('+1'),
            ),
          ],
        ),

        ElevatedButton(
          onPressed: siguienteCuadrante,
          child: const Text('Siguiente'),
        ),
      ],
    );
  }

  // ======================================================
  // Pantalla 3
  Widget pantallaResultados() {

    int total =
        conteos.reduce((a, b) => a + b);

    return Column(
      children: [

        Text('Total: $total'),
        Text('Promedio: $promedio'),
        Text('Células/mL: $celulasPorMl'),

      ],
    );
  }
}