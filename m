Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017867;
	b=E0QUYGpMuJH1PJ3UfmpyUX4Z5MxUoG2vfR0LJ5PG2tWuBhGoaxH9QvJfix5Nj/Jm4goR
	 bFb9zZu1Y25lDicBzZuHazT5usg9luTwetWn7S/GvK1WqXohgRSt3hp74PMZMM5X+BG3E
	 04NCEedpAj2d/zsOaowtQlnDIc/BOtVIcX42I6DL8J/jqGaJZ4f227b3SJdE19d8gvn3g
	 fFrqZ8Lg3BOjwESzf4IQipevDfijEUrQcltUrtebZZYZNjhUjH03YPNW8BXOKCXtlRbNB
	 dVOJz6QQAEaSDTiFeDqowNdy9sZkaNwAueAxb6i0N95dckBhtatEKG4xxrKMrF6L3gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZeMF5RKqrifBY4hkKnmY9QDjX2iwANF0eTjM1xlinY4=;
	b=e11Me3BC28tzehLsI3A+5i0PxrNyhxO+c02FzLQ68fIEL440hHoh/TXUc2vjwY820+6z
	 thdf/PItPCfQplIYlIC8+MHdmuxSMmOGkeCJgydRhxXswkFLyS1Kci8ohl4YPk/eF+JZl
	 x6et7Eooiy1hfGjaHg/h70GLclzq3yTWUgW3UaCT/Qka6TZbWmZCQ+VsmqPmyR5whbQz5
	 p2jlK0nO86LHb1AzalIyL9TjvThAYkjnocPPS3oh+stsT+ud8ydpMitoQq5ZPOHixyCY6
	 kbIvRgFfgIrGkJ3fLb5AZnNkjI5Y/Ie+8b47AdUgIWZKnZhQt4ZyeOf3Av0ACvhu98w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCbnYVk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFB1606A32A;
	Wed, 18 Nov 2026 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCbnYVk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBC91F000CF;
	Wed, 18 Nov 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017867;
	bh=ZeMF5RKqrifBY4hkKnmY9QDjX2iwANF0eTjM1xlinY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCbnYVk8+wpJ3iN289HEPJSbiL1ezkU5/Q5s7DroUyTHcvz7P4hsBAIL8+V7+wp0c
	 aK6IlXkCf5KB6Fn+hz/tYhGI3DZd98+t5Xy+Slu8GNNQQ7HUJtTmyFR5wDwcmYaK/k
	 7W0Uek1qGZC9BVq/TSLyQllLblpLop4o6U5+k/dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1036/2651] RDMA/rxe: unpublish the per-net tunnel socket before
Date: Wed, 18 Nov 2026 15:37:56 +0100
Message-ID: <20261118150325.265053887@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 4af07308d8227affa1710b392ba79af7e878073e ]

KASAN reports a slab-use-after-free in ip6_route_output_flags()
reached from rxe_find_route(), with the free in __sk_destruct() after
rxe_sock_put(), and a user with CAP_NET_ADMIN can remove the device with
"rdma link del rxe0" while RoCE v2 over IPv6 traffic keeps looking the
socket up.

BUG: KASAN: slab-use-after-free in ip6_route_output_flags+0x300/0x360
Read of size 4 at addr ffff888115ddd794 by task kworker/u32:6/309
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 print_report+0xd0/0x630
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? ip6_route_output_flags+0x300/0x360
 kasan_report+0xce/0x100
 ? ip6_route_output_flags+0x300/0x360
 ip6_route_output_flags+0x300/0x360
 ip6_dst_lookup_tail.constprop.0+0x76c/0xcc0
 ? ct_nmi_exit+0xc3/0xf0
 ip6_dst_lookup_flow+0xf5/0x1e0
 ? __pfx_ip6_dst_lookup_flow+0x10/0x10
 rxe_find_route+0x426/0xa30
 ? __kasan_slab_alloc+0x6e/0x70
 ? __pfx_rxe_find_route+0x10/0x10
 ? kmem_cache_alloc_node_noprof+0x141/0x370
 ? kmalloc_reserve+0x103/0x2b0
 ? rxe_icrc_generate+0x229/0x330
 ? __pfx___alloc_skb+0x10/0x10
 rxe_prepare+0x9e8/0x18b0
 ? rxe_init_packet+0x3c7/0x4f0
 rxe_requester+0x1a0f/0x51f0
 ? rxe_completer+0x1de9/0x38c0
 ? __pfx_rxe_completer+0x10/0x10
 ? __queue_work+0x43e/0x11f0
 ? __pfx_rxe_requester+0x10/0x10
 ? irqentry_exit+0xd2/0x640
 ? _raw_spin_lock_irqsave+0x85/0xe0
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __pfx_rxe_sender+0x10/0x10
 rxe_sender+0xe/0x30
 do_work+0x144/0x470
 process_one_work+0x633/0x1030
 ? assign_work+0x11d/0x370
 worker_thread+0x45b/0xd10
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x2c6/0x3b0
 ? recalc_sigpending+0x15c/0x1e0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x36e/0x5a0
 ? __pfx_ret_from_fork+0x10/0x10
 ? __switch_to+0x572/0xdd0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 146020:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x6e/0x70
 kmem_cache_alloc_noprof+0x130/0x360
 sk_prot_alloc+0x56/0x210

Fix by clearing the per-net pointer before the last reference is dropped.

Fixes: f1327abd6abed ("RDMA/rxe: Support RDMA link creation and destruction per net namespace")
Signed-off-by: Binbin Deng <18983559317@163.com>
Link: https://patch.msgid.link/20260923051800.244740-1-18983559317@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2e..fc597e02c85ca 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -638,9 +638,8 @@ static void rxe_sock_put(struct sock *sk,
 	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
 		__sock_put(sk);
 	} else {
+		set_sk(net, NULL);
 		rxe_release_udp_tunnel(sk);
-		sk = NULL;
-		set_sk(net, sk);
 	}
 }
 
-- 
2.53.0



