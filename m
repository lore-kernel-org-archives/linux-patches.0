Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3887134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D04EC4339B;
	Mon, 12 Jun 2023 10:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566816;
	bh=U0Fjhdii9OMNHLJzzBnfo9/TjS1tMaJ5trJZgLwSLoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpOTkCQlV2YRtgpeZ7y1DVYBe30Ku8lzh/IuTgVGBfp969Ub+UWr52BQx47LePYyu
	 LZxDcsj8+HcmEX7pixJzqNxzogh/NGvtL5PNK1Nic+7qr9SwzolDgApovlVhQdDA69
	 4Vw4KfOOF27xlWrSQPgmH4Pa7x9JZFGSq5Eho6RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 042/160] netfilter: nft_bitwise: fix register tracking
Date: Mon, 12 Jun 2023 12:26:14 +0200
Message-ID: <20230612101716.965947218@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
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

[ Upstream commit 14e8b293903785590a0ef168745ac84250cb1f4c ]

At the end of `nft_bitwise_reduce`, there is a loop which is intended to
update the bitwise expression associated with each tracked destination
register.  However, currently, it just updates the first register
repeatedly.  Fix it.

Fixes: 34cc9e52884a ("netfilter: nf_tables: cancel tracking for clobbered destination registers")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67a..2527a01486efc 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -323,7 +323,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	dreg = priv->dreg;
 	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
 	for (i = 0; i < regcount; i++, dreg++)
-		track->regs[priv->dreg].bitwise = expr;
+		track->regs[dreg].bitwise = expr;
 
 	return false;
 }
-- 
2.39.2



