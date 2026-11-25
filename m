Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619157;
	b=aHWpVLZegDeEsQcKvGLuuwlauC3wh3tGoNRH/J2VbcsHDtDiGp2CU9Qu5paMnI2FJIHu
	 vOygrbjyjb805s8/DBl5mqOuNsobU32HEYX79SQKQF8Mkt4SOxFe5tXredJUsU36GtxLN
	 QShcd+iVCBBUzDMhMd9w2TWbw+V/11/xPRmi1pLHzkf01rwUGb0fZwKHJKz29ouLdzWjB
	 SSHkmQVvG780jNYVOY+MEAWRAkl8nk2U6J/jOPwec2H8+CyAt4DaZToAn9Q92D1lS2jXd
	 o9gJ3Cn2RdUFOF5zpeiLb7URWVFiPal3abz9C+gIy0kq40OdUsBKKPJtQvl1Opvrr8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zB0oR45YYPxxt6mBhRI+XFuRnpxJPUOft68tkcahptc=;
	b=TUJc7AcjFoX0kCDHiORJJGbDVfGje+c+pBTQEkYZzMZqdEDil59oQW7fc3yhPv7RSExO
	 1k+29aae0JSv8GAC/GIYN5OSl5P6MMkV+BuusvjKRKYq4+dZsQm2g21gKjIWrK5BhmQ48
	 9n+XnPJP45k5yGNRz0IGsgx++cch4qkFOYLt3eBmCLUi56tHRoHQ8gKkccqnCJbbHqVAj
	 +QtVDYxLWI3ZEkKgRDjJjaKbyt0IBfU8EPJVW7VmX+ChyY0rD1V7wk5BzKi+c4gGdMa8s
	 xAuPNwdhpjFXwJwWluTnYJsMmy7XjavyqFP41N5jPE39dzdnMjCPN+RKgbmug3kG1Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzbKd2cP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0E0606A31E;
	Wed, 25 Nov 2026 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzbKd2cP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4B71F000D0;
	Wed, 25 Nov 2026 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619156;
	bh=zB0oR45YYPxxt6mBhRI+XFuRnpxJPUOft68tkcahptc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzbKd2cPQooA4vjRmsefnmAExiVObb1Yv5sZ/IM0sspmEZMbnG0zhNiFlvChobEs7
	 Ab4P+ridUtjntfpkOkeS8HcsSWkKVLRA+bVPcq+z8+CKr1gsIk3wO64JPOpo16/Jdj
	 0IUp7poSuGxL4JR+fo+5tEWFyRbow05m24QZ92qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0501/1005] net/mlx5e: Fix ipsec core device access during profile changes
Date: Wed, 25 Nov 2026 15:30:39 +0100
Message-ID: <20261125143833.480649512@linuxfoundation.org>
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
index a8c7f09f903fc..c8c103b0a879a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -773,12 +773,20 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
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
 
@@ -797,16 +805,16 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
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
 
@@ -877,9 +885,9 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	if (allow_tunnel_mode)
-		mlx5_eswitch_unblock_encap(priv->mdev);
+		mlx5_eswitch_unblock_encap(mdev);
 
-	mlx5_eswitch_unblock_mode(priv->mdev);
+	mlx5_eswitch_unblock_mode(mdev);
 
 	return 0;
 
@@ -895,11 +903,11 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
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
@@ -1268,16 +1276,24 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
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
 
@@ -1288,7 +1304,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
 
-	if (!mlx5_eswitch_block_ipsec(priv->mdev)) {
+	if (!mlx5_eswitch_block_ipsec(mdev)) {
 		err = -EBUSY;
 		goto ipsec_busy;
 	}
@@ -1302,7 +1318,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return 0;
 
 err_fs:
-	mlx5_eswitch_unblock_ipsec(priv->mdev);
+	mlx5_eswitch_unblock_ipsec(mdev);
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 38ce7d0a9001e..77c54b1702a90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6383,7 +6383,7 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	node = dev_to_node(mlx5_core_dma_dev(mdev));
 
 	/* priv init */
-	priv->mdev        = mdev;
+	WRITE_ONCE(priv->mdev, mdev);
 	priv->netdev      = netdev;
 	priv->max_nch     = nch;
 	priv->max_opened_tc = 1;
@@ -6468,6 +6468,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		mlx5e_mqprio_rl_free(priv->mqprio_rl);
 	}
 
+	/* Clear atomically before memset() for lockless XFRM readers. */
+	WRITE_ONCE(priv->mdev, NULL);
 	memset(priv, 0, sizeof(*priv));
 	if (destroying) /* restore destroying bit, to allow unload */
 		set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-- 
2.53.0



