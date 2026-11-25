Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619048;
	b=RGo1avu6xMn8cNApo37hVNSf8bkDx2mBqqb/kVJXndJyJ4kCMAH0pLqfSJu4XQeRPu1Z
	 7Z3Pdk+kENGrGX/zOsWOWWG71AFR24FZrS0pnQAdFeyKAO1d3PwvgkOVdavdhcAW1mWeg
	 56VKV3OikgHSXWjdi4QfeP/bMqPBIfVjDA6ec8cL8XsJQM4HmshIZDRGQG6Ip5Jf/2jY7
	 WkYhpxsHxcFTTqzqm1dEpltN+WRM1pnxlbbuYvwunEeWlDbFufh/1cZic2Sqb3JPPakbC
	 QDX/TEqb7gOLnJkTRQ6yq6IVshqfqtLskXd2TaldVvsjtdm300dtwXHZQRe7hn/ayvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MxFFTnStJAl18qRZne0AInSt35mI17B07RWCGb1PBvI=;
	b=JJL48WYbpGNB8vYEokFB4iIO8tkH27cuyqBX1YauNXwpGUkk5n4gnzONvnukrlSRmxiZ
	 YBySUM+AbWyz78FkSEFFFKir3GfEl9/wfIBq2VIplF1dXZ1so9yZWgHFBywNqeoqJpcJI
	 5RPB7R9bhPaSnx8xKsggyMV/6QrUTGsfvmQHNXsHtrqWDvSMBYAbSQC3x96OB09qO8WqJ
	 jpRQGodJhBb69gX3dmrBDm+LlowzWAhbmqbv12TnXVYD77KEx8dsiJf3WRBpRquOQUPn7
	 rxbuZS1AN2KC1sEn2izmBqMnBKgEMaHkTEfr/u/VyNliuX7PuiVlvVdKMenKlWbsqrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDv49PGy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7465606A31E;
	Wed, 25 Nov 2026 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDv49PGy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA211F000C6;
	Wed, 25 Nov 2026 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619048;
	bh=MxFFTnStJAl18qRZne0AInSt35mI17B07RWCGb1PBvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDv49PGyiP/LLGSqrBAsf0t5NLahWhWLmlSTTaJdz8DL09ncT3ZMhq3BSQgEFtZ8N
	 VtAPuSJjSrgeYg+ubozJwRNplaSJ7rWqm3L1zelchosfem+SCfvwuMwAPP+/CV8uzJ
	 k809KTre2Vl/QwWupe+jp1OIr7kaaVdxpKkAKhbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0455/1005] net/mlx5: Bridge, fix bogus MDB offload errors
Date: Wed, 25 Nov 2026 15:29:53 +0100
Message-ID: <20261125143832.406352153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit c714f324eac17b2df03419b5cd5368687efd8e27 ]

MDB add operations are queued on the switchdev deferred queue
(SWITCHDEV_F_DEFER), while vlan object deletions are handled
synchronously.
A 'bridge vlan del' can overtake an MDB add that is still queued, and
the vlan is already gone by the time the driver is called.

The two operations are independent in practice: in my test, the MDB add
is triggered by assigning the VF an IPv6 address (hence joining a
solicited-node multicast group), while another process deletes the vlan
from its representor.

Racing 'bridge mdb add' against concurrent 'bridge vlan del' could
result in:

[ 5390.967651] mlx5_core 0000:08:00.0: E-Switch: Failed to lookup bridge port vlan metadata (vport=1)
[ 5390.969120] mlx5_core 0000:08:00.1: E-Switch: Failed to lookup bridge port vlan metadata to create MDB (MAC=33:33:ff:12:00:05,vid=2204,vport=1)
[ 5390.971676] mlx5_core 0000:08:00.1 eth4: Failed to add Port Multicast Database entry (object id=2) with error: -EINVAL (-22).
               Failure in updating the port's Multicast Database could lead to
               multicast forwarding issues.

The error cannot reach anyone that could do anything with it, switchdev
returned success to the bridge as soon as the MDB object was queued, and
the errno only flags the entry as offload failed.
The end result is correct either way, if the MDB has been offloaded
before the vlan was deleted, mlx5_esw_bridge_port_mdb_vlan_flush() would
have removed it.

The FDB path already treats this as a harmless race,
mlx5_esw_bridge_port_vlan_lookup() reports it on 'info' logging level
and skips the offload. mlxsw did the same in [1].

Skip the MDB offload, report on 'info' logging level and return
-EOPNOTSUPP: switchdev_port_obj_add_deferred() does not log it, and
br_switchdev_mdb_complete() skips the port group flag update.

[1] Commit 17b334a876fe ("mlxsw: spectrum_switchdev: Don't warn about valid situations")

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104183715.771390-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index b4cf3c5ac0dde..9fac6f985a866 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1867,26 +1867,27 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 
 	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
 	if (!port) {
-		esw_warn(br_offloads->esw->dev,
+		/* MDB is added asynchronously from the switchdev deferred
+		 * queue while port might have been deleted concurrently.
+		 */
+		esw_info(br_offloads->esw->dev,
 			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
 			 addr, vport_num);
-		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
-				       addr, vport_num);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	bridge = port->bridge;
 	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
 		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
 		if (!vlan) {
-			esw_warn(br_offloads->esw->dev,
+			/* MDB is added asynchronously from the switchdev
+			 * deferred queue while vlan might have been deleted
+			 * concurrently.
+			 */
+			esw_info(br_offloads->esw->dev,
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
-			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
-					       addr, vid, vport_num);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 
-- 
2.53.0



