resource "aws_cloudwatch_metric_alarm" "ecs_service_cpu_utilization" {
  alarm_name                = "${var.service_name}-${var.environment} CPU Utilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = each.value.period
  statistic                 = "Average"
  threshold                 = each.value.threshold
  alarm_description         = "This alarm is used to detect high CPU utilization for the ECS service. Consistent high CPU utilization can indicate a resource bottleneck or application performance problems."
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.service_name
  }
}


resource "aws_cloudwatch_metric_alarm" "ecs_service_memory_utilization" {
  alarm_name                = "${var.service_name}-${var.environment} Memory Utilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = each.value.period
  statistic                 = "Average"
  threshold                 = each.value.threshold
  alarm_description         = "This alarm is used to detect high Memory utilization for the ECS service. Consistent high Memory utilization can indicate a resource bottleneck or application performance problems."
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.service_name
  }
}



resource "aws_cloudwatch_metric_alarm" "ecs_target_response_time" {
  alarm_name                = "${var.service_name}-${var.environment} Target Response Time"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = "TargetResponseTime"
  namespace                 = "AWS/ECS"
  period                    = each.value.period
  statistic                 = "Average"
  threshold                 = each.value.threshold
  alarm_description         = "This alarm helps you detect a high target response time for ECS service requests. This can indicate that there are problems that cause the service to be unable to serve requests in time."
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.service_name
  }
}


resource "aws_cloudwatch_metric_alarm" "ecs_service_error_rate" {
  alarm_name                = "${var.service_name}-${var.environment} Error Rate"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = each.value.evaluation_periods
  threshold                 = each.value.threshold
  alarm_description         = "This alarm helps you detect a high server-side error count for the ECS service. This can indicate that there are errors that cause the server to be unable to serve requests."
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ECS"
      period      = each.value.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.service_name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ECS"
      period      = each.value.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.service_name
      }
    }
  }

}

resource "aws_cloudwatch_metric_alarm" "alb_alarm" {
  alarm_name                = "${aws_lb.alb.name}-${var.environment}-error-rate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = each.value.evaluation_periods
  threshold                 = each.value.percentage
  alarm_description         = "Request error rate has exceeded ${each.value.percentage}%"
  insufficient_data_actions = []
  treat_missing_data        = "notBreaching"

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = each.value.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_lb.alb.name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = each.value.period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_lb.alb.name
      }
    }
  }
}
