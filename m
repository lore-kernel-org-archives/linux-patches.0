Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032426;
	b=BxKQIgpUMhv9cPqPNeaPmdiY5cecSLn81brpP42zhzKt9HUwIeb8f0d6i9XV6CGyN7of
	 pSpuvcAiqy1pLQ7h98eUo6RJ2VfvZH32/awweRKFPNVJE69dGy2gr3qCA3w59rUzmF+UO
	 gPf3sNhPwaR3FMVClHtdk+a2tl/UecUKtFMG0aGwQ/qOrcsJ/p8te+v9J+YOoG1g1Izde
	 TT9PMd3jQiusx1fvHZZp2zLSaMSyht+EtrLP/TKEJK8fCjk7ExEVHX0fK5/8oN8tS0xK6
	 vE+T8uV+jO46uBjvW1oTlv62Io6AuKRmJCd/UbRGtRcRDYIva3NBeF3lsUYbppX2v6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4Ij90IGMhCYRH25/OMxPc+EzoAkdsqetusTKBwGRZSk=;
	b=0sGFWARd/upSCrHuFay9TRLAB6hCVYdPntYYX5VbttHoORfoQuyrHGAZFUk4QKL8fP9f
	 nf7xJOBEHKtwYwEE5p1dzJQVM7rWI3wHGvimvS8TXe3/g+HBgbqXUEM+lPTHdH7C3X0Js
	 s5OuO5y2RXWONIuolZswioSq1Sc2QuFkQ/iVoRBZPC4W+LkncxG5hJcnUEnD1HaY+wjtK
	 jF+9PYiLUuMhICfCDEBV1k+0tGvqa6l4ZTKvvNlNf8Rmc1OpznXqWD7BT3FrayoQhEcio
	 v/KtTdsWcurO9oY7fJlrLYaSRPVGE/Bn5ue3EgLsnis70XuO/td6Fe9Tlmf2GHEZ0LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQhFdXde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36260606A32F;
	Wed, 18 Nov 2026 20:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQhFdXde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFFE1F000C4;
	Wed, 18 Nov 2026 20:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032426;
	bh=4Ij90IGMhCYRH25/OMxPc+EzoAkdsqetusTKBwGRZSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQhFdXdeP2NqFWewCBPWnW5C2IKLDDNt708jWhThwP3rpVEWPl8VjJaDb0W9qEHDx
	 UMW1P9+HZQ2y8f7KGWijOM48vPdtSoi8cQjm2mVca+bMmANUAsIjsvkW9jmbsRmT74
	 e/9Bc4phFY7jzR5/aZI7bC6Ff8MVVuT5dAvDOYYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1407/1756] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 15:58:54 +0100
Message-ID: <20261118150105.214949478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ccc0463bc21b..6f17cabf82e45 100644
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



