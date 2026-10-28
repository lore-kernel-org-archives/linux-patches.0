Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213476;
	b=jPFfAY/cTDZ0sPjD3JzuLF7hjN1KDjxUzfuFpD2czG790Zx0Y/pCKTknzPf8PEh8Xsed
	 JI1cdLHXAyeHq0Ck/jEhoiVlvNAZwhOOVq5rELl9y7v75XmEJaWEzZtqghpnjGv9L+dEs
	 ZOteJHobHXMuOoQT0SYXZF4L4+iPJ+TvT+AnxWgrkz3ljnhknyUEqoIzWJkjhRaCzxK24
	 0kYBy1ylsJ7ZAee/q/za97YsJAl4UlX73MsVMEdY65Kcb8qwlUK99NnBJ91DntGH1FSgA
	 t0Sf0/ZXe+/IsnzbCf19RhXVXC01BIkdDhwhU7SLp3K2zQhRY360Z/BEgnR3oXmngew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wPrpzzhrGEcXi3IMuFJTwsLRX1pwQS1D70lwV0auEso=;
	b=h6v5gXW2eiSF1TMLxVfGkLNhGeGAClHPf/TmkNMK7uL2xIpmVfJSbDQDi7pdqLOyatK/
	 QpqaldROhAFMZdlWstWDym06089jIS9XcJ62nSeJuOf4oN8CYvrHwwLf4qSKiIXpGbDab
	 P9sZmVoSD4Z7vmFannFSOcKGs26dM48+Fhp/aKMl0XRjN3FA03ysZ/SeRLYfpRuLTDz9u
	 30wKdOQk9Meh3MNjagEU6wAqyTunWLfv5qA494DppU4jXwptX3HB7Ot0pZU5RVULdyy/H
	 gx+AmNFN94IpjIEVRi6WzQNLrUbAN3UsyIYfRIYY2onG9wJeJMRHkhn0Us29/iawBow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBmMBq0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5155606A332;
	Wed, 28 Oct 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TBmMBq0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291441F01829;
	Wed, 28 Oct 2026 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213475;
	bh=wPrpzzhrGEcXi3IMuFJTwsLRX1pwQS1D70lwV0auEso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBmMBq0KlryoCOgo0G81U7Zf8kty70T0CFNI4vivKs5XRwuBbVZ+E9bEMdB1MTAaL
	 uXG3C9BQ3b0I/6oC0MhkRQ3DCe03RNHCsYxY/T/tZMGpWMvd/2fQ6T23AhTEvQALuD
	 vPrxpdnonoGua2Q9966r3kJbhCIzygbB2LhOdJyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramses de Norre <ramses@well-founded.dev>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0518/1887] wireguard: queueing: preserve tstamp_type when encapsulating packet
Date: Wed, 28 Oct 2026 17:43:34 +0100
Message-ID: <20261028170511.110430009@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramses de Norre <ramses@well-founded.dev>

[ Upstream commit 65ab9de4bdd4c05d8277cfc20ae0b9f5aff60897 ]

Sending traffic through a wireguard tunnel on a host using the fq
qdisc fills the log with:

  fq: likely mono tstamp with tstamp_type 0

An skb carries a timestamp in skb->tstamp and, separately, a
skb->tstamp_type field recording which clock that timestamp came from.
The two have to agree.

When wireguard encapsulates a packet it calls wg_reset_packet(), which
clears the fields that must not leak from the inner packet into the
tunnel packet. It does so in two steps:

  skb_scrub_packet(skb, true);
  memset(&skb->headers, 0, sizeof(skb->headers));

skb_scrub_packet() deliberately keeps skb->tstamp when it holds a
monotonic timestamp: that value is the time the packet is scheduled to
be sent, and the qdisc still needs it. The memset then zeroes
skb->tstamp_type, because that field sits inside the headers group
while skb->tstamp does not. The packet therefore leaves wireguard
carrying a monotonic timestamp labelled as a realtime one.

Nothing noticed until commit c4f796c4f16b ("net_sched: sch_fq: convert
skb->tstamp if not monotonic"): fq used to assume every timestamp was
monotonic. It now consults tstamp_type, spots the mismatch, warns, and
falls back to treating the value as monotonic. Pacing still ends up
correct, so the log spam is the actual problem.

Save tstamp_type before the memset and restore it when encapsulating,
next to the hash fields that are already carried over this way. When
decapsulating it stays zeroed, which is right: an incoming packet's
timestamp is a realtime receive timestamp.

Fixes: d98d58a00261 ("net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()")
Signed-off-by: Ramses de Norre <ramses@well-founded.dev>
Reviewed-by: Toke Høiland-Jørgensen <toke@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20261008130124.724119-3-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Replaced `skb->tstamp_type` with the older `skb->mono_delivery_time` field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/queueing.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 3ce70db9dd3fe..50ceff8d107ec 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -78,12 +78,14 @@ static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 	u8 l4_hash = skb->l4_hash;
 	u8 sw_hash = skb->sw_hash;
 	u32 hash = skb->hash;
+	u8 mono_delivery_time = skb->mono_delivery_time;
 	skb_scrub_packet(skb, true);
 	memset(&skb->headers, 0, sizeof(skb->headers));
 	if (encapsulating) {
 		skb->l4_hash = l4_hash;
 		skb->sw_hash = sw_hash;
 		skb->hash = hash;
+		skb->mono_delivery_time = mono_delivery_time;
 	}
 	skb->queue_mapping = 0;
 	skb->nohdr = 0;
-- 
2.53.0



