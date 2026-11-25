Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622933;
	b=2GtVlksIGkB0dMRpC6EJpxtiFTCPEujGyhSFsE8RvdPx4299ESZkOz9ddjoQtFVPo/bc
	 a7nnALLSJ0WlJzvC8l3PwY6f8IFXZvTI//Oc+sERsOuQP74uts311vR4655KGiAxCWwCy
	 Sn1NP49X8vPSDNMJfJP59jCrSAKYwHQZBr5K81csIiu2tJKsSzbr/5CXM+UhYaXcbXu2x
	 OzSzVUf9M//P6pt70neRHXusn0UoqLHw84swt8RScxXAH9ldoyOtWhid2KxNFvshewYOH
	 DrvNcmKUZqV3YX2j/NLGQgwfRbBhZn5hx8OJq24xmPMPx0HCBxiHKPHz7RshB9PeT7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIsOM+Ddsj4RXOPYoxQQ8MFP60reh/EweRzGsxqI3Nk=;
	b=IG2j4qoYlqOMKS85yT3GTtFLYSTkGhcJDR9mjj3SmutsWCP7QlpP3wUsMObkB6tQjBTG
	 ULm5gfdYiLJMSm3VZUz3hb/vbxhC6vEZERUhHG7mi8Kf45M/+/Mbzr7JeWm4Hxyg99TPa
	 WcTuTJXIntQsFvI8qq7l1nQvxWW29avBCNGqktrB6nwWL7XRAnLjGfJBjkZ/t1YR0SXkh
	 55eQ81dPBbl85kIaq5kH9NfaWD9ghI/0GoY7eZM5zYV2dW958ReipTO+wJZ7mHMUJJevO
	 D7LU8/qaUj02SqQQVxbQYjWF9ZZ7Mh0Y38Lf9y9iAbXyfgIW0Bd43Ak2J7HIDwN58ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKYwHDM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F697606A31E;
	Wed, 25 Nov 2026 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKYwHDM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3009B1F000C0;
	Wed, 25 Nov 2026 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622932;
	bh=zIsOM+Ddsj4RXOPYoxQQ8MFP60reh/EweRzGsxqI3Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKYwHDM8NzWPri/KcgPDt95H6KttUBH1im/w2xuorvfoZ4+k36A0jvq4LNTBAcrB5
	 ieiy79mdW/1rh/i8immZVX14gS5wTtL1G3tkXDH9TjHQArQuLnjyaRNr6onzUsoWzh
	 q+tFOc+tT5Rtdq6pboe5YDC6pOt+i50Ns9CZGVuM=
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
Subject: [PATCH 6.18 697/990] net: bridge: use one headroom snapshot for ND replies
Date: Wed, 25 Nov 2026 15:34:24 +0100
Message-ID: <20261125143838.414122345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
 	int i, len;
 	u8 *daddr;
@@ -271,7 +272,8 @@ static void br_nd_send(struct net_bridge
 	if (!dev || skb_linearize(request))
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
 


