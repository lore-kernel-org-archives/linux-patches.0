Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7483F31A6E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01FEC433C7;
	Wed, 20 Sep 2023 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214101;
	bh=RmdFdLdU9tDQPZrrZWG3svroW5xD1LDOtMDJfNGNVEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbSz/Ca6QjTuOChYRf5jaHk7cpeMrGS11bDBgGMHn04P9Av/YMgBPlfBhUrnJip8g
	 QlQbrn/8rGdTe9qh/31DPEHvKR3/q1BbR7LnWmwKyyK3WsnRrXRKcnnUMiA0YG27l7
	 JJwiPPAjJK5U3xw4PSnTXf3eGirkIZj9VG8TuMWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/110] netfilter: nf_tables: fix kdoc warnings after gc rework
Date: Wed, 20 Sep 2023 13:32:25 +0200
Message-ID: <20230920112833.668726489@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08713cb006b6f07434f276c5ee214fb20c7fd965 ]

Jakub Kicinski says:
  We've got some new kdoc warnings here:
  net/netfilter/nft_set_pipapo.c:1557: warning: Function parameter or member '_set' not described in 'pipapo_gc'
  net/netfilter/nft_set_pipapo.c:1557: warning: Excess function parameter 'set' description in 'pipapo_gc'
  include/net/netfilter/nf_tables.h:577: warning: Function parameter or member 'dead' not described in 'nft_set'

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20230810104638.746e46f1@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nft_set_pipapo.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cd3b5b9db8890..86ffb222f4d74 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -499,6 +499,7 @@ struct nft_set_elem_expr {
  *	@expr: stateful expression
  * 	@ops: set ops
  * 	@flags: set flags
+ *	@dead: set will be freed, never cleared
  *	@genmask: generation mask
  * 	@klen: key length
  * 	@dlen: data length
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 0a49c59a22dbd..03472c1d9d548 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1549,7 +1549,7 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 
 /**
  * pipapo_gc() - Drop expired entries from set, destroy start and end elements
- * @set:	nftables API set representation
+ * @_set:	nftables API set representation
  * @m:		Matching data
  */
 static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
-- 
2.40.1



