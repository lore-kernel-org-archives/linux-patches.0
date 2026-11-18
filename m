Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056606;
	b=Ya8nhZ3JrqLWpiSoDK9QQvu/YJl/YzqaierMmZIsP0IvtjUIoypnoHGJ2ktfzNbitCCZ
	 DppXx1Lci6JL8j9T+lRF86RXFuWoEHwgbvqmc30vZGtTR7OVIe08rdhq4HV7TM+/o/Eeq
	 CSUx8RKfl80jR1BDIHjyrBKAQld/one7IInLnHBQdJO6lw6eANRZmeeUd06RCPc/DlULB
	 sa0U2yy32pxFKlF3agdqiKV0tFB1T5MNIjnB1CD8uxtyYWL6+RIdxCkPmFIaHBj1b0tdq
	 N+P9WZosHhpgsFVogcCobwc5Sn3FF3Ra2SqReIdx33wKIVlXeKajsyT9gXsFgmQsaag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=H3huRVlNOTVQTkvKG/gHxRUWnYsqo7zzaGQWZIH+Vts=;
	b=qravHyBm/1oE6ZTtafT88vp8yryoBnB29FIpjzRJNyvP7lXsQ1y90VeZpQ9Gblvlj/Ne
	 MlP6EIn7fI7eSKOxiH3nhIzFTqyVg9AKs4THdOaSj5rmPxF4JawTTkHBhx1P2WUK/RyeE
	 ZKFd8L+3gJoX6i4ItwBkubsONenP2T7xYbGrIqK71rtfNXB+Ku0pfonSrYQDMb6mxHzJw
	 D11EpuVfvn0VfgrVVcHU1jR7dMOh4NJbF3XeBnKQTy/S3fa+fHzF2aoiya4kwfnVRvcXV
	 SkWll0hK7osPI4HoJ9hp2VDFMfHziK1jRny34DY+E2JBfnXzqcin6yw6MuGCUdOidNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQocETBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28A606A320;
	Thu, 19 Nov 2026 02:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQocETBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353AB1F000C4;
	Thu, 19 Nov 2026 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056605;
	bh=H3huRVlNOTVQTkvKG/gHxRUWnYsqo7zzaGQWZIH+Vts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQocETBIgNFeWXd/Sx4SAmqONbdJYWdF5FHpjKsjwuY1MwWo/kjZfpRDU3kdHHKaV
	 RhWf/OqPScuWvAcs+EexLLzRiagaNVor4eYj6ObbE9WPXxEaikfHQsOIxA0NwXosHO
	 52aIIMCFZ/+6+dUqjmmf49lQUo//04nDo7VGZTmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2048/2214] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 16:02:04 +0100
Message-ID: <20261118150132.638136412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 48d522b65fb0ce2bd54f8f5838d77b48afcf1f3e ]

find_prev_fhdr() returns the offset of the Next Header field before an
IPv6 Fragment header through an int pointer, but stores the offset in a
u8 local.  An extension header chain can put this field beyond byte 255,
causing the offset to wrap before it is saved in the fragment queue.

Reassembly later uses the wrapped value to update the preceding Next
Header field.  This overwrites another byte in the IPv6 header chain and
can make conntrack parse a different transport tuple from the one used
by IPv6 local delivery.  A two-fragment packet can, for example, be
recorded as UDP destination port 53 while its payload is delivered to
UDP port 9999.

Use int for the working offset, matching the output argument and the
other offset variables in this path.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index d3b728771737a..56e6f6d912a93 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -395,7 +395,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 {
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 	const int netoff = skb_network_offset(skb);
-	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
+	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
 	int start = netoff + sizeof(struct ipv6hdr);
 	int len = skb->len - start;
 	u8 prevhdr = NEXTHDR_IPV6;
-- 
2.53.0



