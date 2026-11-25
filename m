Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619191;
	b=Q8/kgkmPj8ELbTorrxLKRZlqNsL2TipOwduWZfNMA6fMf/vcevI49nwWiqoMACf7OjR2
	 5GaJlDOgMU5J1y+50281nXJaCzYEBJeheWzFkVxugy2qRCmkW7MvTDCrnGHVaetr2V0+L
	 UXFNO9LgecaEFUkxixmxdDGOXwqJiIkFbkROxQ1wXKGUrPtKYM7bSEcNs7MmGo6vWEmcM
	 gxmPSPSQLGlMhyhltGQiObjddG9RPQXeLWXp8x2/iK2zzKCBZTOn04DQMssjtzNfSDvH5
	 Rx/mShoLlYuN6xwqpHMuDBD3uh/DitFolmF+/vTvS0Ctd491SynbgHrJUq19lc1plMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TzEsMaw94zp75fD79UK+pDanQp1PVHgHynVTUnj9KI=;
	b=t0D4EEBSBKIN/UP95v99Y9QzmvSsMgov1xyZyR2MZz/mKhTE8ad4TO0tj54YbnOSDSJ5
	 TOpgk/3k1akaC29bevRbhbqdtGws3srJHuZgkmbRxiDOrZ6lsv6FRS/Tb+TyYsfwlThwW
	 hPg9YqX455glazfWDalg0Bu9GAwfCrshgtezxiarDuSwdLZSL/vOk8r4o2DN11mAH8+It
	 moSMP5kc2QhdHB5G9kDNzjUsKb/gewxiX5Prk2sFhrKAH46u82tfLVAprRL/OQ7Q5PwrR
	 ytArMP//ZkkbruD+00WnFzRyAjLfHGIehvZCwkjnnvIKdLX0gX26pNU/aQcQzviJ9gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8qxmXZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF4606A321;
	Wed, 25 Nov 2026 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8qxmXZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CDF1F000C4;
	Wed, 25 Nov 2026 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619191;
	bh=1TzEsMaw94zp75fD79UK+pDanQp1PVHgHynVTUnj9KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8qxmXZ2KaC8UT1jWCRBAD2LERmOwS6cgvxp4Mw7UrozKrsqo+1vQXfOxrerlYH7Q
	 xEqAIIR4uO7eA4TIblVAFZCA3R93l4kwPa3BXT7LBVyWpAXGahCh1WE41LLHkaMSrr
	 RYmobtOgfzRhtiR/rfUdS/4ucFzrXyyKMUemPu+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0502/1005] net/mlx5e: Block E-Switch mode changes during IPsec policy creation
Date: Wed, 25 Nov 2026 15:30:40 +0100
Message-ID: <20261125143833.504981829@linuxfoundation.org>
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

[ Upstream commit d9e4ac08ea892da54c5aa7ae4a368f2d09db589c ]

Eswitch mode changes can tear down the IPsec context while policy
creation is accessing it. The mode-blocking reference acquired when
creating a flow table comes too late: the table lookup already accesses
the IPsec context before taking that reference.

Take a temporary mode-blocking reference before checking the IPsec
context and validating the policy. This gets dropped after successful
setup, when the flow table holds its own reference.

The temporary reservation must allow reuse of existing IPsec tables.
For example:
1. An offloaded inbound IPsec policy is added on the uplink.
2. A TC flower rule is added on a VF representor.
3. Another uplink policy is added using the same RX tables.

The third policy reuses the first policy's tables, so it must not be
rejected merely because esw->user_count is nonzero. Add a check_users
argument to mlx5_eswitch_block_mode(). Pass false for temporary policy
reservations and true when creating the first table (rx_get()/tx_get()).

Temporary reservations take mode_lock and check operation ownership
without requiring eswitch user_count to be zero.

mlx5e_xfrm_add_state() needs the same early mode reservation and is
handled in the next patch.

This was found by Sashiko, during review of the last patch in the
series. No reproduction attempted, as it seems quite a tricky race to
successfully trigger.

Fixes: a5b8ca9471d3 ("net/mlx5e: Add XFRM policy offload logic")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 +++++++++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  9 +++++---
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c8c103b0a879a..09f51f6fa8675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -814,7 +814,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 		goto err_xfrm;
 	}
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		goto unblock_ipsec;
 
@@ -1288,18 +1288,28 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		return -EBUSY;
 	}
 
+	/* Block esw mode changes until the policy holds its own block. */
+	err = mlx5_eswitch_block_mode(mdev, false);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
+		return err;
+	}
+
 	if (!priv->ipsec) {
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto unblock_mode;
 	}
 
 	err = mlx5e_xfrm_validate_policy(mdev, x, extack);
 	if (err)
-		return err;
+		goto unblock_mode;
 
 	pol_entry = kzalloc_obj(*pol_entry);
-	if (!pol_entry)
-		return -ENOMEM;
+	if (!pol_entry) {
+		err = -ENOMEM;
+		goto unblock_mode;
+	}
 
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
@@ -1315,6 +1325,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		goto err_fs;
 
 	x->xdo.offload_handle = (unsigned long)pol_entry;
+	mlx5_eswitch_unblock_mode(mdev);
 	return 0;
 
 err_fs:
@@ -1322,6 +1333,8 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 ipsec_busy:
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
+unblock_mode:
+	mlx5_eswitch_unblock_mode(mdev);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 1529d47303234..dbe5547d7a498 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1134,7 +1134,7 @@ static int rx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (rx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
@@ -1427,7 +1427,7 @@ static int tx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (tx->ft.refcnt)
 		goto skip;
 
-	err = mlx5_eswitch_block_mode(mdev);
+	err = mlx5_eswitch_block_mode(mdev, true);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c0f2af86a9342..176940a20b756 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -971,7 +971,7 @@ bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
 int mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev);
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users);
 void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev);
 
 static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
@@ -1082,7 +1082,11 @@ static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
 {
 }
 
-static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev) { return 0; }
+static inline int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev,
+					  bool check_users)
+{
+	return 0;
+}
 static inline void mlx5_eswitch_unblock_mode(struct mlx5_core_dev *dev) {}
 static inline bool mlx5_eswitch_block_ipsec(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0debb02fea268..023d87f17e90b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4342,7 +4342,7 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
+int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
@@ -4350,8 +4350,11 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	/* Take TC into account */
-	err = mlx5_esw_try_lock(esw);
+	/* Temporary reservations may reuse tables while TC users exist. */
+	if (check_users)
+		err = mlx5_esw_try_lock(esw);
+	else
+		err = mlx5_esw_lock(esw);
 	if (err < 0)
 		return err;
 
-- 
2.53.0



