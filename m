Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021320;
	b=q/10cleDIDfBbfMixv4BoWFjZhHEChEdnK6DmO4kv4K5RH3Lu5SFnJ31sUJxXOuALvTC
	 zzpOX6221y2yZjDJ1wmup2SD9Aw92LJhKKq7WoQkDOv03U0U8iYyG9wtXWK1CB18xXVHk
	 VcADGgGvie+9SQfDhhc0MY6cnqGDr+tUMPvvN3xmzhI383eG6O+ct0Wz+cpB4nrVf40sD
	 Oyp3aYXM7mYYNeio10dFYPZBwW8owqJK+2YRiEAjHkr9xcV+pmuvj/F7Ie0BWSSd9UfVR
	 KSHYZLdsjmJO4OWOuFn6j4Ia4hRjFlDhuDkPxso25gq4j6M+5ZoUOslF3RLXTyRRAOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pEKUZnEREQQ3Lz2gENiirs8q1GIQ9CD0dJR/SsY7TdE=;
	b=SbAvA987iOrYF/w9pTFV08bDMhvHpK4EG5C7GPbUFrQp3k1EkMMl8NaTYP0boEi/vriM
	 9gF9XqqEOGabPbvdAOX3mnS5AteH09gGtm4fJothz+5/6LSVq0mQH62O8x+n4tMdF8DiF
	 KrD8//f9y5GVunSHZdI7rkWx/4lRMvHr8pH+3a8SVJqFczYbx1p43w8DbFrpyZGSAJxz2
	 NcAjuByvpmY5e93HRQAvx6q7i7ikD6Yc3mfFK9keAl6iEDdV5Vm31TYVIa+u2Z4yQCJoZ
	 mhpqtMr1zuMT3zzfGDdNgbdA+/uStlXUviuHRL2/7v4GBLeGsfu61k6KDs9IsSPTPnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Afw0l+Q5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BE9606A320;
	Wed, 18 Nov 2026 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Afw0l+Q5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7F41F000C5;
	Wed, 18 Nov 2026 17:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021319;
	bh=pEKUZnEREQQ3Lz2gENiirs8q1GIQ9CD0dJR/SsY7TdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Afw0l+Q5M4AC0Zxh1ipXcvbO4qdMuT7VEyhAN8m4J/OpRPK5e3IH66jdwlxtA2fQ5
	 ac2/e6FKikAkl63T3RbGvhF3uE8HqQvYqSAVZNklZsPRkpnlKk7BQd2m7agkog6OFX
	 o6hNJAUMeuviHs36KIWMrm4hf+Ol6pdJfmkemrHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Dimitri Daskalakis <daskald@meta.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2264/2651] net/mlx5e: Update netdev features only after a successful ringparam set
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150406.898804130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <daskald@meta.com>

[ Upstream commit 23dd5be7e19ceab8c1c79110ee3552bcabc463ef ]

mlx5 couples HW-GRO with tcp-data-split. If a user sets rx-gro-hw on ->
tcp-data-split on -> rx-gro-hw off, the driver will leave HW-GRO on.
mlx5e_ethtool_set_tcp_data_split() calls netdev_update_features() when
tcp-data-split goes from enabled to disabled in case HW-GRO needs to be
released. mlx5e_fix_features() reads the new HDS config from
dev->cfg_pending, so HW-GRO is released before all ring parameters are
validated.

If the subsequent call to mlx5e_ethtool_set_ringparam() fails, the
ethtool core discards the pending change and reports tcp-data-split
enabled. The device is no longer splitting, and subsequent ring changes
are blocked.

Move the call to netdev_update_features() after
mlx5e_ethtool_set_ringparam() exits successfully.

The issue was discovered by manual code inspection during review of
a change that stops mlx5 users from disabling tcp-data-split. It was
reproduced on a ConnectX-7 with ethtool alone.

Steps to reproduce:
ethtool -K eth0 rx-gro-hw on
ethtool -G eth0 tcp-data-split on
ethtool -K eth0 rx-gro-hw off # HW-GRO kept on for tcp-data-split

ethtool -G eth0 tcp-data-split off rx 1 # de-sync driver & kernel state
 netlink error: mlx5_core: rx (1) < min (16)
 netlink error: Invalid argument

ethtool -G eth0 rx 1024 # valid ring changes are now blocked
 netlink error: mlx5_core: TCP-data-split is not supported when GRO HW is disabled
 netlink error: Invalid argument

This is not a terminal state, users can recover by setting rx-gro-hw on.
With the fix, the failing ringparam set leaves rx-gro-hw on and later
ring changes succeed.

Fixes: 46bcce5dfd33 ("net/mlx5e: Support ethtool tcp-data-split settings")
Reported-by: Björn Töpel <bjorn@kernel.org>
Closes: https://lore.kernel.org/87se2grw3d.fsf@all.your.base.are.belong.to.us/
Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261017005401.1582755-1-dimitri.daskalakis1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c    | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 3ed59ced0407a..f38e033ab8faf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -403,11 +403,6 @@ static bool mlx5e_ethtool_set_tcp_data_split(struct mlx5e_priv *priv,
 		return false;
 	}
 
-	/* Might need to disable HW-GRO if it was kept on due to hds. */
-	if (tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
-	    dev->cfg->hds_config == ETHTOOL_TCP_DATA_SPLIT_ENABLED)
-		netdev_update_features(priv->netdev);
-
 	return true;
 }
 
@@ -468,13 +463,23 @@ static int mlx5e_set_ringparam(struct net_device *dev,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	int err;
 
 	if (!mlx5e_ethtool_set_tcp_data_split(priv,
 					      kernel_param->tcp_data_split,
 					      extack))
 		return -EINVAL;
 
-	return mlx5e_ethtool_set_ringparam(priv, param, extack);
+	err = mlx5e_ethtool_set_ringparam(priv, param, extack);
+	if (err)
+		return err;
+
+	/* Might need to disable HW-GRO if it was kept on due to hds. */
+	if (kernel_param->tcp_data_split == ETHTOOL_TCP_DATA_SPLIT_DISABLED &&
+	    dev->cfg->hds_config == ETHTOOL_TCP_DATA_SPLIT_ENABLED)
+		netdev_update_features(priv->netdev);
+
+	return 0;
 }
 
 void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv,
-- 
2.53.0



