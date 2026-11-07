Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060556;
	b=QnzoJA+W3DtKaf35OYO1nzA4QJPdlZA5JLoNb0S4L6GHYTCsPdtgPM1iLdyXR7LVEY6y
	 lKndaNHuLYijfX2c3Rmnnc6OT4gfbfKZx6Sg+x08iLFjcHFh4PSIN2nbA7NcdTWO+w8Pz
	 u+WO+6sGrzxVUBHZpqjss4PZOe66ENeZYZI5Yy2FFuU5k2JHtknRmlrGatfmn17XUoKKx
	 w9YmUR63+/naNMAvEX11mvY0zd/ifDIBl02xR80DyH2ff4lrgTzOhVy3ip1J6veneuabv
	 Ow1ZLn04mZlfiReVvygAidkC1py2UEbMnROi8TD9Balj1ZLsLXxTm/qz+oOloEu5EHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lcRIlXYms9GbVp7bIuG+yY9esNGAcIdoz17ETtvynI=;
	b=xJw9shRcZQpfUFF+QrG4ojozuUr6Dssx8+rccWDG5Z3vUF578cH8a5uXEllgirk3DTrF
	 rQkXVEM0KaUAp9kIKnwnMC1t1mYKMe3cV5A5jYDhdmbLS+cYBKcx/k1R+kyLcFl5kZu2r
	 HV1xCRzp3hmkFy2nU44fS3zE4vh+gnap30VDcc5sHf8KBuG521SDLAp3TLai1t3X4bgLT
	 zbOAoeitznFt5XweHQOSHQG7Ew5CT1GGN5T9W5smO/QYQU8eV3yJkE43fyxUsOh0mNSot
	 obSdeSYlHjrRrLPK8d7wJQkpelhWbz5p/vVB3B6Gjo7Ty2BSJnKgOPZ1HMZ3N+5PkTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gl/UD/lT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A4F606A32C;
	Sat,  7 Nov 2026 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gl/UD/lT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042231F0089F;
	Sat,  7 Nov 2026 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060556;
	bh=1lcRIlXYms9GbVp7bIuG+yY9esNGAcIdoz17ETtvynI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gl/UD/lTGP4OUceual5vgcvI1UTcd5K8023cWooElhowMYVx4HZXPWEQobCnzNznB
	 kMV79U6BZQpCLE64iEYuR3Nm8dHNLdpYQRTlRz+d8PM2EKhfiRsoNPnFwc2elACEYj
	 pOR4r1bAupt63wKD2m9iN3XVOMxgblqfu7H6+pUc=
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
Subject: [PATCH 6.12 0021/1536] net: gso: limit recursive IP-in-IP segmentation
Date: Sat,  7 Nov 2026 08:33:57 -0500
Message-ID: <20261107134958.275392912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
  does, before the jumbo removal ]
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
@@ -1380,6 +1380,9 @@ struct sk_buff *inet_gso_segment(struct
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
 
@@ -120,6 +121,9 @@ static struct sk_buff *ipv6_gso_segment(
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	if (unlikely(gso_recursion_inc_test(skb,
+					   IP_TUNNEL_RECURSION_LIMIT)))
+		goto out;
 	err = ipv6_hopopt_jumbo_remove(skb);
 	if (err)
 		return ERR_PTR(err);


