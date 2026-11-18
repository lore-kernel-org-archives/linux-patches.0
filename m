Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019996;
	b=uol6lnLnvSforR/PLAiRN3ni2JvTAoJzf35BP/8dLb/+rSMNkXbLFwplt7RR54tdF1N8
	 vucQGjmKXpzO9A3CC+CErqBOpv6BhZnqGsEWc3Hvzo019nAcLbqTnrvzovyCIFCcLdu3N
	 XcngISSW75mNSyv4xRD/hG310QNwFMhpjgmCnAr4QMIvycsYYoFR8JIRHWXffQwr8Y6AF
	 08+bb+F+wtpeyITNYpfPMo5m/OoC1RKyFeAjuPM9tE6FDcIw7JdeN9adpqYQRZMYaFVIl
	 z39HgGwOYMEj9WbljcN6Dzz5g4Fe0q2KkeyzqmXQGAyO8LNQc7q+raonkgM9EbCy0Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+6ha8oJZsFpuoKAFpvMrVC/vCFg+FrfKHhUot8fPko=;
	b=IynDq8P1bbby764Hotmp4R/GCMom5GUTq87vj6lB/B7MpZI3pggAkxTS9WV6Tn4rZ1rt
	 BvNsGBtiueJMb0+1xFfLUwv7D8kvbc8YGQtmVolSXUTNXl3iINiklmA6pHIW0YJTSct+6
	 X24VazKX6nOQdLFM0Hh3gGF17BW9slOds7a++G10HEOGfm5j9DFQ9RTbQp4MRgrwamM36
	 kXtULHVf2OnY3TgrFQZn3bGTcZZJdK7KoKyXo9J4KUAv7ximN6ebPgoteiPOaa+QJUAyJ
	 1VXHt95L90Lxjkd+sUwR8/18684iLhM8QkrzGuQ/x9Hv/d68ealgpgkRaNbM+FdNpZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH5ktVvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D1F606A31C;
	Wed, 18 Nov 2026 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH5ktVvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B85E1F000C5;
	Wed, 18 Nov 2026 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019996;
	bh=f+6ha8oJZsFpuoKAFpvMrVC/vCFg+FrfKHhUot8fPko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH5ktVvJFQDnws1OfTo7f7QtdPxrhXSMEdAP918aMGHM2b9vcO/JvtwlRaIrwuSmH
	 9Bmuiwj2N6BDNvbUaEVdIoDe3my1u1cPUYE7xY65z5qrUBrNF9PXRsdvKH1CHHXm+5
	 C78I2eoVYtJc98CaP11h7GYwInHAHbJACk5W717w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1753/2651] clk: qcom: Fix camera rivian PLL configuration settings
Date: Wed, 18 Nov 2026 15:49:53 +0100
Message-ID: <20261118150350.603187144@linuxfoundation.org>
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

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 6666c03f2348886774d6441350fbe0e7a782f471 ]

clk_alpha_pll_write_config() in the PLL configure function skips writes
to PLL registers when the configured value is 0. However, hardware
requires USER_CTL_U and CONFIG_CTL_U2 to be explicitly programmed to 0
for a few rivian PLLs.

Add a clk_regs_configure() callback to ensure these rivian PLL registers
are correctly initialized on Glymur, SM8750, and Kaanapali platforms.

Fixes: 97255eedd690 ("clk: qcom: camcc-glymur: Add camera clock controller driver")
Fixes: f9580bafd39c ("clk: qcom: camcc: Add camera clock controller driver for SM8750 SoC")
Fixes: 92aae35f667c ("clk: qcom: camcc: Add support for camera clock controller for Kaanapali")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://patch.msgid.link/20260801-cam-rivian-pll-config-fix-v1-1-6918d58cd823@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/cambistmclkcc-kaanapali.c | 7 +++++++
 drivers/clk/qcom/cambistmclkcc-sm8750.c    | 7 +++++++
 drivers/clk/qcom/camcc-glymur.c            | 7 +++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/clk/qcom/cambistmclkcc-kaanapali.c b/drivers/clk/qcom/cambistmclkcc-kaanapali.c
index c96e9196d908e..b5bafc1e7d428 100644
--- a/drivers/clk/qcom/cambistmclkcc-kaanapali.c
+++ b/drivers/clk/qcom/cambistmclkcc-kaanapali.c
@@ -394,11 +394,18 @@ static const struct regmap_config cam_bist_mclk_cc_kaanapali_regmap_config = {
 	.fast_io = true,
 };
 
+static void cam_bist_mclk_cc_kaanapali_regs_configure(struct device *dev, struct regmap *regmap)
+{
+	regmap_write(regmap, 0x18, 0); /* CAM_BIST_MCLK_CC_PLL0_USER_CTL_U */
+	regmap_write(regmap, 0x28, 0); /* CAM_BIST_MCLK_CC_PLL0_CONFIG_CTL_U2 */
+}
+
 static const struct qcom_cc_driver_data cam_bist_mclk_cc_kaanapali_driver_data = {
 	.alpha_plls = cam_bist_mclk_cc_kaanapali_plls,
 	.num_alpha_plls = ARRAY_SIZE(cam_bist_mclk_cc_kaanapali_plls),
 	.clk_cbcrs = cam_bist_mclk_cc_kaanapali_critical_cbcrs,
 	.num_clk_cbcrs = ARRAY_SIZE(cam_bist_mclk_cc_kaanapali_critical_cbcrs),
+	.clk_regs_configure = cam_bist_mclk_cc_kaanapali_regs_configure,
 };
 
 static const struct qcom_cc_desc cam_bist_mclk_cc_kaanapali_desc = {
diff --git a/drivers/clk/qcom/cambistmclkcc-sm8750.c b/drivers/clk/qcom/cambistmclkcc-sm8750.c
index 69abb756c04f2..45788ddb9dcc6 100644
--- a/drivers/clk/qcom/cambistmclkcc-sm8750.c
+++ b/drivers/clk/qcom/cambistmclkcc-sm8750.c
@@ -413,11 +413,18 @@ static const struct regmap_config cam_bist_mclk_cc_sm8750_regmap_config = {
 	.fast_io = true,
 };
 
+static void cam_bist_mclk_cc_sm8750_regs_configure(struct device *dev, struct regmap *regmap)
+{
+	regmap_write(regmap, 0x18, 0); /* CAM_BIST_MCLK_CC_PLL0_USER_CTL_U */
+	regmap_write(regmap, 0x28, 0); /* CAM_BIST_MCLK_CC_PLL0_CONFIG_CTL_U2 */
+}
+
 static const struct qcom_cc_driver_data cam_bist_mclk_cc_sm8750_driver_data = {
 	.alpha_plls = cam_bist_mclk_cc_sm8750_plls,
 	.num_alpha_plls = ARRAY_SIZE(cam_bist_mclk_cc_sm8750_plls),
 	.clk_cbcrs = cam_bist_mclk_cc_sm8750_critical_cbcrs,
 	.num_clk_cbcrs = ARRAY_SIZE(cam_bist_mclk_cc_sm8750_critical_cbcrs),
+	.clk_regs_configure = cam_bist_mclk_cc_sm8750_regs_configure,
 };
 
 static const struct qcom_cc_desc cam_bist_mclk_cc_sm8750_desc = {
diff --git a/drivers/clk/qcom/camcc-glymur.c b/drivers/clk/qcom/camcc-glymur.c
index 81c1e102b110e..6d022bbd2ce2e 100644
--- a/drivers/clk/qcom/camcc-glymur.c
+++ b/drivers/clk/qcom/camcc-glymur.c
@@ -2235,11 +2235,18 @@ static const struct regmap_config cam_cc_glymur_regmap_config = {
 	.fast_io = true,
 };
 
+static void cam_cc_glymur_regs_configure(struct device *dev, struct regmap *regmap)
+{
+	regmap_write(regmap, 0x2018, 0); /* CAM_CC_PLL2_PLL_USER_CTL_U */
+	regmap_write(regmap, 0x2028, 0); /* CAM_CC_PLL2_PLL_CONFIG_CTL_U2 */
+}
+
 static const struct qcom_cc_driver_data cam_cc_glymur_driver_data = {
 	.alpha_plls = cam_cc_glymur_plls,
 	.num_alpha_plls = ARRAY_SIZE(cam_cc_glymur_plls),
 	.clk_cbcrs = cam_cc_glymur_critical_cbcrs,
 	.num_clk_cbcrs = ARRAY_SIZE(cam_cc_glymur_critical_cbcrs),
+	.clk_regs_configure = cam_cc_glymur_regs_configure,
 };
 
 static const struct qcom_cc_desc cam_cc_glymur_desc = {
-- 
2.53.0



