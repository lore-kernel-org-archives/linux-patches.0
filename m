Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F434D4892;
	Thu, 17 Sep 2026 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663844; cv=none; b=LDquTq7nGzKqF+0c8BJuWptnRZ2mLcWvDCKWqscURNupMOk+PJg+wlxPX4gakqER4QoM2nEXy5gk0h1wHR0OlzDBeTVtywIT1yA3qONtuczlLVf4TG5S9rE25Xxf3e5AcN8R/S0RJytTk2dsW8GFyDpTsI1y7IGUWtD/hguLsbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663844; c=relaxed/simple;
	bh=yNO4V9Nu7ebNN0UcmOv30AHuXQBgh0zviG6L9+MUzyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI9BnA5zSr9wgg2u5dpNVKzCC959xN1qPKx9QkJDvyRtP20roLBY6+/i7mJzaq0mvWxDJxVa/0AMcY9vkyZAIJslyWlkd754KOyG5uyS05G6phZOaSB2Y+AJHXmQ8QbZ9r7E/VawC3imMaz0ia7WHQWgJUxQlORNZYCi0SscbUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd7wKp0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd7wKp0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7261F000FF;
	Thu, 17 Sep 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663842;
	bh=lro3kS/DYIi5h4hYNmlSNJ2HXGSoJhrrwhJm6qByj2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wd7wKp0mNEiItocXRfxPGDPjidHdVCW89blegdDi5TBQwJS4voTghpM1xwN+agZe8
	 KPnVESJSmNWYETryTX6P1kQa+iPdsVLj+mXx16X4Im2qlfRsOMCO6eHD5XfQqtzpZ3
	 /E+/JbZWzCFX3VQdz+/Yw0ToQ8pye6AZuZ3R24/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0124/1250] clk: qcom: clk-rpmh: Make all VRMs optional
Date: Thu, 17 Sep 2026 15:58:39 +0100
Message-ID: <20260917151555.388961675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Koskovich <akoskovich@pm.me>

[ Upstream commit 25b8f50b0622689cd1f7233e452407ce777a479e ]

Some VRMs aren't present on all boards, so mark them as optional. This
prevents probe failures on boards where not all VRMs are present.

This resolves an issue seen on the Nothing Phone (4a) Pro (Eliza) where
probe fails due to RPMH_RF_CLK5 not being present on the board, this is
due to this device having a slightly different PMIC configuration from
the Eliza MTP.

This matches the downstream approach of marking all VRMs as optional
and makes the previous clka_optional handling redundant.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260414-clk-rpmh-vrm-opt-v3-1-8ca21469ffbc@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 63c38cb47bc45..82f18e15cd77b 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -66,8 +66,6 @@ struct clk_rpmh {
 struct clk_rpmh_desc {
 	struct clk_hw **clks;
 	size_t num_clks;
-	/* RPMh clock clkaN are optional for this platform */
-	bool clka_optional;
 };
 
 static DEFINE_MUTEX(rpmh_clk_lock);
@@ -680,7 +678,6 @@ static struct clk_hw *sm8550_rpmh_clocks[] = {
 static const struct clk_rpmh_desc clk_rpmh_sm8550 = {
 	.clks = sm8550_rpmh_clocks,
 	.num_clks = ARRAY_SIZE(sm8550_rpmh_clocks),
-	.clka_optional = true,
 };
 
 static struct clk_hw *sm8650_rpmh_clocks[] = {
@@ -712,7 +709,6 @@ static struct clk_hw *sm8650_rpmh_clocks[] = {
 static const struct clk_rpmh_desc clk_rpmh_sm8650 = {
 	.clks = sm8650_rpmh_clocks,
 	.num_clks = ARRAY_SIZE(sm8650_rpmh_clocks),
-	.clka_optional = true,
 };
 
 static struct clk_hw *sc7280_rpmh_clocks[] = {
@@ -881,7 +877,6 @@ static struct clk_hw *sm8750_rpmh_clocks[] = {
 static const struct clk_rpmh_desc clk_rpmh_sm8750 = {
 	.clks = sm8750_rpmh_clocks,
 	.num_clks = ARRAY_SIZE(sm8750_rpmh_clocks),
-	.clka_optional = true,
 };
 
 static struct clk_hw *glymur_rpmh_clocks[] = {
@@ -943,8 +938,7 @@ static int clk_rpmh_probe(struct platform_device *pdev)
 		if (!res_addr) {
 			hw_clks[i] = NULL;
 
-			if (desc->clka_optional &&
-			    !strncmp(rpmh_clk->res_name, "clka", sizeof("clka") - 1))
+			if (rpmh_clk->res_addr == CLK_RPMH_VRM_EN_OFFSET)
 				continue;
 
 			dev_err(&pdev->dev, "missing RPMh resource address for %s\n",
-- 
2.53.0



