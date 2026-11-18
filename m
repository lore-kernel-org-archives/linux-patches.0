Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027386;
	b=0wl8ti0kCp/+4dZq80MhDGjESsjnT7nzsIS+ljkAPUBDouPTuKqBo9RpcR4+DhApOvXK
	 CtO6vccLNLta5bd17Qvi8hz8eqR3BbgC8/DrojWUvIUup6CLRAVSKN9zqVfexnkbNnbkh
	 FQDyP6gHFLEKmQiA29uH5zbMHDaLrXvL403inFWckrNR1Nri1Zo39lIaGqKqbji22aj0c
	 5hxYSKHhpVMbLsAbBuVOTunYvDB15KLrpHZp1bgMtv5wvcoEteiTq/w0/DJU66tNFw4mH
	 VU7uek5GS+6TAofca8SQ0GmmGHf+wty2Zqjn4z9X5RwMeHsfvDYCY9Debxz2mMD6/ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UgX1rE2dac6sKYXej/Ch99ghL6rB2nS05yHkYtOBewI=;
	b=dJS8sUt3vzp1tWJ739TkqXozU8jqyFjzUY4S69N8ArtbVWcGxN3yZFBS4ciuGYr6YOUq
	 OzXQQboi0v0x2s6IYOdPR0K2hi1gFINz0ze2+Z5VBOiiGOmzxeDQGCkpdHlU7GpEJjpKA
	 DxkeUM4FSeDGSzqUyWOf3Vpv+G6gApuRrbUE8kkmfaZaPQglWB/jP6kFsYfxdYW4oB445
	 UXijdpuC7AiUBejezDirIw79JkK7Tm3otIjiABZeAmQNW5lY6v5LNKI/8m+bAnZRiAtLs
	 zNC1NsWMrIcDEKcEbDEemO5y3KJHXe/YBwehKto3wNjAK5nsUNoAJ717x/gNCVV15PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9vZsFpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D460A2618;
	Wed, 18 Nov 2026 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p9vZsFpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16EC1F000C5;
	Wed, 18 Nov 2026 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027386;
	bh=UgX1rE2dac6sKYXej/Ch99ghL6rB2nS05yHkYtOBewI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9vZsFpwPt5eysInBJW7aYe0K+pznk2kPUNwuZ8CkF4gw8rV/lj6u4xQITWzS9Mo0
	 6VEl1c9tBIUHyXaW4DLngCZ8oCcCT0xuSg2ec06Amokwomp405EL71ypTWjL9+mOgm
	 nMqROUOdQ4gRY807dX3koV6GBxCU8TzleMP0Qszo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1770/2151] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150226.311076862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 02341c64baaa6..f25ff2a12a824 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -401,7 +401,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
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



