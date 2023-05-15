Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3E6FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84858C4339B;
	Mon, 15 May 2023 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169541;
	bh=npBbLmcMEaQs7e8YBzC1M2nq9z9ZzqYTbmd8ky/cOxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEk0W7ilr+s5yy6Eg8pnb6Kqi4tM4TMQv+ZbXE7YHguVwCzr4t8lCs7zfykae+7U9
	 wPQ7CF7FBI4MPwkFuCjisnKEuJpzMstqkmkCBqM1pYggZxOcDWAFnJig5JEY3ss8GC
	 jZYQBBTaX5j1mFz/ntKI4+qujw5BEruxcsUdt6oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 061/246] netfilter: nf_tables: rename function to destroy hook list
Date: Mon, 15 May 2023 18:24:33 +0200
Message-Id: <20230515161724.414323036@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

[ Upstream commit cdc32546632354305afdcf399a5431138a31c9e0 ]

Rename nft_flowtable_hooks_destroy() by nft_hooks_destroy() to prepare
for netdev chain device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 8509f62b0b07 ("netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6e027fc9b443f..d41f35e88642b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7767,7 +7767,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
-static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
+static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
@@ -7948,7 +7948,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
-		nft_flowtable_hooks_destroy(&flowtable->hook_list);
+		nft_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
 
@@ -8776,7 +8776,7 @@ static void nft_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELFLOWTABLE:
 	case NFT_MSG_DESTROYFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -9429,7 +9429,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
-- 
2.39.2



