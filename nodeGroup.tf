# Provision Node Group and attaches this to the EKS
resource "aws_eks_node_group" "node {
    depends_on = [aws_eks_addon.vpc_cni] # CNI has to be enables on the cluster first

    for_each = var.node_group

    cluster_name = aws_eks_cluster.main.name
    node_group_name = each.key

    node_role_arn  = aws_iam_role.node.arn
    subnet_ids = var.subnet_ids
    instance_types = each.value["instance_type"]
    capacity_type = each.value["capacity_type"]

    scaling_config {
        desired_size = each.value["node_min_size"] # when the cluster was provisioned this would be nodegroup node count
        max_size = each.value["node_max_size"]    # max number of node that the node-group can scale
        min_size = each.value["node_min_size"]    #When the workloads are really less, his would be the number where nodeGroup
    }

    tags = {
        Environment = "Test"
        project     = "expense"

    }
}"

 