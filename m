Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044311;
	b=FPF030XYuTInRrnAUh50NLSG60AF6q1z+5qnYV7VAY29UPff0/6zMSx3M8vDePjR/fG/
	 8LG3CGiyyHdRYyTpzxnx4/P+V66NvW+jjuzuC+3nemA7rKOXWTH3j02x3vk2Jr8sJdD36
	 /rFhDsy1kuXuXUvKBMcnbUOeeW0qnOUOwJktTcevtUJOhij1zjX6G5KDxKiC22VJUkgqr
	 C33eyOzKLq3cjXIA4A4uMDFe4Yh6hS/bHNL5nn15ZaGZYjbE36XhjxpmN9C5DB39/KVJT
	 q+KwMpiec64hLexSYglQXz8VmdjB0pXFgV+KRxW3Fo1pBG2akXzbL/Kb2yWTBTJeWkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R/MO68E7+nB/GaVMUdlILyuEO7B+oRX+1c3IRX3YDdg=;
	b=TeGOiV2L9PE0WMc/kDd/oWQ1Ak5L5gTdGMQ4Y5mcnYH2/XX54WMTbrpkr6v2TH7Yw67P
	 LVExpIxqQ6FH+MdkWFlKcZBCKX8/PkPgiltmMjSpcqoewZ5z9FiJd8/kyUsjmND2AqM/P
	 0eGl1wPsPypjlQvWhQd3DCvlQ5X77FT7M16xtDmmJxnH5Mc5gnqNBvRfeQ8BP8e/M81TL
	 Dvfxvzhbsqemy64VVUODSY3dZegKNjzpJyRfpQ7wszYWvmS6f1Ep7EOGGf5QaelyxaKk1
	 NQwRudDg4L2QeoEDCZneOGa6r9rEzlAV91vKBq/0js0CsWxtNqZ5NbYCxcvgg/fJu1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQM0xKO8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D942606A320;
	Wed, 18 Nov 2026 23:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQM0xKO8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF33B1F000C4;
	Wed, 18 Nov 2026 23:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044311;
	bh=R/MO68E7+nB/GaVMUdlILyuEO7B+oRX+1c3IRX3YDdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQM0xKO8KEsw7qT28O/ebYL3VJfN7og3YFD4raVM1AW6XkFMP64vt7ryHE5tTJe6R
	 cEfBoBLhI8R4fNtXgSGzfTIixO+L6oq0VAjcYOXXk4EeaH9q65P5DIhMyi3KGZr4VQ
	 AyNWMcGsRSgnA+J1VZFJ9/JPl3WYV+y1wS7VMsYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0471/2857] net: extend IPv6 exthdr detection of tunneled packets
Date: Wed, 18 Nov 2026 15:25:05 +0100
Message-ID: <20261118150218.406663389@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 5f0764cb1c81a9712bce605d38efe6d844a70b29 ]

Commit c4336a07eb6b ("net: correctly handle tunneled traffic on IPV6_CSUM
GSO fallback") split skb_gso_has_extension_hdr() into mutually exclusive
branches on skb->encapsulation. This did not yet address all paths:

1. With skb->encapsulation set, the outer header is not checked. IPv6
   tunnels such as ip6_gre and ip6_tunnel add an outer Destination
   Options header by default (encap_limit). Their GSO packets skip
   software GSO, then skb_csum_hwoffload_help() sees the outer extension
   header and calls skb_checksum_help() on the GSO skb, which warns and
   drops it.

2. Tunnels over IPv6 without an outer transport header, such as
   ip6_tunnel, leave skb->transport_header at the inner transport
   header. skb_network_header_len() then spans the outer IPv6, tunnel
   and inner IP headers, a false positive.

3. UDP tunnels without an inner network header, such as SCTP-in-UDP or
   PSP, have no inner IPv6 header to check. Decide on the outer header
   alone.

4. Directly dereferencing inner_ip_hdr(skb)->version without
   skb_header_pointer() is unsafe.

Instead, check ipv6_ext_hdr(nexthdr) on the outer IPv6 header and, if
set, on the inner IPv6 header. Read the headers with skb_header_pointer().
Keep the skb_network_header_len() check when !skb->encapsulation to also
catch encapsulated packets without skb->encapsulation (e.g., virtio).

Use the same helper in skb_csum_hwoffload_help(). Its open coded test
has the false positive of (2) and ignores the inner header.

Background: checksum offload of tunneled packets invariants:

Non-GSO skb:
- If the inner packet is CHECKSUM_PARTIAL, Local Checksum Offload computes
  the outer checksum in software and the device offloads only the inner L4
  checksum.
- If the inner packet is CHECKSUM_NONE (e.g., SCTP-in-UDP, ESP-in-UDP,
  Remote Checksum Offload), the device offloads the outer UDP or GRE
  checksum instead.

GSO skb:
- A device with NETIF_F_GSO_UDP_TUNNEL_CSUM or NETIF_F_GSO_GRE_CSUM
  computes both inner and outer checksums per segment.
  The outer checksum is seeded with only the pseudo-header checksum.

A NETIF_F_IPV6_CSUM device must parse through the outer headers to
reach the inner ones.

Fixes: c4336a07eb6b ("net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback")
Cc: stable@vger.kernel.org
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260926140506.2335137-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Kept the existing !ipv6_has_hopopt_jumbo(skb) guards in both caller conditions while swapping in the new skb_has_ipv6_extension_hdr() helper, since upstream's context lacked those guards. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7c0d0905dd31b..ea6785052e8cf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3592,20 +3592,36 @@ static netdev_features_t dflt_features_check(struct sk_buff *skb,
 	return vlan_features_check(skb, features);
 }
 
-static bool skb_gso_has_extension_hdr(const struct sk_buff *skb)
-{
-	if (!skb->encapsulation)
-		return ((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
-			 (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-			  vlan_get_protocol(skb) == htons(ETH_P_IPV6))) &&
-			skb_transport_header_was_set(skb) &&
-			skb_network_header_len(skb) != sizeof(struct ipv6hdr));
-	else
-		return (!skb_inner_network_header_was_set(skb) ||
-			((skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6 ||
-			  (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-			   inner_ip_hdr(skb)->version == 6)) &&
-			 skb_inner_network_header_len(skb) != sizeof(struct ipv6hdr)));
+static bool __skb_has_ipv6_ext_hdr(const struct sk_buff *skb, int nhoff)
+{
+	const struct ipv6hdr *ip6h;
+	struct ipv6hdr _ip6h;
+
+	ip6h = skb_header_pointer(skb, nhoff, sizeof(_ip6h), &_ip6h);
+	return ip6h && ip6h->version == 6 && ipv6_ext_hdr(ip6h->nexthdr);
+}
+
+static bool skb_has_ipv6_extension_hdr(const struct sk_buff *skb)
+{
+	if (vlan_get_protocol(skb) == htons(ETH_P_IPV6)) {
+		if (__skb_has_ipv6_ext_hdr(skb, skb_network_offset(skb)))
+			return true;
+
+		/* Catch tunnels without skb->encapsulation (e.g., virtio). */
+		if (!skb->encapsulation &&
+		    skb_transport_header_was_set(skb) &&
+		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+			return true;
+	}
+
+	/* Tunnels without an inner network header, such as SCTP-in-UDP or
+	 * PSP, have no inner IP header and thus no inner extension header.
+	 */
+	if (skb->encapsulation && skb_inner_network_header_was_set(skb) &&
+	    __skb_has_ipv6_ext_hdr(skb, skb_inner_network_offset(skb)))
+		return true;
+
+	return false;
 }
 
 static netdev_features_t gso_features_check(const struct sk_buff *skb,
@@ -3654,7 +3670,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * so neither does TSO that depends on it.
 	 */
 	if (features & NETIF_F_IPV6_CSUM &&
-	    skb_gso_has_extension_hdr(skb) &&
+	    skb_has_ipv6_extension_hdr(skb) &&
 	    !ipv6_has_hopopt_jumbo(skb))
 		features &= ~(NETIF_F_IPV6_CSUM | NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4);
 
@@ -3757,8 +3773,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		return 0;
 
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (vlan_get_protocol(skb) == htons(ETH_P_IPV6) &&
-		    skb_network_header_len(skb) != sizeof(struct ipv6hdr) &&
+		if (skb_has_ipv6_extension_hdr(skb) &&
 		    !ipv6_has_hopopt_jumbo(skb))
 			goto sw_checksum;
 
-- 
2.53.0



