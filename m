Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144DE13B2B8;
	Tue, 27 Feb 2024 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043616; cv=none; b=paEZ4ButUFyJa2pJSiZ1zQ0TTCgJrnH2v3opQ41DEvX1sHGkeB4kUpDXpGYCa0IZkVRIMj87SKJmzUcoW58pTjxFYIkVRku2iD9gr0sqCQPaVcR8XjbrAFcsxcy8ed3X4y7PHIi6qHY1C5Z/b83526kCku/Sx4PacZGjJmWkzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043616; c=relaxed/simple;
	bh=DqTYB7Jcbsx4T9syOm0i7m2WNKz0PBYLdu/jlABSCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgwaEAPi5tTwhenhLLz0fKa6gskUXPB3azmhX4L8XfvsV7ye8U0w8MB0WFWJHwLK2LNshvDpjpuworQby4CZIz47r4ZCpsO7I2bc0gB2xsB5WFR1WUVDvQOZCAHl7ivPpDlrsugpCJjaUx1xdFCALf+EACBEQJx0rdOzGscduYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCqMrhTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCqMrhTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91316C433F1;
	Tue, 27 Feb 2024 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043615;
	bh=DqTYB7Jcbsx4T9syOm0i7m2WNKz0PBYLdu/jlABSCKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCqMrhTq5zmCJfRSu9tmtdUVjRuwjc545D+YfkNT7VGFpvCV0+NdB4/T9kE5f7D3w
	 aeaOobO+Id4CM5lfiOMv0cktZ9Zyy21nXDkNNoBJ9/peww62k91d+zG9TbSXkcVCcw
	 ZSLWI+7PO2rfmjMYd8Nr57Uf1mcZ02ABkWxyxDTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/195] netfilter: nf_tables: rename function to destroy hook list
Date: Tue, 27 Feb 2024 14:27:14 +0100
Message-ID: <20240227131616.118462766@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit cdc32546632354305afdcf399a5431138a31c9e0 ]

Rename nft_flowtable_hooks_destroy() by nft_hooks_destroy() to prepare
for netdev chain device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d472e9853d7b ("netfilter: nf_tables: register hooks last when adding new chain/flowtable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f1a74b0949999..c7b543d1a0516 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7938,7 +7938,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 	return err;
 }
 
-static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
+static void nft_hooks_destroy(struct list_head *hook_list)
 {
 	struct nft_hook *hook, *next;
 
@@ -8123,7 +8123,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
-		nft_flowtable_hooks_destroy(&flowtable->hook_list);
+		nft_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
 
@@ -8893,7 +8893,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
@@ -9850,7 +9850,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
-			nft_flowtable_hooks_destroy(&nft_trans_flowtable_hooks(trans));
+			nft_hooks_destroy(&nft_trans_flowtable_hooks(trans));
 		else
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
-- 
2.43.0



