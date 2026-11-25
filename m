Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619173;
	b=sS/8YgGx/qkCOWCrvLFkhEefBUi6CmkywqS9pXb1eBY4LAVuwC4seBHiv8zvzOXSDaNn
	 SRJgYDbVhpZUZ1P/0uhs7ziXmJ0atqrjc/6nKnWIQ/LCdyrP+9sQFd/p0jPTjcOm+Z0Jh
	 3TwnIy1iensJ+pDURfUJxbdVZG/bBZoqDhopTOnXFU8jhbg+3UR0puHhXEZESM4tLsTcz
	 Dx2KjPK7sSSC+vgS02dfRyuwEuWBKLQIn2EHnkOqv0AoHQr2CTboxnD8kDhVnkJcQtXDw
	 Ob5yRqVGxg8fDDgmmmNzxilhWcRKJJ5TzIr0UUOzoQjB17/bS63rCtxRsSa9gemT4UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awimwK3wvv3lj5BV/63sdZ5TRTVO5mx/uHHlvkrjehI=;
	b=bzs60Y1gFIXxQYxhgtLFpID4K3+ZIUulW8ZWsE026rgIYMIzpoYxcFfptdVMQ1rm7w+7
	 kKXDUK75qJ745hvi+L+qnVeW1JnN2n7Gl8sM4FdXqRGvGFp/ZrsBNz4eUQaamR0Phyi/j
	 ETRhWCCiTaUaDiu6eTLwhTBrKlRWaxapuk/mRJAJrWU51GX/oBsoRYZLZHSAMbBuY94Mx
	 ZbM+mB1SGDjNnLTMyeW0H00+LPME+fPRJsHt0SpAg1K+E7otB2OcABQH1+W+hoX9BD7Ya
	 jOcKqQHFVUusj+o5KtCRrbn6SgKdWwAnYtdENKdsN2GEs/oce0OqksCkJiPUzcuZTcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZM5CPpr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EA8606A321;
	Wed, 25 Nov 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZM5CPpr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BDE1F000C0;
	Wed, 25 Nov 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619172;
	bh=awimwK3wvv3lj5BV/63sdZ5TRTVO5mx/uHHlvkrjehI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZM5CPprc0n+JWDurYQNlT3XP+Y8EzottoLo9wchkhGHmZ2lYBBsdTpdXZeouMR49
	 uk4HKgyiSQSvbeTVDpYcjXivqORnuClGO/hvxD4dhg76COQHO4U3uY9ZRwJpVy7Ie7
	 Vcl0b468afkXbSA4hPJfZZkZDBhxLwfT0dpO9lPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0514/1005] udp: check frag_list IP family before using skb_segment_list()
Date: Wed, 25 Nov 2026 15:30:52 +0100
Message-ID: <20261125143833.785957175@linuxfoundation.org>
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
index cf07c3c6611a2..802365b4780fd 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -514,9 +514,14 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
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



