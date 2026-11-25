Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624182;
	b=s6im7RxRcOD2QxNT06yFwwI9MtzuylP135SeY9kOEELQ4431MaA5v/BpzBpidMVFj19/
	 /mqUhFcOu5XBG6NBBeTCsIiu/+fwIQJeVOYWfQw2RHUKs5qVA9oef7UUg3hGSgk3840tu
	 r+nl5SFj/eFWiIm0Mxud8JCPje+laXxiDhh1lPx2xTPxyJNIwC910RSZ5JWUwi9SdSzFB
	 VE0wQL4kMmGpkvIkChzoax814w7Q56WTseYy0JJSYUo5g3SnXoDRcqyyITCFlTmkukI+4
	 YaVT1DUs9DZONIFVRQOrTJys3Vv+0rBCxeAHHB4xVGk/hIYGWJSLXsKhslj/K6S4iVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nf4/HKWOflN9VQgguyK6c0j5Cvj+TPLd6PE1IQU+SQA=;
	b=r92A70Ds8MVakEltr6tFI6yqj4sQHpS8pGrBaIyUz6vkXhpiQs22Rdz7KU+KMzEtBCC5
	 T2LiWDmRdzWV0Lnuvp6CcQ7+DVm072/+JaliNTCYUcdxjf2SIQTnwGT0xtA62Byt0IELS
	 WJ8keTzbqrX5N9LWR8+J7SV52+6IRM4ZfWZsfpkgYBHevtfFIUfyk1Phutd9qYiXDd8UN
	 FS+EEUShbu7z2Lgcs1e8gbHKVKFcJEfdcaNkG8qyaQJJdTdfS+K5qEcVZM0H+B4JHLLF5
	 yU0cNfQfsLF9VHuslaSTHwgDTJ1bfKNF7V0MuChjPLurQgS5xGO6lVt4IWDbB4o8krw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ruod7kTY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E2606A326;
	Wed, 25 Nov 2026 16:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ruod7kTY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E421F000D4;
	Wed, 25 Nov 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624182;
	bh=Nf4/HKWOflN9VQgguyK6c0j5Cvj+TPLd6PE1IQU+SQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ruod7kTYW6sNW42z1KRqrrDmh9p4iOlQr8ngeQmP+G3me0VvuIYIqzgi2yi5r10AD
	 LJGRadXt6IhFIuGo9Lu9HMto+WhteK1mJxRwQMlaXuOu1Z5eZzXsZx+fLdTvOwyX/G
	 flt9vuEDhG5/OQG68AGDOflJyOVgq9jQS1Sprm00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/816] bpf: Move the transport header with the moved headers
Date: Wed, 25 Nov 2026 15:27:38 +0100
Message-ID: <20261125143851.759542284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1cebf5d12e81e..359180c91d034 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3353,9 +3353,25 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
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
@@ -3366,8 +3382,8 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 	if (likely(!ret)) {
 		skb->mac_header -= len;
 		skb->network_header -= len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
+		if (trans_moves)
+			skb->transport_header -= len;
 	}
 
 	return ret;
@@ -3375,7 +3391,7 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 {
-	bool trans_same = skb->transport_header == skb->network_header;
+	bool trans_moves = bpf_skb_trans_hdr_moves(skb, off);
 	int ret;
 
 	/* Same here, __skb_push()/__skb_pull() pair not needed. */
@@ -3383,8 +3399,17 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
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



