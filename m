Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041941;
	b=5WgW9ti0RmpKbcXcXVaY3I05xNiVrMqAXUbVWmVigBzqLcMYuK0xjKB2506MW7B9wOA+
	 BVWzi85MqkrS3tp0TYxxuTms6XEaE0prJzpMlbKh7J/ZV5XgtbaE9bfSa2BO6Oz9DIHLv
	 GttUCNnJG+jMJ3mqigzcH+2ejOLTh1CJyLaRJSYQa7VFl76dXDb5Q98DzyommHGt4SG8s
	 RmI4Nwrnv4RIthbew17LLnyIz8Byd/2U7s+NUeNUdEUFpS8175vHvxEox/Ls7mW+BwBGD
	 0XdLvzsUaoqtR5dIRLdW6gX0kOuGslwX2wNyv+KcMKJgk+VkrZeoxAxok45lxatFWSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0kvbtrJGUYUnpaHCJdqxsb2uPN3Guy38l0vhQkC3NAc=;
	b=mtTI3PoW9E8ZjCNbaM41Tvun/jQzABRHqDPAChD0CXUXYyh7ipKOAqR+j8TCByIjBkgb
	 BKdfhw/v7HIoTMwlhcNXFvfwVGOF0iLMd+Axhiu1rBbkbcFR3x7i3Rb8bI4oTYCh3Csmr
	 wY0Fyn94rIJymRLs+YzDp5URK/igHktyrH0SUBr5xNFLK04Rg5An4KGkCHK0Dan2LPgdI
	 v1XOGzx7bT0rr3OP1WxJgTwK8hS6rh8c2w8xHGQDV/g4f/OxJgLeYFiWmbIn7BQumKL4q
	 9U0+BK9nOVfTVU6Yq+Ap3f2C2m7UcOMhHQ/+DBDb/0I8OJtNXpTrFrBq+JuubB9pmWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhJbf9il;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7967C606A325;
	Wed, 18 Nov 2026 22:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhJbf9il
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FFC1F000C4;
	Wed, 18 Nov 2026 22:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041941;
	bh=0kvbtrJGUYUnpaHCJdqxsb2uPN3Guy38l0vhQkC3NAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhJbf9ilJQkQH5vS+w6iFITghErsi8bEOOp5fp18yej1PHD/hjGZ8Lc83pyvh7+ix
	 SYDw5hzFn3u5mIhLctfm3oz/94LmmFiLrDtNghHak3bhERLvEDuKucWIAT4eDA5FQ5
	 zvj7xaUxvT2sD3OnWO0fStPWeb9eqx4B1iKnQOBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2994/3318] bpf: Make bpf_skb_adjust_room metadata-safe
Date: Wed, 18 Nov 2026 16:00:16 +0100
Message-ID: <20261118150450.086505831@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit be83105d38ab99737ac0488600efd59ddd57b74c ]

bpf_skb_adjust_room() may push or pull bytes from skb->data. In both cases,
skb metadata must be moved accordingly to stay accessible.

Replace existing memmove() calls, which only move payload, with a helper
that also handles metadata. Reserve enough space for metadata to fit after
skb_push.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-skb-meta-rx-path-v4-7-5ceb08a9b37b@cloudflare.com
Stable-dep-of: 12d07c38e1b0 ("bpf: Don't let bpf_skb_adjust_room() use up the MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index fc2b34a453ea9..2d7b27786b587 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3294,11 +3294,11 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
-	/* Caller already did skb_cow() with len as headroom,
+	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
 	skb_push(skb, len);
-	memmove(skb->data, skb->data + len, off);
+	skb_postpush_data_move(skb, len, off);
 	memset(skb->data + off, 0, len);
 
 	/* No skb_postpush_rcsum(skb, skb->data + off, len)
@@ -3322,7 +3322,7 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	old_data = skb->data;
 	__skb_pull(skb, len);
 	skb_postpull_rcsum(skb, old_data + off, len);
-	memmove(skb->data, old_data, off);
+	skb_postpull_data_move(skb, len, off);
 
 	return 0;
 }
@@ -3532,6 +3532,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	u8 inner_mac_len = flags >> BPF_ADJ_ROOM_ENCAP_L2_SHIFT;
 	bool encap = flags & BPF_F_ADJ_ROOM_ENCAP_L3_MASK;
 	u16 mac_len = 0, inner_net = 0, inner_trans = 0;
+	const u8 meta_len = skb_metadata_len(skb);
 	unsigned int gso_type = SKB_GSO_DODGY;
 	int ret;
 
@@ -3542,7 +3543,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
-	ret = skb_cow_head(skb, len_diff);
+	ret = skb_cow_head(skb, meta_len + len_diff);
 	if (unlikely(ret < 0))
 		return ret;
 
-- 
2.53.0



