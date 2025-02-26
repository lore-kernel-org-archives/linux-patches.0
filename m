Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AA421C9E8
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740586409; cv=none; b=Q1Kj4K5QVdMdEshyfCU0U5yr8zRM+uda20YAyQLO0wdE+m+ghMoo1OxV2EjIeA1lLwN4rACDbHA+KyiS9xBGKqUmJMt5A1titGwn9JDpXJDjH70VqpSJGDHdp30hm8eQO+SqCDXVHeQMlDdg3P+wg/kh5LfqFliFSnFtO0run6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740586409; c=relaxed/simple;
	bh=AIa07tIosd2Q/2NEoeR7hFtxOIpGbJrJEPR0A/jih34=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=Y2m7t4Y6+SwiXjLReLokk2r+qVtUBL2JjCjAsPGUEuT+GNkDgxcYjSHrUjIIeItk24Ks1zqcRsR2R/51Bnq/mH0fqGjBBPOAFSckaSU0o6dpJzy6tmeulyA1QfDBwFjVd72bS3m5nb1jPVCIusXiSvoHMS7ErA1ZHpp3FnnDHew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tx9qgFTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tx9qgFTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B795C4CED6
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 16:13:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tx9qgFTf"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 26 Feb 2025 16:13:25 +0000
Resent-Message-ID: <Z789pYzxFPbHImnU@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 26 Feb 2025 14:44:29 +0000
Received: from tor.source.kernel.org ([2600:3c04::f03c:95ff:fe5e:7468])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=w8x5=VR=ti.com=baojun.xu@kernel.org>)
	id 1tnIeA-00G4Te-QM
	for broonie@sirena.co.uk; Wed, 26 Feb 2025 14:44:29 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 281586123C
	for <broonie@sirena.co.uk>; Wed, 26 Feb 2025 14:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B7407C4CEE4; Wed, 26 Feb 2025 14:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FC95C4CED6
	for <broonie@kernel.org>; Wed, 26 Feb 2025 14:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 0FC95C4CED6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=ti.com
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 51QEhvEr2100790
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 08:43:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1740581037;
	bh=/wxTwVL29KQhkgsTJJ0gr+cFwivRLGhTw6aMtsW1W0M=;
	h=From:To:CC:Subject:Date;
	b=tx9qgFTfAYPyyzBRUiUVoPKFb2ARIkEtiNw9Z3jtv/wG/il5lXKvruQE1/phkiFyq
	 VBRzYCMJcIvxFZ9oCcyp+ll0zFAMnUxf+mCSDcxtJ9C9T7yx61PfclBTSr07PJuv5q
	 fjpxE0dE+xLjHwFG6K1RPnuWmuWDJ9dmWnEq3rOg=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 51QEhvCR092538
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 26 Feb 2025 08:43:57 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Feb 2025 08:43:56 -0600
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 26 Feb 2025 08:43:57 -0600
Received: from lelvsmtp6.itg.ti.com ([10.250.165.138])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 51QEhrsp103598;
	Wed, 26 Feb 2025 08:43:54 -0600
From: Baojun Xu <baojun.xu@ti.com>
To: <broonie@kernel.org>, <tiwai@suse.de>
CC: <andriy.shevchenko@linux.intel.com>, <13916275206@139.com>,
        <alsa-devel@alsa-project.org>, <shenghao-ding@ti.com>,
        <baojun.xu@ti.com>
Date: Wed, 26 Feb 2025 22:43:28 +0800
Message-ID: <20250226144328.11645-1-baojun.xu@ti.com>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-SA-Exim-Connect-IP: 2600:3c04::f03c:95ff:fe5e:7468
X-SA-Exim-Mail-From: SRS0=w8x5=VR=ti.com=baojun.xu@kernel.org
Subject: [PATCH v1] ASoC: tas2781: Clean up for some define
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: CwNsrROQ38kS

Do some clean up for some define in header file.
Like change lower case in value, up case in define,
space add in recommends, change date of files and add author.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
---
 include/sound/tas2781.h           | 21 +++++++++++----------
 sound/soc/codecs/tas2781-fmwlib.c |  7 ++++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index 72d2060904f6..a2c8eb111e5f 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -2,7 +2,7 @@
 //
 // ALSA SoC Texas Instruments TAS2563/TAS2781 Audio Smart Amplifier
 //
-// Copyright (C) 2022 - 2024 Texas Instruments Incorporated
+// Copyright (C) 2022 - 2025 Texas Instruments Incorporated
 // https://www.ti.com
 //
 // The TAS2563/TAS2781 driver implements a flexible and configurable
@@ -11,6 +11,7 @@
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
 // Author: Kevin Lu <kevin-lu@ti.com>
+// Author: Baojun Xu <baojun.xu@ti.com>
 //
 
 #ifndef __TAS2781_H__
@@ -31,7 +32,7 @@
 	SNDRV_PCM_FMTBIT_S24_LE | \
 	SNDRV_PCM_FMTBIT_S32_LE)
 
-/*PAGE Control Register (available in page0 of each book) */
+/* PAGE Control Register (available in page0 of each book) */
 #define TASDEVICE_PAGE_SELECT		0x00
 #define TASDEVICE_BOOKCTL_PAGE		0x00
 #define TASDEVICE_BOOKCTL_REG		127
@@ -42,12 +43,12 @@
 #define TASDEVICE_REG(book, page, reg)	(((book * 256 * 128) + \
 					(page * 128)) + reg)
 
-/*Software Reset */
-#define TASDEVICE_REG_SWRESET		TASDEVICE_REG(0x0, 0X0, 0x01)
+/* Software Reset */
+#define TASDEVICE_REG_SWRESET		TASDEVICE_REG(0x0, 0x0, 0x01)
 #define TASDEVICE_REG_SWRESET_RESET	BIT(0)
 
-/*I2C Checksum */
-#define TASDEVICE_I2CChecksum		TASDEVICE_REG(0x0, 0x0, 0x7E)
+/* I2C Checksum */
+#define TASDEVICE_CHECKSUM_REG		TASDEVICE_REG(0x0, 0x0, 0x7e)
 
 /* XM_340 */
 #define	TASDEVICE_XM_A1_REG	TASDEVICE_REG(0x64, 0x63, 0x3c)
@@ -55,8 +56,8 @@
 #define	TASDEVICE_XM_A2_REG	TASDEVICE_REG(0x64, 0x63, 0x38)
 
 /* Volume control */
-#define TAS2563_DVC_LVL			TASDEVICE_REG(0x00, 0x02, 0x0C)
-#define TAS2781_DVC_LVL			TASDEVICE_REG(0x0, 0x0, 0x1A)
+#define TAS2563_DVC_LVL			TASDEVICE_REG(0x00, 0x02, 0x0c)
+#define TAS2781_DVC_LVL			TASDEVICE_REG(0x0, 0x0, 0x1a)
 #define TAS2781_AMP_LEVEL		TASDEVICE_REG(0x0, 0x0, 0x03)
 #define TAS2781_AMP_LEVEL_MASK		GENMASK(5, 1)
 
@@ -95,8 +96,8 @@
 #define TAS2781_PRM_SINEGAIN_REG	TASDEVICE_REG(0x00, 0x14, 0x40)
 #define TAS2781_PRM_SINEGAIN2_REG	TASDEVICE_REG(0x00, 0x14, 0x44)
 
-#define TAS2781_TEST_UNLOCK_REG		TASDEVICE_REG(0x00, 0xFD, 0x0D)
-#define TAS2781_TEST_PAGE_UNLOCK	0x0D
+#define TAS2781_TEST_UNLOCK_REG		TASDEVICE_REG(0x00, 0xfd, 0x0d)
+#define TAS2781_TEST_PAGE_UNLOCK	0x0d
 
 #define TAS2781_RUNTIME_LATCH_RE_REG	TASDEVICE_REG(0x00, 0x00, 0x49)
 #define TAS2781_RUNTIME_RE_REG_TF	TASDEVICE_REG(0x64, 0x62, 0x48)
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index 61d9c220b6a4..bc2f68bd9846 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2,9 +2,10 @@
 //
 // tas2781-fmwlib.c -- TASDEVICE firmware support
 //
-// Copyright 2023 - 2024 Texas Instruments, Inc.
+// Copyright 2023 - 2025 Texas Instruments, Inc.
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
+// Author: Baojun Xu <baojun.xu@ti.com>
 
 #include <linux/crc8.h>
 #include <linux/firmware.h>
@@ -1496,7 +1497,7 @@ static int tasdev_block_chksum(struct tasdevice_priv *tas_priv,
 	unsigned int nr_value;
 	int ret;
 
-	ret = tasdevice_dev_read(tas_priv, chn, TASDEVICE_I2CChecksum,
+	ret = tasdevice_dev_read(tas_priv, chn, TASDEVICE_CHECKSUM_REG,
 		&nr_value);
 	if (ret < 0) {
 		dev_err(tas_priv->dev, "%s: Chn %d\n", __func__, chn);
@@ -1540,7 +1541,7 @@ static int tasdev_load_blk(struct tasdevice_priv *tas_priv,
 	while (block->nr_retry > 0) {
 		if (block->is_pchksum_present) {
 			ret = tasdevice_dev_write(tas_priv, chn,
-				TASDEVICE_I2CChecksum, 0);
+				TASDEVICE_CHECKSUM_REG, 0);
 			if (ret < 0)
 				break;
 		}
-- 
2.34.1

