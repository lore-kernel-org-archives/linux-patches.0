Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9532168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F87DC433EF;
	Mon,  8 May 2023 10:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540818;
	bh=OxINo+q/tSjvY3Nxtj2ly40l4J7dXpR1eGk+vhx47Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBGUEEAB5WdlkdFXNEc+lxPKAcw4kicOok6v88kuvWHVWxoG0bO3DWlJvn8rtHx0u
	 xFP+C6lFbQomvRygAGCmTUOiUlbs8AwqTzXYd8WIkGg4rxE8hdpYbVRs22tUHUMNqM
	 YOY55g6ULV6ZgxpN4/4gwZjStnuMHDZTY4Rjov7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/611] clk: qcom: dispcc-qcm2290: get rid of test clock
Date: Mon,  8 May 2023 11:45:51 +0200
Message-Id: <20230508094438.596979657@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 62db82f9c8004f1226f5cec8a5441fb89eb984fa ]

The test clock apparently it's not used by anyone upstream. Remove it.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221228185237.3111988-9-dmitry.baryshkov@linaro.org
Stable-dep-of: 68d1151f0306 ("clk: qcom: dispcc-qcm2290: Remove inexistent DSI1PHY clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index 96b149365912a..2ebd9a02b8950 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -71,7 +71,6 @@ static const struct parent_map disp_cc_parent_map_0[] = {
 static const struct clk_parent_data disp_cc_parent_data_0[] = {
 	{ .fw_name = "bi_tcxo" },
 	{ .fw_name = "dsi0_phy_pll_out_byteclk" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_1[] = {
@@ -80,7 +79,6 @@ static const struct parent_map disp_cc_parent_map_1[] = {
 
 static const struct clk_parent_data disp_cc_parent_data_1[] = {
 	{ .fw_name = "bi_tcxo" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_2[] = {
@@ -91,7 +89,6 @@ static const struct parent_map disp_cc_parent_map_2[] = {
 static const struct clk_parent_data disp_cc_parent_data_2[] = {
 	{ .fw_name = "bi_tcxo_ao" },
 	{ .fw_name = "gcc_disp_gpll0_div_clk_src" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_3[] = {
@@ -104,7 +101,6 @@ static const struct clk_parent_data disp_cc_parent_data_3[] = {
 	{ .fw_name = "bi_tcxo" },
 	{ .hw = &disp_cc_pll0.clkr.hw },
 	{ .fw_name = "gcc_disp_gpll0_clk_src" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_4[] = {
@@ -117,7 +113,6 @@ static const struct clk_parent_data disp_cc_parent_data_4[] = {
 	{ .fw_name = "bi_tcxo" },
 	{ .fw_name = "dsi0_phy_pll_out_dsiclk" },
 	{ .fw_name = "dsi1_phy_pll_out_dsiclk" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_5[] = {
@@ -126,7 +121,6 @@ static const struct parent_map disp_cc_parent_map_5[] = {
 
 static const struct clk_parent_data disp_cc_parent_data_5[] = {
 	{ .fw_name = "sleep_clk" },
-	{ .fw_name = "core_bi_pll_test_se" },
 };
 
 static struct clk_rcg2 disp_cc_mdss_byte0_clk_src = {
-- 
2.39.2



