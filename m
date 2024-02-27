Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B847145FE0;
	Tue, 27 Feb 2024 14:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042749; cv=none; b=BKM2drBug0HrjaiLyKM3GP7L5Usr+UFmhtpU+89LKlaNG9a4f6lS1jrKqMz9r32YoqNv2OXP0h9xQMN6bYEV9xlDW25xpNVLa1wGtj9uj+a50P62kUIzSYEOlitIQg4XI6A7S/WpL3UhWyZCW+JduIJw/NXpAf6xVlMPAQXgYco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042749; c=relaxed/simple;
	bh=RkSJGh/gXr+JiXFg+Pse2eGZebww+XIja44QPT0u2Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqego2tX+rCfIlT6pebIyp7mkT1gbX+gBQCJnEiuKCRARlzu7G1kDfpRBDAGe9XTyCOzRz13HJ8b1VoR4A757x+a03tyuBG3Z0YHJ7f3lQVnzHNtk7bWN2mK85zwQYKhFWW/Mlds9wbPH5bJfXcBTukhVOa03bkcWN30gsZny1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LubbpK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LubbpK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42309C433C7;
	Tue, 27 Feb 2024 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042748;
	bh=RkSJGh/gXr+JiXFg+Pse2eGZebww+XIja44QPT0u2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LubbpK29eZtv62LBnHgifs6pQKJLSVy+Tq2GE4WP2UEYv0d58sacsIueH68sAcFV
	 ZfB8TgVjZGzTLQqtF3eBSH3iRBvHYfhzlmL1U0RczDqkInDMoi1yecCWc3Nw6rS/N4
	 IYncQJtIOYXDhle9hyhnnCOmD/duazozxdGtmjRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/245] clk: qcom: gcc-qcs404: fix names of the DSI clocks used as parents
Date: Tue, 27 Feb 2024 14:24:55 +0100
Message-ID: <20240227131618.697512855@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4299fe8f19274..a7a9884799cd3 100644
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
2.43.0



