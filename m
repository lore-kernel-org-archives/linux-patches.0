Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622171;
	b=A+cDU1KJgFIRw5mnQRBIX2flAAdl7iTJaWTKrZXOzCJuCrnf+l/QQ4175r0xnOig73LT
	 ll1G+kSeM+Anxmyea6Mv32CZTx5mJHnYsjdDfLHvFlCf6Ym13DRAw8BLokTBVCLQhUao9
	 zW/tbUTgXTapuBf+rcFdW2L0z2XWeOffErAhxFk+Uig+H7T8RTYsladdfYqmTRHmQRsin
	 OtVF694hgjqX6QJlVDQhe9ut6qvnMvyDlxx/4SiPqiznsJS0ySIi3lf3zooXsn9dTPfZX
	 NBXIPlshPJBL7sRyveRUaZLY8xwXdWtrJkf/n9G+ITQMW/qTStG/xqd8gIt6zu4U0Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJZzGDPA8Ptm2mq6fhxAfD6qQ7vnv1zZG3ZYdm38qXg=;
	b=reF0ew7bY6Hz1v/vC2sVSQscdp7RnLGVdE4K1aLtnYIg5UDzh2x8TKsgLBqRSsklO18r
	 xplmVippl0khyOnNuOA99Cpm1UAK+EqMTOs2X03E3UgfD15Wy69DcPdaAPeN/sd9cz20R
	 XHCTOgzt+XBXLHeOjrbRpa+w2QE1xYMeOO9r0muaHc6w9fAHKBVGH26kwGAHP2dc/9rXK
	 ue6eU/ppSaNVIqeDqRL3oGea6CBvRvfayuvbA6mT4s1UMfaZr4inzgAfGOaP7egwN+EBY
	 zs6bXO6oeRFegGAqUBWVPdENHC4LjQCo+LXTSCYx1GQnBqRcd4E5ehfB293v8ZnJLAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udr5lRe7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A47606A321;
	Wed, 25 Nov 2026 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udr5lRe7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFB61F000D0;
	Wed, 25 Nov 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622170;
	bh=iJZzGDPA8Ptm2mq6fhxAfD6qQ7vnv1zZG3ZYdm38qXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Udr5lRe7XULTfctRUpIHlJ1815hqPf+y5GSPrZqe9BWE+JQ9VRmTG6JmOtm7oeu1i
	 bk75TCeMitSDF/oVCe9j+uYDWfViQgJJ8415Stk5x7ol6R5Aw7uliSr9oWZh0pZDyo
	 AGKlTOoH6+0Fy7wUt3Ak1LvMIdExIciUqFN4dR/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 444/990] udp: check frag_list IP family before using skb_segment_list()
Date: Wed, 25 Nov 2026 15:30:11 +0100
Message-ID: <20261125143832.493412842@linuxfoundation.org>
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
index 4f7ae02df8d3a..2fd0d7c72b45e 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -515,9 +515,14 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
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



