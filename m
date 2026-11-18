Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045968;
	b=TJSIiP9LMI5a4kJLU0/By7eZCrt/wcVVyu80cUg6f3zty0dZd0Tayi6Pa5HNkD6evn+c
	 p+8O9kw5H98N2sNlmmJ1NZ5pmA97BgIOtkP4jivODt8oWlH59EgiGoipGdtIFpQlQV7WL
	 CoasdtJmH2nhR4Q9yWhajd22cPkBeMqcL1yhfHeqv38ffBFg9gi2XFr72SwE72rU1FlB5
	 A+4l64EDy4RTTNfsnojpwrivrL/DNvQyOBkBavs/XIAtDlZG6PtOPtn1KjxxFldIfbB/J
	 f9jfQSqDfwZYRs/mmGOtRb9Octl4ZLPZq0iIC0rg9gtCGAPcCt58WEplkBXL2Cq0r/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTVhkYkfvLD8A59gW0+QoSy//45PDF3I/RwIbefmIB4=;
	b=SK2x8u5sUVRG77x484yIVgzNsspJH61N5z6Ex4lEGLa1tw93Gz8iwfAsY7ZbmbUQ5jUa
	 /Oa+5YG2Azc8/L2fzZuIT3aXHbIVjRK5j9R8Fve7rvgs1WANBFQAYt2wwApkPTOPdAm+Z
	 GJ0yMYfiirq6z4dajhBj0q87OxjCuhzkQNzhn5UQn5Schjg9N8LP/sLMFiJyBGGEcqw7M
	 LaPPhzUl+UCm6njSYppgCw1r/4brnrIInZ5/JOWQA8IijABO37Xklb7/jvK44Wtm9pHGb
	 flQTK2GVugRmD/EXXOZx3BpqFq3RV9ebAKAbIlCEuBgjq5om3UKIA18mJLgJCVFJInQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXSwVBXW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099D4606A32C;
	Wed, 18 Nov 2026 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXSwVBXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111CC1F000C4;
	Wed, 18 Nov 2026 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045967;
	bh=hTVhkYkfvLD8A59gW0+QoSy//45PDF3I/RwIbefmIB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXSwVBXWUigEQSN49UdXw1TSW0A3CWqGMAhsQ0aTZeZtwXuzg+UB11aCY1Sd6Xy0z
	 RwV1jamprBAOBH1wyxh3Ln8JoZFl8ZUl+iopVZ0goz6d4Xwx6nRLKTpEg2L9ksqZPa
	 2HvewulyiBdTLv9e07CV0rdxOcmURhlMKL7AEcQo=
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
Subject: [PATCH 6.1 1111/2857] net: limit priority VLAN untag depth
Date: Wed, 18 Nov 2026 15:35:45 +0100
Message-ID: <20261118150241.633793124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport to 6.1.y: __netif_receive_skb_core() has no local
  drop_reason variable, and this branch does not define
  SKB_DROP_REASON_RECURSION_LIMIT. Omit the upstream assignment
  and keep the existing SKB_DROP_REASON_UNHANDLED_PROTO drop path. ]
Signed-off-by: Kamil Sawicki <user148783812897@gmail.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index ea6785052e8cf..8c3f9946a6bfa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5561,6 +5561,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -5572,6 +5574,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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



