Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619263;
	b=Ta0eHisvmGuOIEHFYyvV/EAnIJ2AybyNWonnfto5IW0osiP0iaS+hladMracLyXIUriZ
	 6w/CYZSgWabep5Z4Tqoo22xv4Uw5YSa8VW4BDIfaS3PLxnjfMGyuKLoRb0GJLR7pk2s8w
	 bWN4iOcZoEZS4rf3HNqkJfhC0neO1gfki9ttQNqpFvt7TGZX633DEFiFbWtcoejuu4f0w
	 9TpZIotax9X+YW48LzcuonB+2wYkNvMCXn7mUXc9qxJerRXxsMr78470E/NAOnrMpZRpV
	 sOrozpPsDQE+aXJNV2KgbvEM2JllZrlV2uKWwhV9LuCRkn5eW8l/5si7DyTXc1UnRfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMqomLpVbkGh8GzUQa9Zxs9QFeA3Bql8FFzqS/bEvJA=;
	b=wiaNq+d/GyMCUspYwRzirr0alxWrAE7vsTUBvhbU42Tc/8S4nKvmELcr/qG3Y8RS+ZD5
	 yKDjtHfCN2j93B4EBuJzk5+yDSSvXI9qK7iIeFJndOD3EKP8/6aCXgYlATXR+EkBo4FVo
	 x+EDnMF9hpM1TetO38Z44xwOzmO7C4ynFnrDvP1/Vzr+83s4HRHYgOOLtCbl423ExpYQy
	 JhX43IFu6iKiRT9TTkE60HAewbQ/RcIGpdy/5dIbURBn5peB7o09/5aYYi0MouJ4WLuDK
	 HAwFw1dHWYhS48EcSqP8JJ6CiZDhL3iRgzNZnB5xu6min/YuCqDE+lkUQ/wCjbCsiHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeX8uhRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDF5606A32C;
	Wed, 25 Nov 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeX8uhRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C731F000D1;
	Wed, 25 Nov 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619262;
	bh=KMqomLpVbkGh8GzUQa9Zxs9QFeA3Bql8FFzqS/bEvJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeX8uhRauqgHyjGxoaRnlPwj+6TKWysfMOt3DsJ8Cpom9xsdgjjpvJUnUR63MjZma
	 NUxF391122XsjO/Ecch5mnAFyrCb5jnyzes5wDPKUZuoMoR3rRZRJ1dctOmgmaT5Ud
	 /vJG3xDkqD4ZdXvm44aMXyMGt5FfnLrAmEn6leTQ=
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
Subject: [PATCH 7.3 0504/1005] net/mlx5e: Serialize TC and IPsec offload exclusion counters
Date: Wed, 25 Nov 2026 15:30:42 +0100
Message-ID: <20261125143833.551538383@linuxfoundation.org>
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

[ Upstream commit 717dec565a5e7feab544da5aa77db9da71bc93fe ]

The counters enforcing TC and IPsec packet offload mutual exclusion are
not consistently serialized. IPsec admission conditionally takes
mode_lock for writing, while TC admission holds it only for read.
Neither release path takes the lock, and devices without an eswitch
cannot rely on it at all.

These are per-core-device counters, separate from the eswitch mode and
encapsulation reservations protected by mode_lock. Move them into
mdev->offload_block and protect their checks, increments and decrements
with a dedicated spinlock that is available even without an eswitch.
A spinlock is used because some of these functions are called from
atomic context and is a good fit because the critical sections are and
will stay really short.

IPsec admission then no longer needs mode_lock to update these counters.
Add warnings for unbalanced releases. Keep mlx5_esw_lock() for eswitch
operation admission and temporary mode/encapsulation reservations.

This was found by upstream Sashiko during review of [1], and spun-off
into a fix from the larger patch.

[1]
https://lore.kernel.org/netdev/178907726586.219967.4695695146458742597@kernel.org/

Fixes: c8e350e62fc5 ("net/mlx5e: Make TC and IPsec offloads mutually exclusive on a netdev")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 43 ++++++-------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 +++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 include/linux/mlx5/driver.h                   |  8 +++-
 4 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index dbe5547d7a498..55de9abbd72be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2585,45 +2585,26 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_eswitch *esw = mdev->priv.eswitch;
-	int err = 0;
-
-	if (esw) {
-		err = mlx5_esw_lock(esw);
-		if (err)
-			return err;
-	}
-
-	if (mdev->num_block_ipsec) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	int ret = 0;
 
-	mdev->num_block_tc++;
-
-unlock:
-	if (esw)
-		mlx5_esw_unlock(esw);
-
-	return err;
-}
-#else
-static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
-{
-	if (mdev->num_block_ipsec)
-		return -EBUSY;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_ipsec)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_tc++;
+	spin_unlock_bh(&mdev->offload_block.lock);
 
-	mdev->num_block_tc++;
-	return 0;
+	return ret;
 }
-#endif
 
 static void mlx5e_ipsec_unblock_tc_offload(struct mlx5_core_dev *mdev)
 {
-	mdev->num_block_tc--;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!mdev->offload_block.num_block_tc))
+		mdev->offload_block.num_block_tc--;
+	spin_unlock_bh(&mdev->offload_block.lock);
 }
 
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c40c7b55a54d8..38dbda82c7496 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4834,16 +4834,19 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
 static int mlx5e_tc_block_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
+	int ret = 0;
 
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return 0;
 
-	if (mdev->num_block_tc)
-		return -EBUSY;
-
-	mdev->num_block_ipsec++;
+	spin_lock_bh(&mdev->offload_block.lock);
+	if (mdev->offload_block.num_block_tc)
+		ret = -EBUSY;
+	else
+		mdev->offload_block.num_block_ipsec++;
+	spin_unlock_bh(&mdev->offload_block.lock);
 
-	return 0;
+	return ret;
 }
 
 static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
@@ -4851,7 +4854,10 @@ static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx
 	if (!is_tc_ipsec_order_check_needed(filter, priv))
 		return;
 
-	priv->mdev->num_block_ipsec--;
+	spin_lock_bh(&priv->mdev->offload_block.lock);
+	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_block_ipsec))
+		priv->mdev->offload_block.num_block_ipsec--;
+	spin_unlock_bh(&priv->mdev->offload_block.lock);
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b6..fe98e35d15d21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1810,6 +1810,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	spin_lock_init(&dev->offload_block.lock);
 	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_init(&dev->wc_state_lock);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbca..a778733fdb66f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -788,8 +788,12 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_hwmon	*hwmon;
-	u64			num_block_tc;
-	u64			num_block_ipsec;
+	struct {
+		/* Protects the fields below. */
+		spinlock_t lock;
+		u64 num_block_tc;
+		u64 num_block_ipsec;
+	} offload_block;
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_macsec_fs *macsec_fs;
 	/* MACsec notifier chain to sync MACsec core and IB database */
-- 
2.53.0



