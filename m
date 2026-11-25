Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618695;
	b=hvgGUMqqifjcmP6/mNlbJO/3qIWBfgd0OL9QufFIXFm4AIOkwq1wYsZqk1K4wNmAwSDW
	 mOshFuJw3l4lAzEecgYP3S1e90aJfXFgEKrGarzmGR32mRo5BjFsfG/NFQrE5UZvQgFhx
	 gQ8BadXyj/BbWaPuhlHOmE0se/m1WNPO627WpDVg2Lz6+SviGVWek31KBiteeTmCmCFEy
	 qFQBi6vMRQLsSkaZvEe68TQTBjXM+1kTIC/KW1GQxVbmjAjTlED8wGv2Xvr/nrjOvC0ZZ
	 oJU10JyRoPKI+1jCCJ14mRQ9ItIBH7D0veRsTC9EzJPks2oZjfSu7f5YuhoWLKBv8Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KL1DILIDXnWFNMBo3Fb3LW48d3DGggE6HesjfvARZwI=;
	b=JeafGrTlk7ZMgsIaDKMJX8EtKOi8s9dimchog5zsjnPQHHVP0tt3mbnaLRZl3RIWZDUw
	 P/e/JijAiDYiEeRzcKhPdYxZT/ToBzkSfjFa2jPw4QZSg3hyJ2hSw3mKT/QungPngaWa8
	 PmXQWtXPCkzXNMI+QviBKylLjJ5OBqMo8Vm+op5OSNd4mjdNvnbQIf45oN19oDclwIdyu
	 w9gyOjqmIkrpwah255NHL+tOFUOwGJS5cdImpPCdFsCF0Klpgf4rm+15EjlPCurpwFW94
	 SFhiogZ9S0M2OCp2m20iHsO+pNDnnXvuuPYBClK400z4WKVqLvLW+dbBtxBELLcVBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTSpFXHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153DA606A326;
	Wed, 25 Nov 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTSpFXHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72EE1F000D3;
	Wed, 25 Nov 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618694;
	bh=KL1DILIDXnWFNMBo3Fb3LW48d3DGggE6HesjfvARZwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTSpFXHhUKW6lYNWhBLwBUzLFko4WZqAOk2S4y41wVfoyrobeWeN0+L7tbVFHrUN4
	 vCCs3W2Tb5WQsSAgjHb9DNHIc/uOkWz6iZZLbku0f41HPS05HJxOFi2fuGlRKLHGNx
	 Yy0+G0fqWhuisA3Ak8YVcmUzcZ6YFaKrNOivtdws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0314/1005] netfilter: nft_set_rbtree: check catchall_sync return before queue_done
Date: Wed, 25 Nov 2026 15:27:32 +0100
Message-ID: <20261125143829.094582423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit 1cec19d70bc282a8e7f7c42697d44046f60dc506 ]

nft_rbtree_gc_queue() passes the result of nft_trans_gc_catchall_sync()
straight to nft_trans_gc_queue_sync_done(). When the catchall path flushes
a full GC batch and nft_trans_gc_alloc() fails, catchall_sync returns
NULL and queue_sync_done dereferences trans->net (NULL+0x10). Guard the
call like the pipapo GC path already does.

Fixes: 7d259f021aaa ("netfilter: nft_set_rbtree: prefer sync gc to async worker")
Assisted-by: opencode:deepseek-v4
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fbe1750f1ca23..9d685899da701 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -953,7 +953,8 @@ static void nft_rbtree_gc_queue(struct nft_set *set)
 	}
 
 	gc = nft_trans_gc_catchall_sync(gc);
-	nft_trans_gc_queue_sync_done(gc);
+	if (gc)
+		nft_trans_gc_queue_sync_done(gc);
 }
 
 static u64 nft_rbtree_privsize(const struct nlattr * const nla[],
-- 
2.53.0



