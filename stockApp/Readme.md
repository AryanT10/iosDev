# Stock Management App

This is a Stock Management iOS app that allows users to monitor their stocks in real-time, categorize them as active or watching, and mark their favorite stocks for quick access. The app uses the MS Finance API to fetch real-time stock data.

Features

	•	Real-Time Data: Fetches real-time stock data using the MS Finance API.
	•	Active and Watching Categories: Organize your stocks into two categories: Active (currently monitored) and Watching (passively monitored).
	•	Favorites: Mark important stocks as favorites for quick access while keeping them in their original category.
	•	Drag-and-Drop Functionality: Easily move stocks between categories or add/remove them from the favorites section using drag-and-drop gestures.
	•	Persistent Data: All stocks and their statuses are saved locally, ensuring your data is retained across app sessions.

Installation

	1.	Clone the repository:

git clone https://github.com/yourusername/stock-management-app.git
cd stock-management-app


	2.	Open the project in Xcode:

open StockManagementApp.xcodeproj


	3.	Install dependencies if necessary (e.g., CocoaPods or Swift Package Manager).
	4.	Run the app on a simulator or a connected device.

Usage

	•	Search for Stocks: Use the search bar to find stocks and view their real-time data.
	•	Add to Active/Watching: After searching for a stock, you can add it to the Active or Watching list.
	•	Mark as Favorite: Drag and drop stocks into the Favorites section to mark them as important. Remove from favorites by dragging them out or deleting directly from the Favorites section.
	•	Real-Time Data Refresh: Pull down on the stock list to refresh the data and get the latest stock prices.

API Integration

The app uses the MS Finance API to fetch real-time stock data. You will need an API key from RapidAPI to run the app. The API key should be added to the APIClient class.

Project Structure

	•	APIClient.swift: Handles API requests to fetch stock data.
	•	Stock.swift: Defines the data model for a stock.
	•	StockManager.swift: Manages the storage and retrieval of stock data, including persistence.
	•	SearchViewController.swift: Manages the search functionality and stock list display.
	•	StockViewController.swift: Handles the display and management of Active, Watching, and Favorite stocks, including drag-and-drop operations.
