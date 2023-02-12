# LatencyAgent
Latency Agent Guidelines:
1. Run the LatencyAgent.sh on your system/VM
2. After initialization, visit you server in http://localhost:3003.
3. Default username and password is admin.
4. Now we want to integrate InfluxDB as a data source in Grafana. On the left menu, under Configuration button, click Data sources.
5. In the opened configuration console, choose Add data source, then choose InfluxDB.
6. In the data source setting page, under HTTP section URL field, enter influxDB url: http://localhost:8086.
7. In Auth section, turn on the Basic auth toggle, and enter the InflucDB username (admin) and password (12345678) in the appropriate fields below.
8. In InfluxDB Details section, under Database enter your db name: hosts_metrics.
9. Finally, click Save & Test, and make sure you get the Data source is working message.
10. Click Explore
11. In the exploration panel, build a graph of the test results over time. Your graph should look similar to the bellow screenshot.
12. availabilityMonitor
13. ![image](https://user-images.githubusercontent.com/122601317/218315096-c1bf328a-909d-4ddf-a36e-dcf5ad4cc302.png)
14. Well Done!
