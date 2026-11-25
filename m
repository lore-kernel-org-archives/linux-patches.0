Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618142;
	b=b4UAapq1UvaaTRu8Ch4MfjAu0XxvsbCGJT/sFM6aj+SAUwNENMxNyt9smOKlNTrmkifb
	 HP/dWaPlqzn8oFP3SuwARXGUXvLHqUPQfiwW5rv/jifdEWqbQ0dKjROrTVP1+iEgHDlZk
	 RY7wMj3ge9RuPmody5sJ34N3xkxO4i1q6rRHVhsbApbVjWI29HnU5UrVJR3XR2XI1NJzM
	 OJ9B+bSG6NANKUJ/u7klNbo8eEOT3EqtzWuhblfbZcyGxkkq9nLk5pKlkoc2Lti94FvcM
	 vDjBNr1J461QLMQ+icb1+TNXSLk3yd6jx2GQV5wTeX9X/LLf/mn7gV2OfkrWYFY64sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IV4qKU8JXXn+n8IvBBsRKxO+SbYMmjhF1Dzv/pCOYgs=;
	b=ZeiwZcKeW5DuNBk5FkSZf9i1/xx6f9xkn4uXSx/kfaFAWQwb/xzmT1v9WkWWOQXmp2ra
	 8q1AejhIHR1nszSEhjmoHE3bXis9k9GHD4nEo3fPF+sGdtYGhhA6esIrDWE1+nK6JLzJ7
	 8wjIlic9T2I+BtZPE55DMh+sjqlJwzJN/SDyk0fJPyCdoyDXmVT91MuB6R/2r9be5hZf1
	 oQaOvGYfEuoKdrbCwacPZ7Fd4VKHwWlcgE5CSe3IJPiP10osuj0pf7sQQdqkMQvkIbE+u
	 EFOcTBkC8ML9ATMbmIqtDhaRnJC/cxj99Z17rEu7ubQNLSFqDZW/vAHSaAGAIVHh3fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJPXD+V0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A82A606A31E;
	Wed, 25 Nov 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJPXD+V0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DDF1F000C6;
	Wed, 25 Nov 2026 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618141;
	bh=IV4qKU8JXXn+n8IvBBsRKxO+SbYMmjhF1Dzv/pCOYgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJPXD+V0+SD8reQgfMYLuZSIIXWyqgdIjR/Y//iPb0xFr9QkBDXW4una44F0kWLBa
	 hmv21asHUHsli7A+fY34PjFc4psB77aDX0mDB4lnhVVRBprgpSRltfDPMZaAMwct9/
	 pQ4Nbslf/SNivHaz5JHvBT1miPpXJe8EVq9qd+CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0186/1005] regulator: mt6363: Fix VEMC voltage selection
Date: Wed, 25 Nov 2026 15:25:24 +0100
Message-ID: <20261125143826.099908819@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Mergnat <amergnat@baylibre.com>

[ Upstream commit a8d72f246edb9323f6e0ae8283676a323b7847eb ]

VEMC encodes its voltage as a range and a trim value. The custom
getter looks up the range with

	if (rdesc->linear_range_selectors_bitfield[range] != calsel)

so it stops at the first non-matching range and the reported voltage is
wrong for every range setting. With hardware trap 1, the custom getter
and setter apply MT6363_RG_VEMC_VOSEL_1_MASK, the trap 1 range field,
to the trap 0 trim register and keep the trap 0 range field. Voltage
changes are then not applied and the reported voltage does not reflect
the trap 1 settings.

Apart from the trap handling, both callbacks reimplement the regulator
core pickable regmap helpers, which work for VEMC once the descriptor
holds the range field and trim register of the hardware trap. Select
that field and register at probe and use the helpers instead of
fixing the copies. Keep the setter as a wrapper for the TMA unlock
and relock around the write, which the helper does not do. A trap
value other than 0 or 1, or a failed trap read, now fails the probe
instead of the VEMC voltage get and set.

Fixes: 3c36965df808 ("regulator: Add support for MediaTek MT6363 SPMI PMIC Regulators")
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patch.msgid.link/20261102-rgp-67-mt6363-regulator-fixes-v1-2-420789a3113e@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6363-regulator.c       | 120 ++++++---------------
 include/linux/regulator/mt6363-regulator.h |   1 +
 2 files changed, 33 insertions(+), 88 deletions(-)

diff --git a/drivers/regulator/mt6363-regulator.c b/drivers/regulator/mt6363-regulator.c
index 52220117ce249..e6c4bd851fef5 100644
--- a/drivers/regulator/mt6363-regulator.c
+++ b/drivers/regulator/mt6363-regulator.c
@@ -4,7 +4,6 @@
 // Copyright (c) 2025 Collabora Ltd
 //                    AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
 
-#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/devm-helpers.h>
 #include <linux/err.h>
@@ -487,30 +486,7 @@ static int mt6363_vemc_set_voltage_sel(struct regulator_dev *rdev, unsigned int
 {
 	const __le16 tma_unlock_key = cpu_to_le16(MT6363_TMA_UNLOCK_VALUE);
 	const __le16 tma_lock_key = cpu_to_le16(0);
-	const struct regulator_desc *rdesc = rdev->desc;
-	struct regmap *regmap = rdev->regmap;
-	unsigned int range, val;
-	int i, ret;
-	u16 mask;
-
-	for (i = 0; i < rdesc->n_linear_ranges; i++) {
-		const struct linear_range *r = &rdesc->linear_ranges[i];
-		unsigned int voltages_in_range = linear_range_values_in_range(r);
-
-		if (sel < voltages_in_range)
-			break;
-		sel -= voltages_in_range;
-	}
-
-	if (i == rdesc->n_linear_ranges)
-		return -EINVAL;
-
-	ret = regmap_read(rdev->regmap, MT6363_TOP_TRAP, &val);
-	if (ret)
-		return ret;
-
-	if (val > 1)
-		return -EINVAL;
+	int ret;
 
 	/* Unlock TMA for writing */
 	ret = regmap_bulk_write(rdev->regmap, MT6363_TOP_TMA_KEY_L,
@@ -518,30 +494,8 @@ static int mt6363_vemc_set_voltage_sel(struct regulator_dev *rdev, unsigned int
 	if (ret)
 		return ret;
 
-	/* If HW trapping value is 1, use VEMC_VOSEL_1 instead of VEMC_VOSEL_0 */
-	if (val == 1) {
-		mask = MT6363_RG_VEMC_VOSEL_1_MASK;
-		sel = FIELD_PREP(MT6363_RG_VEMC_VOSEL_1_MASK, sel);
-	} else {
-		mask = rdesc->vsel_mask;
-	}
-
-	sel <<= ffs(rdesc->vsel_mask) - 1;
-	sel += rdesc->linear_ranges[i].min_sel;
-
-	range = rdesc->linear_range_selectors_bitfield[i];
-	range <<= ffs(rdesc->vsel_range_mask) - 1;
-
-	/* Write to the vreg calibration register for voltage finetuning */
-	ret = regmap_update_bits(regmap, rdesc->vsel_range_reg,
-				 rdesc->vsel_range_mask, range);
-	if (ret)
-		goto lock_tma;
-
-	/* Function must return the result of this write operation */
-	ret = regmap_update_bits(regmap, rdesc->vsel_reg, mask, sel);
+	ret = regulator_set_voltage_sel_pickable_regmap(rdev, sel);
 
-lock_tma:
 	/* Unconditionally re-lock TMA */
 	regmap_bulk_write(rdev->regmap, MT6363_TOP_TMA_KEY_L,
 			  &tma_lock_key, sizeof(tma_lock_key));
@@ -549,45 +503,6 @@ static int mt6363_vemc_set_voltage_sel(struct regulator_dev *rdev, unsigned int
 	return ret;
 }
 
-static int mt6363_vemc_get_voltage_sel(struct regulator_dev *rdev)
-{
-	const struct regulator_desc *rdesc = rdev->desc;
-	unsigned int vosel, trap, calsel;
-	int vcal, vsel, range, ret;
-
-	ret = regmap_read(rdev->regmap, rdesc->vsel_reg, &vosel);
-	if (ret)
-		return ret;
-
-	ret = regmap_read(rdev->regmap, rdesc->vsel_range_reg, &calsel);
-	if (ret)
-		return ret;
-
-	calsel &= rdesc->vsel_range_mask;
-	for (range = 0; range < rdesc->n_linear_ranges; range++)
-		if (rdesc->linear_range_selectors_bitfield[range] != calsel)
-			break;
-
-	if (range == rdesc->n_linear_ranges)
-		return -EINVAL;
-
-	ret = regmap_read(rdev->regmap, MT6363_TOP_TRAP, &trap);
-	if (ret)
-		return ret;
-
-	/* If HW trapping value is 1, use VEMC_VOSEL_1 instead of VEMC_VOSEL_0 */
-	if (trap > 1)
-		return -EINVAL;
-	else if (trap == 1)
-		vsel = FIELD_GET(MT6363_RG_VEMC_VOSEL_1_MASK, vosel);
-	else
-		vsel = vosel & rdesc->vsel_mask;
-
-	vcal = linear_range_values_in_range_array(rdesc->linear_ranges, range);
-
-	return vsel + vcal;
-}
-
 static int mt6363_va15_set_voltage_sel(struct regulator_dev *rdev, unsigned int sel)
 {
 	struct regmap *regmap = rdev->regmap;
@@ -700,7 +615,7 @@ static const struct regulator_ops mt6363_ldo_vemc_ops = {
 	.list_voltage = regulator_list_voltage_pickable_linear_range,
 	.map_voltage = regulator_map_voltage_pickable_linear_range,
 	.set_voltage_sel = mt6363_vemc_set_voltage_sel,
-	.get_voltage_sel = mt6363_vemc_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_pickable_regmap,
 	.set_voltage_time_sel = regulator_set_voltage_time_sel,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -797,6 +712,30 @@ static int mt6363_backup_op_setting(struct regmap *map, struct mt6363_regulator_
 	return 0;
 }
 
+static int mt6363_vemc_select_bank(struct regmap *map, struct regulator_desc *desc)
+{
+	unsigned int trap;
+	int ret;
+
+	ret = regmap_read(map, MT6363_TOP_TRAP, &trap);
+	if (ret)
+		return ret;
+
+	/* The hardware trap value selects which VEMC voltage controls are used */
+	switch (trap) {
+	case 0:
+		desc->vsel_reg = MT6363_RG_VEMC_VOCAL_ADDR;
+		desc->vsel_range_mask = MT6363_RG_VEMC_VOSEL_MASK;
+		return 0;
+	case 1:
+		desc->vsel_reg = MT6363_RG_VEMC_VOCAL_1_ADDR;
+		desc->vsel_range_mask = MT6363_RG_VEMC_VOSEL_1_MASK;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static void mt6363_irq_remove(void *data)
 {
 	int *virq = data;
@@ -881,6 +820,11 @@ static int mt6363_regulator_probe(struct platform_device *pdev)
 	 */
 	regmap_read(config.regmap, MT6363_TOP_TRAP, &val);
 
+	ret = mt6363_vemc_select_bank(config.regmap,
+				      &mt6363_regulators[MT6363_ID_VEMC].desc);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to select VEMC bank\n");
+
 	interrupt_parent = of_irq_find_parent(dev->of_node);
 	if (!interrupt_parent)
 		return dev_err_probe(dev, -EINVAL, "Cannot find IRQ parent\n");
diff --git a/include/linux/regulator/mt6363-regulator.h b/include/linux/regulator/mt6363-regulator.h
index 60761f01d3ad8..e0d2c01827a7a 100644
--- a/include/linux/regulator/mt6363-regulator.h
+++ b/include/linux/regulator/mt6363-regulator.h
@@ -138,6 +138,7 @@
 #define MT6363_RG_LDO_VSRAM_APU_VOSEL_ADDR	0x1b17
 #define MT6363_RG_LDO_VSRAM_APU_VOSEL_MASK	GENMASK(6, 0)
 #define MT6363_RG_VEMC_VOCAL_ADDR		0x1b1b
+#define MT6363_RG_VEMC_VOCAL_1_ADDR		0x1b1c
 #define MT6363_RG_VEMC_VOCAL_MASK		GENMASK(3, 0)
 #define MT6363_RG_LDO_VCN15_ADDR		0x1b57
 #define MT6363_RG_LDO_VCN15_EN_BIT		0
-- 
2.53.0



