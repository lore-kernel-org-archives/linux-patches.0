Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214436;
	b=CabfTDZZAxkwcpY3IgcSmm6vK2MMaOamb6j0jg7gRayefaFjsRTjJUlgu8adOCWnP0z5
	 +N74iIIGaMV0j+sJOA9pDBN6nW8cKerl8b1uOFydKEO/8TtJxaCJxn+s71ak0bqfvPJtM
	 GtdXreuY8H+9P1qLf/ZPfsN26UdEv0F8rXS1jLG5MPpQr0uCeN7gda5gjCe77B1ByHCwe
	 ZgOEV1KCuGn2Q0HjxeMRxv5zecFkLV/oRBvFoWT2Eppguot3zL/BnZTECxuL6MVzdMMjK
	 H00Qvul13q+O26shjPmKwtX55HPWQmg/+Nep3q2GkfrKmSb/BHJpijTuwz07wheQV5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQQ/DeXL/aHsVXb9wbHJkjt7M1lF5OkbYwBNUasUkHg=;
	b=ELwHxpnm0OoYnL2yTZhqoz3N4B9gB1SUAJT2dRp1YXVO5iD7DGCZMrKj33mrsoxz8/Vg
	 QYSr+ZOpY4v17zKxOaNHK8WhROXtYFetbd2yxgkpJFzzLEVeCK77Fz2kg7kYFMxUDIu5A
	 Nj0UOoFKSFKFcHUBDnYCGFsn9oSO51Zzj5uP010dJzh1DuWChgELJ5rkrv293W3LvKuXe
	 QJ7ItFjEUduv9co1LnuiW9dRT9W4CH+mTH7KH6IhJ5eDu7Vd4QNiL8QNhYdaVMUh3fPAy
	 /Ooc6s/QoowGyAMu40r1+LjQuHIs9Pgp+dXjE00KiwiG83z/r4L6VHtl0ha2a49kcoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XA/1qIF1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E573606A31E;
	Wed, 28 Oct 2026 19:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XA/1qIF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73D41F01828;
	Wed, 28 Oct 2026 19:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214436;
	bh=BQQ/DeXL/aHsVXb9wbHJkjt7M1lF5OkbYwBNUasUkHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XA/1qIF1VCPqn3KjzEMVTtG69TnlhqeqgzOzjGPAWnbH+L4eg92b3i+spg1G2XvKD
	 CgCJGZu/K3RzqV+Ich9JufDeCvAOe5isyJg1h5JXeIfuMhHBRBEA2yG1/fzR7FAxaY
	 cKc5Xbkw6+zwbYsxwYDGADY45hSsJ3rTuCKrRY0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0815/1887] net/mlx5e: Remove skb secpath if xfrm state is not found
Date: Wed, 28 Oct 2026 17:48:31 +0100
Message-ID: <20261028170517.972048903@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 6d19c44b5c6dd72f9a357d0399604ec16a77de3c ]

Hardware returns a unique identifier for a decrypted packet's xfrm
state, this state is looked up in an xarray. However, the state might
have been freed by the time of this lookup.

Currently, if the state is not found, only a counter is incremented.
The secpath (sp) extension on the skb is not removed, resulting in
sp->len becoming 0.

Subsequently, functions like __xfrm_policy_check() attempt to access
fields such as xfrm_input_state(skb)->xso.type (which dereferences
sp->xvec[sp->len - 1]) without first validating sp->len. This leads to
a crash when dereferencing an invalid state pointer.

This patch prevents the crash by explicitly removing the secpath
extension from the skb if the xfrm state is not found after hardware
decryption. This ensures downstream functions do not operate on a
zero-length secpath.

 BUG: unable to handle page fault for address: ffffffff000002c8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 282e067 P4D 282e067 PUD 0
 Oops: Oops: 0000 [#1] SMP
 CPU: 12 UID: 0 PID: 0 Comm: swapper/12 Not tainted 6.15.0-rc7_for_upstream_min_debug_2025_05_27_22_44 #1 NONE
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:__xfrm_policy_check+0x61a/0xa30
 Code: b6 77 7f 83 e6 02 74 14 4d 8b af d8 00 00 00 41 0f b6 45 05 c1 e0 03 48 98 49 01 c5 41 8b 45 00 83 e8 01 48 98 49 8b 44 c5 10 <0f> b6 80 c8 02 00 00 83 e0 0c 3c 04 0f 84 0c 02 00 00 31 ff 80 fa
 RSP: 0018:ffff88885fb04918 EFLAGS: 00010297
 RAX: ffffffff00000000 RBX: 0000000000000002 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000000002 RDI: 0000000000000000
 RBP: ffffffff8311af80 R08: 0000000000000020 R09: 00000000c2eda353
 R10: ffff88812be2bbc8 R11: 000000001faab533 R12: ffff88885fb049c8
 R13: ffff88812be2bbc8 R14: 0000000000000000 R15: ffff88811896ae00
 FS:  0000000000000000(0000) GS:ffff8888dca82000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffff000002c8 CR3: 0000000243050002 CR4: 0000000000372eb0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  ? try_to_wake_up+0x108/0x4c0
  ? udp4_lib_lookup2+0xbe/0x150
  ? udp_lib_lport_inuse+0x100/0x100
  ? __udp4_lib_lookup+0x2b0/0x410
  __xfrm_policy_check2.constprop.0+0x11e/0x130
  udp_queue_rcv_one_skb+0x1d/0x530
  udp_unicast_rcv_skb+0x76/0x90
  __udp4_lib_rcv+0xa64/0xe90
  ip_protocol_deliver_rcu+0x20/0x130
  ip_local_deliver_finish+0x75/0xa0
  ip_local_deliver+0xc1/0xd0
  ? ip_protocol_deliver_rcu+0x130/0x130
  ip_sublist_rcv+0x1f9/0x240
  ? ip_rcv_finish_core+0x430/0x430
  ip_list_rcv+0xfc/0x130
  __netif_receive_skb_list_core+0x181/0x1e0
  netif_receive_skb_list_internal+0x200/0x360
  ? mlx5e_build_rx_skb+0x1bc/0xda0 [mlx5_core]
  gro_receive_skb+0xfd/0x210
  mlx5e_handle_rx_cqe_mpwrq+0x141/0x280 [mlx5_core]
  mlx5e_poll_rx_cq+0xcc/0x8e0 [mlx5_core]
  ? mlx5e_handle_rx_dim+0x91/0xd0 [mlx5_core]
  mlx5e_napi_poll+0x114/0xab0 [mlx5_core]
  __napi_poll+0x25/0x170
  net_rx_action+0x32d/0x3a0
  ? mlx5_eq_comp_int+0x8d/0x280 [mlx5_core]
  ? notifier_call_chain+0x33/0xa0
  handle_softirqs+0xda/0x250
  irq_exit_rcu+0x6d/0xc0
  common_interrupt+0x81/0xa0
  </IRQ>

Fixes: b2ac7541e377 ("net/mlx5e: IPsec: Add Connect-X IPsec Rx data path offload")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1753256672-337784-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 318695a6aba2c..9646abc630ae1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -331,6 +331,10 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 	xs = mlx5e_ipsec_sadb_rx_lookup(ipsec, sa_handle);
 	if (unlikely(!xs)) {
 		atomic64_inc(&ipsec->sw_stats.ipsec_rx_drop_sadb_miss);
+		/* Clear secpath to prevent invalid dereference
+		 * in downstream XFRM policy checks.
+		 */
+		secpath_reset(skb);
 		return;
 	}
 
-- 
2.53.0



