Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024288;
	b=XqCfB9fsqJPFBzx8bWWI3KtgAswxV8AgL95gO73RkTI7WE4FC8H+pDcedUGSvdMEfVO2
	 GtthRb0Md05se5lFi0Z720Qs4Lz6AvvN2L5cbplnWvtHV876DbUBKtzumMKNWyRPE4aCf
	 YTQHMGElrSPkB2O3twEhORPyH8KnKJksUXyMKlz+gIGhuUoIqdWAMDiRuom7o/uu7LvGw
	 R1bSROGWAyDAakisNdNNGtxd64A96lGEbjU1ZrnS+H7/X20XHHdVTNIaKKWo7TbKixB04
	 BSMUYBFb0/Q37EZ3AAtwPV5tdirBjPnXCM/5MMt8z9rtpsUUXELdC4yhvw5mqJCHyCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23esx6sTsNHPR8PdScMbEC+P5J4njTyaZSW9gIvzi0s=;
	b=IPNZ6oCd6oAiJsEDuh1fpijhydCFGDF6z+SAXsBq/sdqJyuKfB8qVJ9qiewkOoHI5yRp
	 k3mUoDes3jO9D6MW/errI+LMa5C24voypPLjISj/4aHOdhPfryyGmdA+87d07Uwdz3j06
	 W1/q1XI19XzbOgDS5aqFvSpcc2tXApmbQuOkTvAbgsfLMTJHnQll16TsAlaadTveE3e/J
	 MSJ5rUQMsq/14JXS1NPbLaNWSCk6Lk0mdFOiQ3nV0xSmFQCa8NL3TwYcJa4pzkqxM6aYw
	 TXrVuahetev1UNQD2W5ZDgZsNC+ZRt3vuZ7A4hQlRLrEr+PvMhh/08uzAjHpq3y/1Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0LWmIiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD992606A320;
	Wed, 18 Nov 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0LWmIiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7461F000C5;
	Wed, 18 Nov 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024288;
	bh=23esx6sTsNHPR8PdScMbEC+P5J4njTyaZSW9gIvzi0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0LWmIiTKQVytsYDDKw1Fi1k2ZBsqAByOiTFb8TvAK9veNv8sP1GrFyEUBeN2wzpM
	 WreNoqaojfhexCc8Jrc8XpNLZlfPWuiXJugrgEalcyfVuo3XScyhiG8uzCJGO5mft7
	 4d+5yjrEv4AhID0OrbBHTWojtMd0mHA7t3g210jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0672/2151] clk: qcom: alpha-pll: Check Lucid Ole PLL status before configuring
Date: Wed, 18 Nov 2026 15:40:07 +0100
Message-ID: <20261118150146.298710570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit eb34e2804ce4ea56efb741e23d598469274a2f94 ]

On some platforms such as SM8475, not doing this may result in graphical
glitches when the mdss driver takes over.
This fixes the aforementioned issue.

Fixes: 3132a9a11e57 ("clk: qcom: clk-alpha-pll: Add support for lucid ole pll configure")
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260713-sm8450-qol-dispcc-v3-3-56fd05822270@proton.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index a84e8bee65346..05a54f3894669 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2356,6 +2356,15 @@ void clk_lucid_ole_pll_configure(struct clk_alpha_pll *pll, struct regmap *regma
 {
 	u32 lval = config->l;
 
+	/*
+	 * If the bootloader left the PLL enabled it's likely that there are
+	 * RCGs that will lock up if we disable the PLL below.
+	 */
+	if (trion_pll_is_enabled(pll, regmap)) {
+		pr_debug("Lucid Ole PLL is already enabled, skipping configuration\n");
+		return;
+	}
+
 	lval |= TRION_PLL_CAL_VAL << LUCID_EVO_PLL_CAL_L_VAL_SHIFT;
 	lval |= TRION_PLL_CAL_VAL << LUCID_OLE_PLL_RINGOSC_CAL_L_VAL_SHIFT;
 	clk_alpha_pll_write_config(regmap, PLL_L_VAL(pll), lval);
-- 
2.53.0



