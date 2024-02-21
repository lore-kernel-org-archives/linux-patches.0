Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865CA7E59B;
	Wed, 21 Feb 2024 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522127; cv=none; b=AnDtj3yJWKfzZSbsyMsWySnSDZPCfnAwn53RVtY0QkCL+JwuHn+DdRPPLuobnP1Ce+gDSwUK8a0LDbbaGSSyiuOt3eFUvbQIvynupUbcOUi/GqUGrW9RY1/xIZ7LFNAYPrT7uBP6FNFmq2ENLc/iK3LzHZO43Hxzz3IDrEVcLD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522127; c=relaxed/simple;
	bh=7eHJTTkAZkmzfTVSWP1DIcGYckfQ7TSMcVD15YNG0cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQTIzeNaDPr2/pJpJKrZjWH0ZaXeQqWPB+NJhULtzLUrgOmVghhuwInh4xLH09Ia8mufX+8IX1yzX+JhuBL50939mYUWGV5O90zvJcRMJ2wKBrppMaksztKmmdPvXzZXwCQaEupG6024qmuFObpLSbV2otpMG0lVQBVezvxnfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRqyrLm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRqyrLm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89696C433F1;
	Wed, 21 Feb 2024 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522127;
	bh=7eHJTTkAZkmzfTVSWP1DIcGYckfQ7TSMcVD15YNG0cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRqyrLm86gWqyewVF5wTYPz8a9zBpmm9CKry7lvzW/xCul+Hk2Coz6WiULyrAoAn/
	 5aZYTzdMWviFoy9YMh2qWEZRJwI2OvicOuUDJ627bSiPZormaaNEJlhqFPHexIERsN
	 b3Al5CO0UML+7mRhLtRjIpEtO20FwzMvlzYhx/0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/476] net/mlx5: DR, Replace local WIRE_PORT macro with the existing MLX5_VPORT_UPLINK
Date: Wed, 21 Feb 2024 14:01:49 +0100
Message-ID: <20240221130010.075124155@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 7ae8ac9a582088c85154970982766617c9ebf8dc ]

SW steering defines its own macro for uplink vport number.
Replace this macro with an already existing mlx5 macro.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 5b2a2523eeea ("net/mlx5: DR, Can't go to uplink vport on RX rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c   | 2 +-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_domain.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 4 ++--
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h    | 7 +++----
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 380e3294df43..3f074d09a5fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -670,7 +670,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
 			if (rx_rule) {
-				if (action->vport->caps->num == WIRE_PORT) {
+				if (action->vport->caps->num == MLX5_VPORT_UPLINK) {
 					mlx5dr_dbg(dmn, "Device doesn't support Loopback on WIRE vport\n");
 					return -EOPNOTSUPP;
 				}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index ea1b8ca5bf3a..fe2c2b4113f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -171,7 +171,7 @@ static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
 
 	/* Last vport is the wire port */
 	wire_vport = &dmn->info.caps.vports_caps[vport];
-	wire_vport->num = WIRE_PORT;
+	wire_vport->num = MLX5_VPORT_UPLINK;
 	wire_vport->icm_address_rx = esw_caps->uplink_icm_address_rx;
 	wire_vport->icm_address_tx = esw_caps->uplink_icm_address_tx;
 	wire_vport->vport_gvmi = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index aca80efc28fa..323ea138ad99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1042,10 +1042,10 @@ static bool dr_rule_skip(enum mlx5dr_domain_type domain,
 		return false;
 
 	if (mask->misc.source_port) {
-		if (rx && value->misc.source_port != WIRE_PORT)
+		if (rx && value->misc.source_port != MLX5_VPORT_UPLINK)
 			return true;
 
-		if (!rx && value->misc.source_port == WIRE_PORT)
+		if (!rx && value->misc.source_port == MLX5_VPORT_UPLINK)
 			return true;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 9e2102f8bed1..175b9450c9aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -4,7 +4,7 @@
 #ifndef	_DR_TYPES_
 #define	_DR_TYPES_
 
-#include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include <linux/refcount.h>
 #include "fs_core.h"
 #include "wq.h"
@@ -14,7 +14,6 @@
 
 #define DR_RULE_MAX_STES 18
 #define DR_ACTION_MAX_STES 5
-#define WIRE_PORT 0xFFFF
 #define DR_STE_SVLAN 0x1
 #define DR_STE_CVLAN 0x2
 #define DR_SZ_MATCH_PARAM (MLX5_ST_SZ_DW_MATCH_PARAM * 4)
@@ -1116,10 +1115,10 @@ static inline struct mlx5dr_cmd_vport_cap *
 mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u32 vport)
 {
 	if (!caps->vports_caps ||
-	    (vport >= caps->num_vports && vport != WIRE_PORT))
+	    (vport >= caps->num_vports && vport != MLX5_VPORT_UPLINK))
 		return NULL;
 
-	if (vport == WIRE_PORT)
+	if (vport == MLX5_VPORT_UPLINK)
 		vport = caps->num_vports;
 
 	return &caps->vports_caps[vport];
-- 
2.43.0



