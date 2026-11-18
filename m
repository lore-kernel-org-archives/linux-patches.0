Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050890;
	b=zBS6l9sNJpk5PW6TG2qvW9PCgzhU85Bbx1GSDObBxgjVXS2XY2V1+zyw1sbn7fP0ktvM
	 +p9n20tewcfkEk/ooBWeYeEIAN45cG2g4deaoyBEbEO0mawud1qp87LnefcOssF1u05nu
	 YmPc+Yq8x/XYxszACAtvlbUbEzXXJ1exuLmzCrHHDx+tg+8EaqH+BzDVdEVAcOBA6CiiR
	 EyGhazFITOKgvTrOMfHdUvwDLWpewF6SKIjqacd/aLLy5jaNjkOsXmxwTISrKftRT7eW/
	 LeulEUil5U6bLN87e0H8xJWaS6hYqkOB8h+w4Ki/8WIs4C2+w4/40Bw/XlyyTGyF4Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IGuuhyYcF6P4jAKRwSvoCpKLG5GMrcrpz38HcMRRliA=;
	b=WMHFOaT/dqk5tBzGUs8DsFEP74GxGY6IRTUuMlWCNzlgna3/BF/1T0uxA+x87hLRpyJH
	 udtTPnMv/hnCZuNcJKQ4Bl40HhoI0De6CzQyIP8xSMlKsjatZmv6PeNUwEyaTJtx53t2x
	 GWB+UoTq9sTXdsYxaUqbukvsJCrDr73We7AYPpr9Pu04w+Tq11MeOtkgMFzX7JGUK12Uy
	 jT/lZtEzh38yAVn7GdDKhiqPOSQHFFmzAx23PUwzmyjEZ86uulEeVizrLvbSIIZy091av
	 mHJ2n2vNiHmhUREMwGHDaS1RCCG7MY0b5p/iXDnWqeZY4knoA8QYGcQaSqOLM/8q8cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lovURnqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89128606A325;
	Thu, 19 Nov 2026 01:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lovURnqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37DA1F000C4;
	Thu, 19 Nov 2026 01:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050890;
	bh=IGuuhyYcF6P4jAKRwSvoCpKLG5GMrcrpz38HcMRRliA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lovURnqnZKfeAWATdl/eLA0usBmq0Dh6rg3QHkrOcpRBS1Z48ctHg8Kq/2v/D6mBx
	 ou1RM96vBe4iJU4yPiJC54aqmmuJFNfVQ7OnMOlRIsUG3qlCAJvhKSwCErPJS5uxcs
	 /Eo0o1z2+QIkD9wQSxNL9rMe8zSkqznHCLB1pdOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Ting-Han Hou <ue081723@gmail.com>
Subject: [PATCH 5.15 0015/2214] net: gso: limit recursive IP-in-IP segmentation
Date: Wed, 18 Nov 2026 15:28:11 +0100
Message-ID: <20261118150010.757402331@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 006c8b834aed8b02bd8fb9fb05e9e7ead37d1763 upstream.

IP-in-IP GSO can re-enter inet_gso_segment() or ipv6_gso_segment()
for each nested IP header. encap_level tracks header bytes, not callback
depth, so a deep chain can exhaust the kernel stack. Making
inet_gso_segment() stackable introduced unbounded IPv4 nesting; IPIP
GSO/TSO later made the path reachable. The IPv6 stackable path was
introduced separately and uses the same guard.

Count IPv4 and IPv6 GSO handler entries in skb_gso_cb, initialized once
per top-level GSO operation and preserved across GRE/UDP context changes.
Use the existing IP_TUNNEL_RECURSION_LIMIT for both handlers. The first
five entries pass, and the sixth returns -EINVAL before dispatching
another GSO callback.

Fixes: 3347c9602955 ("ipv4: gso: make inet_gso_segment() stackable")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Closes: https://lore.kernel.org/all/cover.1790157745.git.zihanx@nebusec.ai/
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260924051521.32568-2-zihanx@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Ting-Han: this tree predates include/net/gso.h and net/core/gso.c, so
  the skb_gso_cb change and gso_recursion_inc_test() go into
  include/linux/skbuff.h and the reset into __skb_gso_segment() in
  net/core/dev.c. IP_TUNNEL_RECURSION_LIMIT was added upstream by
  6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit
  functions"), which is not in this tree, so define it (same value, 5)
  in ip_tunnels.h ]
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h   |    8 ++++++++
 include/net/ip_tunnels.h |    3 +++
 net/core/dev.c           |    1 +
 net/ipv4/af_inet.c       |    3 +++
 net/ipv6/ip6_offload.c   |    4 ++++
 5 files changed, 19 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4657,10 +4657,18 @@ struct skb_gso_cb {
 	int	encap_level;
 	__wsum	csum;
 	__u16	csum_start;
+	/* Number of IPv4/IPv6 GSO handler entries for this packet. */
+	u8	recursion_counter;
 };
 #define SKB_GSO_CB_OFFSET	32
 #define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_GSO_CB_OFFSET))
 
+static inline bool gso_recursion_inc_test(struct sk_buff *skb,
+					  unsigned int limit)
+{
+	return ++SKB_GSO_CB(skb)->recursion_counter > limit;
+}
+
 static inline int skb_tnl_header_len(const struct sk_buff *inner_skb)
 {
 	return (skb_mac_header(inner_skb) - inner_skb->head) -
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -24,6 +24,9 @@
 #include <net/ip6_route.h>
 #endif
 
+/* Maximum nesting depth for recursive IP tunnel processing */
+#define IP_TUNNEL_RECURSION_LIMIT	5
+
 /* Keep error state on tunnel for 30 sec */
 #define IPTUNNEL_ERR_TIMEO	(30*HZ)
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3475,6 +3475,7 @@ struct sk_buff *__skb_gso_segment(struct
 
 	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
 	SKB_GSO_CB(skb)->encap_level = 0;
+	SKB_GSO_CB(skb)->recursion_counter = 0;
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1358,6 +1358,9 @@ struct sk_buff *inet_gso_segment(struct
 	int id;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*iph))))
 		goto out;
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -16,6 +16,7 @@
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/gro.h>
+#include <net/ip_tunnels.h>
 
 #include "ip6_offload.h"
 
@@ -87,6 +88,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;


