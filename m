Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831613;
	b=dKnjIjr2prfMMRu547J1WcSCOrMwqFOswJwph8nw4ObDmikIGeAnrPoFBnTLly/b62kJ
	 gytz1wPaQVOoxnQl0YHAmaATkMGE8PRCUgXoJ0Fx3BIk63T6Xkp679VIbLARWijnOUi8E
	 fE5+1gxKgGKsZoe7SPDsFY16OsKPnm8bEOMXEFeB2wVdPi/aaksG3APoR+nPlI4RhLPr8
	 dF4aK+ymHQ5ByQrkym7Gmio27PFWwlTq2ng/fGLVUfuO3mKA7JDwdgrkQVMGQzWjhmM+V
	 A5RH/HIwMHZxprT6M4Cn0EDE4JxQW1qXOxu5V+qKOJLekKntrdfo/0wf23gyG7TAu9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxLyBOLOX76rtfGtST1r+nJXE2zV5G5KCx0tvuDOeVU=;
	b=AvLkfuWnDNtxsbe7SSP/Bqbm/nvUIoALhmjeuU0LrBZeGvyD70A9Jqf2Xg40BpiF1lXh
	 WjtvEO0gPS8/gMXpcHUvCLwQMA2i9uzKRB/gFOzFUFsOf2dQytoxMUQqDga1duz9FaryD
	 Cdu5Ktk+rIEVA4zAhP6RFH2YZd/MPNOZsw/mh5DS3ISGVpgW3R89Snd+Fd8wSyRBoaXYf
	 8Zm4ODnXV4y6ydhpmQDSboejIUEGTAMaV5AkKMKeiphcygNtCYyvZq2kyu0Yj20hMNl13
	 gDdS6femBkhhwIsMMF8EepFLm0yQJ0zP9bHUHX3opEzLjh2YiX5hwDwMYc3LrEVtJCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yplz0jwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D6D606A326;
	Wed,  4 Nov 2026 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yplz0jwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28B31F00919;
	Wed,  4 Nov 2026 22:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831613;
	bh=XxLyBOLOX76rtfGtST1r+nJXE2zV5G5KCx0tvuDOeVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yplz0jwoDbrNjzerplcVdIXy4/61/+q8rDm48PnohszFaj8d+KNjcTdohDBt6I0g5
	 6CQe98ETZAXpdps5A9h4l7d9uctkHG/cgHKbRMdNFEt7Sq84lmwB4nfDVlk3ErQUke
	 xD3d+6u/i1vo/YP+DrURhSxET4rrdVqdEKib5K5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tang <tpluszz77@gmail.com>,
	Tong Liu <lyutoon@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0811/1005] netfilter: disable payload mangling in userns
Date: Wed,  4 Nov 2026 16:09:04 -0500
Message-ID: <20261104211106.068654546@linuxfoundation.org>
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

[ Upstream commit 968cc2c96390f06e56ed6a43f935bfebdefed28f ]

Several parts of network stack rely on iph->ihl validation
done by network stack before PRE_ROUTING.

Disable this feature for user namespaces for now.

tcp option handling is likely safe even for LOCAL_IN, so this
this leaves tcp option mangling via nft_exthdr.c as-is.

I don't think these are the only means to alter packets, but these
appear to be relatively prominent.

This could be relaxed later.  Example:
 - allow userns for ingress hook.
 - allow userns if base is transport header.

 Also, we should revalidate or restrict generally:
 - Don't allow linklayer writes to spill into network header
 - restrict ipv4 and ipv6 to 'known safe' writes, e.g.
   saddr/daddr/check/tos

Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Tong Liu <lyutoon@gmail.com>
Tested-by: Qi Tang <tpluszz77@gmail.com>
Link: https://lore.kernel.org/netfilter-devel/20260515100411.3141-1-fw@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 6 ++++--
 net/netfilter/nft_payload.c     | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index cf545ed26161a..463abfb3fb54e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1190,6 +1190,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 {
 	struct sk_buff *nskb;
 
+	if (e->state.net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
@@ -1592,8 +1595,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 		if (nfqnl_mangle(nla_data(nfqa[NFQA_PAYLOAD]),
 				 payload_len, entry, diff) < 0)
 			verdict = NF_DROP;
-
-		if (ct && diff)
+		else if (ct && diff)
 			nfnl_ct->seq_adjust(entry->skb, ct, ctinfo, diff);
 	}
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e07888aaf1475..4034d61e2a135 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -917,6 +917,9 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	struct nft_payload_set *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
-- 
2.53.0



