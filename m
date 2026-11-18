Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027823;
	b=gAo9VkXmQbtiCp9fSeJm10HcvBqDQSRz0wEGHNe3Bu3F4tbYxzXYYH9XqZa7N1sH7vnz
	 I6uJRXoxgJMlEJUEZNyt+6PfeY2Ejg0vjnNt7i8enUjZuz150giAucSwbowraOxkG17CE
	 V+YEVuI21lenjk/KZxoansSVihKl2yv+XSsf6FNT1R6YMiCWgkUXLu4m96PglcaPU9HCc
	 rxGGAEhoqOTbKrvz0Gb7sBOuRfaGMzFGUNky+mKN0YDansT1pO/Vg7BQa+ogc4cvebsbz
	 3YhGTPMAmsvpbwH/AF4pK9Y6hjw68H+FkVHHrhLlEXEZFAMK4Y4JOZRigqmOC+xUZXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCdJhWEDVngy4EOkM3r6o0G0Yk6C6OEHXgjASAiuu5g=;
	b=ju8Hlw5aEPhYuHLk3UwgNQBnqAzV1U7mBE+R0o67Ozym2PrvUj7eX8U+7IMvJT9yO2uj
	 QTuTd/HKH4MZMii4RHqcnUxaht63rpYNPBR2zfgre6aFDGc3VB2KKJhm269PlBp6n4wyP
	 UkNLyalEwsrkoPZ6vmVE2yQJjixWfLj3OY1gD2kYwxOLHXRqhpdbG+iKOLsr41LNfC83l
	 eX7pxN7QV0gz+o37LkpMzV/p6B1+mQ21rO7BGj3LvieKwqwSKWaaGxYzOZsPs19pyqE7P
	 oa9bZf8/LFHynQIs48L0bGN7ObVeE8H0PSFgY/vZPYYX+A1Wt+MMjLJwD48ig6nQa1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N6FB/Cla";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B119606A332;
	Wed, 18 Nov 2026 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6FB/Cla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7991F000C4;
	Wed, 18 Nov 2026 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027822;
	bh=sCdJhWEDVngy4EOkM3r6o0G0Yk6C6OEHXgjASAiuu5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6FB/ClasfoAxIwxdH8qnCO2cJPHcVvwVtzCztmqahA70NvuRuBaiqPcRdJh3En/z
	 8MNpoRi7IZNf9VPvZwpOZYXrycIsdbf1OXsf5xTsmRaDSxb7PwXShcfsryANn3ORVr
	 4jnn0EaTDmv33cgIXunTsbVQ8ptBluI285P88X9Q=
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
Subject: [PATCH 6.18 1927/2151] net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150231.980129885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 51fb857a27665..2874a50bead6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -960,6 +960,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
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



