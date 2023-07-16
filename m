Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750C8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26194C433C8;
	Sun, 16 Jul 2023 20:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538800;
	bh=hMVz/u0DUiBtT3oW4HAV5m38Z1xFxNT68qkd8kJwots=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCnmT2VtUCKHHhMjJ0JX4XeIoPJ1yGoQNTFNvKoZ1dgjoFtBhQy6HzI6EFWqXaMnt
	 WmxksJvugjfoSb6eS81Dz+K/pkUet2FaTkYJoU2/JESWhx7+lrCdAXnmd7vzQnC9H0
	 YYDPFI0MyXRXPWV6wikDofTr5j8CGpPS7FXTZz9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 580/800] clk: qcom: dispcc-qcm2290: Fix GPLL0_OUT_DIV handling
Date: Sun, 16 Jul 2023 21:47:13 +0200
Message-ID: <20230716195002.556865328@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 63d56adf04b5795e54440dc5b7afddecb2966863 ]

GPLL0_OUT_DIV (.fw_name = "gcc_disp_gpll0_div_clk_src") was previously
made to reuse the same parent enum entry as GPLL0_OUT_MAIN
(.fw_name = "gcc_disp_gpll0_clk_src") in parent_map_2.

Resolve it by introducing its own entry in the parent enum and
correctly assigning it in disp_cc_parent_map_2[].

Fixes: cc517ea3333f ("clk: qcom: Add display clock controller driver for QCM2290")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230412-topic-qcm_dispcc-v2-2-bce7dd512fe4@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index ee62aca4e5bb2..44dd5cfcc1504 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -28,6 +28,7 @@ enum {
 	P_DISP_CC_PLL0_OUT_MAIN,
 	P_DSI0_PHY_PLL_OUT_BYTECLK,
 	P_DSI0_PHY_PLL_OUT_DSICLK,
+	P_GPLL0_OUT_DIV,
 	P_GPLL0_OUT_MAIN,
 	P_SLEEP_CLK,
 };
@@ -84,7 +85,7 @@ static const struct clk_parent_data disp_cc_parent_data_1[] = {
 
 static const struct parent_map disp_cc_parent_map_2[] = {
 	{ P_BI_TCXO_AO, 0 },
-	{ P_GPLL0_OUT_MAIN, 4 },
+	{ P_GPLL0_OUT_DIV, 4 },
 };
 
 static const struct clk_parent_data disp_cc_parent_data_2[] = {
@@ -153,8 +154,8 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 
 static const struct freq_tbl ftbl_disp_cc_mdss_ahb_clk_src[] = {
 	F(19200000, P_BI_TCXO_AO, 1, 0, 0),
-	F(37500000, P_GPLL0_OUT_MAIN, 8, 0, 0),
-	F(75000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
+	F(37500000, P_GPLL0_OUT_DIV, 8, 0, 0),
+	F(75000000, P_GPLL0_OUT_DIV, 4, 0, 0),
 	{ }
 };
 
-- 
2.39.2



