Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057104;
	b=d0ftyHLHtrADlyRXOkhp5C2jx7sLPWEpeKu2pHkdrPucY/S1FzzPYhgw1Edx8aRn+jQK
	 b7RKzCkfh4Rz2RGD6JCL78XxAIl934ewfXwM6hLfJwy9b+z0letb8zJjCA7FFrECs/5pq
	 QO4OEMbrsw9ZqBsgemxCU7I/RLNKedm0oH0fHw2WgMy1v+qE4aWGFaSjUPHsepJhIu7pa
	 8h4sT3HScfyCXD2GtMO/Pe9pQIb/kGWYt47mc441NlhWD2wbPnjfPkSa8EP/Pod6mKvTI
	 7yJuSEcTgMbDHVzIe/Sn3X+ArFVF79o0VVbiS4SK6bk5TPF8JeVzmhSuHLro6wi7bVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3sLcq7G35z95bJT10QVXC7v3tb8VtHjSbEuYW/EY8U=;
	b=llZye+ffxcVSMufFWH+ceWBH8PkNrA+V/JqPhLIPl1fOpnMz2fO8AlXUQOjIMEVzCEBV
	 GPjF8gEmLAdWhHjGG+HybGznmOkNuSoW9WarE3FedMLtXo1hdy7YVR8YseNde0/TAAFig
	 YqS3mjP6PR2+oY3BiV7FfvIEGWEptTLDV/sNlqrFnSYlU+Y1/JVE314wFt6SbsUKHF8rC
	 0wK1SLkuyuNtS2A2QMcKKwbMOUIdzQlwjNulctMQ1rokBzhHkrQus0dojzlX+znV3P1Pe
	 RcZyjq93jsM5fswEK8oItmigacdPydaeemrS/YQtCSqgpIHdpdTF9Aux3QuxxdVA7hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQa6HHFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18775606A325;
	Thu, 19 Nov 2026 02:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQa6HHFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A151F000C4;
	Thu, 19 Nov 2026 02:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057104;
	bh=x3sLcq7G35z95bJT10QVXC7v3tb8VtHjSbEuYW/EY8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQa6HHFPIeg0fgHInzJw95LB1iaIBDdab8HsM3JOE4CYNv41BVyDdHt7BKgPJ7x7g
	 5NORNpSiCtnG8qQ1BoEqAW2XXpWsGymkZSV+c9atv2avUSaND2tM0tz6HKPnZ54eJ8
	 wCTrBUtirk25QHYaxFzxwmewwOUtbFeWq1OEdc7s=
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
Subject: [PATCH 5.10 0014/1848] net: gso: limit recursive IP-in-IP segmentation
Date: Wed, 18 Nov 2026 15:34:12 +0100
Message-ID: <20261118145911.753725265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4500,10 +4500,18 @@ struct skb_gso_cb {
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
@@ -3415,6 +3415,7 @@ struct sk_buff *__skb_gso_segment(struct
 
 	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
 	SKB_GSO_CB(skb)->encap_level = 0;
+	SKB_GSO_CB(skb)->recursion_counter = 0;
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1351,6 +1351,9 @@ struct sk_buff *inet_gso_segment(struct
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
@@ -15,6 +15,7 @@
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/udp.h>
+#include <net/ip_tunnels.h>
 
 #include "ip6_offload.h"
 
@@ -86,6 +87,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;


