Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97C0345EB9;
	Sat, 12 Sep 2026 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230289; cv=none; b=XIRwYjsY9aGz8w3Ssa3zAce1whpWpgwR2bsjP9G14cUFGSXu7hLQAqShTcGco0bPgyHXVWO5YL6dEtSEDH9C+xIU4RbbxdzhUcC7fSuTG37l1bJnk2V1L33np8LhE21quo4WOFVqfDDwlkTWpcQZYDihNsDcJUTxBUYHQW1DcVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230289; c=relaxed/simple;
	bh=RC/UCbF5DadqWx8VBcvfxa7RE8k1h0xlk0225AYfg80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzuQts3ZJ0FfhB+XkhLQnCA78ENbrqGdcZEP3xwqFKi3yvZnrxmUjkrkpD1zyjznJUvvy05/lx6J6BYFy+ucZpm1D62MtmV0unLBhNL58HfTlTBFOh0TY+A+x9coGcJux1ZH/OVG81Lict1rZbam2u2VU5ik57plV0upGCmbC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvwLKQnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvwLKQnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEA81F000FF;
	Sat, 12 Sep 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230287;
	bh=vOof7cy1WMYRDGLf32JHtofgt2TgWGuP6ntyd0YgFcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvwLKQnUKfwXEjlHbYAPOXGhY+ScIBP/i49D4bJqYhhM9g0zPvikyMvziAdhnIlRC
	 UagM2CSoI9GwPjFZfv5xPconq1SwLhNLkV1rBLKr2kFuLybmIuU0MlpStrSeFdEPHV
	 Ho4obSzlNEa88TGa65r33Vr47gcCIxLoRE7wxMTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0763/1191] clk: qcom: Add LUCID_OLE PLL type for SM8550
Date: Sat, 12 Sep 2026 08:58:11 +0200
Message-ID: <20260912065605.414752277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 1de7e70941fff80139df8a37d4b35264543e3fc0 ]

Add a LUCID_OLE PLL type for SM8550 SoC from Qualcomm.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221130112852.2977816-5-abel.vesa@linaro.org
Stable-dep-of: 9c4cee964e0c ("clk: qcom: gcc-qcm2290: don't park QUP RCGs upon registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 16 ++++++++++++++++
 drivers/clk/qcom/clk-alpha-pll.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index c591fa1ad802d..5399c9d36336f 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -155,6 +155,22 @@ const u8 clk_alpha_pll_regs[][PLL_OFF_MAX_REGS] = {
 		[PLL_OFF_TEST_CTL_U] = 0x30,
 		[PLL_OFF_TEST_CTL_U1] = 0x34,
 	},
+	[CLK_ALPHA_PLL_TYPE_LUCID_OLE] = {
+		[PLL_OFF_OPMODE] = 0x04,
+		[PLL_OFF_STATE] = 0x08,
+		[PLL_OFF_STATUS] = 0x0c,
+		[PLL_OFF_L_VAL] = 0x10,
+		[PLL_OFF_ALPHA_VAL] = 0x14,
+		[PLL_OFF_USER_CTL] = 0x18,
+		[PLL_OFF_USER_CTL_U] = 0x1c,
+		[PLL_OFF_CONFIG_CTL] = 0x20,
+		[PLL_OFF_CONFIG_CTL_U] = 0x24,
+		[PLL_OFF_CONFIG_CTL_U1] = 0x28,
+		[PLL_OFF_TEST_CTL] = 0x2c,
+		[PLL_OFF_TEST_CTL_U] = 0x30,
+		[PLL_OFF_TEST_CTL_U1] = 0x34,
+		[PLL_OFF_TEST_CTL_U2] = 0x38,
+	},
 	[CLK_ALPHA_PLL_TYPE_RIVIAN_EVO] = {
 		[PLL_OFF_OPMODE] = 0x04,
 		[PLL_OFF_STATUS] = 0x0c,
diff --git a/drivers/clk/qcom/clk-alpha-pll.h b/drivers/clk/qcom/clk-alpha-pll.h
index e0c5f2f855ad1..9695ef8def8c2 100644
--- a/drivers/clk/qcom/clk-alpha-pll.h
+++ b/drivers/clk/qcom/clk-alpha-pll.h
@@ -18,6 +18,7 @@ enum {
 	CLK_ALPHA_PLL_TYPE_AGERA,
 	CLK_ALPHA_PLL_TYPE_ZONDA,
 	CLK_ALPHA_PLL_TYPE_LUCID_EVO,
+	CLK_ALPHA_PLL_TYPE_LUCID_OLE,
 	CLK_ALPHA_PLL_TYPE_RIVIAN_EVO,
 	CLK_ALPHA_PLL_TYPE_DEFAULT_EVO,
 	CLK_ALPHA_PLL_TYPE_BRAMMO_EVO,
@@ -38,6 +39,8 @@ enum {
 	PLL_OFF_TEST_CTL,
 	PLL_OFF_TEST_CTL_U,
 	PLL_OFF_TEST_CTL_U1,
+	PLL_OFF_TEST_CTL_U2,
+	PLL_OFF_STATE,
 	PLL_OFF_STATUS,
 	PLL_OFF_OPMODE,
 	PLL_OFF_FRAC,
@@ -160,7 +163,9 @@ extern const struct clk_ops clk_alpha_pll_zonda_ops;
 extern const struct clk_ops clk_alpha_pll_lucid_evo_ops;
 extern const struct clk_ops clk_alpha_pll_reset_lucid_evo_ops;
 extern const struct clk_ops clk_alpha_pll_fixed_lucid_evo_ops;
+#define clk_alpha_pll_fixed_lucid_ole_ops clk_alpha_pll_fixed_lucid_evo_ops
 extern const struct clk_ops clk_alpha_pll_postdiv_lucid_evo_ops;
+#define clk_alpha_pll_postdiv_lucid_ole_ops clk_alpha_pll_postdiv_lucid_evo_ops
 
 extern const struct clk_ops clk_alpha_pll_rivian_evo_ops;
 #define clk_alpha_pll_postdiv_rivian_evo_ops clk_alpha_pll_postdiv_fabia_ops
-- 
2.53.0



