Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C29818A6AE;
	Tue, 17 Jun 2025 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174583; cv=none; b=WIB+YqYGeE5/ddsOcjo2ZKiSS0luid/Dbbxz+Nx5/f8CaA4g48Gvny3bJ6pq+/Qf7CH1OIlhXACpkcM0zgIIE3a19ON6ae3OvqRfZ90fG/1CIco6aJQWBqrDuXsFab2/geeZxOV4DFdT0ryHSMF3A+jgnMkZHI2OPajWzej6Mcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174583; c=relaxed/simple;
	bh=nhnxot+J/SUerMriOqInK1iGFNIN6aIRYy74839rYzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUgZGIsY2YAZdRvRblF1cEgpdKulysg9n6WmsBasGTfwxSLIgt2GxigMm076lmK3SC9xwZp2OTLvtq/tbJByxrOiorAvCrMlh6o3sZyKGIVeFjQH0o6Fbeh81SIZBiSrzN5aG/Ye9u1Yv056vQ/bvikwk7w6SMOJl4FXvtnHJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/HxEZr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/HxEZr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD0C4CEF4;
	Tue, 17 Jun 2025 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174583;
	bh=nhnxot+J/SUerMriOqInK1iGFNIN6aIRYy74839rYzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/HxEZr8o+t9BlNSDSKQYsZK4YARUpSfaWsvpvCOexjrVuCLAGdIASoUYMRt86Ows
	 0r3GvWF5yTCqPgo/73M09YhV/HLBCEMWooFEn1ZRfKo0iM6W+k5x2/K8TGhTnX8iG+
	 wTMN9w45PujrtUFaS5pcU5nWcW78TYa1UeiAWAiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/356] xfrm: Use xdo.dev instead of xdo.real_dev
Date: Tue, 17 Jun 2025 17:23:25 +0200
Message-ID: <20250617152341.837534963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 25ac138f58e7d5c8bffa31e8891418d2819180c4 ]

The policy offload struct was reused from the state offload and
real_dev was copied from dev, but it was never set to anything else.
Simplify the code by always using xdo.dev for policies.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
 net/xfrm/xfrm_device.c                                   | 2 --
 net/xfrm/xfrm_state.c                                    | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 463c23ae0ad1e..5161bf51fa110 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -1093,7 +1093,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 				 struct netlink_ext_ack *extack)
 {
-	struct net_device *netdev = x->xdo.real_dev;
+	struct net_device *netdev = x->xdo.dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
 	struct mlx5e_priv *priv;
 	int err;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 04dc0c8a83707..7188d3592dde4 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -371,7 +371,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 
 	xdo->dev = dev;
 	netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
-	xdo->real_dev = dev;
 	xdo->type = XFRM_DEV_OFFLOAD_PACKET;
 	switch (dir) {
 	case XFRM_POLICY_IN:
@@ -393,7 +392,6 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
 	if (err) {
 		xdo->dev = NULL;
-		xdo->real_dev = NULL;
 		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 		xdo->dir = 0;
 		netdev_put(dev, &xdo->dev_tracker);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 86029cf5358c7..d2bd5bddfb05d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1326,7 +1326,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xso->type = XFRM_DEV_OFFLOAD_PACKET;
 			xso->dir = xdo->dir;
 			xso->dev = xdo->dev;
-			xso->real_dev = xdo->real_dev;
 			xso->flags = XFRM_DEV_OFFLOAD_FLAG_ACQ;
 			netdev_hold(xso->dev, &xso->dev_tracker, GFP_ATOMIC);
 			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
@@ -1334,7 +1333,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 				xso->dir = 0;
 				netdev_put(xso->dev, &xso->dev_tracker);
 				xso->dev = NULL;
-				xso->real_dev = NULL;
 				xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 				x->km.state = XFRM_STATE_DEAD;
 				to_put = x;
-- 
2.39.5



