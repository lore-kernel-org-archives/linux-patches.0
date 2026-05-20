Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D653A16B6;
	Wed, 20 May 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294767; cv=none; b=YlTbVTDEkd3e2iOZehmtv8S+QM2vus610ODrdRjQkXwSvJHShZAo/YNiRGFOL9oOAfjd+AmcJ5mHRKtWPnv/7v9hUVao/tHEWaG4TennXhNunakvGdaoLCkFFxnLzJuERqG0k3b1KGHUB2z+NMlvzPfr4ZiYeEiHh+PDzXOE4Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294767; c=relaxed/simple;
	bh=sTJW6nKT0xJuXVcHknsDW7P1jcS+HZ5vPspJ7YMfFBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLUQYM3KMaaPN5dnw9qWKycGXWtQ5yBehKRrb4c+xcbjwSoqrX0EVtgN9bI16O6p8kx/8MO0kitOi+NEp5G8UFM+pA8jNLNBQ6y4BUSHuGacgYmeDgXVSr/BDeUkv8JtXmaSjZDUxRjZ1AgseO4jDQbkw+e0+cAKKIrfY3GCj48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5DQS5j+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5DQS5j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D0F1F000E9;
	Wed, 20 May 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294766;
	bh=MoIzknNqsCAkNnxDlEiwTBElyihHMmA6Gw+9MKCMIe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5DQS5j+KJu9qBN0k5NsJzgqjTHiOWixzjBAZY8XYTwes20hFKSr5Jib0PUhoUnoX
	 gPyWA6ltcOLQ9jobVzwH+USSQ6BUNRQ7FjPR47Vwb6oqtunNvLs+2t9/J4Fkk+vQAx
	 EnKL6soQIbkeqiVkyNcfH4yupErX0BQHWzidcFbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0162/1146] net: qdisc_pkt_len_segs_init() cleanup
Date: Wed, 20 May 2026 18:06:52 +0200
Message-ID: <20260520162151.961307887@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 30e02ec3b4b6bd429a4824f125eb843a291dcccf ]

Reduce indentation level by returning early if the transport header
was not set.

Add an unlikely() clause as this is not the common case.

No functional change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260403221540.3297753-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 62 +++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0f45825bbed2f..44a712f777b79 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4106,6 +4106,7 @@ EXPORT_SYMBOL_GPL(validate_xmit_skb_list);
 static void qdisc_pkt_len_segs_init(struct sk_buff *skb)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	unsigned int hdr_len;
 	u16 gso_segs;
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
@@ -4119,44 +4120,43 @@ static void qdisc_pkt_len_segs_init(struct sk_buff *skb)
 	/* To get more precise estimation of bytes sent on wire,
 	 * we add to pkt_len the headers size of all segments
 	 */
-	if (skb_transport_header_was_set(skb)) {
-		unsigned int hdr_len;
+	if (unlikely(!skb_transport_header_was_set(skb)))
+		return;
 
-		/* mac layer + network layer */
-		if (!skb->encapsulation)
-			hdr_len = skb_transport_offset(skb);
-		else
-			hdr_len = skb_inner_transport_offset(skb);
+	/* mac layer + network layer */
+	if (!skb->encapsulation)
+		hdr_len = skb_transport_offset(skb);
+	else
+		hdr_len = skb_inner_transport_offset(skb);
 
-		/* + transport layer */
-		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
-			const struct tcphdr *th;
-			struct tcphdr _tcphdr;
+	/* + transport layer */
+	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
+		const struct tcphdr *th;
+		struct tcphdr _tcphdr;
 
-			th = skb_header_pointer(skb, hdr_len,
-						sizeof(_tcphdr), &_tcphdr);
-			if (likely(th))
-				hdr_len += __tcp_hdrlen(th);
-		} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
-			struct udphdr _udphdr;
+		th = skb_header_pointer(skb, hdr_len,
+					sizeof(_tcphdr), &_tcphdr);
+		if (likely(th))
+			hdr_len += __tcp_hdrlen(th);
+	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
+		struct udphdr _udphdr;
 
-			if (skb_header_pointer(skb, hdr_len,
-					       sizeof(_udphdr), &_udphdr))
-				hdr_len += sizeof(struct udphdr);
-		}
+		if (skb_header_pointer(skb, hdr_len,
+				       sizeof(_udphdr), &_udphdr))
+			hdr_len += sizeof(struct udphdr);
+	}
 
-		if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
-			int payload = skb->len - hdr_len;
+	if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
+		int payload = skb->len - hdr_len;
 
-			/* Malicious packet. */
-			if (payload <= 0)
-				return;
-			gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
-			shinfo->gso_segs = gso_segs;
-			qdisc_skb_cb(skb)->pkt_segs = gso_segs;
-		}
-		qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
+		/* Malicious packet. */
+		if (payload <= 0)
+			return;
+		gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
+		shinfo->gso_segs = gso_segs;
+		qdisc_skb_cb(skb)->pkt_segs = gso_segs;
 	}
+	qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
 }
 
 static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
-- 
2.53.0



