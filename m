Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619459;
	b=FLY1ZqbZ6Ix4XSFYOj6nHFkkLpwKcBmQTCKS6q0zN5+s5qshRoNtaFMK4GaQyADYlKkD
	 upRoV9eUMtBoVbNHuZ1dvvbjZ2ZeuE0xRH9BCGMaWZzrcMUT2XyLRPsS4B15Bq2ycG9My
	 Hra5l0cvx/huW3SqMG6/0UL1VN/iR0Sx/fIHEM++rpshzWZhW6Xdk4lT5bHHg7E5Uprfd
	 WiPL2Llx6Fv2727o+rHi5v0xhX8l4Br/zJfy/vn20hSoqHcIqv5bKv9Z9yLRwYOJhmngS
	 /q733fmxjYcNLOHOm9Ns1OSNTOzACywKGiLGiOmu/mAhIbidMrFqgOAh50vGGDrZTqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wKx+Ft/wkxQ47rvMabZiBhmFQrY2DnPvZ2JGFnfPDsM=;
	b=xC3hX3GRoIaWY9fri518SdPswgerj/CMpwxtFdOjjBlcgv7Xk8kfB50nKOsEhgl06uXe
	 n8P2jq/J2OE+YV67pQzl60+DLecZ/9p51lyOyjObQh2d1+wh8u+8YK23SU15yJSfvuucF
	 d1kidlTU/IVKQEB4B1H/GQNXdtPuFXnoyl1RRx0k/W2bH0s4uGKde4FYfwXLRql8MtYcw
	 hUSbeKKGcve8D8GU/gLBuYKm2L+9u0IVPkm681VGQoINRUeK+OM6ZR4SHYU6G3SVGa7U/
	 SyXxqxqkEF+pq8tYVteQNL3z6ZDQb/UEwhq9BgM3AdtaGR8Mq9XbRRe2OFEuHnJC7hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEBYF+B1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559D8606A31E;
	Wed, 25 Nov 2026 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nEBYF+B1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967961F000D4;
	Wed, 25 Nov 2026 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619459;
	bh=wKx+Ft/wkxQ47rvMabZiBhmFQrY2DnPvZ2JGFnfPDsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEBYF+B1PNbDwo2LfkYDnAj0Ksr063gQ7QzRxcWQQIqpDI4Y3ANXSb8Khv5KCawNA
	 WkGcod40lP6juiExSMmLcdFCLpDC161sj8HGshahaEjTsg2qy3atT2Nr9PhIFym0Mg
	 iupT+q4Ec2LyiBNl92MuWO4K+iNJ+uxhM8VzRK8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0548/1005] net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup on RX init failure
Date: Wed, 25 Nov 2026 15:31:26 +0100
Message-ID: <20261125143834.582141261@linuxfoundation.org>
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

[ Upstream commit 3962ded998c1df8a449fdf986f44f478e9c09675 ]

mlx5e_attach_netdev() sets rx_mode_active before calling init_rx(), so
any init_rx() failure after mlx5e_create_flow_steering() has succeeded
makes mlx5e_destroy_flow_steering() trip
WARN_ON_ONCE(fs->rx_mode_active) in mlx5e_del_vlan_rules().

Hit in internal regression testing, so kthread creation failed
with -EINTR:

  WARNING: CPU: 3 PID: 170 at drivers/net/ethernet/mellanox/mlx5/core/en_fs.c:564 mlx5e_del_vlan_rules+0x295/0x2b0 [mlx5_core]
  mlx5e_destroy_flow_steering+0x34/0xc0 [mlx5_core]
  mlx5e_init_nic_rx+0x137/0x200 [mlx5_core]
  mlx5e_attach_netdev+0x105/0x360 [mlx5_core]

Fix it by creating NIC flow steering with rx_mode_active cleared and
setting it only after profile->init_rx() succeeds. This also lets the
internal error paths of mlx5e_create_flow_steering() destroy partially
created steering without warning. The flag is set in
mlx5e_attach_netdev() rather than mlx5e_init_nic_rx() so that non-NIC
profiles, such as representors, also get it set after a detach/attach
cycle.

Fixes: 8c7353b6f716 ("net/mlx5e: Fix VLAN cleanup flow")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261111082142.3131746-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 ++++++++-----------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bda57b117250f..964d976c5c890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6039,9 +6039,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	priv->dfs_root = debugfs_create_dir("nic",
 					    mlx5_debugfs_get_dev_root(mdev));
 
-	fs = mlx5e_fs_init(priv->profile, mdev,
-			   !test_bit(MLX5E_STATE_DESTROYING, &priv->state),
-			   priv->dfs_root);
+	fs = mlx5e_fs_init(priv->profile, mdev, false, priv->dfs_root);
 	if (!fs) {
 		err = -ENOMEM;
 		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
@@ -6558,10 +6556,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	int err;
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
@@ -6622,6 +6616,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	if (err)
 		goto err_cleanup_tx;
 
+	if (priv->fs)
+		mlx5e_fs_set_rx_mode_active(priv->fs, true);
+
 	if (profile->enable) {
 		err = profile->enable(priv);
 		if (err)
@@ -6633,6 +6630,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	return 0;
 
 err_cleanup_rx:
+	if (priv->fs) {
+		mlx5e_fs_set_rx_mode_active(priv->fs, false);
+		cancel_work_sync(&priv->set_rx_mode_work);
+	}
 	profile->cleanup_rx(priv);
 err_cleanup_tx:
 	profile->cleanup_tx(priv);
@@ -6640,10 +6641,6 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 out:
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
-	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -6654,9 +6651,7 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		mlx5e_fs_set_rx_mode_active(priv->fs,
-					    !test_bit(MLX5E_STATE_DESTROYING,
-						      &priv->state));
+		mlx5e_fs_set_rx_mode_active(priv->fs, false);
 
 	if (profile->disable)
 		profile->disable(priv);
-- 
2.53.0



