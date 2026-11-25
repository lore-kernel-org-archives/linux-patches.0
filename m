Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619288;
	b=AV8rmksNYNL7LtnvbqEjXTJubtKSIjblwqOD38zNewPJPoWuo1gF3YPDDZPUiIStf9MP
	 +YjEKIGY9LuCIG9VqHqs1qPDHSVeRPTN9CFnYXoIaGouv8M1gD0FNup/13KCVSFTVZDy0
	 Wn7hTj7FX/OARNdZfthqqDQUho3E4nEOEdkhLFqhnvc+keWWaETt9y2lgvNJhfT2VMgAg
	 NC7uqx1Z/g62tsYiPtQBcmAmEF2tF7w3MrHzqEM76Sz7Zqv+L8LDjRjzs1jPMvr+qsa+N
	 ZkYbPfcQaCsa9KD6TSkScJzmWoX0zsywuUDt8DJKaqSaTvN+9L+yHOcI+nS+je9Qdxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vuOKZf+C/kVj5w82vMlHdKJelwG3aVUwbVdgKOzMk7Q=;
	b=Lr3Nllq9345o0is3idCphw5RLIqiRbeF8RM2O7srVfDkzjqN09HLOVUNVUzUD8mDYy9p
	 TCh/munljBvJTEYobGaMQs7KJwPI/p1B/OZgtryC1lLwbDS+3A5CqILKtB1osJnl4aDRA
	 UBfODzEF4b26kAxzR45SCexXTffeYJeSvkyCAoNpXLPlyHZzpxDP0E33iVQQ4z60Bxkep
	 50B+YzYe8WnyHHMb01TBoQpkCXv7nBGa0fNZ8ZKGukg+i/UvZ13b32IFa2h9zSwyPOlJa
	 PWyvY6edAk0AEtoasnkgZ2bBWgcF2wqwTTDCyJQwPjcVisptAyPkwBT9qCXz74cg6AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA8DMKC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7647606A321;
	Wed, 25 Nov 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA8DMKC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311731F000CF;
	Wed, 25 Nov 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619288;
	bh=vuOKZf+C/kVj5w82vMlHdKJelwG3aVUwbVdgKOzMk7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA8DMKC2OOfhB+BNOQBzqHDfW1rtmkL582bbfYh8Km6Ql0xZB6ybIscirnPivvx/c
	 LBMry/QXkN1tTM47Sazh1QELEpiQCquBvxJmFB3BmmuaCy3Xun57sRfeXdUrNGtodv
	 rXf4AQi1Z8OLvsyWQuZePtrQXBmk9iHnngb16BFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0547/1005] net/mlx5e: Rename state_destroy to rx_mode_active in flow steering
Date: Wed, 25 Nov 2026 15:31:25 +0100
Message-ID: <20261125143834.559262343@linuxfoundation.org>
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit cdcb648a97ebc247eea3a9a7d15916613f640527 ]

This flag controls the enablement of RX mode handling (promisc,
allmulti, broadcast, netdev addr sync). It acts as a safeguard
that prevents new FS (flow steering) operations during device
teardown. When the device is in destroying state it is set to
false to indicate RX mode operations are not allowed.
Its name is misleading, as it suggests a destroy-state flag
rather than RX mode activity. Rename it for clarity.

No functional change.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20261011093100.769149-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3962ded998c1 ("net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup on RX init failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 17 +++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 15 +++++++++------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 4973fb473ff02..aa370227b7bcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -158,7 +158,7 @@ void mlx5e_destroy_flow_steering(struct mlx5e_flow_steering *fs, bool ntuple,
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy,
+					  bool rx_mode_active,
 					  struct dentry *dfs_root);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
 struct mlx5e_vlan_table *mlx5e_fs_get_vlan(struct mlx5e_flow_steering *fs);
@@ -198,7 +198,8 @@ void mlx5e_fs_set_udp(struct mlx5e_flow_steering *fs, struct mlx5e_fs_udp *udp);
 struct mlx5e_accel_fs_tcp *mlx5e_fs_get_accel_tcp(struct mlx5e_flow_steering *fs);
 void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_fs_tcp *accel_tcp);
 #endif
-void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy);
+void mlx5e_fs_set_rx_mode_active(struct mlx5e_flow_steering *fs,
+				 bool rx_mode_active);
 void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs, bool vlan_strip_disable);
 
 struct mlx5_core_dev *mlx5e_fs_get_mdev(struct mlx5e_flow_steering *fs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 12492c4a5d410..c19238bc821fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -44,7 +44,7 @@
 
 struct mlx5e_flow_steering {
 	struct work_struct		set_rx_mode_work;
-	bool				state_destroy;
+	bool				rx_mode_active;
 	bool				vlan_strip_disable;
 	struct mlx5_core_dev		*mdev;
 	struct mlx5_flow_namespace      *ns;
@@ -560,7 +560,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_flow_steering *fs)
 	for_each_set_bit(i, fs->vlan->active_svlans, VLAN_N_VID)
 		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	WARN_ON_ONCE(fs->state_destroy);
+	WARN_ON_ONCE(fs->rx_mode_active);
 
 	mlx5e_remove_vlan_trap(fs);
 
@@ -743,7 +743,7 @@ static void mlx5e_handle_netdev_addr(struct mlx5e_flow_steering *fs,
 	mlx5e_for_each_hash_node(hn, tmp, fs->l2.netdev_mc, i)
 		hn->action = MLX5E_ACTION_DEL;
 
-	if (fs->state_destroy)
+	if (fs->rx_mode_active)
 		mlx5e_sync_netdev_addr(fs, netdev, uc, mc);
 
 	mlx5e_apply_netdev_addr(fs);
@@ -840,7 +840,7 @@ void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs,
 		goto update_vport_context;
 	}
 
-	bool rx_mode_enable  = fs->state_destroy;
+	bool rx_mode_enable    = fs->rx_mode_active;
 	bool promisc_enabled   = rx_mode_enable && (netdev->flags & IFF_PROMISC);
 	bool allmulti_enabled  = rx_mode_enable && (netdev->flags & IFF_ALLMULTI);
 	bool broadcast_enabled = rx_mode_enable;
@@ -1479,7 +1479,7 @@ static void mlx5e_fs_debugfs_init(struct mlx5e_flow_steering *fs,
 
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
-					  bool state_destroy,
+					  bool rx_mode_active,
 					  struct dentry *dfs_root)
 {
 	struct mlx5e_flow_steering *fs;
@@ -1490,7 +1490,7 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 		goto err;
 
 	fs->mdev = mdev;
-	fs->state_destroy = state_destroy;
+	fs->rx_mode_active = rx_mode_active;
 	if (mlx5e_profile_feature_cap(profile, FS_VLAN)) {
 		err = mlx5e_fs_vlan_alloc(fs);
 		if (err)
@@ -1606,9 +1606,10 @@ void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_f
 }
 #endif
 
-void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy)
+void mlx5e_fs_set_rx_mode_active(struct mlx5e_flow_steering *fs,
+				 bool rx_mode_active)
 {
-	fs->state_destroy = state_destroy;
+	fs->rx_mode_active = rx_mode_active;
 }
 
 void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 77c54b1702a90..bda57b117250f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6559,8 +6559,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
@@ -6640,8 +6641,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -6652,8 +6654,9 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_state_destroy(priv->fs,
-					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs,
+					    !test_bit(MLX5E_STATE_DESTROYING,
+						      &priv->state));
 
 	if (profile->disable)
 		profile->disable(priv);
-- 
2.53.0



