Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585258;
	b=BUeQ4gjTeHyjEYo92UyapmkqK7ApsLhxfbAlgsLKTfmJKMpjnvcSD3mT5HlPIRRu8VJ0
	 wbZ0yfpUYE+OAlUicp8Iwhm4X3PxOc3Vuaahk+5NwJEOnyWJlusJq9qBUECRuDxuBcp6u
	 1t2WqHS2ftQ+GH7ycrodw4UVy1mBxtAAY9Xd68tes0v3D54sGAmGiiiDRGuT2p8HJc3vq
	 o2lbL3QHl8FKvL6WFAypjwW3ZT016qik0zXyMzies1gvoRIrUiKerEuXKKx6K0fFX9OYK
	 iQGdkOGURwOGkY0U8VVMXbwfM2ATuntjOzCOi30rjXvlPh6YWp8D3boiniMkmYA9Tmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BXNXV0n3YqjNNRVsOu4JHnBT45FAkCWXu0BoXzDzO1E=;
	b=MvIfsPFGvnQNE0gCsFD3GVYQXzur6RLB/ePaknXAvlvGwmLWGHU8FGQ0tl/Ba8+Aq69B
	 txI70QinpisBluIOfPLb9PwBWYKMiQ2eT4MgSDHygpoG0GIMz5I0VqnMEwtVThqfLinjD
	 4DLkE19/gO3AZB61+0kTxMwZeRcH17bxqvY00l4XXeA0qy4DScEGHLcPCZiNam1DipPpu
	 ADWyDCIfnKwAqXlha34JA6ud5ACh3bhcacCG7cSvS/r2qsV85+9SpReEs2K1/iZy9dKV6
	 dFslwjla4bmlU+DuadX/+saCNvr+29x2k8M3q9unJ4NbzCWXcKrfuhIRDhEobyasWfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpZDpwN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9166606A330;
	Fri, 13 Nov 2026 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vpZDpwN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA491F000C4;
	Fri, 13 Nov 2026 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585258;
	bh=BXNXV0n3YqjNNRVsOu4JHnBT45FAkCWXu0BoXzDzO1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpZDpwN8IbfMoZ433uhb3GM9LTkmaUVKxtQr41xgo3Ezc3TAVhW9kH7WYWU1c5Okr
	 n+Sp1AlplQiMjwNnVmcdIIEwyL+XoHK/S7Lk3lQemJT2ib46bxIX8TIdkN+SyRB9Ki
	 xnmCCae/wPOQn9vpNETrk4yqhBnl6IG6Q4xRRaJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Kamil Sawicki <user148783812897@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/670] net: limit priority VLAN untag depth
Date: Fri, 13 Nov 2026 10:42:49 -0500
Message-ID: <20261113153811.374925825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Kamil Sawicki <user148783812897@gmail.com>

[ Upstream commit d3ff07f5acc573e5f72bf1c581bae5d05191ba61 ]

The priority VLAN receive path can repeatedly remove VID 0 tags and retry
packet processing. Unlike the read-only VLAN protocol parser, this path has
no limit on the number of nested tags it consumes.

Each skb_vlan_untag() advances skb->data and resets header offsets. The
offsets are stored in 16-bit fields. With enough nested tags, the network
or transport offset can wrap. A later protocol handler can then derive a
large pull length from the wrapped offsets and access memory outside the
skb allocation.

Apply the existing VLAN_MAX_DEPTH limit to the exceptional VID 0 retry.
Count the tag already stored in skb VLAN metadata as the first level, then
stop before untagging a ninth level. Keep the accounting inside this
uncommon branch so the regular VLAN receive path is unaffected.

A single VID 0 priority tag before a real VLAN tag is valid. No normal
deployment was found that intentionally emits multiple consecutive VID 0
tags; permitting eight levels is therefore conservative.

The issue was found while researching the Linux network receive path for
Google kvmCTF, with OpenAI Codex (gpt-5.6-sol) assisting the analysis. The
affected path, reproducer and fix were manually reviewed and tested.

Fixes: 36b2f61a42c2 ("net: handle 802.1P vlan 0 packets properly")
Cc: stable@vger.kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Kamil Sawicki <user148783812897@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261024004835.17862-1-user148783812897@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[ Backport to 6.12.y: __netif_receive_skb_core() has no local
  drop_reason variable, and this branch does not define
  SKB_DROP_REASON_RECURSION_LIMIT. Omit the upstream assignment
  and keep the existing SKB_DROP_REASON_UNHANDLED_PROTO drop path. ]
Signed-off-by: Kamil Sawicki <user148783812897@gmail.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 397fd0f9cc7a2..058965698004d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5760,6 +5760,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -5771,6 +5773,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			 * 802.1Q or 802.1AD and vlan_do_receive() above could
 			 * not find vlan dev for vlan id 0.
 			 */
+			if (unlikely(priority_tag_depth >= VLAN_MAX_DEPTH))
+				goto drop;
+
+			priority_tag_depth++;
 			__vlan_hwaccel_clear_tag(skb);
 			skb = skb_vlan_untag(skb);
 			if (unlikely(!skb))
-- 
2.53.0



