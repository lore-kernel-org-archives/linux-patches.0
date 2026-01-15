Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46653BF2FF;
	Thu, 15 Jan 2026 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497286; cv=none; b=OVXzRmXk3B7bHQ06sUUyo1Hqsy2SN7MrQ2SkEdy1PJyk3lFN/gkCga0w5A2QsT9QLVspx7/orXObbIcqPeCtXMPzpdbAC97/8SEK9pykxHLQEGlzq+QPQpHZ/8/8XteyS/BAwjwUGR140xo4bRptDxMtmu5P2xhhscp0fjNmftI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497286; c=relaxed/simple;
	bh=PJaXqinHlqWt+RMbt7eYTCIakTGBMw5SEho0/6ECpMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqowVfrdYGSRkAyxeJll4G9hGaQZrxKv+FPWYnWqo2B9DDMdV5qSxM+PvNG5kr17qsS5GxNojZwPo+e8ChDVHbvUr+uhIDBUBY8THEF+Ce8XbOpbv4uzq1Jpi0+vumly80RfbJJQD+QrkvkZQC65XMOww6uIEOuh1eIVD6ghZNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m02O+74G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m02O+74G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504ACC116D0;
	Thu, 15 Jan 2026 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497286;
	bh=PJaXqinHlqWt+RMbt7eYTCIakTGBMw5SEho0/6ECpMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m02O+74G2qYX5pdcE9wQIqR6vNl8mtIpC7QMleefZQ00N7/mDTp97trOyjAuORzLE
	 jokR7aIf6FpOTzmWdS1jEG2XFpUJICYImQNcq5pUO9TaHKOwuqHNXtpWTN0T2QZt6P
	 zTRZtvxfI1B5opYMkZ7OsusRJxlwLpxC0aw1vXUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/554] leds: Replace all non-returning strlcpy with strscpy
Date: Thu, 15 Jan 2026 17:41:13 +0100
Message-ID: <20260115164246.504027731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Azeem Shaikh <azeemshaikh38@gmail.com>

[ Upstream commit bf4a35e9201d30b63a8d276797d6ecfaa596ccd3 ]

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().
No return values were used, so direct replacement is safe.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230523021451.2406362-1-azeemshaikh38@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: ccc35ff2fd29 ("leds: spi-byte: Use devm_led_classdev_register_ext()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-aat1290.c | 2 +-
 drivers/leds/led-class.c          | 2 +-
 drivers/leds/leds-spi-byte.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/flash/leds-aat1290.c b/drivers/leds/flash/leds-aat1290.c
index 589484b22c796..f12ecb2c65803 100644
--- a/drivers/leds/flash/leds-aat1290.c
+++ b/drivers/leds/flash/leds-aat1290.c
@@ -425,7 +425,7 @@ static void aat1290_init_v4l2_flash_config(struct aat1290_led *led,
 	struct led_classdev *led_cdev = &led->fled_cdev.led_cdev;
 	struct led_flash_setting *s;
 
-	strlcpy(v4l2_sd_cfg->dev_name, led_cdev->dev->kobj.name,
+	strscpy(v4l2_sd_cfg->dev_name, led_cdev->dev->kobj.name,
 		sizeof(v4l2_sd_cfg->dev_name));
 
 	s = &v4l2_sd_cfg->intensity;
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 1e4fed64aee18..e098e001a7b0b 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -321,7 +321,7 @@ static int led_classdev_next_name(const char *init_name, char *name,
 	int ret = 0;
 	struct device *dev;
 
-	strlcpy(name, init_name, len);
+	strscpy(name, init_name, len);
 
 	while ((ret < len) &&
 	       (dev = class_find_device_by_name(leds_class, name))) {
diff --git a/drivers/leds/leds-spi-byte.c b/drivers/leds/leds-spi-byte.c
index 82696e0607a53..958e898b58d09 100644
--- a/drivers/leds/leds-spi-byte.c
+++ b/drivers/leds/leds-spi-byte.c
@@ -97,7 +97,7 @@ static int spi_byte_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	of_property_read_string(child, "label", &name);
-	strlcpy(led->name, name, sizeof(led->name));
+	strscpy(led->name, name, sizeof(led->name));
 	led->spi = spi;
 	mutex_init(&led->mutex);
 	led->cdef = device_get_match_data(dev);
-- 
2.51.0



