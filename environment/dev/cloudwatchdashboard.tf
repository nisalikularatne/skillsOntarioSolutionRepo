resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "metrics-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
        {
            "height": 6,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/rds/instance/skills-dev-db/slowquery' | #fields  @message\n parse  @message \"# Time: * User@Host: * Id: * Query_time: * Lock_time: * Rows_sent: * Rows_examined: * timestamp=*;*\" \n as Time, User, Id, Query_time,Lock_time,Rows_sent,Rows_examined,timestamp,query\n | sort Time asc\n \n",
                "region": "us-east-1",
                "title": "Slow queries with detailed info",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 6,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/rds/instance/skills-dev-db/slowquery' | parse  @message \"# Time: * User@Host: * Id: * Query_time: * Lock_time: * Rows_sent: * Rows_examined: * timestamp=*;*\" \nas Time, User, Id, Query_time,Lock_time,Rows_sent,Rows_examined,timestamp,Query \n| display Time, Query_time, Query\n| sort Query_time desc\n \n\n",
                "region": "us-east-1",
                "title": "Top Slow Queries sorted by Query Time",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 18,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "ConnectionAttempts", "DBInstanceIdentifier", "skills-dev-db", { "visible": false } ],
                    [ ".", "RowLockTime", ".", "." ],
                    [ ".", "DMLLatency", ".", "." ],
                    [ ".", "InsertLatency", ".", "." ],
                    [ ".", "InsertThroughput", ".", ".", { "visible": false } ],
                    [ ".", "Deadlocks", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "us-east-1",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "height": 9,
            "width": 24,
            "y": 24,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "ConnectionAttempts", "DBInstanceIdentifier", "skills-dev-db", { "visible": false } ],
                    [ ".", "DatabaseConnections", ".", ".", { "stat": "Maximum" } ],
                    [ ".", "AbortedClients", ".", ".", { "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "us-east-1",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 33,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "skills-dev-db" ]
                ],
                "region": "us-east-1",
                "title": "DB CPUUtilization",
                "period": 60
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 39,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "metrics": [
                    [ "AWS/RDS", "DMLThroughput", "DBInstancceIdentifier", "skills-dev-db" ],
                    [ ".", "DeleteThroughput", ".", "." ],
                    [ ".", "InsertThroughput", ".", "." ],
                    [ ".", "UpdateThroughput", ".", "." ],
                    [ ".", "SelectThroughput", ".", "." ],
                    [ ".", "CommitThroughput", ".", "." ]
                ],
                "region": "us-east-1",
                "title": "DB workLoad - CommitThroughput, DMLThroughput, DeleteThroughput, InsertThroughput, SelectThroughput, UpdateThroughput"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 12,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/rds/instance/skills-dev-db/error' | fields @message\n| sort @timestamp desc\n| limit 200",
                "region": "us-east-1",
                "title": "Top 200 lines of Error Log",
                "view": "table"
            }
        },
        {
            "height": 9,
            "width": 24,
            "y": 45,
            "x": 0,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-0e8d66ed4385b0ec2", { "stat": "Average", "id": "m1", "visible": false } ],
                    [ { "id": "e1", "expression": "AVG([m1])", "label": "us-east-1c", "region": "us-east-1" } ],
                    [ "ECS/ContainerInsights", "ContainerInstanceCount", "ClusterName", "skills-dev-cluster", { "id": "m2" } ],
                    [ ".", "ServiceCount", ".", ".", { "id": "m3" } ],
                    [ ".", "TaskCount", ".", ".", { "id": "m4" } ],
                    [ ".", "CpuUtilized", ".", ".", { "id": "m5" } ],
                    [ ".", "StorageWriteBytes", ".", ".", { "id": "m6" } ],
                    [ ".", "MemoryReserved", ".", ".", { "id": "m7" } ],
                    [ ".", "CpuReserved", ".", ".", { "id": "m8" } ],
                    [ ".", "EphemeralStorageUtilized", ".", ".", { "id": "m9" } ],
                    [ ".", "NetworkTxBytes", ".", ".", { "id": "m10" } ],
                    [ ".", "EphemeralStorageReserved", ".", ".", { "id": "m11" } ],
                    [ ".", "MemoryUtilized", ".", ".", { "id": "m12" } ],
                    [ ".", "StorageReadBytes", ".", ".", { "id": "m13" } ],
                    [ ".", "NetworkRxBytes", ".", ".", { "id": "m14" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "period": 300,
                "view": "singleValue",
                "stacked": true,
                "start": "-PT3H",
                "end": "P0D",
                "title": "ECS Cluster Metrics",
                "region": "us-east-1"
            }
        },
        {
            "height": 24,
            "width": 24,
            "y": 54,
            "x": 0,
            "type": "metric",
            "properties": {
                "view": "gauge",
                "metrics": [
                    [ "ECS/ContainerInsights", "EphemeralStorageUtilized", "ServiceName", "skills-dev-service-blue", "ClusterName", "skills-dev-cluster" ],
                    [ ".", "NetworkTxBytes", ".", ".", ".", "." ],
                    [ ".", "EphemeralStorageReserved", ".", ".", ".", "." ],
                    [ ".", "StorageReadBytes", ".", ".", ".", "." ],
                    [ ".", "MemoryUtilized", ".", ".", ".", "." ],
                    [ ".", "NetworkRxBytes", ".", ".", ".", "." ],
                    [ ".", "RunningTaskCount", ".", ".", ".", "." ],
                    [ ".", "PendingTaskCount", ".", ".", ".", "." ],
                    [ ".", "MemoryReserved", ".", ".", ".", "." ],
                    [ ".", "StorageWriteBytes", ".", ".", ".", "." ],
                    [ ".", "CpuUtilized", ".", ".", ".", "." ],
                    [ ".", "DeploymentCount", ".", ".", ".", "." ],
                    [ ".", "DesiredTaskCount", ".", ".", ".", "." ],
                    [ ".", "TaskSetCount", ".", ".", ".", "." ]
                ],
                "region": "us-east-1",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 2000
                    }
                },
                "title": "Blue Service ECS cluster"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 78,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-0e8d66ed4385b0ec2", { "stat": "Average", "id": "m1", "visible": false } ],
                    [ { "id": "e1", "expression": "AVG([m1])", "label": "us-east-1c", "region": "us-east-1" } ],
                    [ "ECS/ContainerInsights", "CpuReserved", "TaskDefinitionFamily", "skills-dev-task-blue", "ClusterName", "skills-dev-cluster", { "id": "m2" } ],
                    [ ".", "EphemeralStorageUtilized", ".", ".", ".", ".", { "id": "m3" } ],
                    [ ".", "NetworkTxBytes", ".", ".", ".", ".", { "id": "m4" } ],
                    [ ".", "EphemeralStorageReserved", ".", ".", ".", ".", { "id": "m5" } ],
                    [ ".", "MemoryUtilized", ".", ".", ".", ".", { "id": "m6" } ],
                    [ ".", "StorageReadBytes", ".", ".", ".", ".", { "id": "m7" } ],
                    [ ".", "NetworkRxBytes", ".", ".", ".", ".", { "id": "m8" } ],
                    [ ".", "CpuUtilized", ".", ".", ".", ".", { "id": "m9" } ],
                    [ ".", "StorageWriteBytes", ".", ".", ".", ".", { "id": "m10" } ],
                    [ ".", "MemoryReserved", ".", ".", ".", ".", { "id": "m12" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "period": 300,
                "view": "bar",
                "stacked": false,
                "start": "-PT3H",
                "end": "P0D",
                "title": "ECS Cluster blue task definition metrics",
                "region": "us-east-1"
            }
        }
    ]
}
EOF
}
