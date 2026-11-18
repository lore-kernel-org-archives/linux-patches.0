Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021035;
	b=RpyXw6GbBnFj4jjsBo73a2Snztwzkxz/EUKFCmqWKCmDa1t6Mx9AXpHZFS9GhqrKkUe5
	 UwahwSTUV6grp1WuJuvbwJxzbCV5iI1GybJfq6qSsOgpLGaE4k1K1VQXfD9V/jFx7NQir
	 KXlPJKktZt1RbUK/jxzZiQFT7QgmnGXAXeNw0+gZu16OmGLL+1vWPvQODB1SWGI9sUHau
	 cPBEGbzHgX4vBfVMDoXjNM0IJMVYo7xdB+0V+HtileBf9FgUtqZsxTIqJcyaM7C0iQhvV
	 rcbZL6sogNzb3ZbHiNnOl3sgotboVQY3Yqq9zhrJ7PXYIiiyHAmNHKlGWyM9nu0IQGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a5sSMwxiwVDCFfAdglKMx3b5cIwh67Xh5dGT78yhI5M=;
	b=UVdEYWJfZFzEjSEWL6xOlvc6sBOU9S3LQ/MrUxKV+xJEEykzWDpQq8QMw2OLp0pKxDnm
	 FdKyHfCmD7Xv5R0EevfbqXr1zujqH8K9XW3n5Xga0gfKnP4HzLkdcvkptEL7E88wVDFd9
	 2nrA6i+Dbm/IEBjXcfe5yBWXjPVwnWoIHJ9fivsZyqBckoWsF7PE+o73gDhj7kqj3WjAa
	 nLOetD8MLFIxArWjdFdn4mvAM2CzT9N3xbcfVEiHQ+7LjraMyu0Uert+qDQjXMk7xfA04
	 SUXmrJn8RbdoSaJUdk+wSDDS9cJJKTIvunbtA73yTkwt3mxe5ir5J2zmx8ubyVBjeOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h7/pmBqT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C922606A332;
	Wed, 18 Nov 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7/pmBqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE6E1F000C4;
	Wed, 18 Nov 2026 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021035;
	bh=a5sSMwxiwVDCFfAdglKMx3b5cIwh67Xh5dGT78yhI5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7/pmBqTxVK0AslEeh7nKih6vSuwcqdqHUsGJH/4iKdjKLC4MenB8/4VdhSBb11S4
	 6AL3MpZgS0oUZLQi75HGjebXlHAFbdMr1tPPdHz8PR171W9H+uchTk9EozEwPvBaM3
	 xJ7WBinKjizro5jYuPj60+GYPB/cv2qZU4KeXTIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2164/2651] netfilter: flowtable: reset transport header after nf_flow_encap_pop()
Date: Wed, 18 Nov 2026 15:56:44 +0100
Message-ID: <20261118150403.727761808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 08f7882637f2db5b98f521498eeaf94770383a6e ]

nf_flow_encap_pop() pulls vlan/pppoe or ip tunnel headers and resets the
network header, but leaves the transport header pointing into the removed
outer header. Reset the transport header to the inner L4 header, otherwise
later consumers (e.g. GSO segmentation) parse a bogus header.

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2dec15d402ca1..bb894c4f2b4a8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -502,6 +502,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
 	thoff -= ctx->offset;
+	skb_set_transport_header(skb, thoff);
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -1097,6 +1098,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow_offload_refresh(flow_table, flow, false);
 
 	nf_flow_encap_pop(ctx, skb, tuplehash);
+	skb_set_transport_header(skb, sizeof(*ip6h));
 
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
-- 
2.53.0



