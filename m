Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8479F51477A;
	Wed, 30 Sep 2026 16:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786443; cv=none; b=c1tJ84yFv/Ry1h7wPmnlu/MIhxtrVT6Y1r5E15/hhrtzjDucLQAxO9HEuSTGRK9tP9Q6m3kM96R4NVywvxhS/PGalvWyRXAHdQ3zCt8sKmZY0XR+xN6248xMn1BiOB8eXJYymwtH5X1ODGHS4m24jK46+urKC90TfHYuHirbKn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786443; c=relaxed/simple;
	bh=Ilk+naXbAwFWXAll+kFCQI/lRwCQ5JDONVEX9HkMUcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYAv/n4HIAP/wnKBRuHtwfJi/FgMpNJBicD/L/XDJRqwuFdreL5wxHa7EBX2OnIY9Aqbyn2FD23Ds/IH32SdhGuUyoxGcGQ+f0Guk2F5mLPhfjf2iI/46YEiSorssSScnhB22k3VnR7/AfNAqzW0gYQX5Nmb0bKXGeYv2ENX+g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTJYfsdW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTJYfsdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45AD1F000FF;
	Wed, 30 Sep 2026 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786441;
	bh=i5hn2nZgQZAfKP8v49zs2aRDkTvCw1hPW+JGQ43lrAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTJYfsdWNlxfSuEXdY+EeIaRiYo1tFa2xD4lzwkbc0aidHX5FxWY8YrYK1pQVEJI3
	 wj7gPL1mRv0oPhf0vHu8E9D8neeYmkrGamCSs/IN6xXWmkRdhoOxLE2y9Cr7U1XSCR
	 m4Ut9qGfX+m5tZByFbObI6EXAsgrqc+zI1xw5sgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 862/982] net/mlx5: Bridge, increase bridge tables sizes
Date: Wed, 30 Sep 2026 17:26:38 +0200
Message-ID: <20260930152435.261860066@linuxfoundation.org>
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

[ Upstream commit 9071b423c302b70eff80da715d724c4e75c1c46a ]

Bridge ingress and egress tables got more flow groups recently for QinQ
support and will get more in following patches of this series. Increase the
sizes of the tables to allow offloading more flows in each mode.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 35e6f970f553 ("net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index d0b2676c32145..6cd7c5817922c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -13,8 +13,8 @@
 #define CREATE_TRACE_POINTS
 #include "diag/bridge_tracepoint.h"
 
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 12000
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 16000
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
@@ -40,10 +40,10 @@
 	 MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE - 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE			\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
+static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 1048576);
 
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 16000
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (32000 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE 131072
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_SIZE (262144 - 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO		\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_SIZE - 1)
@@ -63,7 +63,7 @@ static_assert(MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE == 64000);
 	MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_FROM
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE			\
 	(MLX5_ESW_BRIDGE_EGRESS_TABLE_MISS_GRP_IDX_TO + 1)
-static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 64000);
+static_assert(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE == 524288);
 
 #define MLX5_ESW_BRIDGE_SKIP_TABLE_SIZE 0
 
-- 
2.53.0



