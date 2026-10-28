Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212544;
	b=xUN/hckCE8oXFZCohh8FvYoFSgtTTo27gogTmwqO4RzsFHToMHRHinsmR9dPUh+brDYK
	 Q5pfeGCyI6RpcdV3vS/62HiWPFY4a52stiSAg9FAfvjzM7zCqqxHF4GxNUzvMg446YFk5
	 PI1HrCkLjXkJzrRQpoLRCozGqvsRr2ZPz8ZLZY5cugHh1WI7CofE87z8BWUP6b+0dtYIP
	 hRzTHbG4hyF6Uxq3BKMhfcwR7iy89ZJKOsiZtrJzDvicPopjGDpDku5Crr9TL0lssrDcW
	 npps325QtWS7/NubegD8HGIxUhS6fkQVKOg2jAAW1g/YL+a8p8WrBWVKXH0fKC3gr3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GMMNIY8IBHPT2eXiiC8+6v1No7SymMRufaZlSzEJ4y0=;
	b=jmbvF3tZwNb01Tqf6jhXi8luLmFXZkdDJ4e+oMX62pMHUjSWy8QAbmnixYU8gBVpVajY
	 V1nnMVHqEVe4PHV+Hr4b07J/gyJAvKKUkW5AV8lo43TJZiKunT9GiQ+oInw38UMEe6j9Y
	 Qx61DXRy8CtvZ7mUOPj/JzD0MRy1+l0+EphhhFNuszfduSETonCUc4szRAGPJIcF2+Vyb
	 tjwN5/WJWa2vUbrAM+sHjWgMLPScie1ClCJZu40GT9cEm2Rvv6YFys/SLXPx1xWO7SLdN
	 78dPZVEWt2LaEC6kRLT+P/Qy2S2ZjJgtwOE7Y+RKFNOeT5RLxFE5PZlalJlaNwZQ3dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwFfAJtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14981606A337;
	Wed, 28 Oct 2026 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwFfAJtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656E81F01828;
	Wed, 28 Oct 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212543;
	bh=GMMNIY8IBHPT2eXiiC8+6v1No7SymMRufaZlSzEJ4y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwFfAJtQCLyFWwB7pen2XZa/ijhe6vmLXJRRguZfjv/XfehDhdBgdeuDimia9Jf4c
	 roQY4szOBSQAoa3gFbuy2S7waUYRnXe1CxF20SRaIVspidv2g0LessWwe8IRNC5RKB
	 4xNgE67shbFcnI5UAV8PV0jnKJJqf3YBe2H9vK/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0190/1887] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 28 Oct 2026 17:38:06 +0100
Message-ID: <20261028170503.559689493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 591a2875dfe2f..c9f02da4c8af8 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2000,13 +2000,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
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
@@ -2014,7 +2016,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



