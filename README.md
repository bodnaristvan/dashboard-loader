# Dashboard loader
This simple bash script generates an empty html file, that only contains a fullscreen iframe. The file is stored on the local filesystem, so even if the network is down, it'll be able to load itself, and catch up by reloading its content every _29_ minutes.

## Setting up the loaded dashboards
The embedded iframes src is set via javascript, it fetches the value from a config in a central repository (github at the moment). Since the file is on the filesystem, and the config can be anywhere, it uses JSONP to avoid cross-domain issues.

The config files format is the following:

```javascript
config(
	{
		"configname": [
			"http://yourdashboard.com/charts.php?dashboard=frontend",
			"http://yourdashboard.com/charts.php?dashboard=backend"
		],
		"otherconfig": ["http://yourdashboard.com/charts.php?dashboard=registrations"]
	}
);

```

## Running the loader generator script

```bash
curl -s https://raw.githubusercontent.com/bodnaristvan/dashboard-loader/master/create-dashboards.sh > /tmp/create-dashboards.sh ; bash /tmp/create-dashboards.sh
```

The script checks the number of displays connected to the computer it runs on, and generates loader frame files for each in the format of `dashboard-screen%n.html`, where `%n` is the index of the screen (starting with 1). It also asks for a specific configuration name that it'll use from the config file, it defaults to the local computers hostname if none specified.