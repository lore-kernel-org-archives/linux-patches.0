Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34734250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301908; cv=none; b=WHHMGFWdarXei/4ZnJKtT188azdRbiMjkxT0vpqTuFvWgXVWihdbz8UCdvIfQz0JGx8jvYEFntJ5Ir8mOThYby1aZaMqcfRoUiXOZ3sOzmT/NSEZbA590IIiBgLN3mIvLSJBB9645C4R1Beww2L4D4HRUAt3jxCN4ONwfw4SjC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301908; c=relaxed/simple;
	bh=oTiSEMciXo5VTGLtJiThDWJxObEcqoTNpkcL0O51Ukk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKt8cfNGkXnvkw5YaQcecx5sKFfy3D1bN1JyFKGBsalNNiz0eKMuC7AvIYZapQLTmkqtkyigf9ih3b2vryeSpQFewtVXE2UBjm+Gj/UrT3jFYMSHF7IDDKdlWLt/NIOyvR1jHNFLL8Y65ExwYoB53AdbrXzWbHWkoP2AQERd8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+ysboCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+ysboCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC46C19424;
	Sat, 28 Feb 2026 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301908;
	bh=oTiSEMciXo5VTGLtJiThDWJxObEcqoTNpkcL0O51Ukk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+ysboCYBZtmpo+ujiSIv2I1Ox3A/XDl1DeVf6NrcyEwMLqcEZBRgsw5Eehn467qz
	 +7Ks5NCj4YzuMngkLLUo9QgCftoG1A4qenhQx0m1Ew7Y2n9cvNmrX63j6BCCJvqgx9
	 5tfM2JgMUGlycXSqWncACmLa+c5g80BuWn2YP65ocNUaEM8Id0VLmfv2mHo+KMNA4N
	 aHX5rh+/j2ahrG/St9g+n+MB14xbv3OkYvGRgqFo86DRuDjQOKP+/dtIwOzBl3Sbh6
	 UpmtLrC597agX/6zC4IsR7fR56ssnmUf/FvRu9NjcH1a2wvOiJWTSuO6AIsEYK5JX3
	 fOsWI2qfe2VWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Elder <elder@riscstar.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/385] mfd: simple-mfd-i2c: Add SpacemiT P1 support
Date: Sat, 28 Feb 2026 12:59:21 -0500
Message-ID: <20260228180011.1568201-339-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alex Elder <elder@riscstar.com>

[ Upstream commit 6fc5d415c10e98ac1b31dd1d5653443e691cdcff ]

Enable support for the RTC and regulators found in the SpacemiT P1
PMIC.  Support is implemented by the simple I2C MFD driver.

The P1 PMIC is normally implemented with the SpacemiT K1 SoC.  This
PMIC provides 6 buck converters and 12 LDO regulators.  It also
implements a switch, watchdog timer, real-time clock, and more.
Initially its RTC and regulators are supported.

Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20250825172057.163883-3-elder@riscstar.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig          | 13 +++++++++++++
 drivers/mfd/simple-mfd-i2c.c | 17 +++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f9325bcce1b94..4c56330b15eda 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1161,6 +1161,19 @@ config MFD_QCOM_RPM
 	  Say M here if you want to include support for the Qualcomm RPM as a
 	  module. This will build a module called "qcom_rpm".
 
+config MFD_SPACEMIT_P1
+	tristate "SpacemiT P1 PMIC"
+	depends on ARCH_SPACEMIT || COMPILE_TEST
+	depends on I2C
+	select I2C_K1
+	select MFD_SIMPLE_MFD_I2C
+	help
+	  This option supports the I2C-based SpacemiT P1 PMIC, which
+	  contains regulators, a power switch, GPIOs, an RTC, and more.
+	  This option is selected when any of the supported sub-devices
+	  is configured.  The basic functionality is implemented by the
+	  simple MFD I2C driver.
+
 config MFD_SPMI_PMIC
 	tristate "Qualcomm SPMI PMICs"
 	depends on ARCH_QCOM || COMPILE_TEST
diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index f7798bd922224..63ac263888606 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -93,6 +93,22 @@ static const struct simple_mfd_data maxim_mon_max77705 = {
 	.mfd_cell_size = ARRAY_SIZE(max77705_sensor_cells),
 };
 
+static const struct regmap_config spacemit_p1_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static const struct mfd_cell spacemit_p1_cells[] = {
+	{ .name = "spacemit-p1-regulator", },
+	{ .name = "spacemit-p1-rtc", },
+};
+
+static const struct simple_mfd_data spacemit_p1 = {
+	.regmap_config = &spacemit_p1_regmap_config,
+	.mfd_cell = spacemit_p1_cells,
+	.mfd_cell_size = ARRAY_SIZE(spacemit_p1_cells),
+};
+
 static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "kontron,sl28cpld" },
 	{ .compatible = "silergy,sy7636a", .data = &silergy_sy7636a},
@@ -101,6 +117,7 @@ static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
 	{ .compatible = "fsl,lx2160aqds-fpga" },
 	{ .compatible = "fsl,ls1028aqds-fpga" },
+	{ .compatible = "spacemit,p1", .data = &spacemit_p1, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0

