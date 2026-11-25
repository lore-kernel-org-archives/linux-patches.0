Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625631;
	b=l3r+6xUZO4z5R7uQthc3agdlZaEVMy5M62+WtEKlRl9crLOTe5C0g1Nhwc+0g/5knIVC
	 5Mg1SYVCNCXCsLPDV0XzrCMMUVwoGuK05iQIqxc3QCc/DsSX4zNDAvszk9lHd0cwT4jJ7
	 hmljmxkENNwW6qyzVAP0hap1mstyOzjre+0PAh7RqBO2ipNoSg+rxkPy+d01wsfEKzwhi
	 oGvZ5kH23XxyZ16zZtgWG5DotICyJ5nvkPGQohM1NCRj8x3LpmUjluyB0I2TfjLvv+b6U
	 fEBIOdiAoQvZXW5m24m28Cf73j/A5zNWOQ8LYaCWHY4Ty5XjUIYGOo+e8p+xUer6X6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Trou5+PekrFvfQ/MqEy0VYmXCoAFk5+qGMR78v7mVPU=;
	b=HV8WpGTSjLwew6XtHrSZZLh2HLKkRkcaBJevJUlnvZ71vnpTa43dczHRWDrnOuQeog+r
	 oeH6QD3QaoxR8pMlSyr6w4GlKbyYeIvVk1dsfTQD9JZblwNMwrFzmI/nD2oHZJ5EUV99j
	 tppJpr/l7iR+N4J+47Je7XUbDF/UBWy7yQfQOTi1z7pGsyZY2tjhC/H1r1YHz2joJfzSd
	 E8EzFc33SSpFR+Mdyq+SDjPYFF3ywOy1hGKSjWB2FY5X+MDhwyy4fdYNafFxfsRyZpacb
	 Flb3yh1yTA0xjfr49tgQn0mT904az1RMQzlWZKpT3E/I+ZmkQEiKzSJybsxoieE6phg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P9/7ELyT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB712606A326;
	Wed, 25 Nov 2026 16:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P9/7ELyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209CA1F000D2;
	Wed, 25 Nov 2026 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625630;
	bh=Trou5+PekrFvfQ/MqEy0VYmXCoAFk5+qGMR78v7mVPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9/7ELyTBr8lF3tLX4CJO5AehOEFmwIl36fKht58RSgykUwSuMC3meE13m6xiEp2W
	 ZF7ROVVJCwhv8BXl5MYmGtlGpPaKlfFCYt4LL/mGR67l7Ene20JreF9h2z/7U8yqYB
	 fMAL9bbr+jV4ILabG1u6mmjF0lX/XJiglohWt7jc=
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
Subject: [PATCH 6.12 580/816] net: bridge: use one headroom snapshot for ND replies
Date: Wed, 25 Nov 2026 15:35:28 +0100
Message-ID: <20261125143902.605758552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -259,6 +259,7 @@ static void br_nd_send(struct net_bridge
 	struct sk_buff *reply;
 	struct ipv6hdr *pip6;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	int i, len;
 	u8 *daddr;
@@ -268,7 +269,8 @@ static void br_nd_send(struct net_bridge
 	if (!dev || skb_linearize(request))
 		return;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 
 	reply = alloc_skb(len, GFP_ATOMIC);
@@ -277,7 +279,7 @@ static void br_nd_send(struct net_bridge
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_set_mac_header(reply, 0);
 


