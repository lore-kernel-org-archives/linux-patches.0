Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704311;
	b=OsWO5S5ShAXj940kWNi8o0aytXpZFHV0BWZT4/kczO+HffWUa+hUnk8eqrk8ISL6XMYf
	 eM+FGlPJue2N1TyeHatzQm3DyCBmeccVQbeMtwi0A5wd8nJ+aK01YSUbTK6za/Q4XrlgZ
	 Beix76uNzgFloagF4FXO2l9JCmLZMa+IWVcLqj+xTYh6IXIUps86xjz+UBDqqr/t09BAN
	 CqlgdmtjxQST5fKxQaAXHkJzAu+LH1UunXc0OTIsGDBArsKkFa08OCC1RU7aMUXLiAo7u
	 hMTr9b0uPsCXRv+gxVY6TUA/TLnLVgciYzpjxh2pDtmLHSQnbz5055L98Pb+V28ygRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDyxAsBY2o9qzYHRdNDPz5iCaZ+Bq+YP+jNxvkWoqXQ=;
	b=tB6uQDAhLPpps5qFGbH11Gb0JwWZ5S8L49PlOzhvMp3+5a1zAhpwFdW792Naml6aw1kJ
	 rzRpceMNTa8mdlHYwDvWy6ewcYHZZQvrma5El5vucXnyQ+AApiHJvKaL3xhpBBo6gebq/
	 EHcbvZ6MXOnpXRtouFifCNi1+k5f/XVjubmZ/RkXAJAJv0xIMrY4hzWrhgMt65iYVL2oc
	 66E/yGnpTkThLFn4oHUyES9xZHoVVGTntron4rQtaOuB2m8eXH+NjjfzipURs5p7UGp5k
	 PUQXHd6LozP1EQ28vL7iZ6J9lGB/H8yhxXmPeJNKJbtuB7TkxKk8wXNrX8KwyFDckVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0XdM0SB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE05606A326;
	Thu, 26 Nov 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0XdM0SB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDAF1F000C0;
	Thu, 26 Nov 2026 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704311;
	bh=mDyxAsBY2o9qzYHRdNDPz5iCaZ+Bq+YP+jNxvkWoqXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0XdM0SBgi7YrkecIdJu9vKwxI9dT4Zpwz93tE/w6gFJv/7ZDXnRHj2u4axQgS0yZ
	 kMOYi2WttY/R+0sZ0JOWuCgWmL1O2nRKcmMhRtT2b0oSGyYoQ3op5ogcP6pmMqKe/x
	 ADqBFkxKdwQY9sWrVLUhT9KEcctfszEVEgutckj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/265] ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().
Date: Thu, 26 Nov 2026 15:36:48 +0100
Message-ID: <20261126143610.486075841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 088c207c10fa3..8ab568e9314ad 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2364,6 +2364,8 @@ out:	return err;
 
 		if (unlikely(!rt_cache_route(nhc, rth)))
 			rt_add_uncached_list(rth);
+	} else {
+		rt_add_uncached_list(rth);
 	}
 	skb_dst_set(skb, &rth->dst);
 	err = 0;
-- 
2.53.0



