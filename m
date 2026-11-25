Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621111;
	b=DBdhz/lzkecR4Kj54YdbH1mT+190WhYbwz0av1qv6kgeZzMW23ZRcv6EXcKLJoINdB+5
	 gtf0BlDWj+ESQkPLHL6+ntxOAmrALQnAGgzrCv2s5LoLInLReT5IoIEYQfEvkoHjxjvBP
	 0gNePwPIGMYigir8zBghGpp48ZpOdiJDQh/4zWZRgJyk7GO+fjiIjMRowE/Ifu2YYvdPB
	 P7j9scFo6TQWMU9on5rlDiFXYUNLu32dN4wGIgCPeLsb5UNPjUX5qH8k5X1R2lGCQJWWV
	 fmnMRkhEiU+ShdC5XZNYbI9KEh4a814bkqTMGKNnJTcbKK8nxd7wbHnfOJ/rWrfz6+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7hQmPDVPWWqNrkrKDtHXweBi+BEk6L+z+tjFDeplco=;
	b=dhF5zLspMkyfEObie/wtAv2IKwNxDw7LQrYgJ2SvgBeopFLp2zB7FWz70/C2XE/ZIGlo
	 BU+gYPcf1vSZmWbZXsoKgZq7glMJtMjNHAbEHfetC5qsX4TJ27sCkMCf/6q2C6LXRpbz0
	 rcLsz8XV2tLBBIUEJkYluuAj8Aspc1CTVuesmD6KOxUYc6O6ptp2rK6RxmWpuwJ9ASY0B
	 XvOPEncvpme+Z2IAkchsGhhtZOD+q2AoT8eNy+q51Lv9qSErBrc53UjQuco9fMS5raEAs
	 JtPHmr3DOEhIP/9PtKzfRwrdEpZ/7dvV/PMpMcg1vC/NxSM3cFtB/2nVryOXLSNFh6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioU5QF6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976C606A321;
	Wed, 25 Nov 2026 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ioU5QF6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1376A1F000C4;
	Wed, 25 Nov 2026 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621111;
	bh=t7hQmPDVPWWqNrkrKDtHXweBi+BEk6L+z+tjFDeplco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioU5QF6ENytnNiK9IhjZj7DhfgRy5VDNVoage8xUjv8vFq/n3q8zk8tVoZW2uuetw
	 qvuPu0TMCYbxAVP7+xVfadbhHktjHYZ06jqGKzMUEfcOTRUJ2MkQyynG0j4jAcxop3
	 l16iRavtDpd92oqjpKehy+Av+lR+g1PfiucIL1dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/990] bpf: Move the transport header with the moved headers
Date: Wed, 25 Nov 2026 15:24:53 +0100
Message-ID: <20261125143825.039925972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 84d5d7e456889..503ca33402840 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3363,9 +3363,25 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
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
@@ -3376,8 +3392,8 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 	if (likely(!ret)) {
 		skb->mac_header -= len;
 		skb->network_header -= len;
-		if (trans_same)
-			skb->transport_header = skb->network_header;
+		if (trans_moves)
+			skb->transport_header -= len;
 	}
 
 	return ret;
@@ -3385,7 +3401,7 @@ static int bpf_skb_net_hdr_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 {
-	bool trans_same = skb->transport_header == skb->network_header;
+	bool trans_moves = bpf_skb_trans_hdr_moves(skb, off);
 	int ret;
 
 	/* Same here, __skb_push()/__skb_pull() pair not needed. */
@@ -3393,8 +3409,17 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
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



