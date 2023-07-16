Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E91A8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6ABC433C7;
	Sun, 16 Jul 2023 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540632;
	bh=d32Qe1cU+B+kLM+MRRRaKSd6S9nkufTBX3Tc8MhuGso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsUxksIXWzuHpS9uHrPk9+gFl/Qt3euXNpo+UhBdKyqQWTY1QNgPxEiBlFR91t/8S
	 779G58o8nFcmrSrJtZS5hb+pqu5J/BqW5zdV8crA0iEj7j2uSRt0gccNbbCPoiTDHX
	 la9DAf3s/H9HygSYP8KJRhFVT2o8M8B0UjOE/vtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/591] clk: qcom: dispcc-qcm2290: Fix BI_TCXO_AO handling
Date: Sun, 16 Jul 2023 21:49:04 +0200
Message-ID: <20230716194934.395662476@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 92dfee0fc889b5b00ffb6b1de87ce64c483bcb7b ]

BI_TCXO_AO (.fw_name = "bi_tcxo_ao") was previously made to reuse the
same parent enum entry as BI_TCXO (.fw_name = "bi_tcxo") in parent_map_2.

Resolve it by introducing its own entry in the parent enum and
correctly assigning it in disp_cc_parent_map_2[].

Fixes: cc517ea3333f ("clk: qcom: Add display clock controller driver for QCM2290")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230412-topic-qcm_dispcc-v2-1-bce7dd512fe4@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-qcm2290.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-qcm2290.c b/drivers/clk/qcom/dispcc-qcm2290.c
index 24755dc841f9d..4a4993470852b 100644
--- a/drivers/clk/qcom/dispcc-qcm2290.c
+++ b/drivers/clk/qcom/dispcc-qcm2290.c
@@ -23,6 +23,7 @@
 
 enum {
 	P_BI_TCXO,
+	P_BI_TCXO_AO,
 	P_DISP_CC_PLL0_OUT_MAIN,
 	P_DSI0_PHY_PLL_OUT_BYTECLK,
 	P_DSI0_PHY_PLL_OUT_DSICLK,
@@ -81,7 +82,7 @@ static const struct clk_parent_data disp_cc_parent_data_1[] = {
 };
 
 static const struct parent_map disp_cc_parent_map_2[] = {
-	{ P_BI_TCXO, 0 },
+	{ P_BI_TCXO_AO, 0 },
 	{ P_GPLL0_OUT_MAIN, 4 },
 };
 
@@ -150,7 +151,7 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 };
 
 static const struct freq_tbl ftbl_disp_cc_mdss_ahb_clk_src[] = {
-	F(19200000, P_BI_TCXO, 1, 0, 0),
+	F(19200000, P_BI_TCXO_AO, 1, 0, 0),
 	F(37500000, P_GPLL0_OUT_MAIN, 8, 0, 0),
 	F(75000000, P_GPLL0_OUT_MAIN, 4, 0, 0),
 	{ }
-- 
2.39.2



