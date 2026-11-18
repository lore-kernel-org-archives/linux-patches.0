Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060501;
	b=gCIcEoqPvhn3f3BNaPo6Ox20oGTCB879t04oJy7ZdAu0wrpbp+WESqcTkxZnv3M9uV/D
	 3eMEB5gT7DIVV0VjA+tRDlwTYSo8OBiz5aRsXEX5vEtTXpc2b7mpJsJFWOQkimxrQt64i
	 6ni/aE3iWOQmjUdfofzGxZX8+kwbIcnVCPKfWTP9ZKTQTWQl3ajMx2o+Kh08RB0beQt0b
	 YrSUILlDDMb4W1ZFTmSfQtvw1d4jZJbYoCKMbB8GRXCaSoYOe6B7zjFUZXixPkknORi4M
	 7UeoKouEzT/X8sc9AYmlDZe5pk76q4ik9DgOAWbJzLt+UZ2lH8j6Vc4tUnvy4Sxdfaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mFAyHGUSBLFkdBqx4AmjPtYDEtQjc1hCopwJ8w4HWw=;
	b=ytNawDLumHzrYUS3fopUvTRIPrWqmp+iqgJoocpvMj0i4jRrRTLEgCc46aDC4u2gPR60
	 OCrOSKGMj4HNxoeHh5kLjUv+pO0F2RFdYCE6FJu3vx2JcQRWDAHvuj8Eq0yCyQjjl81DC
	 B26+DqKAYtpw4WFT0n3fql+j7rY57ik00Bl1OJPuiX97Z8RRJ0ubq9bzKQAFx3mtwZpvn
	 oXEH/iwrW7iJ25O6v6MwwPBkjX3PeA2mbhdFWjVcCJH4SHy1d208OSEWp2VU3RnVjQLkX
	 c4DyA0wPMaqJ5o+/7O08KckJU0dfqMmaA1BdMFh1z/v4IQQjAx9Ha8/JVNt8KEhONDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBIJXnEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94132606A320;
	Thu, 19 Nov 2026 03:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zBIJXnEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67B71F000C4;
	Thu, 19 Nov 2026 03:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060501;
	bh=9mFAyHGUSBLFkdBqx4AmjPtYDEtQjc1hCopwJ8w4HWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBIJXnEQmTr5dlH08w1fMWhxT3GzB5FeZ6VsHXykjS3wpqj08cOpuLCmbdk9BZxhA
	 3sX2sKoMsR9l2r0DAxz+BNjMADRUQoFMgYk2gkWa4Q9NsHHWC/eKdPJqqyhquUJiMZ
	 l8YEDene7M2+O3GYlvqZcfobabeSFGJTFqyAhys0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1221/1848] regulator: ab8500: Add AB8505 VAUX3 3.05 V setting
Date: Wed, 18 Nov 2026 15:54:19 +0100
Message-ID: <20261118150011.063746643@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit ac72c091a9810493ccd9209414d4f859276727ab ]

AB8505 has an additional VAUX3 voltage setting which is not encoded
in the normal three-bit selector. ArmRegu2.Vaux3Sel3 overrides that
selector and selects 3.05 V.

Add the missing voltage and use the override bit as an extended
selector. Program the ordinary selector before clearing the override
so VAUX3 does not briefly switch to a stale voltage.

Reference: AB8505 User Manual, DM00046744 Rev 3, pp. 229 and 254

Fixes: 547f384f33db ("regulator: ab8500: add support for ab8505")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260901-ux500-dts-snowball-regulator-v2-2-fe88b01829bf@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 101 +++++++++++++++++++++++++++++++++++--
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b5307bb5e0342..ae33f05347d67 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -59,6 +59,7 @@ struct ab8500_shared_mode {
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
+ * @expand_register: additional register used to select an extra voltage
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
@@ -79,6 +80,12 @@ struct ab8500_regulator_info {
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
+	struct {
+		u8 voltage_limit;
+		u8 voltage_bank;
+		u8 voltage_reg;
+		u8 voltage_mask;
+	} expand_register;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
@@ -112,6 +119,18 @@ static const unsigned int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
+static const unsigned int ldo_vaux3_ab8505_voltages[] = {
+	1200000,
+	1500000,
+	1800000,
+	2100000,
+	2500000,
+	2750000,
+	2790000,
+	2910000,
+	3050000,
+};
+
 static const unsigned int ldo_vaux56_voltages[] = {
 	1800000,
 	1050000,
@@ -479,6 +498,64 @@ static int ab8500_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
+static int ab8500_regulator_get_voltage_sel_expand(struct regulator_dev *rdev)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+	int ret;
+
+	if (!info)
+		return -EINVAL;
+
+	ret = abx500_get_register_interruptible(info->dev,
+			info->expand_register.voltage_bank,
+			info->expand_register.voltage_reg, &regval);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"couldn't read voltage expand reg for regulator\n");
+		return ret;
+	}
+
+	if (regval & info->expand_register.voltage_mask)
+		return info->expand_register.voltage_limit;
+
+	return ab8500_regulator_get_voltage_sel(rdev);
+}
+
+static int ab8500_regulator_set_voltage_sel_expand(struct regulator_dev *rdev,
+						   unsigned int selector)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	u8 regval;
+	int ret;
+
+	if (!info)
+		return -EINVAL;
+
+	if (selector > info->expand_register.voltage_limit)
+		return -EINVAL;
+
+	if (selector < info->expand_register.voltage_limit) {
+		ret = ab8500_regulator_set_voltage_sel(rdev, selector);
+		if (ret < 0)
+			return ret;
+
+		regval = 0;
+	} else {
+		regval = info->expand_register.voltage_mask;
+	}
+
+	ret = abx500_mask_and_set_register_interruptible(info->dev,
+			info->expand_register.voltage_bank,
+			info->expand_register.voltage_reg,
+			info->expand_register.voltage_mask, regval);
+	if (ret < 0)
+		dev_err(rdev_get_dev(rdev),
+			"couldn't set voltage expand reg for regulator\n");
+
+	return ret;
+}
+
 static const struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
@@ -491,6 +568,18 @@ static const struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.list_voltage		= regulator_list_voltage_table,
 };
 
+static const struct regulator_ops ab8500_regulator_volt_mode_expand_ops = {
+	.enable			= ab8500_regulator_enable,
+	.disable		= ab8500_regulator_disable,
+	.is_enabled		= ab8500_regulator_is_enabled,
+	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
+	.set_mode		= ab8500_regulator_set_mode,
+	.get_mode		= ab8500_regulator_get_mode,
+	.get_voltage_sel	= ab8500_regulator_get_voltage_sel_expand,
+	.set_voltage_sel	= ab8500_regulator_set_voltage_sel_expand,
+	.list_voltage		= regulator_list_voltage_table,
+};
+
 static const struct regulator_ops ab8500_regulator_volt_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
@@ -794,12 +883,12 @@ static struct ab8500_regulator_info
 	[AB8505_LDO_AUX3] = {
 		.desc = {
 			.name		= "LDO-AUX3",
-			.ops		= &ab8500_regulator_volt_mode_ops,
+			.ops		= &ab8500_regulator_volt_mode_expand_ops,
 			.type		= REGULATOR_VOLTAGE,
 			.id		= AB8505_LDO_AUX3,
 			.owner		= THIS_MODULE,
-			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
-			.volt_table	= ldo_vaux3_voltages,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8505_voltages),
+			.volt_table	= ldo_vaux3_ab8505_voltages,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -811,6 +900,12 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
+		.expand_register = {
+			.voltage_limit	= 8,
+			.voltage_bank	= 0x04,
+			.voltage_reg	= 0x01,
+			.voltage_mask	= 0x10,
+		},
 	},
 	[AB8505_LDO_AUX4] = {
 		.desc = {
-- 
2.53.0



