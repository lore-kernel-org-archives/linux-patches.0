Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831616;
	b=aSnYMxE49+bFjnRkKjPfTjJMROb7v/oxMbqkMBwJSiChgd/FBRJ1eg0MdvzNepJwQlF8
	 Mk/sHWOHr5p2IG2PhPt/2rfhsHkQOjDC8YNZHyar9Slboen1Y+umElJi52kmCvrIU5pwa
	 x9Zbqt/JSh1N3AZ5PtEQQOoJzam8v2qqMZCnBLao+jOECVxz9WYcKIL+xP04KZjXLUDNc
	 FyyizCFtAfye2VOnmtAI3VsaywB0gVAAtw44piC/hMmZlJFEcE/d7i9qTw2OpyKhlBk6v
	 jF5Sbh6BG4F6THggssenR1YxRrrWwV9yq7apnsuI750BAHs/BYQrGM4bRxT7scJmscQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEv+IuUxipHnrsoMZc0urgcIe5TgXZl1BxjmzcyLh30=;
	b=EBHLdKvtwp0disSiVwDAoq1A1/KQ+bVoowyhRdwZSdQs/eboZAofRg8rx/XUKYTrx8fe
	 kiD8TYb4SERPo0cGi/6BkVgEzwSh+XR3skap42PixbXQl6G0yqDV+06IYWoblUVMuLbXx
	 7j3WGceemEqcGJdaSPq93PNcDPkbNHitbOJXdLL8klX6UjvUL1EAK+pkwFfLBjgFzyzkK
	 1gauXiYd4/1RJVCEAtiN+oEChatIeYEubDAhV5+WJTxLcNA3s9jXYdti5ULkiC9nkuwp/
	 J3Juiy6yurZTSuhfxvUqDxkFY7Q86tbrgm8Xpgre6mcpDUWOyvXQ9sHp15Jy7hUn9Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnSVS6f+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C6606A326;
	Wed,  4 Nov 2026 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MnSVS6f+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FF31F000C1;
	Wed,  4 Nov 2026 22:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831616;
	bh=SEv+IuUxipHnrsoMZc0urgcIe5TgXZl1BxjmzcyLh30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnSVS6f+8ZehQJ2WGUHL5Jszd3Cct1/SIirWXKob13k0LiZO9bk/PpEOZdongDKs9
	 V9i/jeBPFRxduNkGFSuGXwfhbbAqRroXgVw4qLJFRdKjRRhOLvcZDzJRBqzO+SeF8V
	 vky2NJ04xAhu54dL3+Va6YASEN1ixqJMUi71u2CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0813/1005] netfilter: nfnetlink_queue: restrict writes to network header
Date: Wed,  4 Nov 2026 16:09:06 -0500
Message-ID: <20261104211106.120815687@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 54f34607d184c1cc056c59a5b3d86d96dd6a515c ]

nfnetlink_queue doesn't allow selective replacements of some part of the
payload, only complete replacement.
If the new data is shorter, skb is trimmed, otherwise expanded.

Add minimal validation of the new ip/ipv6 header.  Check total len
matches skb length.  Disallow ip option modifications.

IPv6 extension headers are also disabled.
IP options and exthdrs could be allowed later after validation pass or
ip option recompile.

Transport header is not checked.

Bridge modifications are rejected.  Given userspace doesn't even receive
L2 headers, use is limited and I don't think there are any users of
bridge nfnetlink_queue, let alone users that modifiy payload.

Arp isn't supported at all.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 170 ++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 463abfb3fb54e..7cfb1bdf0e88f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1185,6 +1185,173 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	return err;
 }
 
+static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
+				  const struct nf_queue_entry *e)
+{
+	const struct iphdr *iph_orig = ip_hdr(e->skb);
+	unsigned int ihl = iph_new->ihl * 4;
+
+	if (iph_new->ihl != iph_orig->ihl)
+		return false;
+	if (ihl == sizeof(*iph_orig))
+		return true;
+
+	return memcmp(iph_new + 1, ip_hdr(e->skb) + 1, ihl - sizeof(*iph_orig)) == 0;
+}
+
+static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
+			       const struct nf_queue_entry *e)
+{
+	unsigned int ihl;
+
+	if (data_len < sizeof(*iph))
+		return false;
+
+	ihl = iph->ihl * 4u;
+	if (ihl < sizeof(*iph) || data_len < ihl)
+		return false;
+
+	if (iph->version != 4 ||
+	    ((iph->frag_off ^ ip_hdr(e->skb)->frag_off) & ~htons(IP_DF)) != 0)
+		return false;
+
+	/* BIG TCP won't work; netlink attr len is u16 */
+	if (ntohs(iph->tot_len) != data_len)
+		return false;
+
+	/* support for ipopts mangling would require
+	 * recompile + skb transport header update.
+	 */
+	return nfqnl_validate_ipopts(iph, e);
+}
+
+static bool nfqnl_validate_one_exthdr(const u8 *data,
+				      unsigned int data_len,
+				      const struct nf_queue_entry *e,
+				      int start, int hdrlen)
+{
+	u16 octets;
+
+	if (data_len < hdrlen || hdrlen < 2)
+		return false;
+
+	while (hdrlen > 0) {
+		if (data_len < sizeof(octets))
+			return false;
+		data_len -= sizeof(octets);
+
+		if (skb_copy_bits(e->skb, start, &octets, sizeof(octets)))
+			return false;
+
+		if (hdrlen < sizeof(octets))
+			return false;
+
+		hdrlen -= sizeof(octets);
+		if (memcmp(data, &octets, sizeof(octets)))
+			return false;
+
+		start += sizeof(octets);
+		data += sizeof(octets);
+	}
+
+	return true;
+}
+
+static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
+				  unsigned int data_len,
+				  const struct nf_queue_entry *e)
+{
+	const struct ipv6hdr *ip6_orig = ipv6_hdr(e->skb);
+	int exthdr_cnt = 0, start = sizeof(*ip6_orig);
+	const u8 *data = (const u8 *)ip6_new;
+	u8 orig_nexthdr = ip6_orig->nexthdr;
+	u8 new_nexthdr = ip6_new->nexthdr;
+
+	if (new_nexthdr != orig_nexthdr)
+		return false;
+
+	data += sizeof(*ip6_new);
+	data_len -= sizeof(*ip6_new);
+
+	while (ipv6_ext_hdr(orig_nexthdr)) {
+		const struct ipv6_opt_hdr *hp;
+		struct ipv6_opt_hdr _hdr;
+		int hdrlen;
+
+		if (orig_nexthdr == NEXTHDR_NONE)
+			return true;
+
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return false;
+
+		hp = skb_header_pointer(e->skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			return false;
+
+		switch (orig_nexthdr) {
+		case NEXTHDR_FRAGMENT:
+			hdrlen = sizeof(struct frag_hdr);
+			break;
+		case NEXTHDR_AUTH:
+			hdrlen = ipv6_authlen(hp);
+			break;
+		default:
+			hdrlen = ipv6_optlen(hp);
+			break;
+		}
+
+		if (!nfqnl_validate_one_exthdr(data, data_len, e,
+					       start, hdrlen))
+			return false;
+
+		orig_nexthdr = hp->nexthdr;
+		hp = (const void *)data;
+		new_nexthdr = hp->nexthdr;
+
+		if (new_nexthdr != orig_nexthdr)
+			return false;
+
+		data_len -= hdrlen;
+		start += hdrlen;
+		data += hdrlen;
+	}
+
+	return true;
+}
+
+static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
+			       const struct nf_queue_entry *e)
+{
+	if (data_len < sizeof(*ip6))
+		return false;
+
+	/* BIG TCP/jumbograms won't work; netlink attr len is u16 */
+	if (ntohs(ip6->payload_len) != data_len - sizeof(*ip6))
+		return false;
+
+	if (ip6->version != 6)
+		return false;
+
+	return nfqnl_validate_exthdr(ip6, data_len, e);
+}
+
+static bool nfqnl_validate_write(const void *data, unsigned int data_len,
+				 const struct nf_queue_entry *e)
+{
+	switch (e->state.pf) {
+	case NFPROTO_IPV4:
+		return nfqnl_validate_ip4(data, data_len, e);
+	case NFPROTO_IPV6:
+		return nfqnl_validate_ip6(data, data_len, e) &&
+		       !(IP6CB(e->skb)->flags & IP6SKB_JUMBOGRAM);
+	case NFPROTO_BRIDGE:
+		/* No write support. Bridge is dubious: userspace doesn't even see L2 header */
+		return false;
+	}
+
+	return false;
+}
+
 static int
 nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int diff)
 {
@@ -1193,6 +1360,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 	if (e->state.net->user_ns != &init_user_ns)
 		return -EPERM;
 
+	if (!nfqnl_validate_write(data, data_len, e))
+		return -EINVAL;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
-- 
2.53.0



