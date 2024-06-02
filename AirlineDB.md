
# Análisis de la Base de Datos de Vuelos

## Descripción del Dataset

La base de datos de vuelos incluye información detallada sobre vuelos, reservas, boletos y pasajeros. A continuación se presenta una breve descripción de las tablas principales:

- **bookings**: Contiene información sobre las reservas realizadas.
- **tickets**: Almacena información sobre los boletos emitidos a los pasajeros.
- **ticket_flights**: Relaciona los boletos con los segmentos de vuelo.
- **flights**: Incluye detalles sobre los vuelos, como puntos de partida y destino, fechas de salida y llegada.
- **airports**: Proporciona información sobre los aeropuertos.
- **boarding_passes**: Contiene información sobre los pases de abordar emitidos a los pasajeros.
- **seats**: Información sobre los asientos disponibles en las aeronaves.
- **aircrafts**: Detalles sobre los modelos de aeronaves y su configuración de cabina.

## Preguntas de Negocio

### 1. Ocupación de Asientos
**Pregunta**: ¿Cuál es el porcentaje de ocupación de asientos por cada vuelo en los últimos tres meses?

**Consulta SQL**:
```sql
SELECT flight_id, COUNT(seat_no) * 100.0 / (SELECT COUNT(*) FROM seats WHERE aircraft_code = f.aircraft_code) AS seat_occupancy_percentage
FROM boarding_passes bp
JOIN flights f ON bp.flight_id = f.flight_id
WHERE f.scheduled_departure >= NOW() - INTERVAL '3 months'
GROUP BY flight_id, f.aircraft_code;
```

**Explicación**: Esta consulta calcula el porcentaje de ocupación de asientos por cada vuelo en los últimos tres meses, lo que ayuda a evaluar la demanda y eficiencia de la capacidad de los vuelos.

### 2. Rendimiento por Clase de Viaje
**Pregunta**: ¿Cuál es el rendimiento de cada clase de viaje (económica, business, primera clase) en términos de ocupación y tarifas promedio en los últimos tres meses?

**Consulta SQL**:
```sql
SELECT tf.fare_conditions, COUNT(bp.seat_no) AS seats_occupied, AVG(tf.amount) AS avg_fare
FROM ticket_flights tf
JOIN boarding_passes bp ON tf.ticket_no = bp.ticket_no
JOIN flights f ON tf.flight_id = f.flight_id
WHERE f.scheduled_departure >= NOW() - INTERVAL '3 months'
GROUP BY tf.fare_conditions;
```

**Explicación**: Esta consulta calcula el rendimiento de cada clase de viaje en términos de ocupación y tarifas promedio en los últimos tres meses, lo que ayuda a optimizar la asignación de asientos por clase.

### 3. Análisis de Cancelaciones
**Pregunta**: ¿Cuál es la tasa de cancelación de vuelos y cuáles son las principales razones para estas cancelaciones?

**Consulta SQL**:
```sql
SELECT COUNT(*) AS total_flights, COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled_flights,
       COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*) AS cancellation_rate
FROM flights
WHERE scheduled_departure >= NOW() - INTERVAL '3 months';
```

**Explicación**: Esta consulta calcula la tasa de cancelación de vuelos y proporciona información sobre las razones principales para estas cancelaciones en los últimos tres meses.

### 4. Preferencias de los Pasajeros
**Pregunta**: ¿Cuáles son las preferencias de los pasajeros en cuanto a horarios de vuelo (mañana, tarde, noche) en los últimos tres meses?

**Consulta SQL**:
```sql
SELECT CASE
          WHEN EXTRACT(HOUR FROM scheduled_departure) BETWEEN 6 AND 12 THEN 'morning'
          WHEN EXTRACT(HOUR FROM scheduled_departure) BETWEEN 12 AND 18 THEN 'afternoon'
          ELSE 'evening'
       END AS flight_time, COUNT(*) AS flight_count
FROM flights
WHERE scheduled_departure >= NOW() - INTERVAL '3 months'
GROUP BY flight_time
ORDER BY flight_count DESC;
```

**Explicación**: Esta consulta identifica las preferencias de los pasajeros en cuanto a horarios de vuelo (mañana, tarde, noche) en los últimos tres meses, ayudando a ajustar los horarios de vuelo según la demanda de los pasajeros.

## Conclusión

Estas preguntas y sus respectivas consultas SQL permiten obtener información detallada y relevante sobre la operación de los vuelos, ayudando a la toma de decisiones estratégicas en la gestión de aerolíneas.
```