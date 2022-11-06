# <img src="./img/FumPort_logo.png" width="50"/> Fum al Port

**La calidad del aire que respiramos tiene un impacto directo en nuestra salud**. No respirar un aire limpio causa una variedad de problemas de salud, incluidas infecciones respiratorias, dolores de cabeza y fatiga. También puede agravar condiciones existentes como el asma y las alergias.

Los focos de contaminación varian a lo largo de la historia de una ciudad, industria, tráfico rodado o tráfico marítimo que es el caso de estudio de este proyecto ya que puede suponer un impacto significativo en la calidad del aire. 

El monitoreo ambiental en ciudades se refiere a las prácticas de seguridad y privacidad utilizadas para proteger a los ciudadanos de los contaminantes transportados por el aire. Esto incluye la recopilación de datos sobre la calidad del aire, la temperatura, la humedad y otros factores ambientales. Estos datos luego se utilizan para evaluar el riesgo de exposición a materiales peligrosos y tomar medidas para mitigar o eliminar esos riesgos.

## Nuestra solución

Para abordar este desafío, se desarrolló un proyecto de ciencia ciudadana. Que parte de [talleres de fabricación de sensores de calidad de aire](https://www.meetup.com/makespace-mallorca/events/282643149?utm_medium=referral&utm_campaign=share-btn_savedevents_share_modal&utm_source=link) que se son posteriormente desplegados y construidos por los ciudadanos. Esto forma una red de monitoreo ambiental basado en [sensores SDS011](http://www.aliexpress.com/wholesale?groupsort=1&SortType=price_asc&SearchText=sds011) que monitorean el ambiente exterior y envían los datos recopilados a una solución en la nube donde se pueden realizar más cálculos. Con el fin de:

- Emitir alertas para informar a la ciudania de riesgos a la salud en tiempo real.
- Hacer un análisis predictivo para dar avisos de contaminación.
- Tratar de identificar los focos de la contaminación.

En un primer enfoque, **la solución gira en torno a la actividad en el puerto de Palma de Mallorca**. De manera que se está recopilando y tratando solo la información de este entorno. Detrás de esta iniciativa está el proyecto de la plataforma abierta [Sensor Community](https://sensor.community/es/) de [Open Data Stuttgart](https://github.com/opendata-stuttgart/) que soporta parte de la infraestructura.

## Arquitectura de solución
Este proyecto cumple con modelos y estándadres utilizados en soluciones de **Smart City**. Y se ha diseñado una arquitectura basada en uno de los más utilizados ´stacks´ de IoT: MQTT, Node-RED, InfluxDB y Grafana. Todo está desplegado sobre infraestructura Raspberry Pi y corriendo en contenedores Docker.





La v1 de la aplicación web es accesible desde: http://fumport.de-a.org/ui y espero que sirva para mostrar todo lo que estamos desarrollando por detrás.


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


