Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617944;
	b=ykznLVXcMHxp0FwD0yugFfQFmtxMxPIxV5s8txb0bDNt96n6q/Wl61EwaNcuPUczItdU
	 MZQBTTQAq/iSo6QVrHzGruSuJ3zeNlxhj9IvzFvlICidlOhM8YpvbS7C7D+fa38hfGyZC
	 6hhGg0yIPs7loueLpHKqsyJ8Av4MSXdb/EZsPZK/i7G3hO+WN2XaAS+VfLcRb+V+bxxG6
	 AQ/kf1BULX7XO6+TBI998wa2JTQd/luO4smOejcTIEmPpxMQAXRcaOG4YY2j7i4ZvHuYi
	 8Md5bqI/RzeMVa/onTUrUY385Ad43uWDpLfKzZG0qr/0Nr9xBQjwV1zQ/HKTdqP4gFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7sG5chiMV3avq12skPTfr0mz04tLByXfE7rGchGXpU=;
	b=UQnoagEvqjTuULDtud6Ix9+MJnJmW4nIQ0KOh72W+8O/yMtXFZLTI3uHVoZnFqB6RBrD
	 wETPqvNwEyd9IKiYx6rkv0SsoqxpfaQ+jzApJuLfpkDHd2vb46VP7NyCTkVvQ8il5Tuwx
	 v2x1bupBvGKwj25h62vVOq3hos3Aa9SQuzanWciTg7audH//9mG1/HYf1+GVAArpbdUgb
	 Z+RwGkrA3xHxOcXw6VNmI+Q16ZCQ4rM+h/LciE3rG4VrfAhc1+0z3tY8RMd8uPtqap0of
	 uC8xnvl+Yk9oAGySnncS1f3zpsmX53ybzDyTQ9sUnBHiYvouOYQ3br51pc+dr4GU8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAYnZNv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7528D606A329;
	Wed, 25 Nov 2026 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAYnZNv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6CB1F000C0;
	Wed, 25 Nov 2026 14:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617943;
	bh=b7sG5chiMV3avq12skPTfr0mz04tLByXfE7rGchGXpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAYnZNv5qM/A1G4z+0g/ef1x/oFO8D9GQKBQGks3pvKGckSQUxgr79gkFKh7cLSpH
	 nNfhwpWg7BkBIP1amokNWRQGBKKiZ8A0A+4LPwDLmUx0fz0xbB4YO0hhTtDcgrCA4x
	 rZZClLT9Z++kEtxr9LGPvUz9/Vz0q4P9OmhD1HjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0117/1005] bpf: Use the inner transport header after a decap
Date: Wed, 25 Nov 2026 15:24:15 +0100
Message-ID: <20261125143824.485189671@linuxfoundation.org>
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

[ Upstream commit 33be492c2e239de8c525254e593357ae5e80852d ]

If skb->encapsulation is set, qdisc_pkt_len_segs_init() reads the TCP
header of a GSO packet at skb->inner_transport_header. Otherwise it uses
skb->transport_header. A decap with BPF_F_ADJ_ROOM_DECAP_L4_{GRE,UDP}
removes the outer transport header. It clears skb->encapsulation if no
tunnel flag remains in gso_type. The result in BPF_ADJ_ROOM_MAC mode is:

  before  | MAC | outer IP | GRE | inner IP | TCP | payload
          transport_header ^                ^ inner_transport_header
  after                    | MAC | inner IP | TCP | payload
                transport_header ^          ^ inner_transport_header

Then qdisc_pkt_len_segs_init() reads the inner IP header as a TCP header.
Thus the kernel can drop a valid packet with SKB_DROP_REASON_SKB_BAD_GSO.

Copy skb->inner_transport_header to skb->transport_header when a decap
clears skb->encapsulation. Keep skb->transport_header if it is larger. This
occurs if nothing sets the inner field. At tc ingress nothing changes for
IPIP or GRO packets. Both fields are at the TCP header there.

Fixes: ec20dee2f2c4 ("bpf: Clear decap state on skb_adjust_room shrink path")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-27-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 475c9e06cf06b..d27e73647a8df 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3769,6 +3769,25 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	return 0;
 }
 
+/*
+ * Code that went by the inner transport header while skb->encapsulation was set
+ * goes by the transport header from now on. So take the inner one over, unless
+ * it is the smaller one, as it is if nobody has set it. Do not leave the result
+ * in front of @off, where the bytes were removed.
+ */
+static void bpf_skb_clear_encap(struct sk_buff *skb, u32 off)
+{
+	int thoff;
+
+	if (!skb->encapsulation)
+		return;
+
+	thoff = max(skb->inner_transport_header, skb->transport_header) -
+		skb_headroom(skb);
+	skb_set_transport_header(skb, max_t(int, thoff, off));
+	skb->encapsulation = 0;
+}
+
 static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			      u64 flags)
 {
@@ -3850,8 +3869,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 						  SKB_GSO_IPXIP4 |
 						  SKB_GSO_IPXIP6 |
 						  SKB_GSO_ESP)))
-				if (skb->encapsulation)
-					skb->encapsulation = 0;
+				bpf_skb_clear_encap(skb, off);
 		}
 
 		/* Header must be checked, and gso_segs recomputed. */
@@ -3859,10 +3877,9 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 		shinfo->gso_segs = 0;
 	} else {
 		/* For non-GSO packets, clear encapsulation if decap flags are set */
-		if ((flags & (BPF_F_ADJ_ROOM_DECAP_L4_MASK |
-			      BPF_F_ADJ_ROOM_DECAP_IPXIP_MASK)) &&
-		    skb->encapsulation)
-			skb->encapsulation = 0;
+		if (flags & (BPF_F_ADJ_ROOM_DECAP_L4_MASK |
+			     BPF_F_ADJ_ROOM_DECAP_IPXIP_MASK))
+			bpf_skb_clear_encap(skb, off);
 	}
 
 	return 0;
-- 
2.53.0



