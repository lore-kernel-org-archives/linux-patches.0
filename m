Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021021;
	b=rbStYX/YJVQ3qjhx858MJmt36uDaZlE5fRsyX6RVN4J64ak6eckdUThowKm+K1rbznuf
	 iwd54FxJffNLkjbtdrAreZzhN31yzKdCl5TbLaKrawOYWHizA6R4mOi/4/mGeUeOeDPL2
	 /nDGQ7iMhovMbAwvESQaSb1e3qwq/CyBp8wCSzHkAR3/LSOpzK8uf5zTf7ca4gHTA/eYx
	 KHEy9Bk4Saaa6M/j5yE80YzQ31d7L+BF5udqn0ENtIPzwt9gLSuSvG8DQE5umNoUNUSE7
	 Kxv5Qb7V1Cgn9EOrvlH/SmrWi7US0Gc9Fbms+w/PXvkqnYtgLsOBKVeBp04UaVJ90xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3zyWx8RQjCz8tDFuU2kBbxIRgeqNuUwYAyzgckO47jg=;
	b=UkGonGTUbw/ydrskuTiUQzy6Jww6mshC/Cb7wfFEE26upkyUG0Lny8J0h22TySMvoBoy
	 f2HjAPFv1igRsk1nkxUlvJaG9w2ZZ67bzWM+//ihNw7M7k3Amna+HYL38UI/8Csgc+mNd
	 hzf8o+s1ZgZDQogn3Z6BIsGr/MoJ81OTKKukbRUDz2GGKbQ2AkIC5SBhPI3hROkvdOMFb
	 Y0ww+0mKoKBQVOtOj3pTxQI8jSZA7ecDeTWHKeZ4CAxFZ6LM+J+tF5ts/f1weuGeoTV2F
	 fP2IKTHcvqEMz0VweAA/c91k0Gt4QhUg2kOMcS/SbwfBeOCS/C5ETU7NPLYY9NTH4DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XbGg4VW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5E0606A330;
	Wed, 18 Nov 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XbGg4VW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E16D1F000C4;
	Wed, 18 Nov 2026 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021020;
	bh=3zyWx8RQjCz8tDFuU2kBbxIRgeqNuUwYAyzgckO47jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XbGg4VW1R8gR/pVVtETriylGFluN6HDLdsdEBwZUV+DkmaY/JshWsucDm+lVkGS2
	 HA9bmz/Tl/SLl/YqRETNKk6oZh+CR4y0u4CuAlYtI4wNmnXA9bFpnpu1xnTNxyvIFp
	 Q22fGZoRgxkMHfaJTCWAHxxvKmckWg8ZkzvX2sag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2159/2651] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 15:56:39 +0100
Message-ID: <20261118150403.533622699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



