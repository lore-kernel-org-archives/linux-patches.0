Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063720;
	b=RUvL9VThbvdQb71/uk8vG9bCrbtPNUIUS31HRN8MQACxz3bTq/HzGuOhKjwzeewccCQ5
	 yY0VSxB2tvDkVguTCS1dw6vt/3sIA8UkxQdgJB1QsdVX7Ej/+N+cHMAKQFA60VCMU8F5b
	 3zUuhlyq/LXbXOT4+emYl6OjPVdkatHfZ5ymAi24sj/rTOgDQ3TGw9HndFrk12sZ9eKN0
	 VMh7hyh8h6kzU/3PY+zEBxXHkeegE53FKdUJiUPre+hYOMpnEIBHCRExYcsrMdM3TP5sN
	 UeIrNKmEmP5Ekf4ZvCWRIYjyxQcPo92vi1wKVw4L4DX0rvc1zO6S/Vrah3KRN2zVTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LumB+2YTncyGttT/zv6Boqk+IXTiymlr4yvTiMRt+bo=;
	b=gFtvtTk0oM4b5+Xcf3VZ2m52TI1ZPneTyXZm/PQKQLDuSV4n2zLB1bx3Vz6w/VAUX5aV
	 dy80xEcWJ2INwOFQNJQctu7wJrSr6nUgtOSKp+5tGyPcOCIfB0IAyL97prGMt0ExZfF5Y
	 gy9+nKpDeodgRf3dp4is7fEkZjVrs9naOy6cVZRfDeGPa7W2EbMVKIq7qmZdNv9McfiAm
	 EbT5widuFxsyLuwz1n+O5AfVs9HPJSsFE+T5sHz0qR9or/J2kiP9JP1Tp4ukifFukXOah
	 Jq2ot0jHCJ5eVIsYZ9YHP/GBoy1S+Bnj8jBL4Coj5H9f8dpdgPUZiZA1CBUYBKG4cfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIdsVzVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCA1606D83F;
	Sat,  7 Nov 2026 15:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIdsVzVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96A91F0089F;
	Sat,  7 Nov 2026 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063720;
	bh=LumB+2YTncyGttT/zv6Boqk+IXTiymlr4yvTiMRt+bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIdsVzVhlw7HbCmDjBMyrsmHsZtsnIaNMZS+eroPO9FNGA3O54eXvTJhK9abofEuY
	 2bpJQKHzXjCep/pAVyfBl0rMKM5FeteLzz8a2ni0TOGbPcOB/O1Pezv2iyqBjJgsOB
	 onCjOB/7OQCqi0e9dFPYg57UP7idMhBc6Vgpi4Ss=
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
Subject: [PATCH 6.18 820/869] net: limit priority VLAN untag depth
Date: Sat,  7 Nov 2026 08:58:22 -0500
Message-ID: <20261107134920.790500352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0bfd5e9940df0..673223065b955 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6074,6 +6074,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -6085,6 +6087,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 			 * 802.1Q or 802.1AD and vlan_do_receive() above could
 			 * not find vlan dev for vlan id 0.
 			 */
+			if (unlikely(priority_tag_depth >= VLAN_MAX_DEPTH)) {
+				drop_reason = SKB_DROP_REASON_RECURSION_LIMIT;
+				goto drop;
+			}
+
+			priority_tag_depth++;
 			__vlan_hwaccel_clear_tag(skb);
 			skb = skb_vlan_untag(skb);
 			if (unlikely(!skb))
-- 
2.53.0



