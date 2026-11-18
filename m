Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021645;
	b=gglhCqg1MIwcSUlc+FIzbboSZ+jpxYArtuTELAygvEs3fXqzriJL42bi0ATZBZJacUP2
	 qK5y6n3/7a4yegXXe04PSP697YXvu7uZtNa/iOCcPiWPc15KYEPm1M51DsKIVSmcLSxNr
	 KWXlybhpKGaVCu2xwOAp3dJ5zIPdQ3OP0diDK8GiwvATw25Y1d2f1Mha0Lf9Hdt+/SVwF
	 Kwwu7uaSlIRo2GuH0ecjSbUkqwoWbYk4k0zLHmZ6MkCj5Kmeg53OCqqwoSkn+s3SAuSBz
	 lca8rSJ3aRnYPwkLYpHVXbWfkOCs/e7P6nI0COxAtDEnZW7+/e4lgAw/WyukPxfzKrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bGr14ZyXuXlo88kOz2XYzZWaLEjS3bypvpR/i1g3ts=;
	b=QLtM7FU5V90L5VKD6V5eqMBFKWCP2kTsMUtIhQKuVMeD7SwEWJlxQYJed4xoumIz2BT3
	 YmDmvo8fQSP9B/8eTxlbfsNaX6ZJxt9PHeg7rUxNtEZcA0j9WRkEwxkhP+1YQMMH6FNYU
	 Nu6iSKK7iO1uh2Z6tbzaTEwBfV6NtQ07DIoEz8h0C/DcCobZaJRpU0u+l5JR+BuEALuke
	 D2ba74wTH4AEIAd1aSurwk5pfBHN97j3BkTLSUxlnuPaD21xSFqQxPoVs0cLI76noAgmo
	 quvY6kvkwnpFFiB4oycB1+95wyP9P43lJQMAtY76fS/AlQMj83MTToy+gST1yyaJdVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OKAy/dpw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A930606A320;
	Wed, 18 Nov 2026 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKAy/dpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B731F000C4;
	Wed, 18 Nov 2026 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021645;
	bh=4bGr14ZyXuXlo88kOz2XYzZWaLEjS3bypvpR/i1g3ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKAy/dpwIGVksoWRh++hVJ87BNtqln4jdsgp1rODC8rQUBD6r11PkvFQpBr3TZ7RF
	 2ZXkU4afRqMMyJFneQnQUy7YPulKQ5IWxLNj/t5zT5J6X3ys8u+bHVNFZMqGC2AZG7
	 1FtXws6x0l0tpHmpHwYemqnkcjK/MgcApavbTuJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2381/2651] net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150411.168698812@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 520631554a689d2cd52452578f3140f045730ee0 ]

mlx5e_ipsec_netevent_event() keeps the L2 headers of offloaded tunnel
mode SAs up to date: on every neighbour change it looks for SAs whose
endpoint matches the neighbour's address. The compare width, 4 bytes for
IPv4 or 16 for IPv6, is chosen from the SA's address family, with no
check that the neighbour is of the same family.

An ARP entry only stores a 4-byte key, so with an IPv6 tunnel mode SA
offloaded, any IPv4 neighbour update in the system is compared as if it
were a 16-byte IPv6 address, reading past the end of the object:

  BUG: KASAN: slab-out-of-bounds in mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
  Read of size 4 at addr ff110001260a4ad8 by task swapper/8/0
  Call Trace:
   <IRQ>
   mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
   notifier_call_chain+0x97/0x2b0
   atomic_notifier_call_chain+0x5d/0x130
   neigh_timer_handler+0x35c/0x1140
   call_timer_fn+0x164/0x490
   __run_timers+0x5b9/0x960
   run_timer_softirq+0xf0/0x1d0
   handle_softirqs+0x189/0x8a0
   __irq_exit_rcu+0x10d/0x250
   ...

  Allocated by task 1015:
   __kmalloc_noprof+0x2e6/0x8b0
   ___neigh_create+0xcc9/0x24c0
   ip_finish_output2+0xfc7/0x1e80
   ip_output+0x172/0x3b0
   ip_send_skb+0xa5/0x1b0
   udp_send_skb+0x852/0x10f0
   udp_sendmsg+0x1333/0x2150
   ...

The opposite mix (IPv4 SA with IPv6 neighbour) stays in bounds, but only
the first 32 bits of the IPv6 address are compared, so an unrelated
neighbour can match.

Skip neighbours whose address family doesn't match the SA.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20261021064231.3466989-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index db260e3d1412f..e6dd911475e31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -958,6 +958,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
 		attrs = &sa_entry->attrs;
 
+		if (attrs->addrs.family != n->tbl->family)
+			continue;
+
 		if (attrs->addrs.family == AF_INET) {
 			if (!neigh_key_eq32(n, &attrs->addrs.saddr.a4) &&
 			    !neigh_key_eq32(n, &attrs->addrs.daddr.a4))
-- 
2.53.0



