Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619135;
	b=qgEtiCLSx5hRIcGjZggMiYA9Tu9r8nYn6pPEdA3N8JTNNhkrHhyokVjq2tRjF0gKA9/Z
	 eq507iJC6NgLRuipQHu0yrM1t7EAQcmkBxRJQ/yQY1iHMjfwSTWQTcCrcRmyF1gzOCnbd
	 4lcFcc21ItmevtrhfrsCFJOSv4jc/K2uHV7hgYA7q2V1Q+gUoGt6JceHSJkGYJOTLTRx9
	 1dvSnW78X25mytkBatPPqihlmzaRal+5YqgOATi5dHSmv+gHUV2PMK/zHNGslOZ1v8qAp
	 xBYhXiaVCbjIYphWmqz4oxHwucUqJHkiFpqNgzgpQgIj2Lwpy9y8ELPVLn8gEOdQjIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ce+PWYvJ3QKv9bmx0Kl1AYhPZodwWN/+/obCN+QzCd8=;
	b=Nv2DtGRrlFYHEe5BIy/RRfcsfwhCBSsP2rdrnB+uNMPqVaFcMrR7z0PNAzsUlaDXyr2P
	 J183LovQDF3ox0aXCH58bJ4QUgKuPo4osWbDCh2IPAmef0kI3E0onDK0DMgbs7G0m7psK
	 RL/ZIknI5ekdp40n0GrjKJx6mB5N73fRA2+/RqLFyv1ypV6vGkNZqgzpq1rO9HFAMKlQG
	 F9O44UyAVUNpCOvAi1/Tts14F1bvW/fedikVeTpWsPFBkstwSEequYKrJqD6HOrlVZ18i
	 B9GarMjSOes9v4Y9HnxooXQGwM0PyWywA2El3VHGBF+kAOV0e3cwz+oN/wV8vWWJpDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iXKBm1/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBD606A32D;
	Wed, 25 Nov 2026 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXKBm1/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2AD1F000D1;
	Wed, 25 Nov 2026 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619135;
	bh=Ce+PWYvJ3QKv9bmx0Kl1AYhPZodwWN/+/obCN+QzCd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXKBm1/8/nLzIEdvexn4MAM3l7SJoqOYysaaiYPXhNsunASVb8U/6aB/fFnMrhjnL
	 ZrHIDyu0SiLXCH7tMuDSQfiKv57Xk7d6hSYl+CxqegdylovIJhG1vK/m4VlUOLtARV
	 yrG4iehu395o0ZJJobdrg93wqHzjCYPPabWW+HUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0499/1005] net/mlx5e: Take HCA devcom lock before esw->mode_lock
Date: Wed, 25 Nov 2026 15:30:37 +0100
Message-ID: <20261125143833.433979708@linuxfoundation.org>
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

[ Upstream commit b7e98883eeb72b736dbdeb443e1f43e45f8e5dc1 ]

Uplink ETH driver removal waits for any eswitch operation in progress
before removing REPs. Removal through mlx5_unregister_device() or
mlx5_detach_device() does this while holding the HCA devcom lock, which
is used by peer devices in the same group.

An E-Switch mode change can therefore race with a Socket Direct
secondary device removal:

T1: primary mode set             T2: SD secondary dev removal
mlx5_devlink_eswitch_mode_set()
  sets operation in progress
                                 mlx5_unregister_device()
                                   mlx5_devcom_comp_lock(hca)
                                   ...
                                   mlx5e_remove()
                                     mlx5_sd_get_adev() -> T1 dev
                                     mlx5_eswitch_safe_aux_devs_remove()
                                       waits for T1's operation
  esw_offloads_start()
    esw_mode_change()
      mlx5_devcom_comp_lock(hca)
        waits for T2's lock

The timeout in mlx5_eswitch_safe_aux_devs_remove() makes this not a
deadlock, but representor removal is skipped in that case which is
incorrect.

This bug was found by Sashiko inspecting the next patch in the series,
which removes the timeout. It wasn't reproduced but the scenario seems
plausible, albeit unlikely. This was undetectable by lockdep because the
down_read_trylock() in mlx5_esw_hold() doesn't register as a lock edge,
and also because it can't see the wait on the flag as a lock edge.

Fix the lock order so the HCA devcom lock is taken in
mlx5_devlink_eswitch_mode_set() before esw->mode_lock and held for the
duration of the mode change.
Expanding the HCA devcom lock critical section implies new lock edges
being added, but this is safe:
- mlx5_devlink_netdev_netns_immutable_set() adds HCA devcom -> RTNL, but
  there's already a HCA devcom -> RTNL dependency in
  mlx5_register_device() -..-> register_netdev()
- esw_offloads_disable/enable() -> esw devcom cleanup/init: adds HCA
  devcom -> esw devcom. Nothing takes the HCA devcom lock while holding
  the esw devcom lock.

Fixes: 2ae8c7edea87 ("net/mlx5: Fix Unbinding uplink-netdev in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f298e72eeec53..8dd9d96d499c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2457,8 +2457,8 @@ void mlx5_esw_reps_unblock(struct mlx5_eswitch *esw)
 
 static void esw_mode_change(struct mlx5_eswitch *esw, u16 mode)
 {
+	mlx5_devcom_comp_assert_locked(esw->dev->priv.hca_devcom_comp);
 	mlx5_esw_reps_unblock(esw);
-	mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp);
 	if (esw->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_IB_ADEV ||
 	    mlx5_core_mp_enabled(esw->dev)) {
 		esw->mode = mode;
@@ -2471,7 +2471,6 @@ static void esw_mode_change(struct mlx5_eswitch *esw, u16 mode)
 	esw->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 out:
 	mlx5_rescan_drivers_locked(esw->dev);
-	mlx5_devcom_comp_unlock(esw->dev->priv.hca_devcom_comp);
 	mlx5_esw_reps_block(esw);
 }
 
@@ -4485,10 +4484,11 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		return 0;
 
 	mlx5_lag_disable_change(esw->dev);
+	mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't change mode, E-Switch is busy");
-		goto enable_lag;
+		goto unlock_hca;
 	}
 	cur_mlx5_mode = err;
 	err = 0;
@@ -4551,7 +4551,8 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	esw->eswitch_operation_in_progress = false;
 unlock:
 	mlx5_esw_unlock(esw);
-enable_lag:
+unlock_hca:
+	mlx5_devcom_comp_unlock(esw->dev->priv.hca_devcom_comp);
 	mlx5_lag_enable_change(esw->dev);
 	/* Shared FDB activation is creating LAG which is changing reps. */
 	if (!err)
-- 
2.53.0



