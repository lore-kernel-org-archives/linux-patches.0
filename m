Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622144;
	b=0tVcW3HGj6+3cQNgkUf0biHH7Ovpg+LPU8r61YFzVqNm+n7FLLb1hwJ2TSAg0TXpNhYM
	 JYhGi2ofW2Z7uKlV0BxLRvRRJa377b8ghRa7x835ITKqKzq2Ljgd020qOIWxNrFSMh/Gk
	 hPgvg8m2u8Tlfzbz8qXHCUQRD8wtUAfJQBrdGSlaBXMHWnP1td+e+uZTQrvxNm30b7W0J
	 uKOjj5FVYFI6q0OHBSkvTUVYw7uiR6crWDz0PnFkyR2eT4B8SlAxTpsUYZ5S8Ld7OSsVv
	 q7FeUyYw5V3P87q+6VrW1lg3F/sH3OF1P7uEyagt8hP++LtZjYnDFs+vrtrU6kaSdzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Skf/NOtJOe8TcVt31tKDs/5QzASdZy2DTyKyvgvwQCU=;
	b=Hrz5AUmJ12HVAHn5bnh0o9IBGQtVjzV6EHLDRzZe8siFMb38bq8EQYYOZXnHMyyT5Ol3
	 l26vf0183AW+Uxdu7wrpvAPciVh14C96lm5ZeoU6PYH8sdrBMq9YCDuXy/queCJKpTmgA
	 uIHZPt8XLfOkjMKrEoD4uNJLQ47i6uon/XuAeeXU5crsOFpbn0YAt62BMQZ9720RiLvYu
	 0itGJSOyuKjZMyrDcwhoBwdtNFRyVzqv/lZQhUdyFfsQ85FGBv6WTaSidOP3EzYsvB58R
	 3REMyQT+pkrG4F+a3qMQRndHxQB+Y4q0T745BaXLOieC3sQGaH/dtOReprHzhbDvL3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRLgT1hQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59959606A32C;
	Wed, 25 Nov 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRLgT1hQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BAE1F000C0;
	Wed, 25 Nov 2026 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622144;
	bh=Skf/NOtJOe8TcVt31tKDs/5QzASdZy2DTyKyvgvwQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRLgT1hQtj1qQDvoW8R06dM3O7etXg+2qA2vTwgsPZeK734EAhOJYK7HIexiPnSza
	 Q8GIy5mzwigHohSQpFtB/AZNqSBlChCgjf4F//jjjiZZlGpyUMOiyTP8iJ3MjS9nHe
	 fNeUPam2SNVnjdS3Nt68EVRH5s572L3Sv4yioKik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/990] net/mlx5e: Fix ipsec core device access during profile changes
Date: Wed, 25 Nov 2026 15:30:03 +0100
Message-ID: <20261125143832.307542731@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 5b310ae1eff7531030b123bfcb192b0176d73075 ]

Devlink E-Switch mode changes replace the netdev profile without
unregistering the netdev. XFRM state and policy creation can therefore
run while mlx5e_priv_cleanup() clears priv with memset() or
mlx5e_priv_init() initializes it again. Accesses to priv->mdev can
observe NULL or a torn pointer, and repeated loads may return different
values.

Read priv->mdev once in each add callback and use the saved pointer
throughout the callback, including error unwinding. The core device
survives the in-place profile change, so a saved non-NULL pointer
remains valid even if priv is cleared in the meantime.

A NULL priv->mdev means a profile change is in progress, which only
happens during an eswitch mode change. Return -EBUSY in that case, as
mlx5_eswitch_block_mode() does for the same mode change. -EOPNOTSUPP
would make xfrm_dev_state_add() silently fall back to software for a
crypto offload SA for its whole lifetime.

Use WRITE_ONCE() when initializing priv->mdev and when clearing it
before memset(). This makes the transition to NULL atomic; the
subsequent bulk clear only writes zero bytes over an already NULL
pointer. Annotate the READ_ONCE() snapshots with data_race() to allow
that harmless overlap with the unmarked memset() without suppressing
checks for the rest of priv.

This fixes the core-device pointer accesses. Protecting the IPsec
context itself during state and policy creation is handled separately.

This was found by Sashiko, during review of the next patches in the
series. No attempt was made at reproducing this race, the chances seem
vanishingly small.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 38 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2874a50bead6a..611876f204134 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -775,12 +775,20 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	bool allow_tunnel_mode = false;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5e_priv *priv;
 	gfp_t gfp;
 	int err;
 
 	priv = netdev_priv(dev);
+	/* Profile cleanup can memset an already NULL mdev. */
+	mdev = data_race(READ_ONCE(priv->mdev));
+	/* NULL only during a profile change, which is an eswitch operation. */
+	if (!mdev) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add state");
+		return -EBUSY;
+	}
 	if (!priv->ipsec)
 		return -EOPNOTSUPP;
 
@@ -799,16 +807,16 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		return 0;
 	}
 
-	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
+	err = mlx5e_xfrm_validate_state(mdev, x, extack);
 	if (err)
 		goto err_xfrm;
 
-	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
+	if (!mlx5_eswitch_block_ipsec(mdev)) {
 		err = -EBUSY;
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(priv->mdev);
+	err = mlx5_eswitch_block_mode(mdev);
 	if (err)
 		goto unblock_ipsec;
 
@@ -876,9 +884,9 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	if (allow_tunnel_mode)
-		mlx5_eswitch_unblock_encap(priv->mdev);
+		mlx5_eswitch_unblock_encap(mdev);
 
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 
 	return 0;
 
@@ -894,11 +902,11 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 	kfree(sa_entry->work);
 unblock_encap:
 	if (allow_tunnel_mode)
-		mlx5_eswitch_unblock_encap(priv->mdev);
+		mlx5_eswitch_unblock_encap(mdev);
 unblock_mode:
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 unblock_ipsec:
-	mlx5_eswitch_unblock_ipsec(priv->mdev);
+	mlx5_eswitch_unblock_ipsec(mdev);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_WEAK_MOD(extack, "Device failed to offload this state");
@@ -1267,16 +1275,24 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 {
 	struct net_device *netdev = x->xdo.dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int err;
 
 	priv = netdev_priv(netdev);
+	/* Profile cleanup can memset an already NULL mdev. */
+	mdev = data_race(READ_ONCE(priv->mdev));
+	if (!mdev) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
+		return -EBUSY;
+	}
+
 	if (!priv->ipsec) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5e_xfrm_validate_policy(priv->mdev, x, extack);
+	err = mlx5e_xfrm_validate_policy(mdev, x, extack);
 	if (err)
 		return err;
 
@@ -1287,7 +1303,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
 
-	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
+	if (!mlx5_eswitch_block_ipsec(mdev)) {
 		err = -EBUSY;
 		goto ipsec_busy;
 	}
@@ -1301,7 +1317,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return 0;
 
 err_fs:
-	mlx5_eswitch_unblock_ipsec(priv->mdev);
+	mlx5_eswitch_unblock_ipsec(mdev);
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3bbb19712a586..3695498f27e0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6205,7 +6205,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	node = dev_to_node(mlx5_core_dma_dev(mdev));
 
 	/* priv init */
-	priv->mdev        = mdev;
+	WRITE_ONCE(priv->mdev, mdev);
 	priv->netdev      = netdev;
 	priv->max_nch     = nch;
 	priv->max_opened_tc = 1;
@@ -6298,6 +6298,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		mlx5e_mqprio_rl_free(priv->mqprio_rl);
 	}
 
+	/* Clear atomically before memset() for lockless XFRM readers. */
+	WRITE_ONCE(priv->mdev, NULL);
 	memset(priv, 0, sizeof(*priv));
 	if (destroying) /* restore destroying bit, to allow unload */
 		set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-- 
2.53.0



