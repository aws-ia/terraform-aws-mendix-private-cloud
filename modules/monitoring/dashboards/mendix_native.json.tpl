{
  "__inputs": [
    {
      "name": "DS_PROMETHEUS",
      "label": "Prometheus",
      "description": "",
      "type": "datasource",
      "pluginId": "prometheus",
      "pluginName": "Prometheus"
    },
    {
      "name": "DS_LOKI",
      "label": "Loki",
      "description": "",
      "type": "datasource",
      "pluginId": "loki",
      "pluginName": "Loki"
    }
  ],
  "__elements": [],
  "__requires": [
    {
      "type": "grafana",
      "id": "grafana",
      "name": "Grafana",
      "version": "8.3.5"
    },
    {
      "type": "panel",
      "id": "logs",
      "name": "Logs",
      "version": ""
    },
    {
      "type": "datasource",
      "id": "loki",
      "name": "Loki",
      "version": "1.0.0"
    },
    {
      "type": "datasource",
      "id": "prometheus",
      "name": "Prometheus",
      "version": "1.0.0"
    },
    {
      "type": "panel",
      "id": "timeseries",
      "name": "Time series",
      "version": ""
    }
  ],
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": null,
  "iteration": 1661503138455,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 23,
      "panels": [],
      "title": "App statistics",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 1
      },
      "id": 4,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_handler_requests_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",name!=\"\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "{{name}}",
          "refId": "Requests by path"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_handler_requests_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",name=\"\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "/",
          "refId": "Requests"
        }
      ],
      "title": "Request statistics",
      "transformations": [],
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 1
      },
      "id": 6,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "mx_runtime_stats_sessions_named_user_sessions{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "named sessions",
          "queryType": "randomWalk",
          "refId": "Named user sessions"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "mx_runtime_stats_sessions_anonymous_sessions{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "anonymous sessions",
          "refId": "Anonymous user sessions"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "mx_runtime_stats_sessions_named_users{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "named users",
          "refId": "Named users"
        }
      ],
      "title": "User accounts and login sessions",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "ops"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 9
      },
      "id": 15,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_connectionbus_inserts_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"})[5m:])",
          "interval": "",
          "legendFormat": "inserts",
          "queryType": "randomWalk",
          "refId": "Inserts"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_connectionbus_transactions_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "transactions",
          "queryType": "randomWalk",
          "refId": "Transactions"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_connectionbus_updates_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "updates",
          "queryType": "randomWalk",
          "refId": "Updates"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_connectionbus_selects_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "selects",
          "queryType": "randomWalk",
          "refId": "Selects"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "irate(sum without (XASId) (mx_runtime_stats_connectionbus_deletes_total{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"})[5m:])",
          "hide": false,
          "interval": "",
          "legendFormat": "deletes",
          "queryType": "randomWalk",
          "refId": "Deletes"
        }
      ],
      "title": "Number of database queries being executed",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 17
      },
      "id": 27,
      "panels": [],
      "title": "Resource usage",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 18
      },
      "id": 12,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "rate(sum without (id, name) (container_cpu_usage_seconds_total{namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\"})[5m:])",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "use",
          "queryType": "randomWalk",
          "refId": "CPU usage seconds"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "kube_pod_container_resource_requests{exported_namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\",resource=\"cpu\",unit=\"core\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "requests",
          "refId": "CPU requests"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "Prometheus"
          },
          "exemplar": true,
          "expr": "kube_pod_container_resource_limits{exported_namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\",resource=\"cpu\",unit=\"core\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "limits",
          "refId": "CPU limits"
        }
      ],
      "title": "Container CPU usage",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "binBps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 26
      },
      "id": 17,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "irate(container_network_transmit_bytes_total{namespace=~\"$namespace\",pod=~\"$pod_name\"}[5m])",
          "instant": false,
          "interval": "",
          "legendFormat": "out container",
          "queryType": "randomWalk",
          "refId": "Container network out"
        },
        {
          "exemplar": true,
          "expr": "irate(container_network_receive_bytes_total{namespace=~\"$namespace\",pod=~\"$pod_name\"}[5m])",
          "hide": false,
          "interval": "",
          "legendFormat": "in container",
          "refId": "Container network in"
        },
        {
          "exemplar": true,
          "expr": "irate(jetty_connections_bytes_in_bytes_sum{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}[5m])",
          "hide": false,
          "interval": "",
          "legendFormat": "in jetty",
          "refId": "Jetty in"
        },
        {
          "exemplar": true,
          "expr": "irate(jetty_connections_bytes_out_bytes_sum{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}[5m])",
          "hide": false,
          "interval": "",
          "legendFormat": "out jetty",
          "refId": "Jetty out"
        }
      ],
      "title": "Network ",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Memory limit"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "A",
                  "mode": "none"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Memory usage"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "A",
                  "mode": "none"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "JVM memory pool (except eden space)"
            },
            "properties": [
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "JVM memory pool (eden space)"
            },
            "properties": [
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Unused heap"
            },
            "properties": [
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Unused nonheap"
            },
            "properties": [
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 26
      },
      "id": 2,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",id!~\"G1 Eden Space|Eden Space\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{id}}",
          "queryType": "randomWalk",
          "refId": "JVM memory pool (except eden space)"
        },
        {
          "exemplar": true,
          "expr": "sum(jvm_memory_committed_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\"})-sum(jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "unused heap",
          "queryType": "randomWalk",
          "refId": "Unused heap"
        },
        {
          "exemplar": true,
          "expr": "sum(jvm_memory_committed_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"nonheap\"})-sum(jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"nonheap\"})",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "unused nonheap",
          "queryType": "randomWalk",
          "refId": "Unused nonheap"
        },
        {
          "exemplar": true,
          "expr": "kube_pod_container_resource_limits{exported_namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\",resource=\"memory\",unit=\"byte\"}",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "max memory",
          "refId": "Memory limit"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",id=~\"G1 Eden Space|Eden Space\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "Eden Space",
          "queryType": "randomWalk",
          "refId": "JVM memory pool (eden space)"
        },
        {
          "exemplar": true,
          "expr": "max without (id, name) (container_memory_usage_bytes{namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\"}) ",
          "hide": false,
          "interval": "",
          "legendFormat": "used memory",
          "refId": "Memory usage"
        }
      ],
      "title": "JVM process memory usage",
      "transformations": [],
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 35
      },
      "id": 10,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "max without (id, name) (container_threads{namespace=~\"$namespace\",pod=~\"$pod_name\",container=\"mendix\"})\r",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "container",
          "queryType": "randomWalk",
          "refId": "Total number of threads"
        },
        {
          "exemplar": true,
          "expr": "jvm_threads_live_threads{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "live",
          "refId": "JVM live threads"
        },
        {
          "exemplar": true,
          "expr": "jvm_threads_daemon_threads{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "daemon",
          "refId": "JVM daemon threads"
        }
      ],
      "title": "Total number of threads",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 35
      },
      "id": 8,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "jetty_threads_config_max{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "max",
          "queryType": "randomWalk",
          "refId": "Max"
        },
        {
          "exemplar": true,
          "expr": "jetty_threads_config_min{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "min",
          "refId": "Min"
        },
        {
          "exemplar": true,
          "expr": "jetty_threads_current{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "current",
          "refId": "Current"
        },
        {
          "exemplar": true,
          "expr": "jetty_threads_idle{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "idle",
          "refId": "Idle"
        },
        {
          "exemplar": true,
          "expr": "jetty_threads_busy{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "busy",
          "refId": "Busy"
        },
        {
          "exemplar": true,
          "expr": "jetty_threads_jobs{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "jobs",
          "refId": "Jobs"
        }
      ],
      "title": "Threadpool for handling external requests",
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 43
      },
      "id": 25,
      "panels": [],
      "title": "JVM",
      "type": "row"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "normal"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Committed nonheap"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "committed",
                  "mode": "normal"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Used nonheap"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "used",
                  "mode": "normal"
                }
              },
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 44
      },
      "id": 29,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"nonheap\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "used {{id}}",
          "refId": "Used nonheap"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_committed_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"nonheap\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "committed {{id}}",
          "refId": "Committed nonheap"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_max_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"nonheap\"}",
          "hide": true,
          "interval": "",
          "legendFormat": "max {{id}}",
          "refId": "Max nonheap"
        }
      ],
      "title": "JVM nonheap contents",
      "transformations": [],
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "Prometheus"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "JVM memory (except eden space)"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "used",
                  "mode": "normal"
                }
              },
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Eden space"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "used",
                  "mode": "normal"
                }
              },
              {
                "id": "custom.drawStyle",
                "value": "bars"
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Committed heap"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "committed",
                  "mode": "normal"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byFrameRefID",
              "options": "Max heap"
            },
            "properties": [
              {
                "id": "custom.stacking",
                "value": {
                  "group": "max",
                  "mode": "normal"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 44
      },
      "id": 28,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom"
        },
        "tooltip": {
          "mode": "multi"
        }
      },
      "pluginVersion": "8.1.6",
      "targets": [
        {
          "exemplar": true,
          "expr": "jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\",id!~\"G1 Eden Space|Eden Space\"}",
          "format": "time_series",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "{{id}}",
          "queryType": "randomWalk",
          "refId": "JVM memory (except eden space)"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_used_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\",id=~\"G1 Eden Space|Eden Space\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "Eden Space",
          "refId": "Eden space"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_committed_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "committed {{id}}",
          "refId": "Committed heap"
        },
        {
          "exemplar": true,
          "expr": "jvm_memory_max_bytes{namespace=~\"$namespace\",privatecloud_mendix_com_app=\"$environment_id\",pod=~\"$pod_name\",area=\"heap\"}",
          "hide": false,
          "interval": "",
          "legendFormat": "max {{id}}",
          "refId": "Max heap"
        }
      ],
      "title": "JVM heap contents",
      "transformations": [],
      "type": "timeseries"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 53
      },
      "id": 31,
      "panels": [],
      "title": "Logs",
      "type": "row"
    },
    {
      "datasource": {
        "type": "cloudwatch",
        "uid": "cloudwatch"
      },
      "gridPos": {
        "h": 13,
        "w": 24,
        "x": 0,
        "y": 54
      },
      "id": 33,
      "options": {
        "dedupStrategy": "none",
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": false,
        "sortOrder": "Ascending",
        "wrapLogMessage": false
      },
      "pluginVersion": "7.5.0",
      "targets": [
        {
          "datasource": {
            "type": "cloudwatch",
            "uid": "cloudwatch"
          },
          "expression": "fields @timestamp, @message |\n filter kubernetes.namespace_name = '$namespace' and kubernetes.pod_name = '$pod_name' |\n sort @timestamp desc",
          "logGroups": [
            {
              "accountId": "${awsAccountId}",
              "arn": "${awsLogGroupARN}:*",
              "name": "${awsLogGroupName}"
            }
          ],
          "hide": false,
          "instant": false,
          "queryMode": "Logs",
          "region": "default",
          "range": true,
          "refId": "Mendix Runtime logs"
        }
      ],
      "title": "Runtime logs",
      "type": "logs"
    }
  ],
  "refresh": false,
  "schemaVersion": 34,
  "style": "dark",
  "tags": [
    "prometheus"
  ],
  "templating": {
    "list": [
      {
        "current": {},
        "datasource": {
          "type": "prometheus",
          "uid": "Prometheus"
        },
        "definition": "label_values({privatecloud_mendix_com_component=\"mendix-app\"},namespace)",
        "hide": 0,
        "includeAll": false,
        "label": "Namespace",
        "multi": false,
        "name": "namespace",
        "options": [],
        "query": {
          "query": "label_values({privatecloud_mendix_com_component=\"mendix-app\"},namespace)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {},
        "datasource": {
          "type": "prometheus",
          "uid": "Prometheus"
        },
        "definition": "label_values({namespace=~\"$namespace\"},privatecloud_mendix_com_app)",
        "hide": 0,
        "includeAll": false,
        "label": "Environment internal name",
        "multi": false,
        "name": "environment_id",
        "options": [],
        "query": {
          "query": "label_values({namespace=~\"$namespace\"},privatecloud_mendix_com_app)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {},
        "datasource": {
          "type": "prometheus",
          "uid": "Prometheus"
        },
        "definition": "label_values({namespace=~\"$namespace\",privatecloud_mendix_com_app=~\"$environment_id\"}, pod)",
        "hide": 0,
        "includeAll": false,
        "label": "Pod name",
        "multi": false,
        "name": "pod_name",
        "options": [],
        "query": {
          "query": "label_values({namespace=~\"$namespace\",privatecloud_mendix_com_app=~\"$environment_id\"}, pod)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      }
    ]
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Mendix app dashboard (native)",
  "uid": "vDZHQgA7k",
  "version": 7,
  "weekStart": ""
}