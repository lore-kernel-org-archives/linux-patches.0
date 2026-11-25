Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619307;
	b=HCwEGHvHfV6CAFJgA3w8zsz1TnZaUlwaPm2P4bANHDUOWLq3xFeE9Po6O0FdYX54p+45
	 XKBljzyRvgCcEgUJCy6T8kmsUkDDr4psLiGjH+BO6nT2geSg8zv4DciL/pusZJwfp1WRY
	 Si+aBGCChurwmtp8y3hKk1g5paFzHdb+DtzZsSzzOfcLIVU6chL/LIeNiT9pkfo97dANK
	 b/wLgaxChqalvT4tXN492D04Vr21JVxJ+TExHL+A20P2XGlMmtCtVOGR9v49wHT8j0K9Q
	 gkgUytjX7uSbylLpLwYEdiPJIS6ghQtNPChGJR4KrOK6920ZGbr8YarRUOYIhprRrEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=apfowAK8RTiQ/LRQ4LajhJYA6RRCw36ufZfXI5kqUms=;
	b=lgvp28HdE0Lw1aGGn7Ee5WAhVC6i2BIN7NabBlCk/78kBdTO9ewo9h4+ctmYSF1M5H0Q
	 /Dg7D5htn/TAPGenlvOFgNWbKg8Tnl58phKOueFdy5YXi/ykGn2R9wk2ym+qg/FNmkHf3
	 oUeTvyfgzlMgn/TvGMjQoXQRnUgqd7D666x1IYyM0ORGJjMG0dlLoPHXxov/7glUDRkRx
	 eOOhVcTJkAHTSTu36kwR9fenfQ0NVRNRioia/S0wnBgAk47EiT/Qp8R604IYGT/GiaNYd
	 iuQQ2XR5DzlnYYup6Al9FGfvHKjbXQ9k+MFAJBP+H3z3E5O2FJCSyMw0TrlpFUIGu/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8O3TcP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D5E606A321;
	Wed, 25 Nov 2026 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8O3TcP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF971F000C0;
	Wed, 25 Nov 2026 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619307;
	bh=apfowAK8RTiQ/LRQ4LajhJYA6RRCw36ufZfXI5kqUms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8O3TcP46ov6zzc7fkIeZO/Fj4ZEImb+8PMmnH3z1/vP+jvfJCrD80SscdlaanjNE
	 KtWpndcDptZzWo8tdzHswap2fwTwzkTajMx+16XDJ0De6awNtGe6tm3JeND0OM8mxk
	 IgHD+gk4A64kx4oww8tBiXMxesdzvKABGtUC5JdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0500/1005] net/mlx5e: Fix E-Switch races in uplink unbind
Date: Wed, 25 Nov 2026 15:30:38 +0100
Message-ID: <20261125143833.457478295@linuxfoundation.org>
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

[ Upstream commit 5eaf9931c8af41b1f0de6dc0589efa698784157c ]

Unbinding the uplink Ethernet auxiliary driver in switchdev mode with
offloaded IPsec policies deadlocks on the esw->mode_lock semaphore:
mlx5_eswitch_safe_aux_devs_remove()
  mlx5_esw_hold()
    down_read_trylock(&esw->mode_lock)                 (*)
  mlx5_core_reps_aux_devs_remove()
    ...
    mlx5e_vport_uplink_rep_unload()
      unregister_netdev()
        xfrm_dev_unregister()
          xfrm_dev_policy_flush()
            xfrm_policy_kill()
              xfrm_dev_policy_delete()
                mlx5e_xfrm_del_policy()
                  mlx5e_accel_ipsec_fs_del_pol()
                    rx_ft_put_policy()
                      rx_put()
                        mlx5_eswitch_unblock_mode()
                          down_write(&esw->mode_lock)  (BOOM)

Another deadlock with IPsec states:
mlx5_eswitch_safe_aux_devs_remove()
  mlx5_esw_hold()
    down_read_trylock(&esw->mode_lock)                (*)
  mlx5_core_reps_aux_devs_remove()
    ...
    mlx5e_vport_uplink_rep_unload()
      unregister_netdev()
        xfrm_dev_unregister()
          xfrm_dev_state_flush()
            xfrm_dev_state_free()
              mlx5e_xfrm_free_state()
                mlx5e_accel_ipsec_fs_del_rule()
                  rx_ft_put()
                    rx_put()
                      rx_destroy()
                        mlx5_eswitch_unblock_encap()
                          down_write(&esw->mode_lock)  (BOOM)

To fix these, first refactor initiators of eswitch operations so they no
longer step on each other's toes.

The active/inactive toggle and setting the inline/encap mode now use the
new mlx5_esw_lock_wait(), which waits for an operation in progress to
finish. They all hold devl_lock, so the only operation they can find in
progress is an uplink unbind, which doesn't need devl_lock.
Setting the esw mode keeps using mlx5_esw_try_lock(), which also rejects
the change while eswitch users exist and bails out with -EBUSY.

mlx5_eswitch_safe_aux_devs_remove() now also waits for an operation in
progress with the same mlx5_esw_lock_wait() before initiating one,
dropping mode_lock and then removing representors.
The deadlocks are avoided.

Finishing an operation in progress now requires mlx5_esw_unlock() to
wake up any waiters instead of plain up_write(&mode_lock).

As a side effect, the timeout in mlx5_eswitch_safe_aux_devs_remove() is
gone, which fixes another scary corner case, of representor devs not
being removed on timeout but leaked instead. The timeout hid the SD
deadlock fixed in the previous patch. Now that that's gone, no reason
for the timeout to stay.

This was found by internal testing and reproduced on HW.
It was independently found by Sashiko during analysis of another patch
in this series.

Fixes: 2ae8c7edea87 ("net/mlx5: Fix Unbinding uplink-netdev in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 50 +++++++++----------
 3 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 603e8ae72734c..07bea6b0e3d68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -3039,12 +3039,36 @@ int mlx5_esw_lock(struct mlx5_eswitch *esw)
 	return 0;
 }
 
+static void esw_mode_lock(struct mlx5_eswitch *esw)
+{
+	down_write(&esw->mode_lock);
+}
+
+static void esw_mode_unlock(struct mlx5_eswitch *esw)
+{
+	up_write(&esw->mode_lock);
+}
+
+/* Lock the eswitch and wait for an operation in progress to finish. */
+void mlx5_esw_lock_wait(struct mlx5_eswitch *esw)
+{
+	down_write(&esw->mode_lock);
+	wait_var_event_any_lock(&esw->eswitch_operation_in_progress,
+				!esw->eswitch_operation_in_progress,
+				esw, esw_mode, TASK_UNINTERRUPTIBLE);
+}
+
 /**
  * mlx5_esw_unlock() - Release write lock on esw mode lock
  * @esw: eswitch device.
+ *
+ * Also wakes up mlx5_esw_lock_wait() waiters, so it must be used to release
+ * mode_lock after clearing eswitch_operation_in_progress.
  */
 void mlx5_esw_unlock(struct mlx5_eswitch *esw)
 {
+	wake_up_var_locked(&esw->eswitch_operation_in_progress,
+			   &esw->mode_lock);
 	up_write(&esw->mode_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c904860df7b3e..c0f2af86a9342 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -948,6 +948,7 @@ void mlx5_esw_get(struct mlx5_core_dev *dev);
 void mlx5_esw_put(struct mlx5_core_dev *dev);
 int mlx5_esw_try_lock(struct mlx5_eswitch *esw);
 int mlx5_esw_lock(struct mlx5_eswitch *esw);
+void mlx5_esw_lock_wait(struct mlx5_eswitch *esw);
 void mlx5_esw_unlock(struct mlx5_eswitch *esw);
 
 void esw_vport_change_handle_locked(struct mlx5_vport *vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8dd9d96d499c9..0debb02fea268 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4418,7 +4418,7 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
 	    !esw->offloads_inactive)
 		return false;
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 	esw->offloads_inactive = !esw->offloads_inactive;
 	esw->eswitch_operation_in_progress = true;
 	up_write(&esw->mode_lock);
@@ -4430,34 +4430,30 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
 
 	down_write(&esw->mode_lock);
 	esw->eswitch_operation_in_progress = false;
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return true;
 }
 
-#define MLX5_ESW_HOLD_TIMEOUT_MS 7000
-#define MLX5_ESW_HOLD_RETRY_DELAY_MS 500
-
 void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
 {
-	unsigned long timeout;
-	bool hold_esw = true;
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
-	/* Wait for any concurrent eswitch mode transition to complete. */
-	if (!mlx5_esw_hold(dev)) {
-		timeout = jiffies + msecs_to_jiffies(MLX5_ESW_HOLD_TIMEOUT_MS);
-		while (!mlx5_esw_hold(dev)) {
-			if (!time_before(jiffies, timeout)) {
-				hold_esw = false;
-				break;
-			}
-			msleep(MLX5_ESW_HOLD_RETRY_DELAY_MS);
-		}
-	}
-	if (hold_esw) {
-		if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
-			mlx5_core_reps_aux_devs_remove(dev);
-		mlx5_esw_release(dev);
-	}
+	if (!mlx5_esw_allowed(esw))
+		return;
+
+	/* Wait for any concurrent eswitch mode transition to complete.
+	 * Deadlock risk if ever called from within an operation in progress.
+	 */
+	mlx5_esw_lock_wait(esw);
+	esw->eswitch_operation_in_progress = true;
+	up_write(&esw->mode_lock);
+
+	if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
+		mlx5_core_reps_aux_devs_remove(dev);
+
+	down_write(&esw->mode_lock);
+	esw->eswitch_operation_in_progress = false;
+	mlx5_esw_unlock(esw);
 }
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
@@ -4633,7 +4629,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
@@ -4671,7 +4667,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 
 	down_write(&esw->mode_lock);
 	esw->eswitch_operation_in_progress = false;
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return 0;
 
 out:
@@ -4741,7 +4737,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_esw_lock_wait(esw);
 
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
@@ -4797,7 +4793,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	esw->eswitch_operation_in_progress = false;
 
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 	return err;
 }
 
-- 
2.53.0



