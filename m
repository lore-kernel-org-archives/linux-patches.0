Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060849;
	b=Po8uaKB0TmcsqjGBwZrRBaa1BDYOija01gzdZFpIce5Ropvs1RlvzNpP5uQzDzP6W7R0
	 KD2mHRzjniXUS1avnWXl8Pk1AsA1FQzmzXBz5haMHNthaDJ2MGiFUSAJWe2kJlEP5b579
	 OQldIfiIzzsX2cxscSMkvz9czDNeSbIcwoIMcwZE3F7H1ZhK33535CdOn9izgzmHTYwOL
	 hVmzLSqCBBbT6/NjUhPMtbe1SFAnH5/7YU+AcNAuWNCBOWGvTqme5Lrqfb7M3MK4lvfFB
	 aN6UUdtryYuOrcdHmG6JgtawxlWVTsMUswHxdTWAUuX0pEFLE3jYK54KUARFbVcVJrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X5A/m2HJaghPtz/284z6INV7jwkGtP1yKsB9Zv7s0OA=;
	b=ctDB/7awiceKRAdBw1Eldg8Sbs4PpeBLRornIZflseSUMoUYY/goyWMSTCOY0tQwpmwC
	 Ybk5tr0s8ztMwXvIXlcJLpg6MCOyQsVKVmCla8wHVN5PbTFQdHWLEjytN08HSF/Oo/nET
	 TdTWugK9xax5pQST4A6sgQ2lGQ/g0absNZEG5tcRGRFLvykvidCeAVeyRpeObtGs2tZDK
	 1iehkhKq2tMuio/bo8Et3gaMrxpRPGbd2lbGEd9cv5GahXpNdAUUeFNcZT3p9e1WaGhFg
	 nBe8muHEMKKT1lBlqrabah3bsqInmHBNaSgNFV0u/zbZ3DU0imNYGSFofzq0gJHNoJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+XJx9j3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E101606A320;
	Thu, 19 Nov 2026 04:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+XJx9j3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25B21F000C4;
	Thu, 19 Nov 2026 04:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060849;
	bh=X5A/m2HJaghPtz/284z6INV7jwkGtP1yKsB9Zv7s0OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+XJx9j3nxXS79X1tkvZHQz2XqXQ8WkSe24gBkApJ/iSY9w4Nhot5XNB9OcZdjL1j
	 o5kIupB+e84vnIxQM/xarSOBOUigR0gXHWYInrlwFg51qmhGSwdyZCZ9xjs1aS714s
	 gJKjlCC+VJ5bn8BPM1n8xgzKGcwqbfz4GkcC93lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=205=2E10=201329/1848=5D=20=3D=3FUTF-8=3Fq=3Fmfd=3A=3D20intel=3D5Fquark=3D5Fi2c=3D5Fgpio=3A=3D20Replace=3D20I=3DC2=3DB2C=3F=3D=20=3D=3FUTF-8=3Fq=3F=3D20speeds=3D20with=3D20descriptive=3D20definitions=3F=3D?=
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150015.392074926@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 10d82ade4fa7dd032b60fc6ba76cd587b276608e ]

I²C header provides a descriptive definitions for standard bus speeds.
Use them instead of plain numbers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 76743fdc69861..b0e1b1e0df256 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -16,6 +16,7 @@
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/dmi.h>
+#include <linux/i2c.h>
 #include <linux/platform_data/gpio-dwapb.h>
 #include <linux/platform_data/i2c-designware.h>
 
@@ -54,19 +55,19 @@ static const struct dmi_system_id dmi_platform_info[] = {
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Galileo"),
 		},
-		.driver_data = (void *)100000,
+		.driver_data = (void *)I2C_MAX_STANDARD_MODE_FREQ,
 	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
 		},
-		.driver_data = (void *)400000,
+		.driver_data = (void *)I2C_MAX_FAST_MODE_FREQ,
 	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
 		},
-		.driver_data = (void *)400000,
+		.driver_data = (void *)I2C_MAX_FAST_MODE_FREQ,
 	},
 	{}
 };
@@ -174,7 +175,7 @@ static int intel_quark_i2c_setup(struct pci_dev *pdev, struct mfd_cell *cell)
 		return -ENOMEM;
 
 	/* Normal mode by default */
-	pdata->i2c_scl_freq = 100000;
+	pdata->i2c_scl_freq = I2C_MAX_STANDARD_MODE_FREQ;
 
 	dmi_id = dmi_first_match(dmi_platform_info);
 	if (dmi_id)
-- 
2.53.0



