Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34038168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6F8C433D2;
	Mon,  8 May 2023 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540795;
	bh=ValpUyJUKPfsegPY6Oujiv451qbJAiZbIHoKjMhQVh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A22sTm1cMG+PIMfvRXNvyTsSW5UJtwp08dAaFsExDp67lpU+FOcL2e8A/0YYbYA53
	 vMk6kbKojjOVJ/OCbpXKyJQbejiDKoP5F+jbaRvLbbbFDXZJjxvO/7dUH6KAJ5G47U
	 MOx5hm5H3tIjTcCJ/twN4oH8Tk+I2vfmgVlL/WaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 501/611] clk: imx: fracn-gppll: fix the rate table
Date: Mon,  8 May 2023 11:45:43 +0200
Message-Id: <20230508094438.341666313@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit cf8dccfedce848f67eaa42e8839305d028319161 ]

The Fvco should be range 2.4GHz to 5GHz, the original table voilate the
spec, so update the table to fix it.

Fixes: c196175acdd3 ("clk: imx: clk-fracn-gppll: Add more freq config for video pll")
Fixes: 044034efbeea ("clk: imx: clk-fracn-gppll: fix mfd value")
Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230403095300.3386988-2-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index a2aaa14fc1aef..ec50c41e2a4c9 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -60,18 +60,20 @@ struct clk_fracn_gppll {
 };
 
 /*
- * Fvco = Fref * (MFI + MFN / MFD)
- * Fout = Fvco / (rdiv * odiv)
+ * Fvco = (Fref / rdiv) * (MFI + MFN / MFD)
+ * Fout = Fvco / odiv
+ * The (Fref / rdiv) should be in range 20MHz to 40MHz
+ * The Fvco should be in range 2.5Ghz to 5Ghz
  */
 static const struct imx_fracn_gppll_rate_table fracn_tbl[] = {
-	PLL_FRACN_GP(650000000U, 81, 0, 1, 0, 3),
+	PLL_FRACN_GP(650000000U, 162, 50, 100, 0, 6),
 	PLL_FRACN_GP(594000000U, 198, 0, 1, 0, 8),
-	PLL_FRACN_GP(560000000U, 70, 0, 1, 0, 3),
-	PLL_FRACN_GP(498000000U, 83, 0, 1, 0, 4),
+	PLL_FRACN_GP(560000000U, 140, 0, 1, 0, 6),
+	PLL_FRACN_GP(498000000U, 166, 0, 1, 0, 8),
 	PLL_FRACN_GP(484000000U, 121, 0, 1, 0, 6),
 	PLL_FRACN_GP(445333333U, 167, 0, 1, 0, 9),
-	PLL_FRACN_GP(400000000U, 50, 0, 1, 0, 3),
-	PLL_FRACN_GP(393216000U, 81, 92, 100, 0, 5)
+	PLL_FRACN_GP(400000000U, 200, 0, 1, 0, 12),
+	PLL_FRACN_GP(393216000U, 163, 84, 100, 0, 10)
 };
 
 struct imx_fracn_gppll_clk imx_fracn_gppll = {
-- 
2.39.2



