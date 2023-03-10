Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BF88481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792C6C433D2;
	Fri, 10 Mar 2023 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457177;
	bh=/pOJYxD46R/dxAJ9FZa7wUCpI6f2861qRI/sz6R6K4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9XkKJD4nJvZfSFBldf/NXYMOzf8JKCULKWW34xf2tF8CrRqhCPh882V0CyXvwBoy
	 WVKMly3yp9qwJPYoB7dYEaCXrUlaMXsCKfTz9fP8NUtSUXGtLpI1jEMhDbALu5wZj9
	 nPAX9Tyjyu8K7wvM6U6k4au/rIuI3tz+TWhCIisk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/200] netfilter: nf_tables: allow to fetch set elements when table has an owner
Date: Fri, 10 Mar 2023 14:37:34 +0100
Message-Id: <20230310133718.543031844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit 92f3e96d642f5e05b9dc710c06fedc669f1b4f00 ]

NFT_MSG_GETSETELEM returns -EPERM when fetching set elements that belong
to table that has an owner. This results in empty set/map listing from
userspace.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dca5352bdf3d7..1a9d759d0a026 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5439,7 +5439,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask, NETLINK_CB(skb).portid);
+				 genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
 		return PTR_ERR(table);
-- 
2.39.2



