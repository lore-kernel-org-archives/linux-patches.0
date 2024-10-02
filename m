Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68E3232;
	Wed,  2 Oct 2024 14:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879974; cv=none; b=sxQZz9AMViymUHvbTesZbFXhh2xH9L4DPCnFe5Y3Ph/spMCn8DB1+onfGf245gs7jCqENMnVBjxIHowDnhS6Qsz4CW2B7JAB/LdxIDNwPy7uVR2lRveUUDBVt3+Jg5pCHbkx2HHn6Ifsuu2xOhHlY2Y9CmhremqZPuYwS3V4GNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879974; c=relaxed/simple;
	bh=Z7LV14vWwvJ5W0dQZR4YKfeXkA1U8iZIUzPPOb9wRUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzoICizPhSty41j++PJW+jzH1FmY+wSlH76gtiVjxCQ3qZs/JFwyAEvDV1dqgBvR3tBLeRaWhAOmtVgpKumbKS3oLEe3orbczZRE2c5y4dkaTnSXZyv3yhh8NsYoIcSN85G54DtAzZ59gRHbRVB9lWXlHF/LHfYm92PldBHW2cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb1FpX6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb1FpX6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA99C4CEC2;
	Wed,  2 Oct 2024 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879974;
	bh=Z7LV14vWwvJ5W0dQZR4YKfeXkA1U8iZIUzPPOb9wRUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb1FpX6GfuhgU1yEy7vjkyObxSv9UZ1XJ+Zj02/y8CSVfABA7+P7DPEsxMrbdhzUq
	 1w1ynq2ctLZsLJpTRa1y2SI0Ias9/xPB567ohzawiUXnNygxmiuIZ1rqzNi5iEH4PR
	 12kZ1jZO/UT32iwUBbIZAJF6ymFRJ/nOjcoR4ZFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/538] clk: qcom: dispcc-sm8550: fix several supposed typos
Date: Wed,  2 Oct 2024 14:58:29 +0200
Message-ID: <20241002125802.914605219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7b6a4b907297b28727933493b9e0c95494504634 ]

Fix seveal odd-looking places in SM8550's dispcc driver:

- duplicate entries in disp_cc_parent_map_4 and disp_cc_parent_map_5
- using &disp_cc_mdss_dptx0_link_div_clk_src as a source for
  disp_cc_mdss_dptx1_usb_router_link_intf_clk

The SM8650 driver has been used as a reference.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-1-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index b9edeb2a221dc..e868c5c426096 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -196,7 +196,7 @@ static const struct clk_parent_data disp_cc_parent_data_3[] = {
 static const struct parent_map disp_cc_parent_map_4[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_DP0_PHY_PLL_LINK_CLK, 1 },
-	{ P_DP1_PHY_PLL_VCO_DIV_CLK, 2 },
+	{ P_DP0_PHY_PLL_VCO_DIV_CLK, 2 },
 	{ P_DP3_PHY_PLL_VCO_DIV_CLK, 3 },
 	{ P_DP1_PHY_PLL_VCO_DIV_CLK, 4 },
 	{ P_DP2_PHY_PLL_VCO_DIV_CLK, 6 },
@@ -213,7 +213,7 @@ static const struct clk_parent_data disp_cc_parent_data_4[] = {
 
 static const struct parent_map disp_cc_parent_map_5[] = {
 	{ P_BI_TCXO, 0 },
-	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 4 },
+	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 2 },
 	{ P_DSI1_PHY_PLL_OUT_BYTECLK, 4 },
 };
 
-- 
2.43.0



