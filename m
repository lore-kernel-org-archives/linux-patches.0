Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B299611C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D05C433C7;
	Mon, 28 Aug 2023 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218443;
	bh=4gEbeYjtQqYd/I6svyD66CtG8q1QCmMK/foexXFV1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddu72Kz38PKGLutYyVP99ULPZ9UX1m9l2q06Y0/NRCeBynfDJAPVbQjn6cIdhgXu2
	 xxYeDvPYHQaqQp2fQU35SaScjSKIePD5cye4OqDyTz/rF7kH+tBkk9rSiYgUGQbZsQ
	 vpgWxUgyc3tgTXF0IoGzzwlU/G0C1rPxwM9ZF54I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/129] netfilter: nft_dynset: disallow object maps
Date: Mon, 28 Aug 2023 12:12:34 +0200
Message-ID: <20230828101155.507506762@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 23185c6aed1ffb8fc44087880ba2767aba493779 ]

Do not allow to insert elements from datapath to objects maps.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_dynset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 651c9784904cb..a4c6aba7da7ee 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -144,6 +144,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
+	if (set->flags & NFT_SET_OBJECT)
+		return -EOPNOTSUPP;
+
 	if (set->ops->update == NULL)
 		return -EOPNOTSUPP;
 
-- 
2.40.1



