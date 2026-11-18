Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061917;
	b=369cB4IhWTYZrdlLSCyY1yR2DwEgc8pmCPaeH/zHxskg2kti+ovfAM827AS6Z/6hLZkT
	 rjknfHpkFvGRoJHOsZ+O9QOiwwID8XHS8jbOFkz+gGKs0n2H8bPDtbs4j3zO1TNJr3iIx
	 y3FdqsGicZq/H3Egprd5qIujyiyMp+IpODfyMbWrn1vbRfgfJMTq3rMilvU4s2A8byGzu
	 gEu/cCZxP6ACzdbYshkvkcweknP8NFT7x7YNzz7kcL8a2vK2tRHJBjMSIWzh+e2rfS318
	 2vnDftVkzu7Jlli8MqXmN9z5QHeoztEWraT48Q7h/9e+owgWUT1WtPrifRMLS87vHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dekTK9EsNajOZfvhFr7kz6DbERg23Y5+/e6QIdh7Bsk=;
	b=CATJ4XbqrAyvKSiPh5kHRREQvcqeyIDDVjDNJLeo9QnUNJwdlelAdK5AQz+BG+sGD7lF
	 Vos5DdY2Zkp/2EfnMrTbhOQfg1O0hR/iZqKJseZ1anB1W9QFks7IMNCnkTubFmP9WSnLI
	 4PhPhciq7FWA8b6PdRa7uG3bSUYxOPRN1N/H13OYnegxfszjg+z22kuPjN04BjA1jfABJ
	 3wJXglvGrwLqlPBlJc7QzdtR+p/ylvzrFq0FK+9BKG83d4s0yen1XZgFxIRHE3euwtonw
	 rZszt+rIx0uu5hTB/zVQD9suA7pejySGk319dgc1uZhCsopy7hLuvGwWpPY53Ysov9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Axm6MlmH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E377606A320;
	Thu, 19 Nov 2026 04:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Axm6MlmH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5001F000C5;
	Thu, 19 Nov 2026 04:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061917;
	bh=dekTK9EsNajOZfvhFr7kz6DbERg23Y5+/e6QIdh7Bsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Axm6MlmHP4e3b83aUVlREKOj6Io2YmMCB4xmdk1R3ITw7tWoJQc7zBgXS7uYSjs5x
	 p1/8542L5edk3D9eOcOh4moFV9BQAWCWEaMJnNnkzRzDAwaXjP9K3jeJBv6YLIJVsW
	 dwVYHtIuDBoUIWVC1JAZ+21vv1EQ+lHHKTjEZl8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1723/1848] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150031.765111516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8313069b9f391..9bbda792efbeb 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -394,7 +394,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
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



