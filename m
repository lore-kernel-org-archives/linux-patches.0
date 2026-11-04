Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831624;
	b=cR1dX31xmN+EoZpu/JV+5IVeLW0EjnyjKqHqYu/3s8BFEWofdhPgFW8ZzwvNUJd+3iyJ
	 Wh48QqX9rmwpYPMFeSTRqbAQNtCjDpGj3fa0xLQYI+PpwGyZlFxxEoLMI+fFWameIZXDv
	 lTDQ/uLL2s+LSeJmt/QIw4wFsMXi3nY1ABV8ukHn3P1bOkRuYg0YpUsPs1/rIiz8fMrcA
	 8hTtGFewcMqVltWyd1a3nAiIBsOZVp9sx3u3YwmOnlIm8zPbXJwhzN9UANqGh/AILwl1t
	 9CG+r67IbfKc11pmuek/6Yus2VnuRti6l8vIMAqiCUD4XD67qFo/wpFRolvRpuW/nmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkKcaZW1ENndgrjwdLf8qG8F15YP9c3IQjdZbJw3fi8=;
	b=C1EVd6lKm+9rGPDMzXNFE8C4j+euBru9t42V06bPiw4SOr2WIKLjz+IHpnBfNpUbMiKT
	 ghV/ASmmNxmeiKvJXhQ68OipbUkGkljqsD3SP545Ykd0KwuwI6lJB+om0/iqhoTgqc8gX
	 Yv63Pr8MF7zO5UDaeVi9/78eKCXo912dE5hIoRmyVMcro4JAGF57zR7/ssHb9n4nP3xNQ
	 WOJ/cpn99UHbB7KE5TNkDeePvsxaKPHJ/tiDdNkbopycezG3dT/CVcwCUP3rH0U+LQhKQ
	 v1YE09j4hjbm3br48MTamm3dznZckhWkjJH4O39WQ56wL3csNmQbcW0s82vXrpDNPZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06BtYofm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401BA606A326;
	Wed,  4 Nov 2026 22:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06BtYofm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAF51F000C1;
	Wed,  4 Nov 2026 22:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831624;
	bh=wkKcaZW1ENndgrjwdLf8qG8F15YP9c3IQjdZbJw3fi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06BtYofmkDGKcrbpjAW+lj+bzXGxIXqo6sn6PQXY3UHkvI4GOkPr0nRtQPTr4RhK+
	 /YmzneP6TUVETNNmF/oqAgQRzu4hhSDnGb1x6Kc5BUFQf737r9UI6aNp+yMoZLg4oK
	 9WurTafZR3Xr/WAOJoHn2yiqGCjk/tRktq70OOJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0817/1005] netfilter: validate L4 headers after userspace packet writes
Date: Wed,  4 Nov 2026 16:09:10 -0500
Message-ID: <20261104211106.227046707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 112e447d17f78d08485b3076a8baa1dfb9794bd8 ]

NFQUEUE and nft_payload can hand packet data modified by userspace back
to the stack. Recent restrictions keep link and network headers stable,
but transport header fields can still be changed.

A packet can therefore keep the same network header and conntrack entry
while changing the transport header layout. For TCP, increasing doff can
make later helper or NAT code use a different transport-header base than
the parser used, and can make offsets point past skb->tail.

Extend NFQUEUE payload validation to check the final L4 protocol and
known base headers after IPv4 options or IPv6 extension headers. Reject
packets whose L4 protocol no longer matches an attached non-template
conntrack entry, and reject IP fragments that already have such a
conntrack entry before trying to validate transport headers. Unknown L4
protocols are left to their normal protocol handlers.

For nft payload writes, reject transport-header stores that overlap TCP
doff. nft_nh_write_ok() already rejects network-header protocol changes,
so keeping doff stable prevents nft payload writes from changing the TCP
header length underneath conntrack and helper users.

This patch is a follow up to commit df07998dfd40 ("netfilter: nftables:
restrict linklayer and network header writes") and commit 54f34607d184
("netfilter: nfnetlink_queue: restrict writes to network header").

Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 72 +++++++++++++++++++++++++++++++--
 net/netfilter/nft_payload.c     | 13 ++++++
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7cfb1bdf0e88f..c5f3307936f8c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -28,10 +28,17 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/ip.h>
 #include <linux/list.h>
+#include <linux/sctp.h>
 #include <linux/cgroup-defs.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/gre.h>
 #include <net/gso.h>
 #include <net/ip.h>
 #include <net/sock.h>
@@ -1199,10 +1206,62 @@ static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
 	return memcmp(iph_new + 1, ip_hdr(e->skb) + 1, ihl - sizeof(*iph_orig)) == 0;
 }
 
+static bool nfqnl_validate_l4(const u8 *data, unsigned int data_len,
+			      const struct nf_queue_entry *e, u8 proto,
+			      bool fragment)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(e->skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct)) {
+		if (fragment || nf_ct_protonum(ct) != proto)
+			return false;
+	}
+#endif
+
+	if (fragment)
+		return true;
+
+	switch (proto) {
+	case IPPROTO_TCP: {
+		const struct tcphdr *th = (const struct tcphdr *)data;
+		unsigned int thlen;
+
+		if (data_len < sizeof(*th))
+			return false;
+
+		thlen = __tcp_hdrlen(th);
+		if (thlen < sizeof(*th) || data_len < thlen)
+			return false;
+
+		return true;
+	}
+	case IPPROTO_UDP:
+		return data_len >= sizeof(struct udphdr);
+	case IPPROTO_ICMP:
+		return data_len >= sizeof(struct icmphdr);
+	case IPPROTO_ICMPV6:
+		return data_len >= sizeof(struct icmp6hdr);
+	case IPPROTO_SCTP:
+		return data_len >= sizeof(struct sctphdr);
+	case IPPROTO_GRE:
+		return data_len >= sizeof(struct gre_base_hdr);
+	case IPPROTO_AH:
+		return data_len >= sizeof(struct ip_auth_hdr);
+	case IPPROTO_ESP:
+		return data_len >= sizeof(struct ip_esp_hdr);
+	}
+
+	return true;
+}
+
 static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
 			       const struct nf_queue_entry *e)
 {
 	unsigned int ihl;
+	bool fragment;
 
 	if (data_len < sizeof(*iph))
 		return false;
@@ -1219,10 +1278,14 @@ static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
 	if (ntohs(iph->tot_len) != data_len)
 		return false;
 
+	fragment = iph->frag_off & htons(IP_MF | IP_OFFSET);
+
 	/* support for ipopts mangling would require
 	 * recompile + skb transport header update.
 	 */
-	return nfqnl_validate_ipopts(iph, e);
+	return nfqnl_validate_ipopts(iph, e) &&
+	       nfqnl_validate_l4((const u8 *)iph + ihl, data_len - ihl, e,
+				 iph->protocol, fragment);
 }
 
 static bool nfqnl_validate_one_exthdr(const u8 *data,
@@ -1266,6 +1329,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 	const u8 *data = (const u8 *)ip6_new;
 	u8 orig_nexthdr = ip6_orig->nexthdr;
 	u8 new_nexthdr = ip6_new->nexthdr;
+	bool fragment = false;
 
 	if (new_nexthdr != orig_nexthdr)
 		return false;
@@ -1279,7 +1343,8 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		int hdrlen;
 
 		if (orig_nexthdr == NEXTHDR_NONE)
-			return true;
+			return nfqnl_validate_l4(data, data_len, e,
+						 new_nexthdr, fragment);
 
 		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
 			return false;
@@ -1290,6 +1355,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 
 		switch (orig_nexthdr) {
 		case NEXTHDR_FRAGMENT:
+			fragment = true;
 			hdrlen = sizeof(struct frag_hdr);
 			break;
 		case NEXTHDR_AUTH:
@@ -1316,7 +1382,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		data += hdrlen;
 	}
 
-	return true;
+	return nfqnl_validate_l4(data, data_len, e, new_nexthdr, fragment);
 }
 
 static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a6f379ecee8a2..592fe48a73f84 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1067,6 +1067,17 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 	return false;
 }
 
+static bool nft_th_write_ok(const struct nft_pktinfo *pkt,
+			    const struct nft_payload_set *priv)
+{
+	unsigned int doff = offsetof(struct tcphdr, ack_seq) + sizeof(__be32);
+
+	if (pkt->tprot != IPPROTO_TCP)
+		return true;
+
+	return priv->offset > doff || priv->offset + priv->len <= doff;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -1105,6 +1116,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
+		if (!nft_th_write_ok(pkt, priv))
+			goto err;
 		offset = nft_thoff(pkt);
 		break;
 	case NFT_PAYLOAD_INNER_HEADER:
-- 
2.53.0



