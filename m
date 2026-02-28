Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5465433F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301173; cv=none; b=XsVnpc9iiDm79qY/EwfrzcbalQPR3fYfvTOfkXvCe5Pfqz7IqX1/y4e6yDWAKCo+mDXzARehFjHqlHnvJ3pDYSh6zFN/8XtBB3nyGubxkvx7LhoZ58b+qXZhDe9SvoT/NCSD0Q6luuv9POE31PNZWv09OrWrsYLSMvmsBWNjKso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301173; c=relaxed/simple;
	bh=TZJLHA1ruZzfEsUVx0wbMMbI14TZoKcsi1pdmpeNt4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUeuBA1TAv2T0CGNvcCMK5eYtnmMsuDOTEI0tU5EtNTQjIXCDsXXKRTSmx8kYRXU7Ex+0PPQ6QjuE4zue4QmP8GE2IYNtjrL4prrQoklNy0zhXgwIzGOS7CuoSI6Avb9m+dFp+uw7hcN0p0BiZTArrdrRFploOOb1g8RscAoO0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tc0auUhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tc0auUhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEEEC19424;
	Sat, 28 Feb 2026 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301173;
	bh=TZJLHA1ruZzfEsUVx0wbMMbI14TZoKcsi1pdmpeNt4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tc0auUhisrqdfdIl/FPVfPcT1Bwz0A3+bcChSCTU35eNqTqHLWnvc8bN1JagjJJcb
	 XWCQ5D2UZ43eXLakJcTap+wyGP9goMFVIuYplgTXGhvzQQGhg6/DJoJ7/ZAU8aZS7b
	 QF/EZmyY9ZdIt7SMWE7xdo7W113DpzBWp/gF2mZwLv4o5mIwt4Mne+veOAO6Yk1eFH
	 V7iYLpr/mFHsX9KWi7H4sSIuUI5AvB8TKeYoz4ce8Ri8sR7IlY3Coih1nKLg8D4giz
	 ttiFhC5dggt322LXMKKFCFMakeqQ8euQs6FCY6lmP9FMkXrUKepkFL7cXwS4ON3KrR
	 XpbJIR4SC/XGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Derek J. Clark" <derekjohn.clark@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 340/752] iio: bmi270_i2c: Add MODULE_DEVICE_TABLE for BMI260/270
Date: Sat, 28 Feb 2026 12:40:51 -0500
Message-ID: <20260228174750.1542406-340-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Derek J. Clark" <derekjohn.clark@gmail.com>

[ Upstream commit f69b5ac682dbc61e6aca806c22ce2ae74d598e45 ]

Currently BMI260 & BMI270 devices do not automatically load this
driver. To fix this, add missing MODULE_DEVICE_TABLE for the i2c,
acpi, and of device tables so the driver will load when the hardware
is detected.

Tested on my OneXPlayer F1 Pro.

Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bmi270/bmi270_i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/imu/bmi270/bmi270_i2c.c b/drivers/iio/imu/bmi270/bmi270_i2c.c
index b909a421ad017..b92da4e0776fa 100644
--- a/drivers/iio/imu/bmi270/bmi270_i2c.c
+++ b/drivers/iio/imu/bmi270/bmi270_i2c.c
@@ -37,6 +37,7 @@ static const struct i2c_device_id bmi270_i2c_id[] = {
 	{ "bmi270", (kernel_ulong_t)&bmi270_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, bmi270_i2c_id);
 
 static const struct acpi_device_id bmi270_acpi_match[] = {
 	/* GPD Win Mini, Aya Neo AIR Pro, OXP Mini Pro, etc. */
@@ -45,12 +46,14 @@ static const struct acpi_device_id bmi270_acpi_match[] = {
 	{ "BMI0260",  (kernel_ulong_t)&bmi260_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(acpi, bmi270_acpi_match);
 
 static const struct of_device_id bmi270_of_match[] = {
 	{ .compatible = "bosch,bmi260", .data = &bmi260_chip_info },
 	{ .compatible = "bosch,bmi270", .data = &bmi270_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, bmi270_of_match);
 
 static struct i2c_driver bmi270_i2c_driver = {
 	.driver = {
-- 
2.51.0

