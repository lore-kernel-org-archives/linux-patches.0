Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622475;
	b=rv+zzrSvrRz0Etn1NGTZ+17mH33wnyC5+4AaJwDSVSk/h1uBXtLZmFSUTCZXLa1xj2sO
	 16aZ7K5hzlxWxR0R4X1JGM77GRagI25qi2lMQG2y4g0sO14et0Vemv098tFxdOAMfq8ay
	 B2pRBY6U/h8+cY9i9Y7IUP26UwKqpzdaXLPwmd0JDaov5V3bCgL+FM2eMb8vMWEy9k8oA
	 6IzUDW/CCMpMAY2EvXfU0svND7Jr1tpnooHCSHgj1/l9NizlwAklBAK8g8EC8dHJX0kwf
	 Xp6M8jb/hBGKSrjkET7mDljSs/fHhGo3G/oRUQPZlQbkY1+LlAIPbP/PfhWcbSzjV2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=78AJrDyE3drvjeKkLXq4fXZVLtH9qwRE4IDlbZa35sE=;
	b=vmdNNkCaYGWYTfZYnTpEz5TOLD3rGNop/iSX4pIrufYEJoO3L43ComBt1zJsGD+techM
	 bZt9nZScn1a6GT31vg7gm/caAVWGYOZlvAQr5lOAi29VToExoKOXj2m3Y5CoO63h5QKUO
	 rtt0CpjlZKz4XjPYwUyD7herTY+BGxtrxGWhY+yUVqF5eQ8lD02HXpBOpqAnnEuG3OTH9
	 okyi+Ewt2kTrnJTVkm9kqrrzWlo/5CuEfMlf+DEbFVGqXBHdTkJqm+oyMIjUDN5HlAtO4
	 tqmA4nbMfF5S1TOY07ShU25+bAdEizoVvjExlBydpd+ac/HL1s9Ag5lUo2uQJHCiKBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+XdQRmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4005606A329;
	Wed, 25 Nov 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+XdQRmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDCE1F000C0;
	Wed, 25 Nov 2026 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622475;
	bh=78AJrDyE3drvjeKkLXq4fXZVLtH9qwRE4IDlbZa35sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+XdQRmfXauZwrdeA0wHbyzpDZGjJC2itUeAOfRl1YnY7cJ+j9+/26Zns886AhUUu
	 jAfRIGaeHtJHxOZv6Kqcomeb6o/+9maAz6VEfy90x0ir3wNC9e15C5XsOPNz8rhYrO
	 agzH8VNqzN0y008R27+SCjRoQ/LF9HkKUHtEv76E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Eric Dumazet <edumazet@kernel.org>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 495/990] inet: frags: prevent acceptance of partially authenticated reassembly
Date: Wed, 25 Nov 2026 15:31:02 +0100
Message-ID: <20261125143833.690712080@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 6fb4e32f2ce3234ae0c416872e911706a3484430 ]

A reassembled skb retains the secpath from its first fragment, which
makes it possible for the final policy check to accept bytes that were
not covered by the transform recorded on the skb. This can affect IPsec
tunnel traffic, including AH and ESP, and allow a packet to be accepted
even though only part of its payload was authenticated.

Reject a fragment when its secpath differs from the fragments already
in the queue, and keep overlap statistics limited to actual overlaps.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
[ sashal: Adapted the ip6_frag_queue overlap stat to use ip6_dst_idev(skb_dst(skb)) instead of a local idev, and kept existing IPFRAG_TOOBIG/truesize context in inet_frag.h and inet_fragment.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_frag.h  |  1 +
 include/net/xfrm.h       | 17 +++++++++++++++++
 net/ipv4/inet_fragment.c |  5 +++++
 net/ipv4/ip_fragment.c   |  3 ++-
 net/ipv6/reassembly.c    |  5 +++--
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 6aea2d1ac376f..c1fb419a9cf03 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -173,6 +173,7 @@ extern const u8 ip_frag_ecn_table[16];
 #define IPFRAG_OK	0
 #define IPFRAG_DUP	1
 #define IPFRAG_OVERLAP	2
+#define IPFRAG_MIXED_SECPATH	3
 #define IPFRAG_TOOBIG	4
 
 /* Max sum of the truesize of fragments in a queue. This keeps the sums
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index af0869c14a253..7479fe2ca5f5e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1189,6 +1189,23 @@ secpath_reset(struct sk_buff *skb)
 #endif
 }
 
+static inline bool
+secpath_equal(const struct sk_buff *skb1, const struct sk_buff *skb2)
+{
+	const struct sec_path *sp1 = skb_sec_path(skb1);
+	const struct sec_path *sp2 = skb_sec_path(skb2);
+	int i;
+
+	if (!sp1 || !sp2)
+		return sp1 == sp2;
+	if (sp1->len != sp2->len)
+		return false;
+	for (i = 0; i < sp1->len; i++)
+		if (sp1->xvec[i] != sp2->xvec[i])
+			return false;
+	return true;
+}
+
 static inline int
 xfrm_addr_any(const xfrm_address_t *addr, unsigned short family)
 {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 4d55444a6f30f..1f0327f07faa2 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -24,6 +24,7 @@
 #include <net/inet_ecn.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
+#include <net/xfrm.h>
 
 #include "../core/sock_destructor.h"
 
@@ -448,6 +449,10 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 	if (skb->truesize > INET_FRAG_MAX_TRUESIZE - q->truesize)
 		return IPFRAG_TOOBIG;
 
+	/* The reassembled skb keeps the first fragment's secpath. */
+	if (last && !secpath_equal(last, skb))
+		return IPFRAG_MIXED_SECPATH;
+
 	/* An IP fragment is never a GSO packet, but an untrusted source
 	 * (virtio_net_hdr) may have attached GSO metadata to it. Do not let
 	 * that reach the reassembled skb, whose head keeps the first
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 03e19a29df05e..ef7fd61284a3f 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -378,8 +378,9 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb, int *refs)
 		err = -EINVAL;
 		goto err;
 	}
+	if (err == IPFRAG_OVERLAP)
+		__IP_INC_STATS(net, IPSTATS_MIB_REASM_OVERLAPS);
 	err = -EINVAL;
-	__IP_INC_STATS(net, IPSTATS_MIB_REASM_OVERLAPS);
 discard_qp:
 	inet_frag_kill(&qp->q, refs);
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index a5e0cec45974a..74ac8e8bc19b6 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -236,9 +236,10 @@ static int ip6_frag_queue(struct net *net,
 		err = -EINVAL;
 		goto err;
 	}
+	if (err == IPFRAG_OVERLAP)
+		__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
+				IPSTATS_MIB_REASM_OVERLAPS);
 	err = -EINVAL;
-	__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-			IPSTATS_MIB_REASM_OVERLAPS);
 discard_fq:
 	inet_frag_kill(&fq->q, refs);
 	__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
-- 
2.53.0



