Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A3433BE;
	Tue, 14 May 2024 10:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682158; cv=none; b=d6g/n8NSeDZnsI3QAUwV7xzil/0Mqi/NresrQZ5uySKp6/5vfWXqZyuoEfj65SWsD+8nL8BoyBYwKxotqA+LJYMQptDBCzCgZCWpRtmF5sdtI+sma7KMa29thuJbIaK/I1umLjS/fIT/doyHJcUjKB23CDj3SCVv6nOZgt7KXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682158; c=relaxed/simple;
	bh=sXgS5DkBELma/Hk+aTyJn0jh4bKaszCfKOoGcjzqiCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVzcRNpSKYJu1uXL35ZVmzWVZO1yMamRgjPl9ztqy9F1gADNbMUTFDNDTVoSIvEAxAy9zXLVJAzvx3SdcjpoUiPTuE7gMVcaXrrev7egR6yltr69BgN31da0+7r+e/ik7PtLw7rN97IP8t8d5eNKf5CPrJ0lnY08//sEqPy5dIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrJzzxDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrJzzxDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB4C2BD10;
	Tue, 14 May 2024 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682158;
	bh=sXgS5DkBELma/Hk+aTyJn0jh4bKaszCfKOoGcjzqiCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrJzzxDif/NfIvwrxCUwj4Ago5kUtymquaoCD2KBvYrO+XbIz6LQFO2Kd8sKStDR3
	 SJcoG8VTm09ecCKyx/Gt5gj6Nu5wOzkfunt+rVu63WMvqLSlSFamSVXKfjYOnTAErI
	 DnTfaCXJbZkf7fEbfIpQXGht0uTK8/AfJZXcwuPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/336] regulator: mt6360: De-capitalize devicetree regulator subnodes
Date: Tue, 14 May 2024 12:13:46 +0200
Message-ID: <20240514101039.444874565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit d3cf8a17498dd9104c04ad28eeac3ef3339f9f9f ]

The MT6360 regulator binding, the example in the MT6360 mfd binding, and
the devicetree users of those bindings are rightfully declaring MT6360
regulator subnodes with non-capital names, and luckily without using the
deprecated regulator-compatible property.

With this driver declaring capitalized BUCKx/LDOx as of_match string for
the node names, obviously no regulator gets probed: fix that by changing
the MT6360_REGULATOR_DESC macro to add a "match" parameter which gets
assigned to the of_match.

Fixes: d321571d5e4c ("regulator: mt6360: Add support for MT6360 regulator")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://msgid.link/r/20240409144438.410060-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6360-regulator.c | 32 +++++++++++++++++-----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/mt6360-regulator.c b/drivers/regulator/mt6360-regulator.c
index ad6587a378d09..24cc9fc94e900 100644
--- a/drivers/regulator/mt6360-regulator.c
+++ b/drivers/regulator/mt6360-regulator.c
@@ -319,15 +319,15 @@ static unsigned int mt6360_regulator_of_map_mode(unsigned int hw_mode)
 	}
 }
 
-#define MT6360_REGULATOR_DESC(_name, _sname, ereg, emask, vreg,	vmask,	\
-			      mreg, mmask, streg, stmask, vranges,	\
-			      vcnts, offon_delay, irq_tbls)		\
+#define MT6360_REGULATOR_DESC(match, _name, _sname, ereg, emask, vreg,	\
+			      vmask, mreg, mmask, streg, stmask,	\
+			      vranges, vcnts, offon_delay, irq_tbls)	\
 {									\
 	.desc = {							\
 		.name = #_name,						\
 		.supply_name = #_sname,					\
 		.id =  MT6360_REGULATOR_##_name,			\
-		.of_match = of_match_ptr(#_name),			\
+		.of_match = of_match_ptr(match),			\
 		.regulators_node = of_match_ptr("regulator"),		\
 		.of_map_mode = mt6360_regulator_of_map_mode,		\
 		.owner = THIS_MODULE,					\
@@ -351,21 +351,29 @@ static unsigned int mt6360_regulator_of_map_mode(unsigned int hw_mode)
 }
 
 static const struct mt6360_regulator_desc mt6360_regulator_descs[] =  {
-	MT6360_REGULATOR_DESC(BUCK1, BUCK1_VIN, 0x117, 0x40, 0x110, 0xff, 0x117, 0x30, 0x117, 0x04,
+	MT6360_REGULATOR_DESC("buck1", BUCK1, BUCK1_VIN,
+			      0x117, 0x40, 0x110, 0xff, 0x117, 0x30, 0x117, 0x04,
 			      buck_vout_ranges, 256, 0, buck1_irq_tbls),
-	MT6360_REGULATOR_DESC(BUCK2, BUCK2_VIN, 0x127, 0x40, 0x120, 0xff, 0x127, 0x30, 0x127, 0x04,
+	MT6360_REGULATOR_DESC("buck2", BUCK2, BUCK2_VIN,
+			      0x127, 0x40, 0x120, 0xff, 0x127, 0x30, 0x127, 0x04,
 			      buck_vout_ranges, 256, 0, buck2_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO6, LDO_VIN3, 0x137, 0x40, 0x13B, 0xff, 0x137, 0x30, 0x137, 0x04,
+	MT6360_REGULATOR_DESC("ldo6", LDO6, LDO_VIN3,
+			      0x137, 0x40, 0x13B, 0xff, 0x137, 0x30, 0x137, 0x04,
 			      ldo_vout_ranges1, 256, 0, ldo6_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO7, LDO_VIN3, 0x131, 0x40, 0x135, 0xff, 0x131, 0x30, 0x131, 0x04,
+	MT6360_REGULATOR_DESC("ldo7", LDO7, LDO_VIN3,
+			      0x131, 0x40, 0x135, 0xff, 0x131, 0x30, 0x131, 0x04,
 			      ldo_vout_ranges1, 256, 0, ldo7_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO1, LDO_VIN1, 0x217, 0x40, 0x21B, 0xff, 0x217, 0x30, 0x217, 0x04,
+	MT6360_REGULATOR_DESC("ldo1", LDO1, LDO_VIN1,
+			      0x217, 0x40, 0x21B, 0xff, 0x217, 0x30, 0x217, 0x04,
 			      ldo_vout_ranges2, 256, 0, ldo1_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO2, LDO_VIN1, 0x211, 0x40, 0x215, 0xff, 0x211, 0x30, 0x211, 0x04,
+	MT6360_REGULATOR_DESC("ldo2", LDO2, LDO_VIN1,
+			      0x211, 0x40, 0x215, 0xff, 0x211, 0x30, 0x211, 0x04,
 			      ldo_vout_ranges2, 256, 0, ldo2_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO3, LDO_VIN1, 0x205, 0x40, 0x209, 0xff, 0x205, 0x30, 0x205, 0x04,
+	MT6360_REGULATOR_DESC("ldo3", LDO3, LDO_VIN1,
+			      0x205, 0x40, 0x209, 0xff, 0x205, 0x30, 0x205, 0x04,
 			      ldo_vout_ranges2, 256, 100, ldo3_irq_tbls),
-	MT6360_REGULATOR_DESC(LDO5, LDO_VIN2, 0x20B, 0x40, 0x20F, 0x7f, 0x20B, 0x30, 0x20B, 0x04,
+	MT6360_REGULATOR_DESC("ldo5", LDO5, LDO_VIN2,
+			      0x20B, 0x40, 0x20F, 0x7f, 0x20B, 0x30, 0x20B, 0x04,
 			      ldo_vout_ranges3, 128, 100, ldo5_irq_tbls),
 };
 
-- 
2.43.0



