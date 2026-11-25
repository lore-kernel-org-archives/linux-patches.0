Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624894;
	b=xlEkCk7LHX5eT/I9jfXgnCe1h2Nku7AxZzPTtPw4Jii5Kukpp2P+VG+EsoCv70b1hMpg
	 j+Pnw8qABZ5gUDLurfX+bzFhf5VqsFj7L0NvwKY4zE5vfiBzurAsaZle+doTAAJTvogcN
	 YPEm0kRrItIoRh2HvTtD8sGE7Lc2gXY6TU54PB/OsUtGnA9Tw8P2SuQTHLWyKyciNXzxh
	 +fnm+UXcyg4K77SjxSPhtYKl1BE6UkEfIocHl8g3ulgn5vdxPg6jVbfv3S1gVjqTFXClC
	 Cfn34dYqRog4QJJ4h8vepay0SQh3WMpdxmI3IrpTeuecz6v5PuNQeemwMRhHItsDWJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgzBf/KYI7c/vYT3Ajmk+UcVRtJ7j8fRCT+quiKx4Ag=;
	b=p1WuTz+fvlxvLgUZCiOVlwcLbLVZ4sjW+3ec1x3IZAgImBfT1CJ7EykZXnK7NmeEKGFr
	 A0PFQcynImLn97ncla7dP4zCw4GXwoJiS7A0AgLcOujkVWmHSKvIJ2Kulv8DgOtbpLhXL
	 tKUUlFSGx20TE8Of49pUUfXhBrI4B3NrCjXtYEzj9Jtc+7yE+vFiQpTZxX9RCBnH8MyKr
	 8t7Bel+EZl7udtACKwmUFLLhUndpM/1MxiFSP9L3hhuGGJt49nUsZFXnmQyyJ2214Npa+
	 oJ39nqk9rJmnwFFPTr56l9I6SWXl9gnCt1AJ4BuUDwZzB0V9hwr2drWRogzXvVsS9Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2l9nnz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC21606A321;
	Wed, 25 Nov 2026 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2l9nnz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666871F000D0;
	Wed, 25 Nov 2026 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624893;
	bh=sgzBf/KYI7c/vYT3Ajmk+UcVRtJ7j8fRCT+quiKx4Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2l9nnz6klvBvUyLcAdlcWCNCnZZA38kIaIM042Uafx8HirOvgosv+vq2iei10OKj
	 z5Syb4WE7AnF31qldPhXVe6UO1rh2EdW9cawFgt5vFMG0GJOyD6WWEOUSo1Fxluvv5
	 tWcQENgnrkRFjSqLa96ik95GGmXmmHS8l1TA0d/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/816] udp: check frag_list IP family before using skb_segment_list()
Date: Wed, 25 Nov 2026 15:31:28 +0100
Message-ID: <20261125143857.067377341@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 22b7cb932c6a0f7566d41072be6956cb6c8af4e1 ]

UDP fraglist GRO uses SKB_GSO_UDP_L4 for both IPv4 and IPv6.

__udp_gso_segment() reuses the frag_list skbs when the geometry of
the head skb was not modified. skb_segment_list() keeps the network
header of each frag_list skb as it was at GRO time and only adjusts
the transport header offset.

Nothing guarantees that the head skb still has the IP family of the
frag_list skbs: helpers like skb_mpls_pop() let the caller choose
the new protocol. In that case __udpv6_gso_segment_list_csum()
handles the 20 byte IPv4 header of each frag_list skb as a struct
ipv6hdr, and can write IPv6 addresses beyond its linear part.

Check the IP version of the first frag_list skb. All skbs in the
list belong to the same flow, so they share the same IP family.
Use the skb_segment() fallback on a mismatch. Regular fraglist GRO
traffic keeps the fast path.

Fixes: b936a9b8d4a5 ("net: ipv6: fix UDPv6 GSO segmentation with NAT")
Fixes: c3df39ac9b0e ("udp: ipv4: manipulate network header of NATed UDP GRO fraglist")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: simplified the fix, rewrote the comment and the changelog]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 04246d1f8b3e7..24f2cd86bbb5b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -359,9 +359,14 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	}
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST) {
-		 /* Detect modified geometry and pass those to skb_segment. */
+		/* Detect modified geometry and pass those to skb_segment.
+		 * SKB_GSO_UDP_L4 is used by both IPv4 and IPv6: also make sure
+		 * the frag_list skbs still have the IP family we segment for,
+		 * as their network headers are not rebuilt.
+		 */
 		if ((skb_pagelen(gso_skb) - sizeof(*uh) == skb_shinfo(gso_skb)->gso_size) &&
-		    !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_DODGY))
+		    !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_DODGY) &&
+		    ip_hdr(skb_shinfo(gso_skb)->frag_list)->version == (is_ipv6 ? 6 : 4))
 			return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 		ret = __skb_linearize(gso_skb);
-- 
2.53.0



