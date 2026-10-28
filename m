Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210786;
	b=yn/ukL5wNivZMWWh+CuKyr6vNhssy9ARHbRtlF5Z1b02N32optWTudcr27NXOsA/bH7u
	 MwJw5f6DjS5Y9+9EES3A7ZhtcMp7gfUwaCjNyyXC7flGtcMWB/jCE5H/W48THhNNyIgy4
	 4qVekrRLZn/SbErCj/oYlP1R7NGq6ZWXYnPVG19eRMrV51huYj5p35G4QhTsNfzUGUAZn
	 kmmojPTqhwlut4oX10Jl5ICYJ3JryktnuKlQwE5lXi+tFKtlEYyuACsJXcZq7jgy3WG/J
	 QOr9o4RWGHPBIXK3SfbhVTi+NZDEZCoPzPP6oR2dDg+Gz3sV9uHE82O871Bijo8rh4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13vrH4EoWcW8iaptOxwhLNFcMcwXIlpfGRt4Jfm/xKo=;
	b=i4T/NG9OpUTGQBCJ5guRMVg3qhqp1tdncpIi1rqE4MCcmp0eLYLnFNYQE3GtR2IXplnB
	 SOuzPkYWL6/nHRAk00BNJ3XnEU7ZHhUrCOGDUKLJhOBwRwcPt4B+kPy266IH8zAhuGK2y
	 4IETNRf8aPl/MGRCn1iIxxCikFmp0e4LGIfjZGThvgCNtyeSOGlj/wI8+5xCS/ct1ULGv
	 rmJgtV2RISaGtTJJueP7M96z2fcGIG2vvVYx8lfMXm68DWvsI0Pn13+du0OtcRyVc7J14
	 j5tUHZ741KSXJquhII+uY/L35lJnftykeTswpPCpWoYUCqkSWzfZv0zkcJvFbKtjmBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yzj2YJwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039C2606A31A;
	Wed, 28 Oct 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yzj2YJwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546E71F01825;
	Wed, 28 Oct 2026 18:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210785;
	bh=13vrH4EoWcW8iaptOxwhLNFcMcwXIlpfGRt4Jfm/xKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yzj2YJwWu+rPj9FL1TDhVSkCVNeZ7aAOQU850afMFsXE6JipIZccnS0i0f4O0EkLK
	 uAb7861GXSyKp98OKyEhExD95dUcE3wkcOq46UiXox80vKl9vuSejS/XhVWO+eIYVN
	 MjrVyE9C4mvWjo/D+8H5TeQQpxSK+6AH+PEkmTbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/571] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 28 Oct 2026 17:54:55 +0100
Message-ID: <20261028170011.528331506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 481506a756dcd828ef42391cb08f38d8d96d38fc ]

vxlan_na_create() samples LL_RESERVED_SPACE() to size the reply skb and then
samples it again to reserve headroom. A concurrent vxlan_changelink() can
update needed_headroom between the two reads, creating a TOCTOU race. The
second value can exceed the allocation and make the Ethernet header write out
of bounds.

The race is reproducible on the unpatched kernel. It occurred when
vxlan_na_create() generated a neighbour reply while vxlan_changelink() changed
the link headroom. KASAN caught a four-byte write two bytes beyond a 704-byte
skbuff_small_head allocation.

Snapshot the headroom once and use that value for both allocation and
reservation.

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Link: https://patch.msgid.link/20260918032842.502409-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index c1ee03aebed51..0491ff123b38e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2086,13 +2086,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	struct ipv6hdr *pip6;
 	u8 *daddr;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	int i, len;
 
 	if (dev == NULL || !pskb_may_pull(request, request->len))
 		return NULL;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 	reply = alloc_skb(len, GFP_ATOMIC);
 	if (reply == NULL)
@@ -2100,7 +2102,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



