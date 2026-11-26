Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705402;
	b=AXORgEn4Rt2ELtC8S+q69ppqxTMSmukr6p2r9dfVbT2Yd3hEsucQ2tJkG08aPIt0Qywn
	 6ih9pp6zRmWVqOgT9L2vZcKQzGlEBUilxEzPEfreL7s47UP1RJVYkzvsLa4bLUFZGk6aA
	 g4GtEr/DyR9tw9UJITjluu0dMH62M5jschRc17zjzNSF/yIjtXWvZZ4TJNobPrWVWXVzl
	 Unu1Qa2WoD1ESdBMTfIuYOA9hkirFc2QRD+hSbbI78y5wwBOKszRfj7Gg7YCWzr080nbn
	 +fYqgvI7HCZQBUVhIC7kMkfj7Bb5g6tZ5Q1fm9Fz/juoTbuIQqyJJMWLcyDGE/CkrwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yhDsKUY9DazYTEMunuaDLQxKy/cLIlE6ZRK5CHffe5c=;
	b=RS8sCfXuoBZUFSN/q1HDlP5eKv09hInsvyUGgZ6lRnLwtltj9UrG3r86Zt5tIjnqW1ih
	 C3bZtATrGb8vEDvedvxg9LBlMAhJMnBa5oWMm44KnQgDXwPWUlDCxrBRBhmit9A8/G93/
	 06ztTYrjF9UQ8GOVjhW42RdUx47LMSPi05SJjd26mhLor+S7ZgMAZ985rd+zBgjtxQkSI
	 bs+dnQ9L8wXemgCCPhH+3l5N3owi3mfC635VfIGxJlEEmrtRXIMa1RU7fkLW30dHVT6/4
	 JBEAhBsxJcyMEHnrYnSGehEJ3omoeF/51SgPEx90Pvt7gZJ1sZgiIsvdZU6gEDz+GgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHo+y9UL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCDA606A31C;
	Thu, 26 Nov 2026 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHo+y9UL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD391F000C0;
	Thu, 26 Nov 2026 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705401;
	bh=yhDsKUY9DazYTEMunuaDLQxKy/cLIlE6ZRK5CHffe5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHo+y9ULKdxCFk/6Mttwh4ujeiDvb2+OodyF1xJYjioymcHhbDPFUOBckQvIY6yoV
	 WT9bt0fL8GNJYjABVKEgbzcUKv7wvyYP0RvBk/zJvMupdokVBQgJ01XeOhmbV8S8Ru
	 6dHZ7QlAnaI2vnZ03fSXCJZRC0mcJVDZMwBmtiA0=
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
Subject: [PATCH 5.15 187/319] net: bridge: use one headroom snapshot for ND replies
Date: Thu, 26 Nov 2026 15:39:15 +0100
Message-ID: <20261126144010.966881572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -257,6 +257,7 @@ static void br_nd_send(struct net_bridge
 	struct sk_buff *reply;
 	struct ipv6hdr *pip6;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	int i, len;
 	u8 *daddr;
@@ -266,7 +267,8 @@ static void br_nd_send(struct net_bridge
 	if (!dev || skb_linearize(request))
 		return;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 
 	reply = alloc_skb(len, GFP_ATOMIC);
@@ -275,7 +277,7 @@ static void br_nd_send(struct net_bridge
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_set_mac_header(reply, 0);
 


