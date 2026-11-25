Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618133;
	b=mOvet/kextwZfvw01pNyx1VAttYr6qUtU3jiWEh9Za2AQf/Kque64VtWRD7q4/mJ+pgd
	 UfmlN5uEGI6ga28v1iB9YeoJwVpN3ZLUFyZWS1h+KOjscVmYkMyfQhjHWY+DTYnfAQEeH
	 G5/tjMSikh//FrNH/cmHbps+8cZQE3ZyAx/bg2lEMv5sgTWj9U3jxHE0dI2wvPeJ93gv3
	 rK93hVmBv/e3bquBdlRe/7xyqg8N6opAQ9ZHyGiFqAQp8yZ72+GELH3lVF4JNTE+WAwRj
	 1XrKDGkaFagoO+rKugB5duVF94pE8p8kGDqL78Y7LTczhXgCg7GUWmnkwxKg92BcmVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XdQfXiuNQWDL5rES3k3nwNc0X8MTDqTmmruB5BJQDo8=;
	b=qCcVdj2P7nFt/UAT0wj4OLn/Sqb1o6Uo7G+68MKXWzQOxZ/9ROt6MW+wNIVHlrQprso0
	 lPkki/ohQBrG6m7JU8vheAGM5L1kGLTA7Lpz+hA1OzY8DDipDzWmDq3ry8BsjW3OrNZEH
	 DfrdlwDU/Y3a+zZk1zcCm7mlpAIMDO1r/h2Rn7ZwSb8NOLMNxUsv/MgqO5wmx/yl8BzQG
	 BAO87H24q+hgwrz84rWDM5sryDAPhnN4zyOWJcjQBi22rYh2j+kZyDY+Hs09mnYA0WmUO
	 zOVyj7LTlknFnvN7YZs8onrLlKz8vNc9PZ5QHgkV11tzr3/W/F4rNDTkuP2SmtIarhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Sw9Vryj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F857606A31E;
	Wed, 25 Nov 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Sw9Vryj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3F71F000C4;
	Wed, 25 Nov 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618133;
	bh=XdQfXiuNQWDL5rES3k3nwNc0X8MTDqTmmruB5BJQDo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Sw9VryjXr8uOQui18HgKhV01T3KVT2XRP5IDal10TsAHvSXhuqBNPjrep2gfwHyJ
	 RVMC/Le5euoEiOwfM/3WuqWG/V0Sjy6OBL/FhYDZRJWKjVO0V8FacvZquN1lgkNczu
	 QKfF6orfmFdwyUQoR6AGOyz/O7I3Ja0FeF0E3in8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?GIBEOM=20LEE=20 ?= <rtx4060@gmail.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0184/1005] regulator: mt6363: Fix the registers of the VSRAM CPU and APU LDOs
Date: Wed, 25 Nov 2026 15:25:22 +0100
Message-ID: <20261125143826.052067047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GIBEOM LEE (이기범) <rtx4060@gmail.com>

[ Upstream commit 8aed8b66751e006589b6a9474af757d1ba04a857 ]

VSRAM_CPUB, VSRAM_CPUM, VSRAM_CPUL and VSRAM_APU have a register of their
own for the enable (bit 0) and low power (bit 1) bits, which the header
defines as MT6363_RG_LDO_VSRAM_*_ADDR. The driver does not use it:
MT6363_LDO_L() takes the registers of the BUCK1 group, which is right only
for the VSRAM_{DIGRF,MDFE,MODEM} LDOs of MT6363_LDO_L_SC().

Bit 0 of the BUCK1 enable register is VS1 and bit 1 of the BUCK1 low power
register is VS3. So disabling one of these LDOs disables VS1, their state
is the state of VS1, and asking for their low power mode puts VS3 in it.
The LDOs themselves are never switched.

Use the register of the LDO, as MediaTek's driver does.

Fixes: 3c36965df808 ("regulator: Add support for MediaTek MT6363 SPMI PMIC Regulators")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: GIBEOM LEE (이기범) <rtx4060@gmail.com>
Tested-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patch.msgid.link/20261101164405.1743177-3-rtx4060@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6363-regulator.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/mt6363-regulator.c b/drivers/regulator/mt6363-regulator.c
index aa6a8eb7ac4b4..e56a2f0dd7778 100644
--- a/drivers/regulator/mt6363-regulator.c
+++ b/drivers/regulator/mt6363-regulator.c
@@ -147,7 +147,7 @@ struct mt6363_regulator_info {
 }
 
 #define MT6363_LDO_LINEAR_OPS(match, vreg, in_sup, vops, min, max,	\
-			      step, buck_reg, ocp_intn)			\
+			      step, en_reg, lp_reg, ocp_intn)		\
 [MT6363_ID_##vreg] = {							\
 	.desc = {							\
 		.name = match,						\
@@ -160,13 +160,13 @@ struct mt6363_regulator_info {
 		.n_voltages = (max - min) / step + 1,			\
 		.min_uV = min,						\
 		.uV_step = step,					\
-		.enable_reg = MT6363_RG_##buck_reg##_EN_ADDR,		\
+		.enable_reg = en_reg,					\
 		.enable_mask = BIT(MT6363_RG_LDO_##vreg##_EN_BIT),	\
 		.vsel_reg = MT6363_RG_LDO_##vreg##_VOSEL_ADDR,		\
 		.vsel_mask = MT6363_RG_LDO_##vreg##_VOSEL_MASK,		\
 		.of_map_mode = mt6363_map_mode,				\
 	},								\
-	.lp_mode_reg = MT6363_RG_##buck_reg##_LP_ADDR,			\
+	.lp_mode_reg = lp_reg,						\
 	.lp_mode_mask = BIT(MT6363_RG_LDO_##vreg##_LP_BIT),		\
 	.hw_lp_mode_reg = MT6363_LDO_##vreg##_HW_LP_MODE,		\
 	.hw_lp_mode_mask = 0x4,						\
@@ -176,12 +176,15 @@ struct mt6363_regulator_info {
 #define MT6363_LDO_L_SC(match, vreg, inp, min, max, step, buck_reg,	\
 			ocp_intn)					\
 	MT6363_LDO_LINEAR_OPS(match, vreg, inp, mt6363_vreg_setclr_ops,	\
-			      min, max, step, buck_reg, ocp_intn)
+			      min, max, step,				\
+			      MT6363_RG_##buck_reg##_EN_ADDR,		\
+			      MT6363_RG_##buck_reg##_LP_ADDR, ocp_intn)
 
-#define MT6363_LDO_L(match, vreg, inp, min, max, step, buck_reg,	\
-		     ocp_intn)						\
+#define MT6363_LDO_L(match, vreg, inp, min, max, step, ocp_intn)	\
 	MT6363_LDO_LINEAR_OPS(match, vreg, inp, mt6363_ldo_linear_ops,	\
-			      min, max, step, buck_reg, ocp_intn)
+			      min, max, step,				\
+			      MT6363_RG_LDO_##vreg##_ADDR,		\
+			      MT6363_RG_LDO_##vreg##_ADDR, ocp_intn)
 
 #define MT6363_LDO_LINEAR_CAL_OPS(match, vreg, in_sup, vops, vrnum,	\
 				  ocp_intn)				\
@@ -754,10 +757,10 @@ static struct mt6363_regulator_info mt6363_regulators[] = {
 	MT6363_LDO_VT("vio0p75", VIO075, "vs1-ldo1", 5, 36),
 	MT6363_LDO_VT("vio18", VIO18, "vs1-ldo2", 3, 35),
 	MT6363_LDO_VT("vm18", VM18, "vs1-ldo1", 4, 40),
-	MT6363_LDO_L("vsram-apu", VSRAM_APU, "vs3-ldo1", 400000, 1193750, 6250, BUCK1, 30),
-	MT6363_LDO_L("vsram-cpub", VSRAM_CPUB, "vs2-ldo1", 400000, 1193750, 6250, BUCK1, 27),
-	MT6363_LDO_L("vsram-cpum", VSRAM_CPUM, "vs2-ldo1", 400000, 1193750, 6250, BUCK1, 28),
-	MT6363_LDO_L("vsram-cpul", VSRAM_CPUL, "vs2-ldo2", 400000, 1193750, 6250, BUCK1, 29),
+	MT6363_LDO_L("vsram-apu", VSRAM_APU, "vs3-ldo1", 400000, 1193750, 6250, 30),
+	MT6363_LDO_L("vsram-cpub", VSRAM_CPUB, "vs2-ldo1", 400000, 1193750, 6250, 27),
+	MT6363_LDO_L("vsram-cpum", VSRAM_CPUM, "vs2-ldo1", 400000, 1193750, 6250, 28),
+	MT6363_LDO_L("vsram-cpul", VSRAM_CPUL, "vs2-ldo2", 400000, 1193750, 6250, 29),
 	MT6363_LDO_L_SC("vsram-digrf", VSRAM_DIGRF, "vs3-ldo1", 400000, 1193750, 6250, BUCK1, 23),
 	MT6363_LDO_L_SC("vsram-mdfe", VSRAM_MDFE, "vs3-ldo1", 400000, 1193750, 6250, BUCK1, 24),
 	MT6363_LDO_L_SC("vsram-modem", VSRAM_MODEM, "vs3-ldo2", 400000, 1193750, 6250, BUCK1, 25),
-- 
2.53.0



