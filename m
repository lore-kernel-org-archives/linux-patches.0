Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5B7846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FBCC4339B;
	Fri, 10 Mar 2023 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458928;
	bh=AmMm7gYbhCBrtn8HCPjInzL3JXe2XDlZxOtXweY6IHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvRLpvkya6y4nIzcAbNoPgKRj7QiRFhUi+njuvlcNFz/G5Tp2Gu9AwsvYB0Bh0+2b
	 0upY1+gNEbnra4BTSCwJnSZkQnjAX5a/n5yPcHfo4X2NkZuwbFmM+UMfABlABvGDNH
	 wSPnqPu4tWJx9PMdKS7e8httbpcxh1iofp2DmDjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/357] clk: qcom: gcc-qcs404: fix names of the DSI clocks used as parents
Date: Fri, 10 Mar 2023 14:37:18 +0100
Message-Id: <20230310133741.283953030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 47d94d30cd3dcc743241b4208b1eec7247610c84 ]

The QCS404 uses 28nm LPM DSI PHY, which registers dsi0pll and
dsi0pllbyte clocks. Fix all DSI PHY clock names used as parents inside
the GCC driver.

Fixes: 652f1813c113 ("clk: qcom: gcc: Add global clock controller driver for QCS404")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221226042154.2666748-7-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs404.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcs404.c b/drivers/clk/qcom/gcc-qcs404.c
index 265e774d63476..5982253b03307 100644
--- a/drivers/clk/qcom/gcc-qcs404.c
+++ b/drivers/clk/qcom/gcc-qcs404.c
@@ -112,7 +112,7 @@ static const struct parent_map gcc_parent_map_5[] = {
 
 static const char * const gcc_parent_names_5[] = {
 	"cxo",
-	"dsi0pll_byteclk_src",
+	"dsi0pllbyte",
 	"core_bi_pll_test_se",
 };
 
@@ -124,7 +124,7 @@ static const struct parent_map gcc_parent_map_6[] = {
 
 static const char * const gcc_parent_names_6[] = {
 	"cxo",
-	"dsi0_phy_pll_out_byteclk",
+	"dsi0pllbyte",
 	"core_bi_pll_test_se",
 };
 
@@ -167,7 +167,7 @@ static const struct parent_map gcc_parent_map_9[] = {
 static const char * const gcc_parent_names_9[] = {
 	"cxo",
 	"gpll0_out_main",
-	"dsi0_phy_pll_out_dsiclk",
+	"dsi0pll",
 	"gpll6_out_aux",
 	"core_bi_pll_test_se",
 };
@@ -204,7 +204,7 @@ static const struct parent_map gcc_parent_map_12[] = {
 
 static const char * const gcc_parent_names_12[] = {
 	"cxo",
-	"dsi0pll_pclk_src",
+	"dsi0pll",
 	"core_bi_pll_test_se",
 };
 
-- 
2.39.2



