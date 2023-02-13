Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E538F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A0C433D2;
	Mon, 13 Feb 2023 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300349;
	bh=751cXdT7RYiSgxFuMzzIzt5rumiPwWSjQHusLaByN5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=or5Gow3rOUXz7b/LppwumT5q/Cdql6D4gTrtV68+ooz0Ub6RTj9NAKdQGk1o53LnY
	 9WxEVgtlx8PXcHRXy5ndIJiXutFO1HFJG0w6lDou0i8mkcMWJvG9lwXMXYLBjxxT94
	 z90XW3ixbIJhcUzjpfWSI1fy5KNIGltlftLvN6iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@aj.id.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/67] pinctrl: aspeed: Fix confusing types in return value
Date: Mon, 13 Feb 2023 15:49:26 +0100
Message-Id: <20230213144734.496637148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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
index 83d47ff1cea8f..5a12fc7cf91fb 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -122,7 +122,7 @@ static int aspeed_disable_sig(struct aspeed_pinmux_data *ctx,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(ctx, *exprs);
-- 
2.39.0



