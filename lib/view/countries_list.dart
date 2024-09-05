import 'package:covid_tracker/Services/stats_services.dart';
import 'package:covid_tracker/view/details_country.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {}); // Update the UI on search input change
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search with country name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: statsServices.countriesListApi(),
                builder: (context, snapshot) {
                  // Check if there's an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                      ), // Show error message
                    );
                  }

                  // Check if the data is still loading
                  if (!snapshot.hasData) {
                    // Show shimmer effect while loading
                    return ListView.builder(
                      itemCount: 4, // Show 4 shimmer items
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 31,
                              color: Colors.white,
                            ),
                            title: Container(
                              width: 89,
                              height: 10.0,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              width: 89,
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  // If we have data, display it in a list
                  return ListView.builder(
                    itemCount: snapshot.data?.length ??
                        0, // Number of items in the list
                    itemBuilder: (context, index) {
                      // Safely get the country data for this list item
                      var countryData = snapshot.data![index];
                      var countryInfo = countryData['countryInfo'];

                      // Safely get the flag URL (it might be null)
                      var flagUrl =
                          countryInfo != null ? countryInfo['flag'] : null;

                      String name = countryData['country'] ?? 'Unknown Country';

                      // Filter the list based on the search input
                      if (searchController.text.isEmpty) {
                        return InkWell(
                          onTap: () {
                           Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsCountryScreen(
      name: name,
      image: flagUrl ?? '', // Default to an empty string if null
      totalCases: countryData['cases'] ?? 0,
      totalDeaths: countryData['deaths'] ?? 0,
      totalRecovered: countryData['recovered'] ?? 0,
      active: countryData['active'] ?? 0,
      critical: countryData['critical'] ?? 0,
      population: countryData['population'] ?? 0,
      tests: countryData['tests'] ?? 0,
      oneCasePerPeople: countryData['oneCasePerPeople'] ?? 0,
      oneDeathPerPeople: countryData['oneDeathPerPeople'] ?? 0,
    ),
  ),
);
                          },
                          child: ListTile(
                            leading: flagUrl != null
                                ? Image.network(
                                    flagUrl,
                                    width: 50,
                                    height: 31,
                                    fit: BoxFit.cover,
                                  ) // Show flag image
                                : const Icon(
                                    Icons.flag,
                                  ), // Fallback icon if no flag URL
                            title: Text(
                              name, // Country name
                            ),
                            subtitle: Text(
                              'Cases: ${countryData['cases'] ?? 'N/A'}', // Number of cases
                            ),
                          ),
                        );
                      } else if (name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return InkWell(
                          onTap: (){
                             Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsCountryScreen(
      name: name,
      image: flagUrl ?? '', // Default to an empty string if null
      totalCases: countryData['cases'] ?? 0,
      totalDeaths: countryData['deaths'] ?? 0,
      totalRecovered: countryData['recovered'] ?? 0,
      active: countryData['active'] ?? 0,
      critical: countryData['critical'] ?? 0,
      population: countryData['population'] ?? 0,
      tests: countryData['tests'] ?? 0,
      oneCasePerPeople: countryData['oneCasePerPeople'] ?? 0,
      oneDeathPerPeople: countryData['oneDeathPerPeople'] ?? 0,
    ),
  ),
);
                          },
                          child: ListTile(
                            leading: flagUrl != null
                                ? Image.network(
                                    flagUrl,
                                    width: 50,
                                    height: 31,
                                    fit: BoxFit.cover,
                                  ) // Show flag image
                                : const Icon(
                                    Icons.flag,
                                  ), // Fallback icon if no flag URL
                            title: Text(
                              name, // Country name
                            ),
                            subtitle: Text(
                              'Cases: ${countryData['cases'] ?? 'N/A'}', // Number of cases
                            ),
                          ),
                        );
                      } else {
                        return Container(); // Return empty container if no match
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
