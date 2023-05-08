Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54138168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFECC433D2;
	Mon,  8 May 2023 10:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540821;
	bh=xghh3jpNNkWugck2oAidqLtKhwyzrLdC9xihcEx88bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7lrn+vMQk0XbXiOfCmdwxc//oNKlA4fUUHVL5eZtCKnTcZUue7mgA+UWtd6CtCoX
	 Ue6wvYp7vPouBcceizYjSiNFEq1jt0UIvrtYB2LjWR9A+7SJPtjdBA00hqBtGyyVe3
	 3JNVsMGtJrz+2+HmYewQekjRLaPULLJxsY+k1EY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 510/611] clk: qcom: dispcc-qcm2290: Remove inexistent DSI1PHY clk
Date: Mon,  8 May 2023 11:45:52 +0200
Message-Id: <20230508094438.626400551@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 68d1151f03067533827fc50b770954ef33149533 ]

There's only one DSI PHY on this SoC. Remove the ghost entry for the
clock produced by a secondary one.

Fixes: cc517ea3333f ("clk: qcom: Add display clock controller driver for QCM2290")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230412-topic-qcm_dispcc-v1-2-bf2989a75ae4@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index 2ebd9a02b8950..24755dc841f9d 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -26,7 +26,6 @@ enum {
 	P_DISP_CC_PLL0_OUT_MAIN,
 	P_DSI0_PHY_PLL_OUT_BYTECLK,
 	P_DSI0_PHY_PLL_OUT_DSICLK,
-	P_DSI1_PHY_PLL_OUT_DSICLK,
 	P_GPLL0_OUT_MAIN,
 	P_SLEEP_CLK,
 };
@@ -106,13 +105,11 @@ static const struct clk_parent_data disp_cc_parent_data_3[] = {
 static const struct parent_map disp_cc_parent_map_4[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_DSICLK, 1 },
-	{ P_DSI1_PHY_PLL_OUT_DSICLK, 2 },
 };
 
 static const struct clk_parent_data disp_cc_parent_data_4[] = {
 	{ .fw_name = "bi_tcxo" },
 	{ .fw_name = "dsi0_phy_pll_out_dsiclk" },
-	{ .fw_name = "dsi1_phy_pll_out_dsiclk" },
 };
 
 static const struct parent_map disp_cc_parent_map_5[] = {
-- 
2.39.2



