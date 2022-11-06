# <img src="./img/FumPort_logo.png" width="50"/> Fum al Port

**La calidad del aire que respiramos tiene un impacto directo en nuestra salud**. No respirar un aire limpio causa una variedad de problemas de salud, incluidas infecciones respiratorias, dolores de cabeza y fatiga. También puede agravar condiciones existentes como el asma y las alergias.

Los focos de contaminación varian a lo largo de la historia de una ciudad, industria, tráfico rodado o tráfico marítimo que es el caso de estudio de este proyecto ya que puede suponer un impacto significativo en la calidad del aire. 

El monitoreo ambiental en ciudades se refiere a las prácticas de seguridad y privacidad utilizadas para proteger a los ciudadanos de los contaminantes transportados por el aire. Esto incluye la recopilación de datos sobre la calidad del aire, la temperatura, la humedad y otros factores ambientales. Estos datos luego se utilizan para evaluar el riesgo de exposición a materiales peligrosos y tomar medidas para mitigar o eliminar esos riesgos.

## Nuestra solución
<img src="./img/taller.jpg" width="300" align="right" />

Para abordar este desafío, se desarrolló un proyecto de ciencia ciudadana. Que parte de [talleres de fabricación de sensores de calidad de aire](https://www.meetup.com/makespace-mallorca/events/282643149?utm_medium=referral&utm_campaign=share-btn_savedevents_share_modal&utm_source=link) realizados en el Fablab de Mallorca y que se son posteriormente desplegados y construidos por los ciudadanos. Esto forma una red de monitoreo ambiental basado en [sensores SDS011](http://www.aliexpress.com/wholesale?groupsort=1&SortType=price_asc&SearchText=sds011) que monitorean el ambiente exterior y envían los datos recopilados a una solución en la nube donde se pueden realizar más cálculos. Con el fin de:

- **Emitir alertas** para informar a la ciudania de riesgos a la salud en tiempo real.
- Hacer un **análisis predictivo** para dar avisos de contaminación.
- Tratar de **identificar los focos** de la contaminación.

En un primer enfoque, **la solución gira en torno a la actividad en el puerto de Palma de Mallorca**. De manera que se está recopilando y tratando solo la información de este entorno. Detrás de esta iniciativa está el proyecto de la plataforma abierta [Sensor Community](https://sensor.community/es/) de [Open Data Stuttgart](https://github.com/opendata-stuttgart/) que soporta parte de la infraestructura.

## Arquitectura de solución
Este proyecto cumple con modelos y estándadres utilizados en soluciones de **Smart City**. Y se ha diseñado una arquitectura basada en uno de los más utilizados //stacks// de IoT: MQTT, Node-RED, InfluxDB y Grafana. Todo está desplegado sobre infraestructura Raspberry Pi y corriendo en contenedores Docker.
![Arquufecfura baseline](./img/FumPort_SystemArchutecture.png)

### Sensores 
Se ha partido de los [sensores Airroh](https://github.com/McOrts/taller-iot-sensor_calidad_aire) medioambientales. Aunque sólo se utilizamos la lectura de partículas en suspensión. Estos dispositivos también leen temperatura, humedad y precisión atmosférica. Pero dentro de este proyecto estamos diseñando unos más simples para la detección de partículas de 2,5 nm que son el principal indicador de calidad de aire.

La conectividad se resuelve utilizando una WiFi a su alcance para transmitir las lecturas por UDP tanto a los servidores de Sensor Community como a los de Fum Al Port. 

Por otra parte tenemos información meteorología de una estación situada en el centro del puerto y la posibilidad de utilizar otras micro-estaciones autónomas y conectadas por LoRaWAN.

### Backend 

Una aplicacion Node-RED recoge todos los datos a través de conexiones UDP, llamadas a APIs y colas MQTT. Tanto esta información de observaciones como la predictiva se almacena en una base de basada en series temporales muy utilizada en IoT que es InfluxDB. 

Node-RED además orquesta las llamadas a otros modulos:
- Python para captura de datos de webs.
- Pandas para la analítica de datos.
- 
- Bots de Telegram y Twitter.

### Aplicación de usuario

<img src="./img/node-red_app_menu.png" width="200" align="left" />

Se ha desarrollado una aplicaciónweb a fin de disponer de un Lugar donde a la vez que se informa del proyecto. Se muestran todos la datos recopilados junto con los indices más importantes calculados por los algoritmos.  
Esa aplicación web es accesible desde: [www.fumport.de-a.org](http://fumport.de-a.org/ui) y consta de los siguientes módulos:

#### Información actualizada 
<img src="./img/node-red_app_home.png" width="300" align="right" />


#### Formulario de participación 
<img src="./img/node-red_app_form.png" width="300" align="right" />


## Análisis de datos
### Primera fase
Visualización
Algoritmo de avisos de propagación de contaminación.
### Segunda fase
Análisis de curvas de detección y propagación para distinguir entre:
- Contaminación aislada, posiblemente de origen cercano.
- Nube de contaminante propagándose por la ciudad.

Correlación de factores: atraques, meteorología y contaminación. Para identificar el origen de la contaminación


## Operación
### Avisos y alertas automáticos
### Control desde Telegram


