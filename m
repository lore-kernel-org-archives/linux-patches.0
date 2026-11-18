Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033439;
	b=PEl8Mds5WPOZwgYjWis6zlN5sKl89eoWx3gjw7Xshc9TE7jkiNp4XGMGlxrjw3Av2e61
	 K2gloJnd/4+9Bieia49vTMxwmjH+odxOCU4olDXrBkS0lEpIFMMOMETaupps5xiF+DKhJ
	 Vo4h81T6Jm7JS7bzrv8/zppDu8StfMW2pWsP4vTrYx71S3UZmv1jQom4BMEv8tY29ord9
	 EBcfKCinYetROF/7xJNAqepRzRSFopEFQuhONOVM5B83kj4SG1ptBEKDZqOYahqFXTSAb
	 HF4Gh9CxgZ4aiWoAne0rg/RGCmOMO2he13s2Gz8O6M0vDjYnetg4UR4WB7hPtEqQXmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoHQrbu9HJU/2ccVK3pZVhZHRRIEAQ7a0hzOnUncRFk=;
	b=lR1tu6nW2SGaSeev6xZIrhAqU9pEmUkXfomjzbjh7dnWcqvVcSBZkf2uPR+P10z4fxmL
	 nobqaoAvOjoGtm5Wh/5jXGlHfkSr30UGJk5prEBhBl+1/29qzhY8Ne6gDXwQ9CxIroruF
	 b0U/LtNh5T+NgF5lC9TnXdjJ26pYGDsxIujlOEZY9ykokHCKWA9dVXJTuiN41+pwjGfWU
	 725bCLFxOSeGedD/8lU0uY9lOcf54zY3hepW7CosgaXBOXMDYeaSZiFJtb1rH4piCYZDl
	 x8/EUFyft4oHgfuarG0DM3fyP4f+dnU6T9KLa/8eQBVWcjMSOQT+rDlUURBGE8aFnQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQcheUFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90703606A31C;
	Wed, 18 Nov 2026 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQcheUFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99091F000C4;
	Wed, 18 Nov 2026 20:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033439;
	bh=RoHQrbu9HJU/2ccVK3pZVhZHRRIEAQ7a0hzOnUncRFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQcheUFNJOm2NpXLNaWotT7o2JGY7ooF9B+BzUvrRD5IZiVcoRAzqyLk5eAm5JFSb
	 QfrJnSeu2xZYCNULoNMGYKB1OO4LK4lsfqbfBmtkAxBKpVpGrm/cBT/xa2t4spmxkY
	 Bnh68/mJgt/PHpWdGu6y+Ym+RnZ1HvzuzTarmnM0=
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
Subject: [PATCH 6.6 0016/3318] net: gso: limit recursive IP-in-IP segmentation
Date: Wed, 18 Nov 2026 15:10:38 +0100
Message-ID: <20261118150314.185377622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Ting-Han: ipv6_gso_segment() still calls ipv6_hopopt_jumbo_remove()
  right after skb_reset_network_header() in this version; keep the new
  recursion check directly after skb_reset_network_header() as upstream
  does, before the jumbo removal. IP_TUNNEL_RECURSION_LIMIT is still 4
  in this tree because 77facb35227c ("net: increase
  IP_TUNNEL_RECURSION_LIMIT to 5") is not here, so the fifth entry is
  the one that fails until that commit is applied ]
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gso.h      |    8 ++++++++
 net/core/gso.c         |    1 +
 net/ipv4/af_inet.c     |    3 +++
 net/ipv6/ip6_offload.c |    4 ++++
 4 files changed, 16 insertions(+)

--- a/include/net/gso.h
+++ b/include/net/gso.h
@@ -19,10 +19,18 @@ struct skb_gso_cb {
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
--- a/net/core/gso.c
+++ b/net/core/gso.c
@@ -117,6 +117,7 @@ struct sk_buff *__skb_gso_segment(struct
 
 	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
 	SKB_GSO_CB(skb)->encap_level = 0;
+	SKB_GSO_CB(skb)->recursion_counter = 0;
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1378,6 +1378,9 @@ struct sk_buff *inet_gso_segment(struct
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
@@ -17,6 +17,7 @@
 #include <net/udp.h>
 #include <net/gro.h>
 #include <net/gso.h>
+#include <net/ip_tunnels.h>
 
 #include "ip6_offload.h"
 
@@ -122,6 +123,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	err = ipv6_hopopt_jumbo_remove(skb);
 	if (err)
 		return ERR_PTR(err);


