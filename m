Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050219;
	b=3cP0t/CK2cFR8wD6q2S2l9YcLIWzx/P2WmztgoiV0lVQpLHytotvbNz82Laoq39KNcIW
	 2EbSAqeEBBepa8YdoDZcsKeBi3Zq6O5C/BvaFUuXQtC9PO0erDk5I26wzmSVW093+KUKG
	 xYQlY8HwYCRN6J/PRwINjNtzM/TljsE7SM5Fdw302MisZdc02cBn41YqJcpY8T1Imr+rM
	 DD7y3w/j3pmBwYFb8gXIUTMEHMyUfEVvaBpokqbRU5wKBBL9+/xJjaUp2WmuGrwwQqd9P
	 yv242VKUNJHC+F2ZRx84umdx7bLVsSdNBnoGssShfvtBGt4mwGvMmY3utpTVydWqdKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Bkkp/I9xV6CUbg02VarAslS8nl4/fBZVUHtLbG4dWE8=;
	b=uFDGONiq2L7/f3V3fJy38O40dz4DJQaRLf5JPRHtElcEiMD+sxPc9+rOY19FpdPMs0pB
	 bH/hh+H4FMgv/MtFw1b/UALYvbFRqfS6CzARU5L7EITSFnbG6iI9lgsbT5m3BIqgJTBvq
	 PJL0QLRBJlzaKTJFpNPhMXKMW8ujDCJ+LtWTBjggbswpG9832/9UPTqlizCmkkpWjUDij
	 +crd0MAutdmOw3K8GitwqrllSuxDPuhpi+h25Wlpz2KTZa3f8wGk99Pds298/2SxxnFxR
	 q70IG7oE2H6gvTARvkI88mcO467YzIOvI8C9aa6i9GwSlh/mXbfRhCH6Rrx2pJKyDZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtrEFYja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA4E606A32C;
	Thu, 19 Nov 2026 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JtrEFYja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D741F000C5;
	Thu, 19 Nov 2026 01:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050219;
	bh=Bkkp/I9xV6CUbg02VarAslS8nl4/fBZVUHtLbG4dWE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtrEFYjaPC0wYZi0aKFRLpNxFtb52iT3oBJyu5iJBmyU3rqUnYlEv/RZdCUGMADAk
	 8SVcDrji128/kP7md60HLcPBoMnUKYSSzpW4oiCK65udmOsWTEhqfq+IIwGVvQubWZ
	 y8uHVDR1k3DZZNyugEGHIU05sVYwkW4EQi6Xczn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2623/2857] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150336.013125935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 6642f06d1b1dc..357e7b3768633 100644
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



