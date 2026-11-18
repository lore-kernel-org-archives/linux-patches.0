Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032794;
	b=vBywEIdB7zzG0L0i3mLgQ4U+5ORyLsl9RY1ARR8lgbolpCiCzUURfR62leFSvvhQrsvb
	 ejN+t5k/15aV/dF3OakPhO+KsPC6Phrpe/X3sX/TEL6RI3PEM75Yowjb+qQerO0y31to8
	 M5sElfCIqQhVYyK2rybSchYHUN29MymurQsGiY4eU9T8ctCK+vWLayMxeQ0uuGHOkdAgN
	 xVTRg1dPUUYYaAQt2/SkhAN8/w4p/xPm2LzclgdF0WpE1PrUfwkgPWxnrio8Foh722Dmy
	 ZAocpwiAkBDP0R04LpttLH7xgQG4TtJn/9nem834vZyq949EgcoUI6iIwNS4z6ELMtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jcl0RModpVLpih5eVnkDseWZOmb9z65tWdBs3brDNQQ=;
	b=gsFViqISLjaLIf6JmVBiDkLUD2aCBBdttdbHwgQj4utdyakv5m2bDdeFoXoJoDc7fUu1
	 gElQIS1BNp+aROlUg5GeGBvrHLbpPB/DtlFX1wXffbY3rKLXjV0nM0xdse5QcQaJdfoB1
	 nLV5MyIApeZWAEt4kWb9CZnjb294xK+vAksLMLTFdXDW83pIL5gWyWXi87yoFU2k1JliL
	 yjoYS3S3qEe0f4WIcW2TSHku3k8Q3tJ4YtiEwVIW6Ijfb+JD8SR0sH8OTx1HAvAW7thG4
	 xt04LNLn7UCx8u8c6ifYQ50DA8Lhg7ARiLtVhhwsU9lXVQQ1Tp5vFdiZ/DEgsmJZ9sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTczBN9v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93248606A32C;
	Wed, 18 Nov 2026 20:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTczBN9v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F246C1F000C4;
	Wed, 18 Nov 2026 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032794;
	bh=Jcl0RModpVLpih5eVnkDseWZOmb9z65tWdBs3brDNQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTczBN9vvBi6iOcexi+wBbZIS7FcLtTm9X3KgJUNQ1XlUr7vbCebB5EIDmCkGOKSh
	 XKVKvz7okrFlPPIQmfps2kyUyc1eTIcyJUmf11nTIsBKICSBfP44MklnZVGdMehfVj
	 5vAzwmN/ZmX4Ewr2BRNnxLZFwlrJrsL6wSP4tugc=
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
Subject: [PATCH 6.12 1538/1756] net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150110.177870054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c1b6893389fdf..d389f55124be9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -938,6 +938,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
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



