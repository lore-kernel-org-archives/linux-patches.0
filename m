Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619533;
	b=MJTWsZXl5m/hCNaYNvub9G6E6ZJGeQcAWYBWqD7taEB/0x/7DxVvXLmmsGiJsNBQ4g+k
	 VuFaIDJUFUUawUtWtbug/RCCi+u1a5iftwy4KtkiO0rOltMR/4FDUyIQhyd8evx10kf6w
	 jhkxd0d9Iy16mcYrx8Z3/r7nuS8OeO3dIHWe9TsDG31fyUfXgLSZ/AtkYr2IVrzdSeWF1
	 nL+kZVml+JHNdvi7sdDFthDdBSBgXbAk834Fo5z5Kek6fZK5ihSJH3qt3i8NyJhgKmIaw
	 M+qmfwZB+jp+aGDRSTrmwxVsVRy7Zr0oY/kqw9jELYh3QHOX8abgqcS7gd41fUuQIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMe/L/eH1n3B4csh//0cbZohcGa7OOScnNo+EOdu1wY=;
	b=5SyAxWXTS5tlnAusXo2i04zW6rDUFlpQztzOdpQG6UENuMlV23HWKpa43vU7l3bMJBcX
	 t7xjl27W5HAGhzMAMIt6KlChXVBloLNZ7UyLL4mRosxuAYT//3lkXnklYq3j1ExFS7tDT
	 ScSGd6Rg3Y5QSiIIpW+fiS89QHkFwSi7bIgOgi2pQQvcRk3tzHCoSlMV3mSD9T8B8aQY/
	 xIbGyXFsBvah6SiFQqyzWnx2YKPGiAr9e+P0asOXppE9dNJ47gJORTVLurgqggh6QecA9
	 V7Sz3k+CfIVUokJ5zqU4fuFb2rN6SiAuR7LoGvdWMbHLJYaqEP0WqTLVKOrarbITxTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz0BLnlG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFEA606A321;
	Wed, 25 Nov 2026 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz0BLnlG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C81F000C0;
	Wed, 25 Nov 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619532;
	bh=YMe/L/eH1n3B4csh//0cbZohcGa7OOScnNo+EOdu1wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz0BLnlGVV1BH9r4oAYhnYZqp8t+cyB6PQ0KadzGxyLs3dxtWem65cv2KlMbQCiHV
	 vorLxEYQd2wtnuL/d8mwtVAPAtMinaeUE9ydULIdiMo8LN9y8AcutKBP0oHaBv7kUV
	 WTnX8rktEwCVJX1/vT8lb3VSVES/Tx+RDO18pDbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>,
	Jun Yang <junvyyang@tencent.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0626/1005] net: bridge: use one headroom snapshot for ND replies
Date: Wed, 25 Nov 2026 15:32:44 +0100
Message-ID: <20261125143836.411589216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jun Yang <junvyyang@tencent.com>

commit e573df093ef849bb7c763aed591cb6556b110671 upstream.

br_nd_send() calls LL_RESERVED_SPACE(dev) once to size the reply skb and
again to reserve its headroom. When a port requiring more headroom is
added to the bridge, br_add_if() can increase dev->needed_headroom
between the two calls. The reserved headroom can then exceed the space
accounted for by alloc_skb().

Take one headroom snapshot and use it for both the allocation size and
skb_reserve().

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261103075439.43644-1-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_arp_nd_proxy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -262,6 +262,7 @@ static void br_nd_send(struct net_bridge
 	struct sk_buff *reply;
 	struct ipv6hdr *pip6;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	u8 *daddr;
 	bool dad;
@@ -271,7 +272,8 @@ static void br_nd_send(struct net_bridge
 	if (!dev)
 		return;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 
 	reply = alloc_skb(len, GFP_ATOMIC);
@@ -280,7 +282,7 @@ static void br_nd_send(struct net_bridge
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_set_mac_header(reply, 0);
 


