Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618100;
	b=tvrndW5IQ/Y6ZACkI5UNp0eLGVUm1/KrGqBCZapBYyN+NqCbXlh9hG68/lS+LIn5xYpI
	 gOEL363nEOJzEToDSj1nSDWJmlPZ3jzzKOTlZDOF6DjWA07emWj5+W7jrmjBCU6k9/v34
	 OHCxjXEkf3B6HcNmWA7WSoAVbDScIT3Jii78A2R98OnszTser/Td1/qWw0PHPIhdX5Xmt
	 E+ySOiOLMWosoZPx1xNeF1BRWufgggSjXJy/KWmezli4EnqoG61r8D3xmOP/H6BUWMu+i
	 GtgeRRm+siRYk8MTIccElBu9GgOutAEpprqtJnIq22fmu99gLzBfGcH5VbX1PUndK+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPiLwsL8rJiAPjNgJhYujMv6Ut61B9P9gKsbbkWgcDY=;
	b=RmZGqK0EsNoks+PoP/NmO6VpXxXmUgnPgOxq+2S/Vv9tJD+gS2yoYFR20bs36oKxuc1Y
	 dCQfJsRCiGCV7SZF+JriS4+mj1CB0P7caINKOuRAFMGBbMYkGJwbZKPNRQPL5x2jSCuOR
	 a7pK/YQ/E1WnzcvhJXYkfAlwrHVvud8t50kBNpBUS93eoafar+DLno0vIpltOXN1k0o3+
	 xC0CeKmEvZQ1mSLoy6sQwFc0/LWJT8cOXnnaK2Mt3AdLLuBzfY5o7cyhOeSmQboJbd5Z4
	 AGfdT5NkM6OESuLqTd3YE5Rm4AxLdNpxj1t4YFOEeRzkZpguesc+hr5Laun/bYt0x2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPc76WLH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D0606A321;
	Wed, 25 Nov 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPc76WLH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641501F000C0;
	Wed, 25 Nov 2026 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618099;
	bh=bPiLwsL8rJiAPjNgJhYujMv6Ut61B9P9gKsbbkWgcDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPc76WLHdwh3dg5jKGtCucY2t6ioRZ/nT2jmNLGtqQTnrwUKOu6dFbVAuBfqp2Dmp
	 Q4lRVgFAWS/TCY0gnPN7i8vsO659Jv97F6oBXO4ohNhUrKHaWGiOZd3864TSZfbxRX
	 VjkVe6RqgQ4P5pIs/vw/AGECjuVJHfkBSOx8Mies=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0116/1005] bpf: Move the transport header with the moved headers
Date: Wed, 25 Nov 2026 15:24:14 +0100
Message-ID: <20261125143824.461869071@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit a9d08fe60fa728ce0e3a99085241e8e790fb14c6 ]

bpf_skb_net_hdr_pop() removes len bytes at offset off.
bpf_skb_net_hdr_push() does the opposite.

           skb->data       off
  before   | A             | removed | B            |
  after              | A             | B            |
                     skb->data       off

mac_header and network_header move with A. transport_header moves only when
it is equal to network_header. inner_transport_header never moves. This is
correct only for a header in B. In bpf_lwt_seg6_adjust_srh()
transport_header is in A. bpf_skb_adjust_room() can remove both transport
headers. With an incorrect header offset, the stack can drop the skb or
read outside of it.

Also move transport_header with A when it is in A. Set it to offset off
when it is in the removed bytes. In BPF_ADJ_ROOM_MAC mode it is then equal
to network_header. Do not unset it, because skb_gso_validate_mac_len() uses
it without a check. After a removal, set inner_transport_header to off when
it is not in B and skb->encapsulation is set. A has only outer headers.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Fixes: 868d523535c2 ("bpf: add bpf_skb_adjust_room encap flags")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-26-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2d539860684f5..475c9e06cf06b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3402,9 +3402,25 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	return 0;
 }
 
+/*
+ * bpf_skb_net_hdr_push() inserts bytes at @off, bpf_skb_net_hdr_pop() removes
+ * bytes at @off. Both move the bytes in front of @off together with skb->data,
+ * and leave the rest of the packet where it is. Return true if the transport
+ * header is in the part that moves. A transport header that is equal to the
+ * network header stays equal to it.
+ */
+static bool bpf_skb_trans_hdr_moves(const struct sk_buff *skb, u32 off)
+{
+	if (skb->transport_header == skb->network_header)
+		return true;
+
+	return skb_transport_header_was_set(skb) &&
+	       (u32)skb_transport_offset(skb) < off;
+}
+
 static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 {
-	bool trans_same = skb->transport_header == skb->network_header;
+	bool trans_moves = bpf_skb_trans_hdr_moves(skb, off);
 	int ret;
 
 	/* There's no need for __skb_push()/__skb_pull() pair to
@@ -3415,8 +3431,8 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 	if (likely(!ret)) {
 		skb->mac_header -= len;
 		skb->network_header -= len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
+		if (trans_moves)
+			skb->transport_header -= len;
 	}
 
 	return ret;
@@ -3424,7 +3440,7 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 {
-	bool trans_same = skb->transport_header == skb->network_header;
+	bool trans_moves = bpf_skb_trans_hdr_moves(skb, off);
 	int ret;
 
 	/* Same here, __skb_push()/__skb_pull() pair not needed. */
@@ -3432,8 +3448,17 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	if (likely(!ret)) {
 		skb->mac_header += len;
 		skb->network_header += len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
+		if (trans_moves) {
+			skb->transport_header += len;
+		} else if (skb_transport_header_was_set(skb) &&
+			   skb_transport_offset(skb) < (int)off) {
+			/* It was in the removed bytes or before skb->data. */
+			skb_set_transport_header(skb, off);
+		}
+		/* Do not leave the inner transport header in front of @off. */
+		if (skb->encapsulation &&
+		    skb_inner_transport_offset(skb) < (int)off)
+			skb_set_inner_transport_header(skb, off);
 	}
 
 	return ret;
-- 
2.53.0



