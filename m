Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704205;
	b=HB2i8ApMx8TIe+WB3FlJXcPiwFjcTKNvvvAWe0rdAPOE4JOU8I6xwc8tWvQoTRbr3LKk
	 wKG1351GGcI5WjgR4yX4ZVz0ubIMmaE9AOiMg/F18KLVjfHTV2NOjSKeZ4HawOjj0Kqra
	 WzyjOk7nPEBPZjnxBVPjyHXnSFkt7yz7xl1offG0zuURJCkrbCpsUd2sVoaTeiGUTBrDe
	 eBWnP+qHghypjxtr9qkjxf1XbSt0QRYc2l1AyU4oZCsEdlEAlm0WxdfcGnSKp0S179pCV
	 bo6xM7/wXroRmqu274qCUQ1sDSHpzEtx/9MHsajn9aImoFRygZiHM7OKCqqgTjt8Ppw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xPioSKZT5I4Wf+FzoRwIWh7Oz7jkV8WpvM2ihegmYdA=;
	b=eRy/XXGbxNXyBeqqh/ANyTGfnVpeE918484hxkfpLZ5VRmjEAHG+3BOO4ALexwbgVgJt
	 mViIgS633BOZxkko5UCrXEZkaCvJ081etVpNcw36AHi8GgW8G5MvBCTmnocqD3QewWDEk
	 U2Wsv/V8yLpQwlkI3NKgEB7RI56trUMMX87K8CnitfzEVNlM5K1MmZxoImuaj8wnbR51K
	 4j7dSGkCvsOgemY9f79wXI7G/UwNRSARasYHvz2DOex8hjZiYlfm9MTq4eZeqC+rS+TFH
	 63FV4JTO6qAHbbvyXrfSJ4mPtjPv5lKPQoboFdECIfL13VcXkTsE5UuxyogI1zmBI1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTluDNRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E353606A321;
	Thu, 26 Nov 2026 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTluDNRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1DB1F000C4;
	Thu, 26 Nov 2026 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704204;
	bh=xPioSKZT5I4Wf+FzoRwIWh7Oz7jkV8WpvM2ihegmYdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTluDNRj48BtVSzgS0UhtWf0k/dOUmrbfPs84Q3ecTVHsO1TWbq4WDq8Wehq5y6UL
	 +70vy1T/JS1rVJh9f52ZqHKfn7vbLI4oTOGlVw2mbq7BnLvmLhxPH5fU2g4gg1gzeL
	 hLlubO5/ql3c6Ex+1uLSTRpFChnb4AmU5sWff0Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/265] bpf: Move the transport header with the moved headers
Date: Thu, 26 Nov 2026 15:36:10 +0100
Message-ID: <20261126143607.920146552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ec9a74985ab1a..398dddc9a255f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3317,9 +3317,25 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
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
@@ -3330,8 +3346,8 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 	if (likely(!ret)) {
 		skb->mac_header -= len;
 		skb->network_header -= len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
+		if (trans_moves)
+			skb->transport_header -= len;
 	}
 
 	return ret;
@@ -3339,7 +3355,7 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 {
-	bool trans_same = skb->transport_header == skb->network_header;
+	bool trans_moves = bpf_skb_trans_hdr_moves(skb, off);
 	int ret;
 
 	/* Same here, __skb_push()/__skb_pull() pair not needed. */
@@ -3347,8 +3363,17 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
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



