Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025618;
	b=yLFYQuDUyvAi6KeJElHhOQ6wGPd6Y8AC2LBEfiqKd2H7ltQ93RrRHweQdxgKY3vod6Tt
	 ZfV2X46D2qK2gvhOQr2y1TWbSHtDGyTjsoKOpsnhT1Y/HS81qAwoRTj5C+S6c8OQOTDyf
	 lSbybtkY6U8d/miUcEmbcPWW0sBNPLGMMCgc9XM9e4Q6ueolHAHfvhPxYXjKzQBunA3AC
	 YfpNmx2N59M8U90d0mYnNYkCsj6vRPZHrpf8F4ALIePLJvnJsN59d+c7a0e9NenNP7uar
	 aEK9YrOmC8Y/VRa4r3/I+oqFlgFPv8I/UEkEbaqUdtHIfmRoyvoNeNBL+6mF9c4hMJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wWiOpVxBkGq4kF08fWR6OdKjlNPXFiESTwqp/pHjp/g=;
	b=DjhV3nF2v3/sqx/N+qlaN9eBfnRAwQhfRQ1R1n8Yds44CZ3HRPjKKD2HhbeSElqtArKA
	 9oG26nNlZxhSPj3GjD7CSl3mTZwzmZjXHVvJpMzmmEL7xE0STc6de080SoY0CgrabdFiH
	 Qo3BEvkA5RfbGs0hdK2vgbCswviyHMUVJz6EXEv8nFV4TuWq/AnAeyM5SI9Kb/IbB2rTL
	 x04xzZRlZZxYp8DmZs7z6x0SmSZCf1wT3E5hJDGBjaJDnqaS+43CC9sW/4sFD1oEC8HdA
	 Gxc4Xh9tRdKv0LH8nsSSOcws9oV1sa0IKDndXVXZPefUs8UCbo5HcGrq32TowK1c07w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6LcSuqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3707606A31C;
	Wed, 18 Nov 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6LcSuqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E5E1F000C4;
	Wed, 18 Nov 2026 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025618;
	bh=wWiOpVxBkGq4kF08fWR6OdKjlNPXFiESTwqp/pHjp/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6LcSuqO11HOH1kKmRur69uyykGZa+YumGYBUM8vIA62npTD2bbfGc3jy6FsdKLCB
	 uCM8Rwybg00Q2PnGbS752S3tChGy3sfnj6Ocnj4Yz4MFhLXFPLBd/wNpF0pqJMHeUe
	 UvzeEOAi02JqhyEy8pt9tQ3BhBb85t+CYYhTNrQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1142/2151] ipv4: reserve one IP ID per segment for UDP GSO packets
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150203.800336972@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 852c08d6a99149dc71c51cea125b5083f555237e ]

__ip_make_skb() reserves a single IP ID for UDP GSO packets, but GSO
assigns one IP ID per segment. Following packets then reuse these IDs,
either from inet->inet_id or from the shared generator.

Unless IP_PMTUDISC_DO/PROBE is used, DF is not set on UDP GSO packets,
so segments can be fragmented on the path and IP ID reuse can lead to
incorrect reassembly.

Reserve one IP ID per segment, using the same test as udp_send_skb().

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index fedc2bf7ce7fc..a76910e1d1175 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1415,6 +1415,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	struct iphdr *iph;
 	u8 pmtudisc, ttl;
 	__be16 df = 0;
+	int segs;
 
 	skb = __skb_dequeue(queue);
 	if (!skb)
@@ -1469,7 +1470,19 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(net, skb, sk);
+
+	/* UDP GSO packets are segmented later (see udp_send_skb()):
+	 * reserve one IP ID per segment.
+	 */
+	segs = 1;
+	if (cork->gso_size && sk_is_udp(sk)) {
+		int datalen = skb->len - skb_transport_offset(skb) -
+			      sizeof(struct udphdr);
+
+		if (datalen > cork->gso_size)
+			segs = DIV_ROUND_UP(datalen, cork->gso_size);
+	}
+	ip_select_ident_segs(net, skb, sk, segs);
 
 	if (opt) {
 		iph->ihl += opt->optlen >> 2;
-- 
2.53.0



