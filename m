Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30600338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301765; cv=none; b=br2tlEcRN/8Ca+MtSXCc4UPXMVQoG6iuSawZXPsaqRINaZLVv/kjh+Ti3reWT9C6bxxEDPi0F7jBWmBvI3yg1H8zHdvSdUHs1Cw0kkyM9XAXw0p3SfeCLqoJKqYP16QhS68iaiosyFzQ9O9k0z7PIVBVynk9snphXPkgHF8p1Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301765; c=relaxed/simple;
	bh=F3J8DqO5P6bSfufw2BS0VY0JFaD6ce6AMvRDAOyVaqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gm28IkCegRlo4kHqrufG4c7jfxQNwOeM3+TfqYIQKiwRD7K5sTyL5tIP38iz+1ArkPV0tCD3fPCd5wnQlD4sgR56vGudkBOZOpG5vm6iSzXcXj3DUkQByKDXU3IIsivlkr585a1BWBVC4DcCC9bavtK7tZ2hICW73xlJ7VFDAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YM6/8z9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YM6/8z9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC6C19424;
	Sat, 28 Feb 2026 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301765;
	bh=F3J8DqO5P6bSfufw2BS0VY0JFaD6ce6AMvRDAOyVaqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM6/8z9Gax5Jsx1+XDUwMpEP2GG5KFxGQpkmZY8JYHgVWVaBEshlON+FZ3Mam2Rg3
	 EN6vI6AeHk5aWAEws11fkNGCPI4acqqf778KoXdjeOaINtY8a/rsThXtTCljo+Br8P
	 CdhCgdtQro7Y37djRCiYrJLcDYfIsLBNNtf/uVnZ06MTC0ji7SA+SWZB8tCzP+7TOB
	 A9FXRBw2rj4BrTsq7BZ0qjN6tQhsMIAvnBFJuKannBFaG/AON+eB8IcEfovJzYEnCp
	 RVEe8dXl2HblKzQq192CKpMxatcTRCmxY8k+NywsIjXDXev7AxduO9F1YpXeGQrfOc
	 2R4wrNSrgmnVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pawel Dembicki <paweldembicki@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/385] hwmon: pmbus: mpq8785: Add support for MPM82504
Date: Sat, 28 Feb 2026 12:56:33 -0500
Message-ID: <20260228180011.1568201-171-sashal@kernel.org>
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

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit c27291468eb957b11dc81cd35fad36faf0861c07 ]

Add support for the Monolithic Power Systems MPM82504 digital voltage
regulator. MPM82504 uses PMBus direct format for voltage output.

Tested with device tree based matching.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Link: https://lore.kernel.org/r/20250511035701.2607947-5-paweldembicki@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 9e33c1dba224 ("hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/mpq8785.rst | 20 +++++++++++++++-----
 drivers/hwmon/pmbus/mpq8785.c   | 29 ++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/mpq8785.rst b/Documentation/hwmon/mpq8785.rst
index bf8176b870868..b91fefb1a84cd 100644
--- a/Documentation/hwmon/mpq8785.rst
+++ b/Documentation/hwmon/mpq8785.rst
@@ -5,6 +5,7 @@ Kernel driver mpq8785
 
 Supported chips:
 
+  * MPS MPM82504
   * MPS MPQ8785
 
     Prefix: 'mpq8785'
@@ -14,6 +15,14 @@ Author: Charles Hsu <ythsu0511@gmail.com>
 Description
 -----------
 
+The MPM82504 is a quad 25A, scalable, fully integrated power module with a PMBus
+interface. The device offers a complete power solution that achieves up to 25A
+per output channel. The MPM82504 has four output channels that can be paralleled
+to provide 50A, 75A, or 100A of output current for flexible configurations.
+The device can also operate in parallel with the MPM3695-100 and additional
+MPM82504 devices to provide a higher output current. The MPM82504 operates
+at high efficiency across a wide load range.
+
 The MPQ8785 is a fully integrated, PMBus-compatible, high-frequency, synchronous
 buck converter. The MPQ8785 offers a very compact solution that achieves up to
 40A output current per phase, with excellent load and line regulation over a
@@ -23,18 +32,19 @@ output current load range.
 The PMBus interface provides converter configurations and key parameters
 monitoring.
 
-The MPQ8785 adopts MPS's proprietary multi-phase digital constant-on-time (MCOT)
+The devices adopts MPS's proprietary multi-phase digital constant-on-time (MCOT)
 control, which provides fast transient response and eases loop stabilization.
-The MCOT scheme also allows multiple MPQ8785 devices to be connected in parallel
-with excellent current sharing and phase interleaving for high-current
+The MCOT scheme also allows multiple devices or channels to be connected in
+parallel with excellent current sharing and phase interleaving for high-current
 applications.
 
 Fully integrated protection features include over-current protection (OCP),
 over-voltage protection (OVP), under-voltage protection (UVP), and
 over-temperature protection (OTP).
 
-The MPQ8785 requires a minimal number of readily available, standard external
-components, and is available in a TLGA (5mmx6mm) package.
+All supported modules require a minimal number of readily available, standard
+external components. The MPM82504 is available in a BGA (15mmx30mmx5.18mm)
+package and the MPQ8785 is available in a TLGA (5mmx6mm) package.
 
 Device compliant with:
 
diff --git a/drivers/hwmon/pmbus/mpq8785.c b/drivers/hwmon/pmbus/mpq8785.c
index 1f13959c381eb..c8343fee38d9a 100644
--- a/drivers/hwmon/pmbus/mpq8785.c
+++ b/drivers/hwmon/pmbus/mpq8785.c
@@ -4,14 +4,18 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/of_device.h>
 #include "pmbus.h"
 
-enum chips { mpq8785 };
+#define MPM82504_READ_TEMPERATURE_1_SIGN_POS	9
+
+enum chips { mpm82504, mpq8785 };
 
 static u16 voltage_scale_loop_max_val[] = {
+	[mpm82504] = GENMASK(9, 0),
 	[mpq8785] = GENMASK(10, 0),
 };
 
@@ -41,6 +45,20 @@ static int mpq8785_identify(struct i2c_client *client,
 	return 0;
 };
 
+static int mpm82504_read_word_data(struct i2c_client *client, int page,
+				   int phase, int reg)
+{
+	int ret;
+
+	ret = pmbus_read_word_data(client, page, phase, reg);
+
+	if (ret < 0 || reg != PMBUS_READ_TEMPERATURE_1)
+		return ret;
+
+	/* Fix PMBUS_READ_TEMPERATURE_1 signedness */
+	return sign_extend32(ret, MPM82504_READ_TEMPERATURE_1_SIGN_POS) & 0xffff;
+}
+
 static struct pmbus_driver_info mpq8785_info = {
 	.pages = 1,
 	.format[PSC_VOLTAGE_IN] = direct,
@@ -63,12 +81,14 @@ static struct pmbus_driver_info mpq8785_info = {
 };
 
 static const struct i2c_device_id mpq8785_id[] = {
+	{ "mpm82504", mpm82504 },
 	{ "mpq8785", mpq8785 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, mpq8785_id);
 
 static const struct of_device_id __maybe_unused mpq8785_of_match[] = {
+	{ .compatible = "mps,mpm82504", .data = (void *)mpm82504 },
 	{ .compatible = "mps,mpq8785", .data = (void *)mpq8785 },
 	{}
 };
@@ -92,6 +112,13 @@ static int mpq8785_probe(struct i2c_client *client)
 		chip_id = (kernel_ulong_t)i2c_get_match_data(client);
 
 	switch (chip_id) {
+	case mpm82504:
+		info->format[PSC_VOLTAGE_OUT] = direct;
+		info->m[PSC_VOLTAGE_OUT] = 8;
+		info->b[PSC_VOLTAGE_OUT] = 0;
+		info->R[PSC_VOLTAGE_OUT] = 2;
+		info->read_word_data = mpm82504_read_word_data;
+		break;
 	case mpq8785:
 		info->identify = mpq8785_identify;
 		break;
-- 
2.51.0

