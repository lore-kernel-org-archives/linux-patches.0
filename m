Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFF1CDA1A
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731418995; cv=none; b=V725xw7jl03BC+CZrbRzeTIpXq32fBQefOu9cbKoB2kJEgrztmynMMnDN+sYf4+YVeM0GoA3w/TxDZIyWDHr8Sze2ERD9KVBLRhCEWrAwQqSL+L1wx5t0t3YbBEspuz65rIYCetq1X7mTzX2KwZam1z8hNkr6q0ciU57MKzNoA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731418995; c=relaxed/simple;
	bh=N8FpRnzUZPbaHEban3irlAWuvmLWodujTP5VHleNsl8=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=V89WYL2RXEroGitZdiqL2pE3ectozJASInF4vSWFBQ7hcqA46cSNVRH7Ed3sOegTdLQkzYvBHYvLu3LWeeQ54MuddcxF/owr6hKuK0TeTxIRTe9Ac9GcXLbpDXUqOnc5188y0h6WyCnu+HIs6yJFZ9aqwPA5P4eL5moi3SjEH8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=cE7fWQ9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="cE7fWQ9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD52C4CECD
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 13:43:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="cE7fWQ9K"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Tue, 12 Nov 2024 13:43:11 +0000
Resent-Message-ID: <ZzNbbwt_9aNny1lI@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 12 Nov 2024 13:14:48 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=s6/z=SH=opensource.cirrus.com=prvs=80465ff1e4=ckeepax@kernel.org>)
	id 1tAqjG-0039Mr-HF
	for broonie@sirena.co.uk; Tue, 12 Nov 2024 13:14:48 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 18E4B5C55A9
	for <broonie@sirena.co.uk>; Tue, 12 Nov 2024 13:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 40944C4CED0; Tue, 12 Nov 2024 13:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B762C4CECD
	for <broonie@kernel.org>; Tue, 12 Nov 2024 13:14:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1B762C4CECD
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AC6dhRb026352;
	Tue, 12 Nov 2024 07:14:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=PODMain02222019; bh=AdNv6VJBkL+UQ4wf
	hxhyUfabaQRutH6h88XESTcL05c=; b=cE7fWQ9K8FU3wUxKdODMnOxGUp8xgMa5
	LiLln0Jkchs3t9OoqGr+QaTs7HHleKo9hwhGJKQONIgBg4KoqD3WlFCoT9zCIKfY
	x6HTnnJgOdH1mMzzumDfYyxQT8kVG60Ba0s+v95A0ZVMRo2hSrrWhtZo5lHm4L+y
	KNYvjEvWGP1JQZsdzIFd5/z9m4Lm4hmz0Hbu2Qk+W7z0HsnuT/GFlO+vw+MfS/Yr
	ZarzTgo/pdEQ7lODctn1J4emDcx80M8JFYIgq8SWFzY971hZb9iUMzDTVu0DT+lC
	IOi67OK+5lzpisUzNu/xS3eL8NmJzytPqlMex0dpAaz6NIreT4O2uQ==
Received: from ediex02.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 42t613b675-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 07:14:37 -0600 (CST)
Received: from ediex02.ad.cirrus.com (198.61.84.81) by ediex02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 12 Nov
 2024 13:14:35 +0000
Received: from ediswmail9.ad.cirrus.com (198.61.86.93) by
 anon-ediex02.ad.cirrus.com (198.61.84.81) with Microsoft SMTP Server id
 15.2.1544.9 via Frontend Transport; Tue, 12 Nov 2024 13:14:35 +0000
Received: from ediswws07.ad.cirrus.com (ediswws07.ad.cirrus.com [198.90.208.14])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTP id 016EA820241;
	Tue, 12 Nov 2024 13:14:35 +0000 (UTC)
From: Charles Keepax <ckeepax@opensource.cirrus.com>
To: <broonie@kernel.org>
CC: <patches@opensource.cirrus.com>, <linux-spi@vger.kernel.org>
Date: Tue, 12 Nov 2024 13:14:34 +0000
Message-ID: <20241112131434.678882-1-ckeepax@opensource.cirrus.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3Q2WRqZyrHFIM7JSZrmpEP1KfpLsOLgS
X-Proofpoint-GUID: 3Q2WRqZyrHFIM7JSZrmpEP1KfpLsOLgS
X-Proofpoint-Spam-Reason: safe
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=s6/z=SH=opensource.cirrus.com=prvs=80465ff1e4=ckeepax@kernel.org
Subject: [PATCH] spi: cs42l43: Add GPIO speaker id support to the bridge configuration
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 81IXBpZxHMs6

From: Simon Trimmer <simont@opensource.cirrus.com>

OEMs can use the spk-id-gpios ACPI property to indicate the type of
speakers fitted to a device.

Attempt to read a spk-id value using the GPIO method when a usable
spk-id value is not obtained from the 01fa-spk-id-val ACPI property.

Obtaining the spk-id value has been moved earlier in the function to the
other sidecar block, so that an -EPROBE_DEFER from a GPIO driver is
handled more efficiently.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
---
 drivers/spi/spi-cs42l43.c | 46 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index 5b8ed65f8094d..d0b55a26c31b9 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -12,6 +12,7 @@
 #include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
 #include <linux/gpio/property.h>
 #include <linux/mfd/cs42l43.h>
@@ -229,6 +230,33 @@ static size_t cs42l43_spi_max_length(struct spi_device *spi)
 	return CS42L43_SPI_MAX_LENGTH;
 }
 
+static int cs42l43_get_speaker_id_gpios(struct cs42l43_spi *priv, int *result)
+{
+	struct gpio_descs *descs;
+	u32 spkid;
+	int i, ret;
+
+	descs = gpiod_get_array_optional(priv->dev, "spk-id", GPIOD_IN);
+	if (IS_ERR_OR_NULL(descs))
+		return PTR_ERR(descs);
+
+	spkid = 0;
+	for (i = 0; i < descs->ndescs; i++) {
+		ret = gpiod_get_value_cansleep(descs->desc[i]);
+		if (ret < 0)
+			goto err;
+
+		spkid |= (ret << i);
+	}
+
+	dev_dbg(priv->dev, "spk-id-gpios = %d\n", spkid);
+	*result = spkid;
+err:
+	gpiod_put_array(descs);
+
+	return ret;
+}
+
 static struct fwnode_handle *cs42l43_find_xu_node(struct fwnode_handle *fwnode)
 {
 	static const u32 func_smart_amp = 0x1;
@@ -306,6 +334,7 @@ static int cs42l43_spi_probe(struct platform_device *pdev)
 	struct fwnode_handle *fwnode = dev_fwnode(cs42l43->dev);
 	struct fwnode_handle *xu_fwnode __free(fwnode_handle) = cs42l43_find_xu_node(fwnode);
 	int nsidecars = 0;
+	int spkid = -EINVAL;
 	int ret;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -360,6 +389,18 @@ static int cs42l43_spi_probe(struct platform_device *pdev)
 	fwnode_property_read_u32(xu_fwnode, "01fa-sidecar-instances", &nsidecars);
 
 	if (nsidecars) {
+		ret = fwnode_property_read_u32(xu_fwnode, "01fa-spk-id-val", &spkid);
+		if (!ret) {
+			dev_dbg(priv->dev, "01fa-spk-id-val = %d\n", spkid);
+		} else if (ret != -EINVAL) {
+			return dev_err_probe(priv->dev, ret, "Failed to get spk-id-val\n");
+		} else {
+			ret = cs42l43_get_speaker_id_gpios(priv, &spkid);
+			if (ret < 0)
+				return dev_err_probe(priv->dev, ret,
+						     "Failed to get spk-id-gpios\n");
+		}
+
 		ret = software_node_register(&cs42l43_gpiochip_swnode);
 		if (ret)
 			return dev_err_probe(priv->dev, ret,
@@ -385,11 +426,6 @@ static int cs42l43_spi_probe(struct platform_device *pdev)
 	if (nsidecars) {
 		struct spi_board_info *ampl_info;
 		struct spi_board_info *ampr_info;
-		int spkid = -EINVAL;
-
-		fwnode_property_read_u32(xu_fwnode, "01fa-spk-id-val", &spkid);
-
-		dev_dbg(priv->dev, "Found speaker ID %d\n", spkid);
 
 		ampl_info = cs42l43_create_bridge_amp(priv, "cs35l56-left", 0, spkid);
 		if (!ampl_info)
-- 
2.39.5

