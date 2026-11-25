Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621626;
	b=2QJGxK3yx6V3dXioUYuDx4cfVTInYvANnAbeXptj6gKvd31LVxshQ8uPXmDv2k4HJgYy
	 AwZ85ZXjecGVU7cpqhTbJXVtcW0lRoXXcIanf80TSJcssZq/xsWpmiUX9nAZ/zvLBWd09
	 hKyORopGp56YtQkrSA6fsbhvqoUnY9wYxy94n+lfR+fT97HfYa/wgFvabq7zWKv6VFvfC
	 HDviTbk6EE9R3R8O1tF632JfmMWlbpXt5z9S0FTj9uQ1fDmqWy7tlqn7l14JWOM5s2kzt
	 F6GBIUxCmqFf51Qs6HZQCMajprcsg+sekPVMITXwSDQ+W/vtTz0bRT5H6qCI7Dp5o/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHHleJFF78KlcyDkrtRS9QaZOPv3H3jycsgUZFDVUjE=;
	b=RO4ooG1LI6Ijn+GjBzBB/wNusoa4YxKxB2MlG7BjUu3OGMLa+x8yR0SNS8ZsxaiVvEx5
	 sgdXMHV4CB/PZejJ4Hrxx1BS7Gw/K3uJLHXnGSz3tDE3d8qfdcMeHcJjYrpz4Mue7BgwR
	 hIlsVBnHoObQnpBo3wjZXGvSzcW87ru2AhBGZU8SrAnRPF77EnPvw+mWCjD8shLnGEFTN
	 +Yp1Z7TXs1epEaS60kPvbBOFaEBZ8WcE7+dEMWfYi5H6KVRsD5OVDNl/tLtKfGwlxi5gj
	 fAxrLBtcOrbYUa0l17/yFg+y642qy95g6gJevi90UtmRgyUkIKUMIorYg8cp1fzv1LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sF3Npvzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D85606A326;
	Wed, 25 Nov 2026 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sF3Npvzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF521F000C0;
	Wed, 25 Nov 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621625;
	bh=oHHleJFF78KlcyDkrtRS9QaZOPv3H3jycsgUZFDVUjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sF3NpvzcGpHRjAa1E12bKuPxYthUoKn2yE5/zncqa6MtYVho1NfzEaXep6E9gNCXr
	 QME5eRDtMtDMznxfFzH5IA2JmDfm2w1Id9OJZ285DgQxFRDtUGDt4qWE4FUaHnfLaD
	 M1oXCARiqpqqGQz7lI2ZEEVd9pPhikjXUMq5NAIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Zhang <jdz@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/990] ipv4: Call rt_add_uncached_list() if !do_cache in ip_route_input_slow().
Date: Wed, 25 Nov 2026 15:27:05 +0100
Message-ID: <20261125143828.135853364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index e6276896f3ad4..489d3b2cb612b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2485,6 +2485,8 @@ ip_route_input_slow(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 
 		if (unlikely(!rt_cache_route(nhc, rth)))
 			rt_add_uncached_list(rth);
+	} else {
+		rt_add_uncached_list(rth);
 	}
 	skb_dst_set(skb, &rth->dst);
 	reason = SKB_NOT_DROPPED_YET;
-- 
2.53.0



