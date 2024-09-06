# ![Ruby Version](https://img.shields.io/badge/Ruby-2.7.8-red.svg) ![Rails Version](https://img.shields.io/badge/Rails-7.1.4-orange.svg) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![Postman](https://img.shields.io/static/v1?style=for-the-badge&message=Postman&color=FF6C37&logo=Postman&logoColor=FFFFFF&label=)

# Transport System API

This project is a RESTful API for an interplanetary transport system. It allows the creation of pilots, ships, transport contracts, fuel refueling, and the generation of reports on resource movements between planets.

## Main Features:

### Management of Pilots and Ships
- **Pilot Creation**: Allows creating pilots with their respective attributes, such as name and associated ship.
- **Ship Creation**: Each pilot has a ship that can carry resources and travel between planets.

### Management of Transport Contracts
- **Contract Creation**: Creates a new transport contract between two planets, defining the resource to be transported.
- **Accept and Complete Contracts**: Pilots can accept contracts and, upon completing the journey, receive payment.

### Travels and Refueling
- **Travel between Planets**: The pilot can travel from one planet to another, consuming fuel.
- **Fuel Refueling**: The pilot can refuel the ship on any planet, with each unit of fuel costing 7 credits.

### Reports
- **Resource Report**: Generates a detailed report of all resources transported between planets, showing the total weight sent and received by each planet.

## Requirements

Make sure to have the following dependencies installed:

- Ruby 2.7.8
- Ruby on Rails 7.1.4
- PostgreSQL
- Postman

## Installation

1. Clone this repository to your local environment:

    ```bash
    git clone git@github.com:laurameireles23/intergalactic_freight_fleet.git
    cd transport_system_api
    ```

2. Install the required gems:

    ```bash
    bundle install
    ```

3. Create the database and run the migrations:

    ```bash
    rails db:create db:migrate
    ```

4. Start the Rails server:

    ```bash
    rails server
    ```

## Travels
Travel between planets has different distances and durations, reflecting on fuel consumption for each route. The table below shows these fuel costs.

|         	|         	|    To   	|      	|       	|
|---------	|:--------:	|:--------:	|:----:	|:------:	|
| From    	| Andvari 	| Demeter 	| Aqua 	| Calas 	|
| Andvari 	|    -    	|    X    	|  13  	|   23  	|
| Demeter 	|    X    	|    -    	|  22  	|   25  	|
| Aqua    	|    X    	|    30   	|   -  	|   12  	|
| Calas   	|    20   	|    25   	|  15  	|   -   	|

This table shows the X means the route between those planets is blocked by problems like an asteroid belt or a scrapyard.

## Usage

### Via Postman

1. **Pilot and Ship Creation**:
   - Use the endpoint to create a pilot with an associated ship.

2. **Resource Creation**:
   - Create a resource by specifying its name and weight.
   - Note: Only "minerals", "water", or "food" are accepted.

3. **Contract Creation**:
   - Create a transport contract specifying the origin planet, destination planet, and the resource.

4. **Accept Contract**:
   - Use the endpoint for the pilot to accept the contract, verifying if they can travel between the planets.
   - After arriving at the destination planet, the contract will be completed, and the pilot will receive the credits.

5. **Fuel Refueling**:
   - Refuel the pilot's ship when necessary on any planet.

6. **Resource Report**:
   - Generate a detailed report showing the total weight of resources sent and received by each planet.

### Tests

To run unit and integration tests, use the following command:

```bash
bundle exec rspec
```

## Endpoints

List of the main endpoints for easier use of the API:

- **POST /pilots** - Creates a new pilot and a ship.
- **POST /pilots/:id/travel** - The pilot can travel to another planet (considering the ship’s limitations and blocked routes).
- **POST /resources** - Creates a new resource.
- **POST /contracts** - Creates a new transport contract.
- **POST /contracts/:id/accept_and_pay** - Accepts a contract and pays the pilot after completion.
- **POST /ships/:id/refuel** - Refuels the pilot's ship on any planet.
- **GET /contracts/report** - Generates a report of resource transportation between planets.

## Usage

For convenience, here is a link to the collection containing the endpoints mentioned above. After following the installation steps, open the Postman desktop app and import the collection provided below.

Download the [collection here](https://drive.google.com/drive/folders/1CQ8yzGZMYG1dVWTM4oDZdYzFZ4vXYJ86?usp=sharing).

## License

This project is licensed under the terms of the MIT license.
