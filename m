Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017072;
	b=nfj+fJvhY8V1G0rInsweBhBaOPB2/dBMH1Kvh9apUNM4HEWkx/ei/VPZgh5X2z+N/Yzr
	 ERCxjES8jYnAHUpEsmS5Vj/OVa13uulxBAGwmN4aw7Ip739hqGocnOk8ZCPG640nsMcBj
	 RIVqp8cvaLSHGIurN3s5QDsuXP64b5IF7EzHHR0F4c1QGMZosc/hg/pmnqgb7gpb2C1F/
	 wjTG5KEoMXsjQu4zzANXPuhAke4HebgnGcPkxz/KZRBouzLXJaIEYmcCg8pYCGRh0Ro3K
	 /cZf6833CBONBlafmPzQ1wJyjQ+XqJRzbB72w8zQEa3TrNrs2jY+weD7ICGjNuC1Xtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHFyjIftMtGRd/Xb63oe34hNhG+t9C8Nef2/SxlM0fo=;
	b=TaQQUT58VJwCgSVl/QKW0OBhfhH2udmJ+KEwhLbtVKgBpGrS8hgFLUll4i4W2xaZ0jfF
	 OloRnAc6BAONhZkvnUeW0tZUKgeNkwL7l2W0Y9ZOEUTswrjvZVlxj3++w3qfBW6bMBpcr
	 o1OyNdFlLz8dofPHDfX8l2D5sOyS1T2vEkHEGVASoNBX2t72f6E9ayWqhmwsTAJINV1mJ
	 bAltm2JsXNCFtEVM4ECArUu9xdXJ0KfPCMHCw1CNMiWcVDEl2MYYik3A7AXYUwyt+Z29h
	 aXavF8rGgEb3ZY/fhAm51UmiClSKo5frEr1pviLzddUf9nnNeqX3KtpxohZrikxf3Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbvX1qCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86E606A332;
	Wed, 18 Nov 2026 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbvX1qCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580FF1F000CF;
	Wed, 18 Nov 2026 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017071;
	bh=KHFyjIftMtGRd/Xb63oe34hNhG+t9C8Nef2/SxlM0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbvX1qCc5CmnSHaldjBMvvBZRarpkgFa9bLaZ+QJ3Hl7Fhh2fziL4r/+qD/kgdoyR
	 w1gljRvWUletCfYOHivXbcrNCz1sYesUhnYc8feIgbbWDCwCJMBTRSlJ61txxIeLah
	 4TFW3QYJNsyy69e7TKutSKKDMhuKuSBJjU/qQ9gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0754/2651] clk: qcom: alpha-pll: Check Lucid Ole PLL status before configuring
Date: Wed, 18 Nov 2026 15:33:14 +0100
Message-ID: <20261118150315.024702367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f8313f9d0e30f..60173b076cc5f 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2373,6 +2373,15 @@ void clk_lucid_ole_pll_configure(struct clk_alpha_pll *pll, struct regmap *regma
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



