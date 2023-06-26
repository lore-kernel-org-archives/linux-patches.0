Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1E714A80
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C2FC433C8;
	Mon, 26 Jun 2023 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804321;
	bh=ZQsHNlfvGWXK8XmJ9koA0qK7hcn9k08Lw3IBr3lEckg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu4601RfMprZPlTqtBLPiLxLojBoHPsz3xSLxjX0xqw1sIqT5L1hs5PpiUzgLNCWK
	 UNpbUpDNCqZof7/MSrpLK/H2i2uTxDk/tRqT85Ux4xFr2P7A8dVaFiUAz9uYo1nKKg
	 aqMlyX//1iJDxaj7pLvNyiLJ/mLHw1Bun8DaOKRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/170] netfilter: nf_tables: disallow updates of anonymous sets
Date: Mon, 26 Jun 2023 20:11:26 +0200
Message-ID: <20230626180805.809508065@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b770283c98e0eee9133c47bc03b6cc625dc94723 ]

Disallow updates of set timeout and garbage collection parameters for
anonymous sets.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 984720964a498..7f71bdbc82672 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4774,6 +4774,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (nft_set_is_anonymous(set))
+			return -EOPNOTSUPP;
+
 		err = nft_set_expr_alloc(&ctx, set, nla, exprs, &num_exprs, flags);
 		if (err < 0)
 			return err;
-- 
2.39.2



