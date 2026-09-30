Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A3651477A;
	Wed, 30 Sep 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786446; cv=none; b=Wq50hATWv3grK+lXsfBhAmP4Rdlv389MgvRqwXHLbrZOljzUDATRU01eo4e0NKspA8kfx3pglLdvU1Y4GoCXdYHQmciQ8JwoDmRr0XdodnCANuHPc5OgT1odofcdOZ23vf/3+vW/++xg9NDbaH9TRpGJ4zYGZWYWxrzkSu1b1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786446; c=relaxed/simple;
	bh=OoDGOU01nXKhbcgQEmWD0SMt0r8ozqktgkzi2c1x0wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXNVh1FdmH9MQZ1tFQxv7InQib5RGqbJ1IPthUxCroYNhJkd8Qv9UNGN7WfvJcahDQjV15k+u4JQj6GWBIZt934OGUMJTLqgf+L3EwQkmj240HN2ISKw2oXh2kTDL04OEswGKRSZ0hhmSk9vUrrEiUUOlpl4CCVxzghLQGEo89Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVoFdQDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVoFdQDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0271F00898;
	Wed, 30 Sep 2026 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786444;
	bh=imCXX53+B5KXGIzjQZWxJ0dvodK57H2pjAaoTOWaFBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVoFdQDUSXTeWydiyogNn9QSuwyILMsXbreqKuRvpi04NCXebtqcrjOE5+T3s9Gyi
	 KfuOMOhClP8g50OJ5MXwV6Orp6WnVQzrJ0s3FZnnW3r0rfC18kQ7AbBC7T+23iY2tc
	 PnZ7vjTg3Nn2fzS/ky4Xc6aNs+OxbQQm1XCwOtXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 863/982] net/mlx5: Bridge, move additional data structures to priv header
Date: Wed, 30 Sep 2026 17:26:39 +0200
Message-ID: <20260930152435.285794691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 6767c97d7adc3c4283c0167a9716de3953f251b1 ]

Following patches in series will require accessing flow tables and groups
sizes, table levels and struct mlx5_esw_bridge from new the new source file
dedicated to multicast code. Expose these data in bridge_priv.h to reduce
clutter in following patches that will implement the actual functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 35e6f970f553 ("net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 85 -------------------
 .../mellanox/mlx5/core/esw/bridge_priv.h      | 85 +++++++++++++++++++
 2 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 6cd7c5817922c..f1752852c70f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -13,66 +13,6 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM	\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM +	\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
-
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM		\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
-	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO	\
-	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
-	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
-
-#define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
-
-enum {
-	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
-	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
-	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
-};
-
 static const struct rhashtable_params fdb_ht_params = {
 	.key_offset = offsetof(struct mlx5_esw_bridge_fdb_entry, key),
 	.key_len = sizeof(struct mlx5_esw_bridge_fdb_key),
@@ -80,31 +20,6 @@ static const struct rhashtable_params fdb_ht_params = {
 	.automatic_shrinking = true,
 };
 
-enum {
-	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
-};
-
-struct mlx5_esw_bridge {
-	int ifindex;
-	int refcnt;
-	struct list_head list;
-	struct mlx5_esw_bridge_offloads *br_offloads;
-
-	struct list_head fdb_list;
-	struct rhashtable fdb_ht;
-
-	struct mlx5_flow_table *egress_ft;
-	struct mlx5_flow_group *egress_vlan_fg;
-	struct mlx5_flow_group *egress_qinq_fg;
-	struct mlx5_flow_group *egress_mac_fg;
-	struct mlx5_flow_group *egress_miss_fg;
-	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
-	struct mlx5_flow_handle *egress_miss_handle;
-	unsigned long ageing_time;
-	u32 flags;
-	u16 vlan_proto;
-};
-
 static void
 mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *addr, u16 vid,
 				   unsigned long val)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index 878311fe950a4..b99761e73c1b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -12,6 +12,70 @@
 #include <linux/xarray.h>
 #include "fs_core.h"
 
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM +	\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM	\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_FROM +	\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_QINQ_FILTER_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
+
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM		\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_QINQ_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO	\
+	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
+static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
+
+#define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
+
+enum {
+	MLX5_ESW_BRIDGE_LEVEL_INGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_EGRESS_TABLE,
+	MLX5_ESW_BRIDGE_LEVEL_SKIP_TABLE,
+};
+
+enum {
+	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
+};
+
 struct mlx5_esw_bridge_fdb_key {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
@@ -60,4 +124,25 @@ struct mlx5_esw_bridge_port {
 	struct xarray vlans;
 };
 
+struct mlx5_esw_bridge {
+	int ifindex;
+	int refcnt;
+	struct list_head list;
+	struct mlx5_esw_bridge_offloads *br_offloads;
+
+	struct list_head fdb_list;
+	struct rhashtable fdb_ht;
+
+	struct mlx5_flow_table *egress_ft;
+	struct mlx5_flow_group *egress_vlan_fg;
+	struct mlx5_flow_group *egress_qinq_fg;
+	struct mlx5_flow_group *egress_mac_fg;
+	struct mlx5_flow_group *egress_miss_fg;
+	struct mlx5_pkt_reformat *egress_miss_pkt_reformat;
+	struct mlx5_flow_handle *egress_miss_handle;
+	unsigned long ageing_time;
+	u32 flags;
+	u16 vlan_proto;
+};
+
 #endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
-- 
2.53.0



