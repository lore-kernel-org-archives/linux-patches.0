Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213759;
	b=FocEbdyrClu/W+txFRCYrmzqhptmyvH6c93houMesL5RID71wrSgaR1kU0gg1xQP+1w2
	 0bLKYITE1fmnWeFwZbXtLSBZXNq8F8YZFWbPuCUSw6Aaquurdacji7e+/W+3llcrVEr4A
	 x0h+lXxeGECFMWralxdGw9e4TOzeGmJtrtsXzUKT1ylMcJvJ8BwxWKzJ/yHrox0OImsbo
	 dO182InqLi3uHIdR/hsmbnjZ5vEi3HQw6zsuEtT9zj0woY8eRDEy9YZuVoJ+yZ4POKYZB
	 eN5NCh1d+9WRZYNorjbyxu8v1/WW4VVSwaURgbidOiw2gTujQEoHk0LvZhI2Tse3QnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3aRIj1LoQkSP7sZo3/lDU4/pkDpPgo6tPH7KCIp2je0=;
	b=xE9A8z//MDhP4WgBZ4jEOOtOFq8kVUGJtfMnNn6/+CMYkT9du8khPIYF5MH0m4PmtDz/
	 kMDM2ZfNJmPfda0A+z3UXHKmjiHWfMHkGCSyon3k+9DiAZK764DeM/L8gPUEvRTnrayGT
	 KJXXZPn9+t7oJlCTBVAbw+3218SWiFuwDbmio5eP++MhurTN5//U7/ApWZU59CwCueM8J
	 +5INaNUjjZNgN6Hzdl64pU5oqJn5NJg1MHUc0hLnhYQbXanUqqE09OPD5x4DbJpk4KPZY
	 DGtCWxQ6D4WpJkOUbUYC9cmghpMVwrHZliQMKmZZn+u5yl6Y4RneXWceid2wtmAiq1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XC37Qd+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BBC606A31D;
	Wed, 28 Oct 2026 18:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XC37Qd+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC11F01825;
	Wed, 28 Oct 2026 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213759;
	bh=3aRIj1LoQkSP7sZo3/lDU4/pkDpPgo6tPH7KCIp2je0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XC37Qd+4GX8aoz328tgLt7ZBuG6NMoaW8+jpFxU6zSDJcZMeOJuV5xqJ/O0ulJHcK
	 0fU+phLC9W5avCkskE03G5z8KVunXFAKHJ2OXqwjnoRns9U7kwaY9ITq0OB0EvDgx3
	 ML5MYv1dV6tLJYedLcyeO6MGJhS10q4fCmtdBovY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0617/1887] net/mlx5: Reload only IB representors upon lag disable/enable
Date: Wed, 28 Oct 2026 17:45:13 +0100
Message-ID: <20261028170513.451055037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 0f06228d4a2dcc1fca5b3ddb0eefa09c05b102c4 ]

On lag disable, the bond IB device along with all of its
representors are destroyed, and then the slaves' representors get reloaded.

In case the slave IB representor load fails, the eswitch error flow
unloads all representors, including ethernet representors, where the
netdevs get detached and removed from lag bond. Such flow is inaccurate
as the lag driver is not responsible for loading/unloading ethernet
representors. Furthermore, the flow described above begins by holding
lag lock to prevent bond changes during disable flow. However, when
reaching the ethernet representors detachment from lag, the lag lock is
required again, triggering the following deadlock:

Call trace:
__switch_to+0xf4/0x148
__schedule+0x2c8/0x7d0
schedule+0x50/0xe0
schedule_preempt_disabled+0x18/0x28
__mutex_lock.isra.13+0x2b8/0x570
__mutex_lock_slowpath+0x1c/0x28
mutex_lock+0x4c/0x68
mlx5_lag_remove_netdev+0x3c/0x1a0 [mlx5_core]
mlx5e_uplink_rep_disable+0x70/0xa0 [mlx5_core]
mlx5e_detach_netdev+0x6c/0xb0 [mlx5_core]
mlx5e_netdev_change_profile+0x44/0x138 [mlx5_core]
mlx5e_netdev_attach_nic_profile+0x28/0x38 [mlx5_core]
mlx5e_vport_rep_unload+0x184/0x1b8 [mlx5_core]
mlx5_esw_offloads_rep_load+0xd8/0xe0 [mlx5_core]
mlx5_eswitch_reload_reps+0x74/0xd0 [mlx5_core]
mlx5_disable_lag+0x130/0x138 [mlx5_core]
mlx5_lag_disable_change+0x6c/0x70 [mlx5_core] // hold ldev->lock
mlx5_devlink_eswitch_mode_set+0xc0/0x410 [mlx5_core]
devlink_nl_cmd_eswitch_set_doit+0xdc/0x180
genl_family_rcv_msg_doit.isra.17+0xe8/0x138
genl_rcv_msg+0xe4/0x220
netlink_rcv_skb+0x44/0x108
genl_rcv+0x40/0x58
netlink_unicast+0x198/0x268
netlink_sendmsg+0x1d4/0x418
sock_sendmsg+0x54/0x60
__sys_sendto+0xf4/0x120
__arm64_sys_sendto+0x30/0x40
el0_svc_common+0x8c/0x120
do_el0_svc+0x30/0xa0
el0_svc+0x20/0x30
el0_sync_handler+0x90/0xb8
el0_sync+0x160/0x180

Thus, upon lag enable/disable, load and unload only the IB representors
of the slaves preventing the deadlock mentioned above.

While at it, refactor the mlx5_esw_offloads_rep_load() function to have
a static helper method for its internal logic, in symmetry with the
representor unload design.

Fixes: 598fe77df855 ("net/mlx5: Lag, Create shared FDB when in switchdev mode")
Co-developed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509112951.590184-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 28 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 ++++----
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 00d169a11a0a8..b410e836169fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -746,7 +746,7 @@ int mlx5_eswitch_offloads_config_single_fdb(struct mlx5_eswitch *master_esw,
 					    struct mlx5_eswitch *slave_esw);
 void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
-int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
+int mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw);
 
 static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
 {
@@ -798,7 +798,7 @@ mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 					 struct mlx5_eswitch *slave_esw) {}
 
 static inline int
-mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
+mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2a64d0fd2fe52..3e2f28c08b2b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2405,6 +2405,16 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 	return err;
 }
 
+static int __esw_offloads_load_rep(struct mlx5_eswitch *esw,
+				   struct mlx5_eswitch_rep *rep, u8 rep_type)
+{
+	if (atomic_cmpxchg(&rep->rep_data[rep_type].state,
+			   REP_REGISTERED, REP_LOADED) == REP_REGISTERED)
+		return esw->offloads.rep_ops[rep_type]->load(esw->dev, rep);
+
+	return 0;
+}
+
 static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 				      struct mlx5_eswitch_rep *rep, u8 rep_type)
 {
@@ -2453,13 +2463,11 @@ int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
 	int err;
 
 	rep = mlx5_eswitch_get_rep(esw, vport_num);
-	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
-		if (atomic_cmpxchg(&rep->rep_data[rep_type].state,
-				   REP_REGISTERED, REP_LOADED) == REP_REGISTERED) {
-			err = esw->offloads.rep_ops[rep_type]->load(esw->dev, rep);
-			if (err)
-				goto err_reps;
-		}
+	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
+		err = __esw_offloads_load_rep(esw, rep, rep_type);
+		if (err)
+			goto err_reps;
+	}
 
 	return 0;
 
@@ -3102,7 +3110,7 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
-int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
+int mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw)
 {
 	struct mlx5_eswitch_rep *rep;
 	unsigned long i;
@@ -3115,13 +3123,13 @@ int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
 	if (atomic_read(&rep->rep_data[REP_ETH].state) != REP_LOADED)
 		return 0;
 
-	ret = mlx5_esw_offloads_rep_load(esw, MLX5_VPORT_UPLINK);
+	ret = __esw_offloads_load_rep(esw, rep, REP_IB);
 	if (ret)
 		return ret;
 
 	mlx5_esw_for_each_rep(esw, i, rep) {
 		if (atomic_read(&rep->rep_data[REP_ETH].state) == REP_LOADED)
-			mlx5_esw_offloads_rep_load(esw, rep->vport);
+			__esw_offloads_load_rep(esw, rep, REP_IB);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4b4d761081115..e127cbdf2bbf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -796,9 +796,9 @@ void mlx5_disable_lag(struct mlx5_lag *ldev)
 
 	if (shared_fdb) {
 		if (!(dev0->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV))
-			mlx5_eswitch_reload_reps(dev0->priv.eswitch);
+			mlx5_eswitch_reload_ib_reps(dev0->priv.eswitch);
 		if (!(dev1->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV))
-			mlx5_eswitch_reload_reps(dev1->priv.eswitch);
+			mlx5_eswitch_reload_ib_reps(dev1->priv.eswitch);
 	}
 }
 
@@ -898,17 +898,17 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
 
-			err = mlx5_eswitch_reload_reps(dev0->priv.eswitch);
+			err = mlx5_eswitch_reload_ib_reps(dev0->priv.eswitch);
 			if (!err)
-				err = mlx5_eswitch_reload_reps(dev1->priv.eswitch);
+				err = mlx5_eswitch_reload_ib_reps(dev1->priv.eswitch);
 
 			if (err) {
 				dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 				mlx5_rescan_drivers_locked(dev0);
 				mlx5_deactivate_lag(ldev);
 				mlx5_lag_add_devices(ldev);
-				mlx5_eswitch_reload_reps(dev0->priv.eswitch);
-				mlx5_eswitch_reload_reps(dev1->priv.eswitch);
+				mlx5_eswitch_reload_ib_reps(dev0->priv.eswitch);
+				mlx5_eswitch_reload_ib_reps(dev1->priv.eswitch);
 				mlx5_core_err(dev0, "Failed to enable lag\n");
 				return;
 			}
-- 
2.53.0



