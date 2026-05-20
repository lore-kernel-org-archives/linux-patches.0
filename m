Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C510F2;
	Wed, 20 May 2026 17:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298778; cv=none; b=aBlcw6QpjE5XSoYqJWZ2Pv0Ilg0/rQx7oWIVqb+Va1yBufBEC44LQu8AHlrXBLydTsEtDO0IED4NbWiOyCImv6L4oidfw+Z6qFyz6bcL3a0dd58ZeBJnww9pOS1jpLsuZ1kz57oBGJCNvmJ6fqRjPJl62y8YjT6VKPgdH0dQloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298778; c=relaxed/simple;
	bh=P0sa9xAZHZ6Fyz5aB43kKzWPy1H3u5s39ccjj1Ay1oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Alw4/WtqvAUPk0+zmtSrp4C//29QhbK5mtvNiPtCZgJWNpJpBiNQlGlKn7PhM8AgXa/FnaHu5ZJ6LdAniXbbOv6WKEif8p1hMMwrOATB1olJKu355tJQwz3+cuIlapu2mpegXOKapUrNf8MmQo2gOpCZRzPmoDyDN0UhKfiWwLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ld7L/Hcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ld7L/Hcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FADF1F000E9;
	Wed, 20 May 2026 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298777;
	bh=NEMte8mGAzc/JVTgmnf4qrbLydIlXkKG27makuFK1N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ld7L/HcnFN4kEJ9/ZRri7zkKBDJqAy9c1bjRUEDecI97946Ut0tbrmI29q+Q2QcIN
	 DEfflzC+qvO/FRHgppKBsqh9iVzvHp10RcZ0qpQMl9IUEUZqfVe+kWBybt2oG2t/H5
	 T0zN9nBP8VvoRcEAmiBuCSmrXqb8jmpesezZTxYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Luke Jones <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 541/957] platform/x86: asus-wmi: fix screenpad brightness range
Date: Wed, 20 May 2026 18:17:04 +0200
Message-ID: <20260520162146.266171949@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e6fe6ed6a63da..9026744d72267 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -127,7 +127,6 @@ module_param(fnlock_default, bool, 0444);
 #define NVIDIA_TEMP_MIN		75
 #define NVIDIA_TEMP_MAX		87
 
-#define ASUS_SCREENPAD_BRIGHT_MIN 20
 #define ASUS_SCREENPAD_BRIGHT_MAX 255
 #define ASUS_SCREENPAD_BRIGHT_DEFAULT 60
 
@@ -4143,13 +4142,13 @@ static int read_screenpad_brightness(struct backlight_device *bd)
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
@@ -4189,22 +4188,19 @@ static int asus_screenpad_init(struct asus_wmi *asus)
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
@@ -4215,7 +4211,7 @@ static int asus_screenpad_init(struct asus_wmi *asus)
 
 	asus->screenpad_backlight_device = bd;
 	asus->driver->screenpad_brightness = brightness;
-	bd->props.brightness = brightness - ASUS_SCREENPAD_BRIGHT_MIN;
+	bd->props.brightness = brightness;
 	bd->props.power = power;
 	backlight_update_status(bd);
 
-- 
2.53.0



