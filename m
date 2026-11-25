Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618439;
	b=AWs0DaXFba7YsREdcfLZM7BHAAu38Y7W24L/uepj2vFXvRRI28rnNM/pCfge3Tf6GDTQ
	 +CY6U+hP5ig6qaXYegs5FdE7o/VOdoRbr7o3c7tp9tEGUbHTdFNf9dY3LvH1yEdUsww1l
	 2tKRjkHNTXDEk6bz5jiRgOXi5d1PFUqGV2wNNDZeY614UnKSxQKWTgyAOpsjNPud0Ic6Q
	 eu/F51nsdr4nVw5NI/gtF64K1ppX3wa8e297AbhAoZ6XaLRCeumHPln5FX9veNE1TZ0xn
	 7EZTUGqeR1dS5y079o1i8CepjEmY73j2orBvLZdx9e/E/5iB4vd5Y5GQmGtoFJrcHSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ld4SFau+Ni5LmfKKq5avqmQ1PbteP4sZQdZupwumtY=;
	b=2px5L6VzikV01/kczPK50zw6Crdkg3AOkKaQqXrcm8YUjwKGpMflkge83UqAmdp0dffU
	 aCeC3DWOtWOjHiJU06Bdn1qTR/CTc+VhAoCu+S/epizlH6NA30uDtTJdy55/8EIDkVIOJ
	 S52sRuq0B6tawo9uY+GGRQiCIzbocnPkY1jHYpE5vyIL5rZducWBbDv9jMJtXkmv91edX
	 FGFcgWFxXaAgUOH8AdHcUw9O9SH3aQfxfZ5Hpljue2TJxiFc7CkPiUGI2v3ci8ljj+nRm
	 TsXr0//i8qVR55Y7QQ2TW28OKq4cN3qlWd33othZw+dMMuEH+QBxFBmuzfANpLDtTLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lx2Iw319;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A46B606A31E;
	Wed, 25 Nov 2026 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lx2Iw319
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A11F000C6;
	Wed, 25 Nov 2026 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618438;
	bh=8ld4SFau+Ni5LmfKKq5avqmQ1PbteP4sZQdZupwumtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lx2Iw319qoje7nmdvDvs8mlNL9SQBrSe8IgjV4/717DFxA1x4B5k2WpNqROh5qI85
	 0C0bEwYLjBfYVLEBvy7RxRHGzNEcXDprya98HPAlztLTDuOG+V4TOR0bT1KrCJDD5G
	 VR2JLB7yQl8vixstIK4Y3fP/tsBvFof0+Y62EnX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0280/1005] ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().
Date: Wed, 25 Nov 2026 15:26:58 +0100
Message-ID: <20261125143828.302814651@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 4019af3afd72864ec6abbfde2d76e416a64456c2 ]

Since the cited commit, ip_route_input_slow() could call
rt_dst_alloc() with vrf in the local_input: path.

If res->fi != NULL and one of the following is true,

  - a non-zero itag from fib_validate_source_reason()
    (realms/classid)
  - RTN_BROADCAST with BC_FORWARDING enabled

do_cache is set to false.

Then, the route is not added to rt_uncached_list, so the
route cannot be removed from rt_flush_dev().

If the route is cached in sk->sk_rx_dst, removing the
vrf device gets stuck. [0]

Let's call rt_add_uncached_list() if !do_cache in
ip_route_input_slow().

[0]:
unregister_netdevice: waiting for vrf0 to become free. Usage count = 2
ref_tracker: netdev@000000008b304ac4 has 1/1 users at
     dst_alloc+0x14b/0x490
     ip_route_input_rcu+0x1540/0x2530
     ip_route_input_noref+0x5a/0x90
     ip_rcv_finish_core+0x4b0/0x1140
     ip_rcv_finish+0xe6/0x190
     ip_rcv+0x6c/0x130
     __netif_receive_skb+0x121/0x300
     process_backlog+0x2df/0x5e0
     __napi_poll+0x8c/0x380
     net_rx_action+0x43c/0xab0
     handle_softirqs+0x19f/0x520
     do_softirq+0x46/0x60
     __local_bh_enable_ip+0x79/0x80
     __dev_queue_xmit+0x1b0e/0x24c0
     ip_finish_output2+0x8b2/0xcd0
     ip_output+0xf2/0x1e0

Fixes: f5a0aab84b74 ("net: ipv4: dst for local input routes should use l3mdev if relevant")
Reported-by: Jason Zhang <jdz@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261101064418.2055158-4-kuniyu@google.com
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 67c4fae2384b3..1720323d9f025 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2494,6 +2494,8 @@ ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 		if (unlikely(!rt_cache_route(nhc, rth)))
 			rt_add_uncached_list(rth);
+	} else {
+		rt_add_uncached_list(rth);
 	}
 	skb_dst_set(skb, &rth->dst);
 	reason = SKB_NOT_DROPPED_YET;
-- 
2.53.0



