Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065505;
	b=Ru1dgiyPpaxX/bCSzwZA35Y23/rd6N9/KgkFV1h9jVwQjF59bn6WD/f6IwpaVJ+C0oxt
	 CC/LQ5dXyRv9jh2MgepAkVpfIsziqJthsratdZILMEAQkPkO17dyf7YqDOU0E39IMU9s1
	 k9d/uu6YEAlHRutdt/70AgV3KpUv+ckexXXQAwF9ILfis2F8j8Jvk2A2ozd5NqQyi8KDA
	 W3o4uuRwczBs9kWdb1eEqKG9fAoO2igvWpj3EjuPqgVH69vOqSDYo43sZErixxG1ND7EB
	 eQh3anCkifjZjAm1CedGcd5QRS7HmM8LOBAGfhsxzRtVdlGSl4cXbyqOey+aj1qt0Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znTt627akDosM1wO6GWhJm+ZIftBnXyRQdMlzEXd0GI=;
	b=y0VinXrAZDZkn0j4SWEBKSbFCQoap/ROiGToY5/35YGMBVaIMbcUmAz/dnASd1dY5rb0
	 FoQcNrYJYw7SL2BUggUxUPs47asvrTZ9F//9BdYmkUdvfYoKQkZ8lPcE52TFechaVXBn8
	 DNgEg1j95g4uNSostEIL6TGiJbrLGjFT3goB2J2g7nh0bt3AQ4Bv9Zrao65Osfs/W8bOQ
	 RMPKelxuBf47+kNflsJmgBn6UVAte4M9a4pOtVuqjt13usL+EVMQN5Xv7Nv8A8iCUYSAp
	 uc1bouh+fY9Qia3IGTS1QbHYjCs8y2KsvTcLuRhJbmQ5yzMZ7He6d9XOsFIZgU0Mwzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="irmsv/nS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE10606A33A;
	Sat,  7 Nov 2026 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irmsv/nS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42841F0089F;
	Sat,  7 Nov 2026 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065505;
	bh=znTt627akDosM1wO6GWhJm+ZIftBnXyRQdMlzEXd0GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irmsv/nSooiBjZ2Rh2Focu//JAUVLZcY2ybBDujNxH5Xgg4tTe5RXqT8qfvRHoiEE
	 4wsTW76M7e6gB8U+u0W2p8bXs9OAfdKR4zeQLKrk/c8n/MyvoWmszBQAir7fC8Y5tL
	 NXyNps5rYJDA5Aa24vLosFsb1KxU+iq87vxLE9wk=
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
Subject: [PATCH 7.3 1191/1257] net: limit priority VLAN untag depth
Date: Sat,  7 Nov 2026 08:58:07 -0500
Message-ID: <20261107135012.061179322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 3f39d953eb480..cc7b32ab56085 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6201,6 +6201,8 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	}
 
 	if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
+		unsigned int priority_tag_depth = 1;
+
 check_vlan_id:
 		if (skb_vlan_tag_get_id(skb)) {
 			/* Vlan id is non 0 and vlan_do_receive() above couldn't
@@ -6212,6 +6214,12 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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



