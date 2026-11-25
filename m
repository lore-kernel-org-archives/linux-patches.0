Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624482;
	b=lN4mxq/Xd48Q9hdKHCf0enV7wYDfGDAHzHF2iU3uNBTd2EOB1gTKY73edyf32OOBckdx
	 6DbtQzvKaA5Lqhiz62pBZvlYg+qtce5SBcFT+6EaiuYXMD/PahydN3rPG6x7Yj+jJEZBn
	 CDb5+65RfHdO9nRxNPN4Ob+0fxSxrWY7/g6hjg1yKgx8dT176LHc1YEAZHSnbuffldkmS
	 BNqubzm+CWQUzqY7Gw1mKM/AKf0UT+d0GCUi4NWLWXIjJiPfbLozD6S4+f/nmrH3xkIK7
	 /BRrx1oTHrD7VBs27cvnfeWBs1r0IBm0ZcZsBzJ0T2dgxDCF0/zvmsONY1LzsWsOOBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R61BYnYP+lhkC8lpf6QePCS+/EsnGTipc0sArAOymbg=;
	b=j0bUpMkXdaFPpziH05htMYuYt3tDIJhW5LuiGJef9VzhyJCyQ3mnbPNW+iCxx3np6fNl
	 r53Czfr0Cyv0s3mfH6RrXumwXaj5lMVIxa0KAfAB67BUzMeOywhatsG0wS3aKCxq3Df8r
	 Eo5lrBbleQ7xuyhbwx2knxMcI5g2aTq2sZ8QBsp5O6m09TxoWVZzF5h1SG116maSDsQIu
	 JYlxtLp4hV1Jl498YrzybrEPMhkcjriHVZ6R7YB1ui2/31mkHl/yZ1qp+TqIpMyq3xGwM
	 yQeZyzFd3fKckN2yH3DHULG9GP0eqNMarn0J5LvMK5pkIeoIv1yCjlT7a99BY20beUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ss7cQeNV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2710606A33B;
	Wed, 25 Nov 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ss7cQeNV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB91F000C4;
	Wed, 25 Nov 2026 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624482;
	bh=R61BYnYP+lhkC8lpf6QePCS+/EsnGTipc0sArAOymbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ss7cQeNVW3HomH+kdGesYGVEiTynKTt7GcLEmDHHT/f/rfWPELW0eG0kfHw0W4ejx
	 QnKoxMcW1sfmiRGGiTLZadBVPz0fL9ZQbKFUcXaQwSolhXQYVmi0wWh6K/yQk4pSgq
	 wwga7pItbhH6q0xXQpE80blk4kVb+mHLh3C23pmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/816] ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().
Date: Wed, 25 Nov 2026 15:29:14 +0100
Message-ID: <20261125143853.964304511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 64fe59730ed8b..9706d36c8388c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2441,6 +2441,8 @@ out:	return err;
 
 		if (unlikely(!rt_cache_route(nhc, rth)))
 			rt_add_uncached_list(rth);
+	} else {
+		rt_add_uncached_list(rth);
 	}
 	skb_dst_set(skb, &rth->dst);
 	err = 0;
-- 
2.53.0



