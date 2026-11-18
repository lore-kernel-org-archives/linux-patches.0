Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027398;
	b=ZQDnFPD+KVom+rNg5nTDceOyw1PB6ZOAh2Xa7RDc2pJF/0eZjpn8QW1Bn+va3t2wlVNH
	 AQtVVa35uE++7qUvA1L9tV/frrVbC4tEDIfiTeciGJZ85NzZhU/TdalzqxKyDkEyB2xqy
	 1RdGa7he7ccR/uqs8v8SW1xOZWq+dRFTABqFabotH5Qe+y9qw624tsQLysipbPXEAw5Ej
	 RghYX9LdkeTUm05DemKZrNQfi8ivmJqLqyBwMgPpjLz0mA0gWQTmgBDp6ulN75ggAf1nc
	 hB9OfaDZxHMjxE+0Gsc73woSWYZ/5VH1a1gjGMGZIzZpfZMGg7d4LpWPGI4Dgd1SpPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=q4iGNznfXBJXWibyx+YEh0NQu2r/Hw0UGWFwbNEoeYI=;
	b=S321UhZ7Cdft/cgZYi792iWpLMrGARDj5o1q016gD0q4RujEUHbG3cxXYS7ClGDcwzvm
	 rSPYftoCgZigvk8Z3ljuh/ZQqb4o1dOdkNKQ8CyORDC5iQoFJCJws03PC06MWDgsb83Yc
	 +d3vfZeWq978vCmmFak1aoBEtJvKZxVTxF4xBpG9rheg0mHg7JRqydXLt7bjJ8Zjuny8G
	 Mf3y35ioTxTpIICugRPNn1pRHgWk3yyOcKQxdKFnlC3O9UrreNXA5JVHD/eYvwECcmMQR
	 Klm60lDeXNvgYRHbfdljBgKfaR+6bvNpc1GLu5MVv+gRu4+4EIliFqVWtM/NKrkwM0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e78Gwz4w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BB360A2608;
	Wed, 18 Nov 2026 18:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e78Gwz4w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10421F000C5;
	Wed, 18 Nov 2026 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027397;
	bh=q4iGNznfXBJXWibyx+YEh0NQu2r/Hw0UGWFwbNEoeYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e78Gwz4wZMEXd6LqwWLeFtMU8Bfe1tPGMZm8YadwYCbyKcLNOGGHGcMywfuipbp3i
	 23HNwpBMb4Yw8C7GVH45iFlhpYfpwnH2Zh47VNp2ScEktvIAVOd1CF971DGBEWeX5D
	 0is9nqgUe9euXwr57aR+WRvedXGpznwyIlv53sPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1773/2151] netfilter: nft_set_rbtree: narrow down range completion to anonymous sets
Date: Wed, 18 Nov 2026 15:58:28 +0100
Message-ID: <20261118150226.419067632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86d47d4c84a1b8470ba3fc16df13ea2a220b74ff ]

For anonymous sets, when adjacent ranges are found, the end element is
not added to the set to pack the set representation. Use next start
element to complete this interval.

Jérémy Jean says:

Consider two ranges in a netfilter verdict map:
* keys 10-19 accept packets, and
* keys 30-39 jump to chain 'victim'.
Now, delete the end marker at 20. The lookup array now uses element 30
as the first range's end, so an INTERVAL_END query for key 15 returns
element 30, including its jump verdict and chain pointer. This can make
KASAN reports a UAF after the GC releases reference chain for 30 that
has expired:

  BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
  Read of size 8 at addr ff110000009dfb58 by task repro/50
  ...
  Call Trace:
  ...
   nft_verdict_dump+0xdd/0x110
   nft_data_dump+0x4d/0x80
   nf_tables_fill_setelem+0x30b/0x8a0
   ? __asan_memcpy+0x3c/0x60
   nf_tables_fill_setelem_info+0x1b0/0x200
   nft_get_set_elem+0x3fd/0x4b0
  ...
  Freed by task 24:
  ...
   kfree+0x1a5/0x280
   nf_tables_trans_destroy_work+0x2cb/0x520

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/netfilter-devel/20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index a698420ab2b8c..1270b472e3334 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -1096,7 +1096,8 @@ static void nft_rbtree_commit(struct nft_set *set)
 		 * representation. Use next start element to complete this
 		 * interval.
 		 */
-		if (nft_rbtree_interval_start(rbe) &&
+		if (nft_set_is_anonymous(set) &&
+		    nft_rbtree_interval_start(rbe) &&
 		    nft_rbtree_interval_start(prev_rbe) &&
 		    priv->array_next->intervals[num_intervals].from)
 			priv->array_next->intervals[num_intervals++].to = &prev_rbe->ext;
-- 
2.53.0



