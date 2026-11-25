Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625458;
	b=P0nbCLmNW9SNBWBzUBRrS6J5WmAtCGyIi5ubsiSinaQ5ltKoKnN6zYrpU98PR35J13ob
	 yrZz7n9Sqe8jnpSQ1EYFpWa2sGVEm6lnmZ2yjgPV0aoJ7afmfvDD3os7T/65F76OY7KsL
	 ET92Wlet/yjp0dsh4v15v4U2OYuGBJNdATAoVmAA7vBkaSnwiV+CEAN+ME5+UFpQgcKZO
	 AJFpEN7W5NLnp2+2GfVXXf7W32Kpf44z1OGg5z88jPSCZhXkcoBAlWWN4/87unM6DeM98
	 BD4qw02cXIq3rRVTkbFdP+dL4p/vTgmnlvhn2zkuwVLKR3hJg+OqSfuI5/+b0d3ceTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jWIfBbD9tYs4HDeGup4Ozuf0JTpZjzU6YRzmXTYU1TU=;
	b=Bx5zjNo1FETlttCs2hQrPsyz8LlOXh/0G35AZTxB4zRpnEwfEdqNEw8PZw4+y8NjHbV4
	 ArA0yAW2y+IKxC8MJdbvZtVBKK6glNYRdJV7uLTO+IsBKs1jQuhV3ZzAYZD26vJLfJBX9
	 NSUhJ95MT1DyriSFHaqMniRj+6QmyAF9p2F9Kh2p2zFVtwwU9iE/LblahfLzd3qVtw8fd
	 m3Cplja4fqiBc0cF8pgF/kO23yH9jraiAGXvVF5FnhT1MgPFelJac31ZMpQCC4kBVzxrN
	 BRxco5yp1TSE53VNyLLIe+hqT7kk1AJO0wI8+XxV4TUr2utnJHoKsA2BKFk1EqvbKWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYTXSUoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CE3606A321;
	Wed, 25 Nov 2026 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYTXSUoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28ED1F000C4;
	Wed, 25 Nov 2026 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625458;
	bh=jWIfBbD9tYs4HDeGup4Ozuf0JTpZjzU6YRzmXTYU1TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYTXSUoJVzZWOeqRk8IGgViQ6geyGmW1skw7eVxzvzEInjfN0XWB4qpsrAFY36PDg
	 HMEpE6SRy1BXGHyb3JmU79fg5RPCzUg2CjyyKkGzE4PXi8HPTfjbRzZp/ejUQ4sVCb
	 1bhkZ9R1GJSjtb+kVmxvzw4TgpRW+OZ2/mynXULs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 524/816] ip6mr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 25 Nov 2026 15:34:32 +0100
Message-ID: <20261125143901.315560908@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 238164201431a425e48dfcb8e9a59de63caf175b ]

reg_vif_xmit() hands the skb to ip6mr_cache_report() as an
MRT6MSG_WHOLEPKT report. skb_realloc_headroom() copies skb->cb[]
into the report, which is queued to the mroute socket, where
rawv6_recvmsg() reads it as IP6CB.

By the time the pim6reg device transmits the packet, skb->cb[] is
not IP6CB anymore: qdisc_pkt_len_init() overwrites iif and ra,
and any qdisc installed on the device (fq, fq_codel, pie, cake...)
or a tc BPF program writing skb->cb[] fills the area holding
dst0, srcrt, dst1, lastopt and flags.

Since commit dd433671fef3 ("ipv6: validate extension header length
before copying to cmsg") these stale offsets can no longer cause
out-of-bounds reads, but the mroute socket can still receive bogus
IPV6_PKTINFO ifindex and extension header ancillary data.

Clear IP6CB before building the report. The skb is freed right
after, so nothing else depends on its control block.

Fixes: 14fb64e1f449 ("[IPV6] MROUTE: Support PIM-SM (SSM).")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Placed the memset after the branch's existing rcu_read_lock() in reg_vif_xmit(), since the surrounding context differs, but the added code and comment are identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index c608fc0a771aa..c962409a61e10 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -625,6 +625,13 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
 	rcu_read_lock();
+
+	/* skb->cb[] holds qdisc/tc state at this point, not IP6CB.
+	 * ip6mr_cache_report() copies it to the report delivered to
+	 * the mroute socket, where it is read as IP6CB.
+	 */
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
 	ip6mr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
 			   MRT6MSG_WHOLEPKT);
 	rcu_read_unlock();
-- 
2.53.0



