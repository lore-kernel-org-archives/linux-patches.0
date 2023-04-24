Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F617C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED8BC4339C;
	Mon, 24 Apr 2023 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342930;
	bh=Ac3f9BEUATaDx5Jr45R7YNxpn0q4DVf6NHFN5a9janI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFltCCjDFABXjXQCNxqTvE3rtJk2DWwRxcSflScQmOG7t3wVmrS6g4MLMcrgDx3k2
	 aYkWOvHCbDbeTe3otkUH/Q1qRRdUZkDZY48B2dF5+aJ8++vBF68bPiB+WTgFclnm/5
	 aOcYjSEGAdKd4fBX7cxcwD2FA9DZMonyE9hNTMOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Aotian <chenaotian2@163.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 013/110] netfilter: nf_tables: Modify nla_memdups flag to GFP_KERNEL_ACCOUNT
Date: Mon, 24 Apr 2023 15:16:35 +0200
Message-Id: <20230424131136.615017402@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Aotian <chenaotian2@163.com>

[ Upstream commit af0acf22aea359e04412237d68787401f96bb583 ]

For memory alloc that store user data from nla[NFTA_OBJ_USERDATA],
use GFP_KERNEL_ACCOUNT is more suitable.

Fixes: 33758c891479 ("memcg: enable accounting for nft objects")
Signed-off-by: Chen Aotian <chenaotian2@163.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6023c9f72cdca..dc4f692d3005a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7028,7 +7028,7 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (nla[NFTA_OBJ_USERDATA]) {
-		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL_ACCOUNT);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-- 
2.39.2



