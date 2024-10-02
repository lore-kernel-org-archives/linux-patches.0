Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90B579D0;
	Wed,  2 Oct 2024 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879420; cv=none; b=Rz/QH6p2H/QDgQGUAaR2KFbJK2VG4VJ6aFF63d5SH3HPEolQ5bPHhGkvfYilNC3mOu8LJEws6U3yUWY+BtUQV+wyfnh/D+Kwy32DRmKBgNMMB2HD4C9oyqWge753PaStWWKPuK79OvT1o0hXwgz0FUeIGDO+V4dJQF6B8TzNp3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879420; c=relaxed/simple;
	bh=Z6Vh+qtj5cYpBebTB4hBdJE8+DFXKrNjOPBCPNnFmAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4LDgFTZ5UQ34KqdcUJk05IseoiIBH+LtGXteX1JbNuxc2WbQdJabdkKO1OGMoIvk+a/M7XtcDFLQGg3fgTTdT2OT7G0lw0mi0TxlCHpBTwEPap49bbF/8bMOqgq6wgmh4nBM8dU7X2IfkOnnrWVuFfKg562iXTrTKOHVjytaJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se3/7P3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se3/7P3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE3C4CEC2;
	Wed,  2 Oct 2024 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879419;
	bh=Z6Vh+qtj5cYpBebTB4hBdJE8+DFXKrNjOPBCPNnFmAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=se3/7P3mXYqPgsh7P4srPEcKQ7eOxqfD+AAQwUd3CHRJ707fAlgdSSkQYry9W/RqD
	 BTtG6QxS9GBuA1yLr/MFmxQRjXgSZ33o4kIOruGKLj6kvzV6xwM7es9kKh26DfUR9M
	 XhOyDOhDpzZ+iyMDObLBpjkRMD64P7AMaI6rqUYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/538] ASoC: tas2781: remove unused acpi_subysystem_id
Date: Wed,  2 Oct 2024 14:55:51 +0200
Message-ID: <20241002125756.657960534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 4089d82e67a9967fc5bf2b4e5ef820d67fe73924 ]

The acpi_subysystem_id is only written and freed, not read, so
unnecessary.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/454639336be28d2b50343e9c8366a56b0975e31d.1707456753.git.soyer@irl.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c2c0b67dca3c ("ASoC: tas2781-i2c: Drop weird GPIO code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781.h           |  1 -
 sound/pci/hda/tas2781_hda_i2c.c   | 12 ------------
 sound/soc/codecs/tas2781-comlib.c |  1 -
 3 files changed, 14 deletions(-)

diff --git a/include/sound/tas2781.h b/include/sound/tas2781.h
index be58d870505a4..be6f70dd54f93 100644
--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -101,7 +101,6 @@ struct tasdevice_priv {
 	struct tm tm;
 
 	enum device_catlog_id catlog_id;
-	const char *acpi_subsystem_id;
 	unsigned char cal_binaryname[TASDEVICE_MAX_CHANNELS][64];
 	unsigned char crc8_lkp_tbl[CRC8_TABLE_SIZE];
 	unsigned char coef_binaryname[64];
diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index e5bb1fed26a0c..0a587f55583ff 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -95,9 +95,7 @@ static int tas2781_get_i2c_res(struct acpi_resource *ares, void *data)
 static int tas2781_read_acpi(struct tasdevice_priv *p, const char *hid)
 {
 	struct acpi_device *adev;
-	struct device *physdev;
 	LIST_HEAD(resources);
-	const char *sub;
 	int ret;
 
 	adev = acpi_dev_get_first_match_dev(hid, NULL, -1);
@@ -113,18 +111,8 @@ static int tas2781_read_acpi(struct tasdevice_priv *p, const char *hid)
 
 	acpi_dev_free_resource_list(&resources);
 	strscpy(p->dev_name, hid, sizeof(p->dev_name));
-	physdev = get_device(acpi_get_first_physical_node(adev));
 	acpi_dev_put(adev);
 
-	/* No side-effect to the playback even if subsystem_id is NULL*/
-	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
-	if (IS_ERR(sub))
-		sub = NULL;
-
-	p->acpi_subsystem_id = sub;
-
-	put_device(physdev);
-
 	return 0;
 
 err:
diff --git a/sound/soc/codecs/tas2781-comlib.c b/sound/soc/codecs/tas2781-comlib.c
index 5d0e5348b361a..3aa81514dad76 100644
--- a/sound/soc/codecs/tas2781-comlib.c
+++ b/sound/soc/codecs/tas2781-comlib.c
@@ -408,7 +408,6 @@ void tasdevice_remove(struct tasdevice_priv *tas_priv)
 {
 	if (gpio_is_valid(tas_priv->irq_info.irq_gpio))
 		gpio_free(tas_priv->irq_info.irq_gpio);
-	kfree(tas_priv->acpi_subsystem_id);
 	mutex_destroy(&tas_priv->codec_lock);
 }
 EXPORT_SYMBOL_GPL(tasdevice_remove);
-- 
2.43.0



