Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053212;
	b=zvs2kMScU6NiUPLWkAyhvySoXi1t5suNt8V/nfAwfHEQq8kZI4du7TdWT5Zl9IgrN8VZ
	 cehzLjyW0szuksGNuvSdTMutp7ydSx22CUtUCzVzRNZWHVWiUtlbsNJkBBiZPB2ootwUg
	 38lj2PU+GhgVgOeq3VXj9QqAIQeOkbEk25TUQV6gZ6cxYB5Sgk369T9Vh2Hj17Jzirar+
	 Gp/nnkXLJvvrPIUeLkAOhwNtj1606gwWbbxrb7EfuDsXmTgvvPJAM7I/uFpOPKyxSpRn/
	 qbNfGVX+6H82SrF/Grgo1omdbOhz7LHlqyP2nZQTHEAstvrMolglhmm6sl6+zE/suZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3MxRBLaYnIgaAOUfPX8lrRoYMGe21NWH5hS5eAbuxrM=;
	b=zDdza6ec+4M8ScZbQKXEWZBONgjLMgvlKNPWgDTJSNoav8M4Yo1as4YzpQohfJLEykPv
	 SOw8LmBjpChkKz1ivg13hW6Ip8s9rYLWMZ14l4SFaSuf9NsQrH8HUAnQU9djpYy6dg+yQ
	 7pgTUIlL3sTTNk/T0w09cfPZVEIPvI+LuaeRZyBp/+TUkb4Jq6C9+b9rS24t8WApvM+WZ
	 BM+S8qgorNM7rYFELaWQ1E+/gbvPjjoVrSKnFqgNIcGoW5i6urpE5yjDAabVVPMDOrLqq
	 m4e1KGVoqD1od0weytiiQ+zUbVtWcwefsdDAvUKi9HD9I14GeIv7+iQsPGzXXF1nxCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJS8RLdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CDC606A31C;
	Thu, 19 Nov 2026 01:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJS8RLdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEE51F000C4;
	Thu, 19 Nov 2026 01:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053212;
	bh=3MxRBLaYnIgaAOUfPX8lrRoYMGe21NWH5hS5eAbuxrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJS8RLdyp/b8HJy2vuVE7bi2SLXB3He4GwRXznYormaQ3VjUsvjA1GuvHIcUBumBV
	 VCIvbTCLW/1vCagVxHnOE8KCA/nGK1aHSCBMwN9HR7VChJDpPea0sz6SlAqjUu0vsP
	 iOrlva01sa6GMZvVL/1+5JfX/mkcRcaiIjTE9oFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0836/2214] xfrm: interface: validate the IP header on xmit
Date: Wed, 18 Nov 2026 15:41:52 +0100
Message-ID: <20261118150045.606183132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 86de3a1118a16dbbbe5fabe9aa20ffb93c072ed5 ]

Packets injected into an xfrm interface (e.g. AF_PACKET on an xfrmi
device) reach the xfrm output path without IP header validation, but
xfrm4_transport_output() uses iph->ihl for __skb_pull() and memmove()
and expects the header to be valid.

vti_tunnel_xmit() already calls pskb_inet_may_pull() before handing
packets to the xfrm output path.  Do the same in xfrmi_xmit() and
perform the header checks ip_rcv_core()/ip6_rcv_core() do on entry
to the IP stack: reject wrong IP versions and malformed IPv4 header
lengths.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 11caf778446b5..75b64b368d63b 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -395,8 +395,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl, 0, sizeof(fl));
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IPV6):
+		if (ipv6_hdr(skb)->version != 6)
+			goto tx_err;
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET6);
 		if (!dst) {
@@ -412,6 +417,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		break;
 	case htons(ETH_P_IP):
+		if (ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5 ||
+		    !pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			goto tx_err;
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		xfrm_decode_session(skb, &fl, AF_INET);
 		if (!dst) {
-- 
2.53.0



