# <img src="./img/FumPort_logo.png" width="50"/> Fum al Port

**La calidad del aire que respiramos tiene un impacto directo en nuestra salud**. No respirar un aire limpio causa una variedad de problemas de salud, incluidas infecciones respiratorias, dolores de cabeza y fatiga. También puede agravar condiciones existentes como el asma y las alergias.

Los focos de contaminación varian a lo largo de la historia de una ciudad, industria, tráfico rodado o tráfico marítimo que es el caso de estudio de este proyecto ya que puede suponer un impacto significativo en la calidad del aire. 
<img src="./img/AQI.png" width="200" align="right" />

El monitoreo ambiental en ciudades se refiere a las prácticas de seguridad y privacidad utilizadas para proteger a los ciudadanos de los contaminantes transportados por el aire. Esto incluye la recopilación de datos sobre la calidad del aire, la temperatura, la humedad y otros factores ambientales. Estos datos luego se utilizan para evaluar el riesgo de exposición a materiales peligrosos y tomar medidas para mitigar o eliminar esos riesgos.

## Nuestra solución
<img src="./img/taller.jpg" width="300" align="right" />

Para abordar este desafío, se desarrolló un proyecto de ciencia ciudadana. Que parte de [talleres de fabricación de sensores de calidad de aire](https://www.meetup.com/makespace-mallorca/events/282643149?utm_medium=referral&utm_campaign=share-btn_savedevents_share_modal&utm_source=link) realizados en el Fablab de Mallorca y que se son posteriormente desplegados y construidos por los ciudadanos. Esto forma una red de monitoreo ambiental basado en [sensores SDS011](http://www.aliexpress.com/wholesale?groupsort=1&SortType=price_asc&SearchText=sds011) que monitorean el ambiente exterior y envían los datos recopilados a una solución en la nube donde se pueden realizar más cálculos. Con el fin de:

- **Emitir alertas** para informar a la ciudania de riesgos a la salud en tiempo real.
- Hacer un **análisis predictivo** para dar avisos de contaminación.
- Tratar de **identificar los focos** de la contaminación.

En un primer enfoque, **la solución gira en torno a la actividad en el puerto de Palma de Mallorca**. De manera que se está recopilando y tratando solo la información de este entorno. Detrás de esta iniciativa está el proyecto de la plataforma abierta [Sensor Community](https://sensor.community/es/) de [Open Data Stuttgart](https://github.com/opendata-stuttgart/) que soporta parte de la infraestructura.

## Arquitectura de solución
Este proyecto cumple con modelos y estándadres utilizados en soluciones de **Smart City**. Y se ha diseñado una arquitectura basada en uno de los más utilizados *stacks* de IoT: MQTT, Node-RED, InfluxDB y Grafana. Todo está desplegado sobre infraestructura Raspberry Pi y corriendo en contenedores Docker.
![Arquitecfura baseline](./img/FumPort_SystemArchutecture.png)

### Sensores 
<img src="./img/IMG_3990.jpg" width="300" align="left" />

Se ha partido de los [sensores Airroh](https://github.com/McOrts/taller-iot-sensor_calidad_aire) medioambientales. Aunque sólo se utilizamos la lectura de partículas en suspensión. Estos dispositivos también leen temperatura, humedad y presión atmosférica. Pero dentro de este proyecto, estamos diseñando unos más simples para la detección de partículas de 2,5 nm que son el principal indicador de calidad de aire.

La conectividad se resuelve utilizando una WiFi a su alcance para transmitir las lecturas por UDP tanto a los servidores de Sensor Community como a los de Fum Al Port. 

Por otra parte tenemos información meteorología de una estación situada en el centro del puerto y la posibilidad de utilizar otras micro-estaciones autónomas y conectadas por LoRaWAN.

### Backend 

Una aplicacion Node-RED recoge todos los datos a través de conexiones UDP, llamadas a APIs y colas MQTT. Tanto esta información de observaciones como la predictiva se almacena en una base de basada en series temporales muy utilizada en IoT que es InfluxDB. 

Node-RED además orquesta las llamadas a otros modulos:
- Python para captura de datos de webs.
- Pandas para la analítica de datos.
- Bots de Telegram y Twitter.

### Aplicación de usuario

<img src="./img/node-red_app_menu.png" width="150" align="left" />

Se ha desarrollado una aplicaciónweb a fin de disponer de un Lugar donde a la vez que se informa del proyecto. Se muestran todos la datos recopilados junto con los indices más importantes calculados por los algoritmos.  
Esa aplicación web es accesible desde: [www.fumport.de-a.org](http://fumport.de-a.org/ui) y consta de los siguientes módulos:
<br>
<br>

#### Información actualizada 
<img src="./img/node-red_app_home.png" width="300" align="right" />

Esta página recopila todos los indicadores de observación y predicción. Adenás del mapa de sensores y el enlace para el escritorio avanzado de gráficos y estadísticas.

#### Formulario de participación 

Cabe la posibilidad de subscribirse a las alarmas y avisos emitidos por Twitter, Telegram y mail-list. Para ello se puede acceder por la opción de **Participación** desde el menú de hamburguesa. 
<img src="./img/node-red_app_form.png" width="200" align="right" />

La persona interesada solo tiene que seleccionar el barrio donde reside o del que le interesa saber cúando se ha detectado contaminación o hay avisos de que la vaya a haberla. En los siguientes campos se indica un nombre o alias y sus usuarios de los canales por lo que quiera ser informado.

También se ha reservado una casilla para indicar si se está interesado en instalar un sensor de calidad del aire. Si se marca. Nos pondremos en contacto para ayudarle en esta tarea.

## Análisis de datos
### Primera fase
Se ha puesto especial interés en una buena visualización de datos. Para ello hay desplegada una instancia de Grafana que lee la información directamente de InfluxDB. 

![grafana](./img/Grafana_Dashboard.png)

La visualización de los datos es necesaria tanto para detectar errores, caidas de servicio o valores inusuales como para diseñar la analítica de datos que se puede hacer partiendo de correlaciones que aparecen. En nuestro caso sería la presencia de barcos y la detección de contaminantes.

Inicialmente se ha desarrollado una analítica básica de un algoritmo de avisos de riesfo propagación de contaminación. Es una casada de condiciones *and*:

> + Si no está lloviendo
>   + Y el viento lleva soplando en la misma direccón mas de 10 minutos
>     + Y la velocidad del viento es mayor de 5 nudos.
>       + Y la dirección coincide con un arco de propagación hacia el sensor.
 
![grafana](./img/MapWindRose.png)

### Segunda fase
Análisis de las curvas de detección y propagación para distinguir entre:
- Contaminación aislada: posiblemente de origen proximo al sensor. Humo de barbacoa, contaminación de tráfico rodado. 
- Nube de contaminante propagándose por la ciudad: originado por un foco importante de contaminación.
<img src="./img/Isolated_vs_dashing-away.png" width="500" align="center" />

Nuestro objetivo final es implementar un algoritmo que en base a una red de sensores suficente y la
correlación de los factores de: atraques, meteorología y contaminación. Pueda identificar con un grado de certidumbre, el origen de la contaminación.

## Operación
### Avisos y alertas automáticos
La solución incluye dos bots que son controlados automáticamente por Node-RED en respuesta a la salida de los diferentes algoritmos de observación y predicción.
<img src="./img/telegram.png" width="300" align="right" />
<img src="./img/twitter.png" width="300" align="left" />

Tanto la cuenta de Twitter como el canal de Telegram son públicos y cualquier persona puede subscribirse.

Por otra parte existe la cuenta de Gmail: fumport@gmail.com que es sobre la que se hace el envio de mail-list a los usuarios inscritos.

### Control desde Telegram
<img src="./img/telegram_ops.png" width="200" align="right" />

Dado que el sistema tiene una interacción con usuarios. Se ha configurado el Bot de Telegram para que atienda a ciertos comandos a fin de poder operar el funcionamiento de las aplicaciones de una forma remota y rápida. 
Este es el set actual de comandos:
```
/stop - Bloquea todas las notificaciones. 
/start - Activa todas las notificaciones. 
/users - Listado de usuarios registrados. 
/vessels - Registrar numero de barcos en el puerto.
```
En un futuro los usuarios podrán enviar peticiones por este medio a la aplicación.

## Acceso libre a los datos
De primera mano hay una carpeta con un volcado de todas las entidades de datos almacenadas en InfluxDB a excepción de la de usuarios, en este mismo repositorio: https://github.com/McOrts/fumport/tree/main/DDL

Las entidades de datos utilizadas son:
- (sensors_readings.json) Lecturas sensores de calidad del aire
- (sensors.json) Inventario de sensores
- (vessels_location.json) Localización del barcos
- (weathers_readings.json) Lecturas estación metereológica

Por otra parte la plataforma Sensor Community ofrece un REST API que perime tanto la consulta como la ingesta de datos. Más info en: https://github.com/opendata-stuttgart/meta/wiki/EN-APIs y en el swagger no oficial que está un poco desactualizado: https://api-sensor-community.bessarabov.com/#/data/get_airrohr_v1_sensor__SensorID__

Finalmente hay un archivo con el volcado de todas las lecturas a nivel mundial por dia: https://archive.sensor.community/

## Agradecimientos 

- [Associació de Veïnes de Canamunt](http://www.canamunt.org/)
- [Sensor.Community](https://sensor.community/)

> Y gracias a todos los que **participan en construir y desplegar sensores** dando a conocer datos ambientales y ayudado a que los que pueden hacer de nuestra ciudad un lugar mejor para vivir.

