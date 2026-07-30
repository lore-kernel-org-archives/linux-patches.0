Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CD3E0091;
	Thu, 30 Jul 2026 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426047; cv=none; b=AVN6J2odfrYAUYebh7TKcLJE2AHsRNcHFJ929fBMwL/RoiPLh78wbP3gAVf86CuPYEfacR2X+MAsD7ThPPi+t2iyOQ9lUUn1I0kb0qznc40gN+rl8aJigt74tMXhugiWV0mka4x37wEiXVEZ4Us/DVgk7NMJSbhzu8tB7NlwWbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426047; c=relaxed/simple;
	bh=NNIWRv+Qr5qgohQm8B6ySNDQ34MqFmICbrEnMzJuWSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZxlF1Cxq1n9J7XeCef31FA2CtClFkEtXHVvq5YW+gpXYna4QrUIfRehzw37QeqM0i58DZQzTzkr4MaaaCdOlvmvTiu96+y3Z4+x2juJOOvAIgIPHRySsglQrro8q1btwzcfRxsUjvnfByvzQPzmLb79GlrJyON23aDsC1wkWAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmBJFnNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmBJFnNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232821F000E9;
	Thu, 30 Jul 2026 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426046;
	bh=0JhHNC0Zf6FhYhle7FDag+qyH7bbpOg+dyUFFxyl9+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmBJFnNk4yH0kHaCd+/AI/uNtLkohk79PSvyJVWIFtduQ+6kGzff/XR5OCCCyFGv/
	 IKvSqCPNnGx1076LLvGIaZ+H39TY402Yv2fw43j95kQ7PKPfcpamGw/XgwiLQPiuBo
	 TJLvOGX10WDv1sqyFR8Sq0aXNwZJv5pzik6vIOgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/602] net/mlx5: Remove newline at the end of a netlink error message
Date: Thu, 30 Jul 2026 16:10:30 +0200
Message-ID: <20260730141440.974841385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 3a2295ff3f00d44c97baec37c43b6ede3eea9df9 ]

Netlink error messages should not have a newline at the end of the
string.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250226093904.6632-3-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 11c057d23465 ("net/mlx5: Fix MCIA register buffer overflow on 32 dword reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dpll.c            | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c      | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
index 31142f6cc37293..1e5522a194839c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
@@ -242,7 +242,7 @@ static int mlx5_dpll_clock_quality_level_get(const struct dpll_device *dpll,
 		return 0;
 	}
 errout:
-	NL_SET_ERR_MSG_MOD(extack, "Invalid clock quality level obtained from firmware\n");
+	NL_SET_ERR_MSG_MOD(extack, "Invalid clock quality level obtained from firmware");
 	return -EINVAL;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index b9cf79e2712440..7a18a469961db8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -140,7 +140,7 @@ static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
 	gbp_mask = (u32 *)&enc_opts.mask->data[0];
 
 	if (*gbp_mask & ~VXLAN_GBP_MASK) {
-		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)", *gbp_mask);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 1f55c5a7edf31b..d278542677efb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2013,7 +2013,7 @@ static int mlx5e_get_module_eeprom_by_page(struct net_device *netdev,
 		if (size_read < 0) {
 			NL_SET_ERR_MSG_FMT_MOD(
 				extack,
-				"Query module eeprom by page failed, read %u bytes, err %d\n",
+				"Query module eeprom by page failed, read %u bytes, err %d",
 				i, size_read);
 			return size_read;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index c5ea1d1d2b035c..282cef59e6173f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1861,7 +1861,7 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
 			 addr, vport_num);
 		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
+				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
 				       addr, vport_num);
 		return -EINVAL;
 	}
@@ -1874,7 +1874,7 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
 			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)\n",
+					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
 					       addr, vid, vport_num);
 			return -EINVAL;
 		}
@@ -1882,7 +1882,7 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 
 	err = mlx5_esw_bridge_port_mdb_attach(dev, port, addr, vid);
 	if (err) {
-		NL_SET_ERR_MSG_FMT_MOD(extack, "Failed to add MDB (MAC=%pM,vid=%u,vport=%u)\n",
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Failed to add MDB (MAC=%pM,vid=%u,vport=%u)",
 				       addr, vid, vport_num);
 		return err;
 	}
-- 
2.53.0



