Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1792E640
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0B7C433C7;
	Wed, 20 Sep 2023 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213690;
	bh=2D3HpySPV3f5ePvFTYzszdjbec5iWkk4vogILZ5qNNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vadD/b5uho1LKWoeg9JQygukutOAqDgFHl4e2d3J+V4c0JjRZX8sTPju7xA3e4an7
	 uJ9Sso19QefVjAqLDxWic+Jv8k7YEDrxPVeJW0OVGqQhfvgbd6SkPwk1stqRgKI5ab
	 hZgACOwWp7zs+GPQerJW+ZXM13ElpEG5mlby3vV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	YueHaibing <yuehaibing@huawei.com>,
	Anson Huang <Anson.Huang@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/367] clk: imx: clk-pll14xx: Make two variables static
Date: Wed, 20 Sep 2023 13:31:11 +0200
Message-ID: <20230920112906.160888443@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 8f2d3c1759d19232edf1e9ef43d40a44e31493d6 ]

Fix sparse warnings:

drivers/clk/imx/clk-pll14xx.c:44:37:
 warning: symbol 'imx_pll1416x_tbl' was not declared. Should it be static?
drivers/clk/imx/clk-pll14xx.c:57:37:
 warning: symbol 'imx_pll1443x_tbl' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 72d00e560d10 ("clk: imx: pll14xx: dynamically configure PLL for 393216000/361267200Hz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index c43e9653b4156..129a28c3366eb 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -41,7 +41,7 @@ struct clk_pll14xx {
 
 #define to_clk_pll14xx(_hw) container_of(_hw, struct clk_pll14xx, hw)
 
-const struct imx_pll14xx_rate_table imx_pll1416x_tbl[] = {
+static const struct imx_pll14xx_rate_table imx_pll1416x_tbl[] = {
 	PLL_1416X_RATE(1800000000U, 225, 3, 0),
 	PLL_1416X_RATE(1600000000U, 200, 3, 0),
 	PLL_1416X_RATE(1200000000U, 300, 3, 1),
@@ -52,7 +52,7 @@ const struct imx_pll14xx_rate_table imx_pll1416x_tbl[] = {
 	PLL_1416X_RATE(600000000U,  300, 3, 2),
 };
 
-const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
+static const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
 	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
 	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
 	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
-- 
2.40.1



