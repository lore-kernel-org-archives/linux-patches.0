Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9933F1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19176C433EF;
	Mon, 20 Mar 2023 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325166;
	bh=ZemQgRVVysq2nAzoPbiwRns+Dlk/fzU8maTMni9HQqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Edw/snxfByjAU+tgql7ei/xUJI6U2JGsE1UTYc7pBCYfmQReDh6YwnD0h9YvSV0Jm
	 6IhOwFyONwFWelQluKwqYWp5kw4lEBvjJS2jTkIbmwAgCJxTNJ+1cCISm5Hmlus7N0
	 36koUV9LK3ng+4GqSSJeDIUh/Oq0Dn6pc0PMCnAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/198] netfilter: nft_redir: correct value of inet type `.maxattrs`
Date: Mon, 20 Mar 2023 15:52:46 +0100
Message-Id: <20230320145508.675409857@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 493924519b1fe3faab13ee621a43b0d0939abab1 ]

`nft_redir_inet_type.maxattrs` was being set, presumably because of a
cut-and-paste error, to `NFTA_MASQ_MAX`, instead of `NFTA_REDIR_MAX`.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 7ae330d75ac7b..5ed64b2bd15e8 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -235,7 +235,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.39.2



