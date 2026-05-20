Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615963A383C;
	Wed, 20 May 2026 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296135; cv=none; b=tFiwR6l/P6ZnTVJ5whNrLEzHbN959Sjo4ogk+cwEF58dZauccpJwkxZicLIgb4fpTkBkvl3aNpR62DHWtYvGZ61WxphpcOu3j3AFJKZ1hSFzI7+rzj2vNiGDqCfqTmP6E8OepFi6/bIwklWvyQxuwUXTkIU8ZK/TZwH/6c9V0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296135; c=relaxed/simple;
	bh=sAj3gE4E2ER2oI3LhC90+uCG6UDgklSog4I0zlBQQmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqai+heyc1EKUof/1+dI8oYBiUSZJLGqsWhLrPXEFuSGpFmELVikKRnweWWTus4d4Sa+jWtUG6aR6tT5CrfYw2OniPJrOHxP5S/TSPDPfsKkdH/vWG2Hh5xYjH9MT7frI3i3OLuWQXyHArUYPk9oHCPfB161NTYDrlk6YwLwayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg3jG7E6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg3jG7E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A221F000E9;
	Wed, 20 May 2026 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296134;
	bh=uDx+FPoiXOfBTo+POFDrmMNYA+sD4jI//B0RVG+UO/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zg3jG7E6uT0/IErqOmi8FlwFKx5lDiRpMaWpJKd9zmH6WQkmamkYSyHqWxulXPZWH
	 E5BuxOxpgxpALL7YSU2nj0NX9crp/QycqKpsKGux5BkLuM4R39KQMl+V7BRKmWXKXV
	 Nf0NjHNu1Zy/9OtdAnplhi5sNM7iTr/bE9BMHm2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Luke Jones <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0683/1146] platform/x86: asus-wmi: fix screenpad brightness range
Date: Wed, 20 May 2026 18:15:33 +0200
Message-ID: <20260520162203.646076312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 8d95d1f4aa5c76202b0833a70998769384612488 ]

Fix screenpad brightness range being too limited without reason:
testing this patch on a Zenbook Duo showed the hardware minimum not being
too low, therefore allow the user to configure the entire range, and
expose to userspace the hardware brightness range and value.

Fixes: 2c97d3e55b70 ("platform/x86: asus-wmi: add support for ASUS screenpad")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Luke Jones <luke@ljones.dev>
Link: https://patch.msgid.link/20260302174431.349816-3-denis.benato@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index f3c54290c58d2..0f8eb5be7c7a1 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -125,7 +125,6 @@ module_param(fnlock_default, bool, 0444);
 #define NVIDIA_TEMP_MIN		75
 #define NVIDIA_TEMP_MAX		87
 
-#define ASUS_SCREENPAD_BRIGHT_MIN 20
 #define ASUS_SCREENPAD_BRIGHT_MAX 255
 #define ASUS_SCREENPAD_BRIGHT_DEFAULT 60
 
@@ -4408,13 +4407,13 @@ static int read_screenpad_brightness(struct backlight_device *bd)
 		return err;
 	/* The device brightness can only be read if powered, so return stored */
 	if (err == BACKLIGHT_POWER_OFF)
-		return asus->driver->screenpad_brightness - ASUS_SCREENPAD_BRIGHT_MIN;
+		return bd->props.brightness;
 
 	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_SCREENPAD_LIGHT, &retval);
 	if (err < 0)
 		return err;
 
-	return (retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK) - ASUS_SCREENPAD_BRIGHT_MIN;
+	return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
 static int update_screenpad_bl_status(struct backlight_device *bd)
@@ -4454,22 +4453,19 @@ static int asus_screenpad_init(struct asus_wmi *asus)
 	int err, power;
 	int brightness = 0;
 
-	power = read_screenpad_backlight_power(asus);
+	power = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_SCREENPAD_POWER);
 	if (power < 0)
 		return power;
 
-	if (power != BACKLIGHT_POWER_OFF) {
+	if (power) {
 		err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_SCREENPAD_LIGHT, &brightness);
 		if (err < 0)
 			return err;
 	}
-	/* default to an acceptable min brightness on boot if too low */
-	if (brightness < ASUS_SCREENPAD_BRIGHT_MIN)
-		brightness = ASUS_SCREENPAD_BRIGHT_DEFAULT;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW; /* ensure this bd is last to be picked */
-	props.max_brightness = ASUS_SCREENPAD_BRIGHT_MAX - ASUS_SCREENPAD_BRIGHT_MIN;
+	props.max_brightness = ASUS_SCREENPAD_BRIGHT_MAX;
 	bd = backlight_device_register("asus_screenpad",
 				       &asus->platform_device->dev, asus,
 				       &asus_screenpad_bl_ops, &props);
@@ -4480,7 +4476,7 @@ static int asus_screenpad_init(struct asus_wmi *asus)
 
 	asus->screenpad_backlight_device = bd;
 	asus->driver->screenpad_brightness = brightness;
-	bd->props.brightness = brightness - ASUS_SCREENPAD_BRIGHT_MIN;
+	bd->props.brightness = brightness;
 	bd->props.power = power;
 	backlight_update_status(bd);
 
-- 
2.53.0



