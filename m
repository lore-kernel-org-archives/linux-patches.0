Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058805;
	b=ImWK8K4xvTLP4wogLv4d+PqneW+6XA5hmTLe6fKDHfFjfmovTdYFRMHibDz0e3VlP4Ra
	 TEIxL1qrY/ylznV7YaQa0BERCOcp3KtwMYI6ynVvhFPVIe9ohoSNy3Ur/J6YfxURzJrUE
	 MxMPJsxBcf5dydTsaxlb5bKeDwgFESDhAsuEms6BulwlGjdJHpF0OCDq70FEG2xVKS8UC
	 8Sc9Yd7gq6UQ1wSlv+pNLdt/Sw36RDdnKC4M95FgzuBVPRgfEh0BCvMvxt9Z//zJwtf5K
	 OfcnzijyE1PrEOZuA+XFOPkrr6In3dWmptR/th/OINVO/EGFXe5wm/w5y5Q2qYzGrxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1Fa+jUhQ4DxAGPOG2FcYE6XIOo5ajMVkBiWd6gjz4Y=;
	b=ey4U4trHBPIJe6NDzYHNCiexQ9maLaWpMYHwaYWuhmdzv8Kj58Ey9bUKp5rq0wmvRDOR
	 t7mm0FKwNywlNTPLWxQpE4GiGroJajimIMgqAUv1nhpZMQNCHYpVriGETnC+5NFwTlCUO
	 H873QyUpGRJAUO3dxs5IiSXc72v3DdMj8EOBJiSbNyqSUtiSJFdaRVaXK/FuooM6r99wa
	 XFlB0/UxDVPTeJgmGAjNHLkhgwD9VkEnASrbAFYZBHSIdNGZHnEPHRGDGANVu/OsNXoJZ
	 53K3MXMmA/vuumrvcUju96LwK6Hu962xP/xeBluDMpPHSQydZsibRmrgkOI37nlN5+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC471QWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4472E606A320;
	Thu, 19 Nov 2026 03:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC471QWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBD11F000C4;
	Thu, 19 Nov 2026 03:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058805;
	bh=t1Fa+jUhQ4DxAGPOG2FcYE6XIOo5ajMVkBiWd6gjz4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC471QWAwdx/gxkqJ6o7T2bVsEG6M62z6sfzaRZv4Ws/GccW4ym0QsTb+4qt3uxCc
	 0Ucye/BWFJ+id+DccIY1rjIOSswoOE2Eqza7o/tpyaX3IeXxKoosr6PhhVUcCBnHb9
	 tSkxnc6goRZYJLdRpSnib1rDSdN50j6PdD8bsqbU=
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
Subject: [PATCH 5.10 0615/1848] net: limit priority VLAN untag depth
Date: Wed, 18 Nov 2026 15:44:13 +0100
Message-ID: <20261118145941.022987487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

[ Backport to 5.10.y: __netif_receive_skb_core() has no local
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
index b39f31890fce2..8d286a64d2c8f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5315,6 +5315,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -5327,6 +5329,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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



