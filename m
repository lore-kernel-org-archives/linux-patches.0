Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D601863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF7BC433D2;
	Wed, 28 Dec 2022 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242003;
	bh=dR0kvV1DWnVlHn9QTvH8FrHpNa7FUWA908vv8B0UQS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kklMEl4J8DTHQJqmJ1/VwoPleYgbkJ+o+xsM/5XKeVKuxFR+Jx7+95djeWy9ud7u1
	 6j2DI8smeLJ+LVbQjfoOTENqI+H1HN6BXdln4kYzmXFSayOyyJYWmvJuOar07QGpvd
	 lodF+tpnDJGussxpg7Ee5c2FxMLVc24VOwwNRNEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0353/1073] clk: imx93: correct the flexspi1 clock setting
Date: Wed, 28 Dec 2022 15:32:21 +0100
Message-Id: <20221228144337.593311722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 62dfdbcc16e767b91ed35d4fc0428c86d4688505 ]

Correct IMX93_CLK_FLEXSPI1_GATE CCGR setting. Otherwise the flexspi
always can't be assigned to a parent clock when dump the clock tree.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1666589199-1199-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index dcc41d178238..4d2524addc3e 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -162,7 +162,7 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_MU_B_GATE,		"mu_b",		"bus_aon_root",		0x8500, },
 	{ IMX93_CLK_EDMA1_GATE,		"edma1",	"m33_root",		0x8540, },
 	{ IMX93_CLK_EDMA2_GATE,		"edma2",	"wakeup_axi_root",	0x8580, },
-	{ IMX93_CLK_FLEXSPI1_GATE,	"flexspi",	"flexspi_root",		0x8640, },
+	{ IMX93_CLK_FLEXSPI1_GATE,	"flexspi1",	"flexspi1_root",	0x8640, },
 	{ IMX93_CLK_GPIO1_GATE,		"gpio1",	"m33_root",		0x8880, },
 	{ IMX93_CLK_GPIO2_GATE,		"gpio2",	"bus_wakeup_root",	0x88c0, },
 	{ IMX93_CLK_GPIO3_GATE,		"gpio3",	"bus_wakeup_root",	0x8900, },
-- 
2.35.1



