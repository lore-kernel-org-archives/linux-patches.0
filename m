Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032297;
	b=q6o/30skPP/IoFShUWy/ioikbPuC7Suji6I2pAnjCoH556VMFIhRRqMN/q26myHQtwR5
	 V0mXkIZ3+jyZSBxTnvt/PhRDK29mIfZXWKT5fSmJO0zoLWNqLpJVc0gkdvgSKhhL2CIuz
	 IxMf2Fx9iBPco9O1ayTvvds9PQoLPRCh+sGkIb2tZZhpssVVh6VUHFZj9T0KHU20tsVvD
	 uLKPKCH+5tgfi391EtoLhong02SpM0qgv6RgKl0pzftorbKsP3qwKQX6C5UVK9BsUfcKv
	 eORdyM2/HBqnyg4RE468B9enwA2v3nRLsOLGlVmd3uBfmxdSPQdMj+EgcZ3vsh7R8AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y15Dmv8c+dBSbFPvKaGLcGCdgp8IHLiChzjlh/wGbmU=;
	b=oOgmAtLZk2mX8XwjmOxk1jGB5kf/VZpIyfgcMtbdpN6CsqIboD4FNsSI0y0hE50tCGho
	 yJRJbvHWCV19oT0zn193bQj3A7EFt01PiZAB35Uv5y4fJ1yXhx3UngDJFO7TA+9WO5x84
	 MruvX0tCprx1JUbhzOKfw0gRTQvqJtEbt/0wvQgqmG9KFsWmF8cu/k3F5pvmDEMyxaqqp
	 bZz/bQHGx/3uh6jIxNwsHihIFcl5P65SJGP/H0Hf1Xs8MhCEBP6p2aeOisrtlMLipnV8e
	 gaS9N9T5KSOUEpLmTDcMVuyo+vC9qTlQnSSAs05UZdVJ0F6aBpDmkZabDIm0ap0tFyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBleYVAT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B8A60A2616;
	Wed, 18 Nov 2026 20:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBleYVAT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C29E1F000C9;
	Wed, 18 Nov 2026 20:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032297;
	bh=Y15Dmv8c+dBSbFPvKaGLcGCdgp8IHLiChzjlh/wGbmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBleYVATp+LwdWKnIK3lwaMMpjUnVYhbo/RwUqAuJX/FYyH4GWRU500RZS83CY6Cl
	 uVv0Xm8JP7PXmWyn21yBsSUrS5fgSSpURhAGcb1LiWoZr67ZsA2c5//RZGMJJjWD2Q
	 BAr/dXjfEnegyI/9+YTK71asIwbT80Pp/z2DCs94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1361/1756] bpf: Make bpf_skb_adjust_room metadata-safe
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150103.462048523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index c1e4825bba4dd..1613554c88fa5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3319,11 +3319,11 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
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
@@ -3347,7 +3347,7 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	old_data = skb->data;
 	__skb_pull(skb, len);
 	skb_postpull_rcsum(skb, old_data + off, len);
-	memmove(skb->data, old_data, off);
+	skb_postpull_data_move(skb, len, off);
 
 	return 0;
 }
@@ -3557,6 +3557,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	u8 inner_mac_len = flags >> BPF_ADJ_ROOM_ENCAP_L2_SHIFT;
 	bool encap = flags & BPF_F_ADJ_ROOM_ENCAP_L3_MASK;
 	u16 mac_len = 0, inner_net = 0, inner_trans = 0;
+	const u8 meta_len = skb_metadata_len(skb);
 	unsigned int gso_type = SKB_GSO_DODGY;
 	int ret;
 
@@ -3567,7 +3568,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
-	ret = skb_cow_head(skb, len_diff);
+	ret = skb_cow_head(skb, meta_len + len_diff);
 	if (unlikely(ret < 0))
 		return ret;
 
-- 
2.53.0



