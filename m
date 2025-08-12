Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737071B87E9;
	Tue, 12 Aug 2025 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026154; cv=none; b=UQekfkpWB80YR0nAJfPdv0unSv6E4sW127tF0xrlCVgPWAJvtPYtVAtUsw+X8zjETCnrowqM6HZBbnOvO1WHP26i8Essb02Q2tmLqihiewE+q90knEFC9uf9p6tFaOF7m/MiwKzvoauAAkj+CnwP8SIwE9Iq3X9jw2KwBoocYOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026154; c=relaxed/simple;
	bh=/LiMFLrIBmabOwrhkzFcc9/xBENsIT8AU08UG0WFnqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aml9+K9DRdUABGBVTZHwtvTaEmnVZEihFsm8JJpuUdljcQjMwAlp2wj388rjmOG3zElJxf/WnJ0A8pAxVWV6od4NLp/3QMmbZT7tJVUVyFa5Wz7nSbRlu3/u8mVcmZp7pH9XeYU/Rv/2QQPPw91v5sD1TDoQseL46Nx1AnXdCgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ih7e3VbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ih7e3VbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCFC4CEF0;
	Tue, 12 Aug 2025 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026154;
	bh=/LiMFLrIBmabOwrhkzFcc9/xBENsIT8AU08UG0WFnqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ih7e3VbJ4JUZKL0DpM54eEvGVFrXtVANxYwK+Co/UpfRLcqVuT/08RWYnkNwjmXvK
	 G+Yf4t9lOsMy7BshQ4td+BBeOCZKu/vJky2/SsIzQC44yWplBHcIvKE9ujFXB3qS97
	 LVK9pRlr1nUw9OFgDKhuI17W8ItsAsra17Ptgar0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 251/480] phy: qualcomm: phy-qcom-eusb2-repeater: Dont zero-out registers
Date: Tue, 12 Aug 2025 19:47:39 +0200
Message-ID: <20250812174407.805008582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 31bc94de76026c527f82c238f414539a14f0f3e6 ]

Zeroing out registers does not happen in the downstream kernel, and will
"tune" the repeater in surely unexpected ways since most registers don't
have a reset value of 0x0.

Stop doing that and instead just set the registers that are in the init
sequence (though long term I don't think there's actually PMIC-specific
init sequences, there's board specific tuning, but that's a story for
another day).

Fixes: 99a517a582fc ("phy: qualcomm: phy-qcom-eusb2-repeater: Zero out untouched tuning regs")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20250617-eusb2-repeater-tuning-v2-2-ed6c484f18ee@fairphone.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/qualcomm/phy-qcom-eusb2-repeater.c    | 87 +++++++------------
 1 file changed, 32 insertions(+), 55 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index 6bd1b3c75c77..d7493c2294ef 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -37,32 +37,13 @@
 #define EUSB2_TUNE_EUSB_EQU		0x5A
 #define EUSB2_TUNE_EUSB_HS_COMP_CUR	0x5B
 
-enum eusb2_reg_layout {
-	TUNE_EUSB_HS_COMP_CUR,
-	TUNE_EUSB_EQU,
-	TUNE_EUSB_SLEW,
-	TUNE_USB2_HS_COMP_CUR,
-	TUNE_USB2_PREEM,
-	TUNE_USB2_EQU,
-	TUNE_USB2_SLEW,
-	TUNE_SQUELCH_U,
-	TUNE_HSDISC,
-	TUNE_RES_FSDIF,
-	TUNE_IUSB2,
-	TUNE_USB2_CROSSOVER,
-	NUM_TUNE_FIELDS,
-
-	FORCE_VAL_5 = NUM_TUNE_FIELDS,
-	FORCE_EN_5,
-
-	EN_CTL1,
-
-	RPTR_STATUS,
-	LAYOUT_SIZE,
+struct eusb2_repeater_init_tbl_reg {
+	unsigned int reg;
+	unsigned int value;
 };
 
 struct eusb2_repeater_cfg {
-	const u32 *init_tbl;
+	const struct eusb2_repeater_init_tbl_reg *init_tbl;
 	int init_tbl_num;
 	const char * const *vreg_list;
 	int num_vregs;
@@ -82,16 +63,16 @@ static const char * const pm8550b_vreg_l[] = {
 	"vdd18", "vdd3",
 };
 
-static const u32 pm8550b_init_tbl[NUM_TUNE_FIELDS] = {
-	[TUNE_IUSB2] = 0x8,
-	[TUNE_SQUELCH_U] = 0x3,
-	[TUNE_USB2_PREEM] = 0x5,
+static const struct eusb2_repeater_init_tbl_reg pm8550b_init_tbl[] = {
+	{ EUSB2_TUNE_IUSB2, 0x8 },
+	{ EUSB2_TUNE_SQUELCH_U, 0x3 },
+	{ EUSB2_TUNE_USB2_PREEM, 0x5 },
 };
 
-static const u32 smb2360_init_tbl[NUM_TUNE_FIELDS] = {
-	[TUNE_IUSB2] = 0x5,
-	[TUNE_SQUELCH_U] = 0x3,
-	[TUNE_USB2_PREEM] = 0x2,
+static const struct eusb2_repeater_init_tbl_reg smb2360_init_tbl[] = {
+	{ EUSB2_TUNE_IUSB2, 0x5 },
+	{ EUSB2_TUNE_SQUELCH_U, 0x3 },
+	{ EUSB2_TUNE_USB2_PREEM, 0x2 },
 };
 
 static const struct eusb2_repeater_cfg pm8550b_eusb2_cfg = {
@@ -129,17 +110,10 @@ static int eusb2_repeater_init(struct phy *phy)
 	struct eusb2_repeater *rptr = phy_get_drvdata(phy);
 	struct device_node *np = rptr->dev->of_node;
 	struct regmap *regmap = rptr->regmap;
-	const u32 *init_tbl = rptr->cfg->init_tbl;
-	u8 tune_usb2_preem = init_tbl[TUNE_USB2_PREEM];
-	u8 tune_hsdisc = init_tbl[TUNE_HSDISC];
-	u8 tune_iusb2 = init_tbl[TUNE_IUSB2];
 	u32 base = rptr->base;
-	u32 val;
+	u32 poll_val;
 	int ret;
-
-	of_property_read_u8(np, "qcom,tune-usb2-amplitude", &tune_iusb2);
-	of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &tune_hsdisc);
-	of_property_read_u8(np, "qcom,tune-usb2-preem", &tune_usb2_preem);
+	u8 val;
 
 	ret = regulator_bulk_enable(rptr->cfg->num_vregs, rptr->vregs);
 	if (ret)
@@ -147,21 +121,24 @@ static int eusb2_repeater_init(struct phy *phy)
 
 	regmap_write(regmap, base + EUSB2_EN_CTL1, EUSB2_RPTR_EN);
 
-	regmap_write(regmap, base + EUSB2_TUNE_EUSB_HS_COMP_CUR, init_tbl[TUNE_EUSB_HS_COMP_CUR]);
-	regmap_write(regmap, base + EUSB2_TUNE_EUSB_EQU, init_tbl[TUNE_EUSB_EQU]);
-	regmap_write(regmap, base + EUSB2_TUNE_EUSB_SLEW, init_tbl[TUNE_EUSB_SLEW]);
-	regmap_write(regmap, base + EUSB2_TUNE_USB2_HS_COMP_CUR, init_tbl[TUNE_USB2_HS_COMP_CUR]);
-	regmap_write(regmap, base + EUSB2_TUNE_USB2_EQU, init_tbl[TUNE_USB2_EQU]);
-	regmap_write(regmap, base + EUSB2_TUNE_USB2_SLEW, init_tbl[TUNE_USB2_SLEW]);
-	regmap_write(regmap, base + EUSB2_TUNE_SQUELCH_U, init_tbl[TUNE_SQUELCH_U]);
-	regmap_write(regmap, base + EUSB2_TUNE_RES_FSDIF, init_tbl[TUNE_RES_FSDIF]);
-	regmap_write(regmap, base + EUSB2_TUNE_USB2_CROSSOVER, init_tbl[TUNE_USB2_CROSSOVER]);
-
-	regmap_write(regmap, base + EUSB2_TUNE_USB2_PREEM, tune_usb2_preem);
-	regmap_write(regmap, base + EUSB2_TUNE_HSDISC, tune_hsdisc);
-	regmap_write(regmap, base + EUSB2_TUNE_IUSB2, tune_iusb2);
-
-	ret = regmap_read_poll_timeout(regmap, base + EUSB2_RPTR_STATUS, val, val & RPTR_OK, 10, 5);
+	/* Write registers from init table */
+	for (int i = 0; i < rptr->cfg->init_tbl_num; i++)
+		regmap_write(regmap, base + rptr->cfg->init_tbl[i].reg,
+			     rptr->cfg->init_tbl[i].value);
+
+	/* Override registers from devicetree values */
+	if (!of_property_read_u8(np, "qcom,tune-usb2-amplitude", &val))
+		regmap_write(regmap, base + EUSB2_TUNE_USB2_PREEM, val);
+
+	if (!of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &val))
+		regmap_write(regmap, base + EUSB2_TUNE_HSDISC, val);
+
+	if (!of_property_read_u8(np, "qcom,tune-usb2-preem", &val))
+		regmap_write(regmap, base + EUSB2_TUNE_IUSB2, val);
+
+	/* Wait for status OK */
+	ret = regmap_read_poll_timeout(regmap, base + EUSB2_RPTR_STATUS, poll_val,
+				       poll_val & RPTR_OK, 10, 5);
 	if (ret)
 		dev_err(rptr->dev, "initialization timed-out\n");
 
-- 
2.39.5



