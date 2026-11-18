Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052993;
	b=dzEnixKvT/leeo37T5FKTHMRrJU0ftZpQZDYLmOwMXcyuyIbC+sRGBlK+BG97Q4rhUy4
	 MCp36K7PVXDF4CML5N8/VUk1sH2YFccSIwuOyGHxhwTCD8LITWznHxy9SbLQa/6Sr2295
	 n7rb70myqkdb1XfsHTHEOqzTKJCKM8FU3MwM2SeVes+fzeh6Mx+X7TZCVzZCUgekBFGa/
	 BoZYZcSGHqlboFPBIQ1eCynf7tGslefz0ywDukRBlOSWhEgKIS1IfU4LYtLtad1yd50+R
	 KiYAZk4FqHz8rW7N4FDiEguEAXhEWwkQA8lZhktywgsd5cs21/TXb9EAjiOjNEXicBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3PV69hbQgj/Fjg64YUsnFLfDhuuNQSc6x+3hiKCtcw=;
	b=PJ0eehulR7Z+EQq5Z0A852e5WZ1+WxOYYxPvQi+vZEKr6cTkoXTeQdRi+VJHWsXhwXIo
	 4dqhubJ6VHBJdhszhp4pL6UNtduis2taN7PiKEeFKaolDluD4eOZgolakiYilKYY/FHPf
	 d5xa4/sl23QHKSGrcIQxeGW7hSqqLxY1GLORP5VM+jjdW/iwuxIt3CRJ3bQwP7m/oxCuV
	 uaD9LIT86Jc+dnpdCK7Evt/PWR0oYoBEMRA7eem44EOQhG/l7LZxn9yMW0K9X7q7qhQUy
	 BA9y1fjg4IIVXFDzv0UXDnvFgCb+rmKyR+bazJN2UYlEH9hRY26wQjNDnNUMqVzusWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5zwK1Jj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E0A606A32A;
	Thu, 19 Nov 2026 01:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5zwK1Jj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD15F1F000C4;
	Thu, 19 Nov 2026 01:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052993;
	bh=Z3PV69hbQgj/Fjg64YUsnFLfDhuuNQSc6x+3hiKCtcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5zwK1Jjl2BFBRluIafq5oLwoKj+ysKKaTKj3WLcPhOHmz4fgXkw9VZZPbobJRicw
	 PLYtz7KzjxYrruwe0a3KoAvbGsA1E50pOOSrDIUNWeYVY0yP9Yv2RrbB486UrLRweM
	 NWTWsEij0SNTGlaE+wO+Ho6GIAXKfy3HY9QMsNVI=
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
Subject: [PATCH 5.15 0761/2214] net: limit priority VLAN untag depth
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150042.167310709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport to 5.15.y: __netif_receive_skb_core() has no local
  drop_reason variable, and this branch does not define
  SKB_DROP_REASON_RECURSION_LIMIT. Omit the upstream assignment
  and keep the existing drop path, which frees the skb with
  kfree_skb(). ]
Signed-off-by: Kamil Sawicki <user148783812897@gmail.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index f7867bc188242..61813b29f5784 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5461,6 +5461,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -5472,6 +5474,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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



