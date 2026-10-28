Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215818;
	b=bLfHjy/w+tjyw4PDHXPscp3akqF4detv/sbIobxicWjfJF9l98Jg03dws0OqyKCfbe+R
	 h1Wr7t/BL/rHL3jKmBL6TO9a3ZukWu6MBL6//irgUPMBbY7z5myVti3LFT6ys4LyvyMQJ
	 xSF8iRqaiNuDYxmZE4/+/UQgEYfAsC6HH6J07tK+qvFMU2Q7DeMxfe1IvM0INsElhZIUd
	 Kus66GbMWzalxOCbeaEzXbqonQHIOMGXJsDNv0yCYEqes6iUSihuuxABp0TSdp2IrWEDP
	 8VHq0hNIn+XRy8F99jEJhsmKAX0u1Dx3dtPqA/CKxx3XqRMqxuyHURWCnMxqUAhn+Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUvi1iS9RihZEZKxBUrfAWH4EbnQv09vStgc6lA46AI=;
	b=LPI+kquid8VS/XJPieP0EFz2soNWK7MMnZcxB77mrPMIh29E9EwcOC8nY9t2nmy024LX
	 j6fZpZ/XNjkCi4iMaDoFSHt3u6qbEpBZsDDPf7WmGSSW+lLnPRJc79Qh6jmYf4ZGSw54O
	 QZNLx9stMBLFhFJfl7qZtNIF9z+fwBb31qc4fQx6VcvyMavRKKzQtpOepy+YLeZwwOzFe
	 UYGBhhynZs37CkHb6Gzp80N6+SlSPH3BZdAAYElYCcMptDealHyHx8NR/Iy/00mAGm9C/
	 EiszSlnMDtUGtB2xz/m+uMRtg1ZFnlFOyEj8iXdXq+JTa/+ugn107/YbBOhCTq6tU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDMlWp0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147C1606A320;
	Wed, 28 Oct 2026 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDMlWp0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641671F01825;
	Wed, 28 Oct 2026 19:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215817;
	bh=bUvi1iS9RihZEZKxBUrfAWH4EbnQv09vStgc6lA46AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDMlWp0NxnZjSdpzvzoPAdeZ02pVr9fPCF9OGtGgFoMExGekFqiRDIWm4xMLOHuiZ
	 f+jodHlzefAlGYnb+orDYn62AxiGXgq+7hH/WsqKNKbds41kXA99hYxZ8jjy0V4DfL
	 fD+qA2fIrg2geo7t6XVt8st5joqhT5dn7WKb1MDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1343/1887] net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock
Date: Wed, 28 Oct 2026 17:57:19 +0100
Message-ID: <20261028170530.003666406@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 6ddfba2ea98db21b001e0e5c472499156224650c ]

In case __mlx5e_add_fdb_flow() fails in lower levels, the flow is
deleted via mlx5e_tc_del_flow(), and mlx5e_tc_del_flow() is acquiring
ESW devcom lock without condition. In addition, in case of peer_flow,
__mlx5e_add_fdb_flow() is called while holding ESW devcom comp lock.
This results in an AA deadlock.

To fix this, introduce a new PEER flag that is set on flows created as
peer flows (the duplicate flows on peer devices), and check it in
mlx5e_tc_del_flow() before acquiring ESW devcom lock.

Lockdep splat:
============================================
WARNING: possible recursive locking detected
============================================
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(&comp->lock_key#2);
  lock(&comp->lock_key#2);
 *** DEADLOCK ***
Call Trace:
 <TASK>
 dump_stack_lvl+0x69/0xa0
 print_deadlock_bug.cold+0xbd/0xca
 __lock_acquire+0x1671/0x2ec0
 lock_acquire+0x10e/0x2e0
 down_read+0x95/0x430
 mlx5_devcom_for_each_peer_begin+0x4e/0xe0 [mlx5_core]
 mlx5e_tc_del_flow+0x11d/0xa70 [mlx5_core]
 mlx5e_flow_put+0x99/0x100 [mlx5_core]
 __mlx5e_add_fdb_flow+0x409/0xf00 [mlx5_core]
 mlx5e_configure_flower+0x2a86/0x4100 [mlx5_core]
 mlx5e_rep_setup_tc_cls_flower+0x12f/0x1b0 [mlx5_core]
 mlx5e_rep_setup_tc_cb+0x153/0x750 [mlx5_core]
 tc_setup_cb_add+0x1dc/0x470
 fl_change+0x2f4d/0x626d [cls_flower]
 tc_new_tfilter+0x79b/0x2310
 rtnetlink_rcv_msg+0x778/0xad0
 do_syscall_64+0x70/0x960
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>

Fixes: 04de7dda7394 ("net/mlx5e: Infrastructure for duplicated offloading of TC flows")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260728044338.2271143-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 2e42d7c5451e9..b474fdbd6eb5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_PEER                  = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d2f226a09a0c7..11df2761c1393 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2005,7 +2005,8 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow)
 {
 	if (mlx5e_is_eswitch_flow(flow)) {
-		mlx5e_tc_del_fdb_peer_flow(flow);
+		if (!flow_flag_test(flow, PEER))
+			mlx5e_tc_del_fdb_peer_flow(flow);
 		mlx5e_tc_del_fdb_flow(priv, flow);
 	} else {
 		mlx5e_tc_del_nic_flow(priv, flow);
@@ -4389,6 +4390,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 	else
 		in_mdev = priv->mdev;
 
+	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_PEER);
 	parse_attr = flow->attr->parse_attr;
 	peer_flow = __mlx5e_add_fdb_flow(peer_priv, f, flow_flags,
 					 parse_attr->filter_dev,
-- 
2.53.0



