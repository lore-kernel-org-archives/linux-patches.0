Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622107;
	b=yKITYpXasFC3lIOIUoeQs+O20DD5CQHdv6M+FQMxRPg5cMnpMaeXa2tTq+xr2cEcWRPJ
	 M13rK1LAdC0K+F82Hl+hwDypp0e29+q43j2RR7SLqaG8uiTmCP+ORJYsbnR/7X/8ytWlY
	 E+RtJbsW6hM9iZ2PuxHhcWpTQnuVE8gngkKMZlzeg52ROlE1PP6zsZFWXZNN5UGolA6Kl
	 +H5mSXDQVApEgmrW++zb/pmNkob7Z/iumgiNR6m++xFRTVpFjbj/jQuB0C5tDJ0MY65eh
	 xL7WI2Km+KfPTbCeMvkLTNPVd1ui3jlapXQtJRoIH++EeB3ANLtjmFnBaNji7ALMhDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ia21RlystOr+SRtohvcZHFCaA6tVUNk/9eK6Mc4opUU=;
	b=cb+rl0h6RTnEKD/wztjZzyI0lAO61tnSKkitOQqlTH63rv0CL2Je78p8VqQEFfvYbdc1
	 Py2HP/n1TEUcm8RVF4C1IF2GzLSypS5o9vbrJO9lAnHTkEBhqJV0naw+1Va2h/he/6kZk
	 DqDpdmSl0YwM/LMb+XmafYkOjsfpPypDrFIdfE5cARS3U+LbXylg6iTkHtNQlrGiJ6fUF
	 DzS90GPURDqvrJsvLIkeUaACvdNThkJ0o5T9rfNmkmicsw/5jTjfaOFNjj2pbaQcJgOQ1
	 brwInoOq6FF8KByR3sbJtCQUQvUz2ZZvgXQsx+5emGq6xON7Whe4FSqHmOGtEwn+UDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zX/q3sUs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCBB606A31E;
	Wed, 25 Nov 2026 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zX/q3sUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5EA1F000C4;
	Wed, 25 Nov 2026 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622106;
	bh=ia21RlystOr+SRtohvcZHFCaA6tVUNk/9eK6Mc4opUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX/q3sUsE/iFWbPg7SY+LlZf3YfckokV0otCzuhxTJbNryEwupD6rXv9QO+Dxkz3e
	 h6DjeBDx882QBuXRI6KjGYMoL6l39w7pyb6LYdM6HoJg3jg2Uh+X3gD2QLwzKodCDK
	 iC3PDCa3Fv2D11esstyQiUGF/lagrD5Pp201KX5o=
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
Subject: [PATCH 6.18 406/990] net/mlx5: Bridge, fix bogus MDB offload errors
Date: Wed, 25 Nov 2026 15:29:33 +0100
Message-ID: <20261125143831.609926625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 88487e1a58878..744f5cf9eb780 100644
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



