Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5440C1272AE;
	Tue, 14 May 2024 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687213; cv=none; b=E2dibom5OCDQdZx3McHxNTqsBSaGgTxoUyUp7unXG88pRM+GqdI2tzfe7ffVE/oqoYfg5XZhBOmhNyl7l6cL0+ojJm9cSKMn2CW7Lhjxq5Ydgfhe4RkfuByBEEK90gaMjyW2PSqfIBgTynvyHH7f+2IewJjgRxB7xBfbekcltwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687213; c=relaxed/simple;
	bh=kOMm5HziVm1BX4A6/dy7i6lmRx57WZXRK0ehpsyijZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWDwfbsn7/Go1G1kypHjpQ1fqJfuA13NplxxOQJNsS9FjEWUWif0oiHWOx0rmZ/HgyrEakEEbqFVFzkTnpqCNSS3oHU4QPm3gFGfgpZaUrk6jBbeTxuPcvvvadLU/hPyChwTRNHhFEn7VfvCfL22ghmcciWVhs7HgDBo5fbKOWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8DZFZcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8DZFZcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDA5C2BD10;
	Tue, 14 May 2024 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687213;
	bh=kOMm5HziVm1BX4A6/dy7i6lmRx57WZXRK0ehpsyijZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8DZFZcKSwfDgAFner0qdJvgjMUl3s0uWguBDea10VehA8qHll1eEnMkg03QY0rIi
	 8YH1tqgjXGgP4i3/EE6vXAMkTJ0pAnUW66sTc8eRgoyMmC2ybs4ttKSFH+rY+fy6PB
	 e0eNBLUPZpaSMtM/rqg9zp0pWTRKF+Td0JleHFoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/111] regulator: mt6360: De-capitalize devicetree regulator subnodes
Date: Tue, 14 May 2024 12:19:17 +0200
Message-ID: <20240514100957.855332357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 15308ee29c13e..e30eb20bc8ea0 100644
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



