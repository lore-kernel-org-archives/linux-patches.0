Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060343;
	b=SU6FKQjtCH55LM/LuEDeAdTNYJT0E9Punh3xMhxOpde/UX6U2RLinS4N+7+XZh/rS9+L
	 5mAV/UaROw2VFxy9owsf0OGxDHM6xu9fii2x/lC2/nnfYBdGMeUrV+mrcNyOnAaOIiSoc
	 0KNKP1dveyXdZb3XzDKFkDH6qV+EQhcnzXAzoqIgzRKcdTK95S5HN/gEueOF1UbuEiO+z
	 PvamxFVwyg/g1ySrUlVghrGIddPErcXZb8r9HEFUFiXLskcYrNpsQ5mrhEi8akn6Kds6+
	 eSmlgM9kqeaamUALu1CCTi8a3PnOwP2Kba7sjiBDnpQyjKYPI2PvnwLKp2dJlx47q0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2cXlznvwnfQZ1IX5ls/WOd6jTHiHWjoVeQCL2Th+3gM=;
	b=az/v/MrjD75NER6xhgkp70VKhWY3Suz18M/Z/9McuOiiqtLTzPC/XelhloX28Eh9NTLV
	 F58tXCXCdS29lDOQPVjCyDDacLggwer3PKBClzspySKfqVaVyrb91vZ3WH5XgUj1IxN/G
	 jUYOS+7q57vduMsz3deWOJEy+4dMJ4v0Ao5RFxlDANJ+jjPY+z5vxVpcxt9cfiJhUV5tX
	 kiuvG4UVMFSLmm3/L1RX18YfNLe6zvlA6dDWOzLxrWByq9Ft57X7cgXSSoFcUYxXMgeG+
	 Axxd3e27HN+0eoO0fI6D4np+6++/bQ3a9QHdji2ptZzZEl5NwN0vSDU+YBS+XdUnLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsnhOyms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96D606A320;
	Thu, 19 Nov 2026 03:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsnhOyms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F791F000C5;
	Thu, 19 Nov 2026 03:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060343;
	bh=2cXlznvwnfQZ1IX5ls/WOd6jTHiHWjoVeQCL2Th+3gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsnhOymsgq8hay562YxNAACeCGJIOnImEgAZXnd5U3TiOYZqafiG1DNlfHVhsD4vy
	 O+FUKG0StK7rz3A1Rl5efuCcBNEMwpWHS5Ly4OEIVC1xEPr6FSF1tqa1WbTaHSxfvp
	 2zwlhqjbvDZ/U5GvRyztzpJGwnIZDeYT4RI/nRrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Lin <axel.lin@ingics.com>,
	Mark Brown <broonie@sirena.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1166/1848] regulator: mp886x: Convert to use regulator_set_ramp_delay_regmap
Date: Wed, 18 Nov 2026 15:53:24 +0100
Message-ID: <20261118150008.471014980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit e1e8d55bb90c9a07aa66a0c9fa17bd5a67d2689c ]

Use regulator_set_ramp_delay_regmap instead of open-coded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Message-Id: <20210525102708.2519323-1-axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Stable-dep-of: 24fa0eadc2e3 ("regulator: mp886x: fix vsel_mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index a84fd74081de8..8ad4722eca4b3 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -26,7 +26,7 @@
 
 struct mp886x_cfg_info {
 	const struct regulator_ops *rops;
-	const int slew_rates[8];
+	const unsigned int slew_rates[8];
 	const int switch_freq[4];
 	const u8 fs_reg;
 	const u8 fs_shift;
@@ -42,28 +42,6 @@ struct mp886x_device_info {
 	unsigned int sel;
 };
 
-static int mp886x_set_ramp(struct regulator_dev *rdev, int ramp)
-{
-	struct mp886x_device_info *di = rdev_get_drvdata(rdev);
-	const struct mp886x_cfg_info *ci = di->ci;
-	int reg = -1, i;
-
-	for (i = 0; i < ARRAY_SIZE(ci->slew_rates); i++) {
-		if (ramp <= ci->slew_rates[i])
-			reg = i;
-		else
-			break;
-	}
-
-	if (reg < 0) {
-		dev_err(di->dev, "unsupported ramp value %d\n", ramp);
-		return -EINVAL;
-	}
-
-	return regmap_update_bits(rdev->regmap, MP886X_SYSCNTLREG1,
-				  MP886X_SLEW_MASK, reg << MP886X_SLEW_SHIFT);
-}
-
 static void mp886x_set_switch_freq(struct mp886x_device_info *di,
 				   struct regmap *regmap,
 				   u32 freq)
@@ -169,7 +147,7 @@ static const struct regulator_ops mp8869_regulator_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.set_mode = mp886x_set_mode,
 	.get_mode = mp886x_get_mode,
-	.set_ramp_delay = mp886x_set_ramp,
+	.set_ramp_delay = regulator_set_ramp_delay_regmap,
 };
 
 static const struct mp886x_cfg_info mp8869_ci = {
@@ -248,7 +226,7 @@ static const struct regulator_ops mp8867_regulator_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.set_mode = mp886x_set_mode,
 	.get_mode = mp886x_get_mode,
-	.set_ramp_delay = mp886x_set_ramp,
+	.set_ramp_delay = regulator_set_ramp_delay_regmap,
 };
 
 static const struct mp886x_cfg_info mp8867_ci = {
@@ -290,6 +268,10 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
 	rdesc->vsel_mask = 0x3f;
+	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
+	rdesc->ramp_mask = MP886X_SLEW_MASK;
+	rdesc->ramp_delay_table = di->ci->slew_rates;
+	rdesc->n_ramp_values = ARRAY_SIZE(di->ci->slew_rates);
 	rdesc->owner = THIS_MODULE;
 
 	rdev = devm_regulator_register(di->dev, &di->desc, config);
-- 
2.53.0



