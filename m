Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042080;
	b=ZtHDmRuDXhoq0NTehV0pKfmjz8E7rlAwl+c+NGRM5ayqAUjOGGXftM3d8jKyA7NzSbDo
	 MBQlLlO/vjHG5hrTpoU3xl7yQN5kyBHS7woHuSWv43w2XCNlMSURGaYWcRPP01lyGIM8T
	 avWIEVUHSyD5+yNuuGkp3qYG5ycgQKHYKbTAGAl1W132qP0wUPIpVlvsaPDe0KcONC/+6
	 bceJGSwTEEBF+jN19xvHAz1+nPxdYuuQMMmz+ycPr7m+fFBIoZtqiaVoFqZ4zbKC6iYs0
	 GcvkX3Z7pkqpe7QRA0x+hh994+hEYiuc2MnhrZWYfbcaO3dSz6Vo6k605HvhfvxhX4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aeQfvoHPgrvzIWOaEz8WTidSDccg/O/CRPqUTR05R2s=;
	b=jANjR6pghm+2KJQKwMJup0Wn3rSFNZwyYm4HsDTchjua3PUDZWOFare6z50xT9CuUZNV
	 G2T1+oyUIMzSbYU7V3cCsnAUOtwzqwjqACYXyAUM1tgYLgxJ/XYBd0z/KyaqCNp4zWEJK
	 gdJnskqmueWNtDJU+YascNAUZdiRyfdBAfjgFPIkyqmpJZ6pBMR49B8lU43rJREo8jT/i
	 vVMZKYQUF3XX7ROc+lSbbMZA99JpRYsUBzp4cUcGtdav3CoO7H6u8H0kB8YxhAaCqHFVC
	 uFXDZqkXeR8EQnscD5tHiqaOKJdonWT8E0a7O7/mxiQfO0xKN15GoWBFCPY6Gtr2xQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUuPsD0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900A1606A320;
	Wed, 18 Nov 2026 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUuPsD0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1780D1F000C4;
	Wed, 18 Nov 2026 22:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042080;
	bh=aeQfvoHPgrvzIWOaEz8WTidSDccg/O/CRPqUTR05R2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUuPsD0Tk1EsREcq2HdGllJOBrB1RccMAdPJdlsWvWks0dUsbkkb2zNDfk1D228Xo
	 DGzet9maVCwu35hHLdq8dfA5Aeo2SyKfnl3Idjtz9mAA/AA0WQVLmbTkWOpVhNzeGr
	 tEwqvLFVYt7qr8/KLxdXuEluq3m4A8Yh+UAisLlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3043/3318] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150451.449964446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19d5a1370ae6a..1898c3bfb859a 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -402,7 +402,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
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



