Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BF763B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3920C433D2;
	Mon, 20 Feb 2023 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900309;
	bh=veSpYG3kkUNyznCVuCjjA7IcnuCK7WX7UhQoZ1FxYWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE2C7z7AtuOFANyiB3cEsLv8G+KhZEHTpz1MiNDt5SS4uZ/hjHkrhSWyWjhT1JdcQ
	 FBdXVnPaHVGDpbjs9ePL9fYNJQcnJobqu8mLLDIbJvrJ9YmGtz15l3BzttOKBStB17
	 Flh55LmFUfdTp3nYFPZdSU590Fojr2oqToP+4vLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@aj.id.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/53] pinctrl: aspeed: Fix confusing types in return value
Date: Mon, 20 Feb 2023 14:35:55 +0100
Message-Id: <20230220133549.215689286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 287a344a11f1ebd31055cf9b22c88d7005f108d7 ]

The function signature is int, but we return a bool. Instead return a
negative errno as the kerneldoc suggests.

Fixes: 4d3d0e4272d8 ("pinctrl: Add core support for Aspeed SoCs")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20230119231856.52014-1-joel@jms.id.au
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 5249033ed413e..b7155377a86d6 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -295,7 +295,7 @@ static int aspeed_disable_sig(const struct aspeed_sig_expr **exprs,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(*exprs, maps);
-- 
2.39.0



