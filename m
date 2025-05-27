Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0D1DF759;
	Tue, 27 May 2025 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313468; cv=none; b=hIZHXDocQrlmrMmNHIDdamDRST8tY9wXdGIjajgFa9LRrT3L4nHGFClyuQPdxv8x7B7s/dPOU4EEEi0UNZEwq22LtavaD6tj3j1l4nDe8JLx/Dw2j/DMaNiN+JxFWnD72JXboCA/2XQKNSOrmdmliQx/MFykW5SZvAzzWifYQhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313468; c=relaxed/simple;
	bh=0j8uoNILiuCsQSs5TlfIlMlIXUTOBcUV1YN6RWQSLNM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=T2cnE6daGw+mNHQI69mt1T6z99pm4S6efNLcJo9Ft8wwoFnn6mVaQJ4TvgJzYjfrMrxkCRQ0uoA6soAmIcCRJzBBmGKmEtrM3CNFfqjyT3Au6szukFEAWMfyqJGigiIA556PHNGTLXu7boyiBAZmwUVHNhntX3hvBOWUbEn27Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eg/060DW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eg/060DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D786C4CEED;
	Tue, 27 May 2025 02:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313467;
	bh=0j8uoNILiuCsQSs5TlfIlMlIXUTOBcUV1YN6RWQSLNM=;
	h=From:To:Cc:Subject:Date:From;
	b=Eg/060DWwsdzWU6PV9IgNzryokibJOVZuv1D6ABJTTroHrsIncRaNR8I0VguhOxwD
	 0BhCoFiYE42pyyG5bpPFeZ9ABQiHZ3d4U1/DcIZTSs5LYgj9y3DDlWJC5sz3eYGBcW
	 no1Dw/1JhlGKKZ1kzj+TdxpKStHWlYNCfQiXmP9Ow2n7zbZWdGoycggLBsHHxByt9t
	 uJ6yxil9XT7ZOFPRdL/VXlxStlnNS5EIKhqreC5Ox0JzviF5oIXhk4kMob1XgRdgUr
	 ZuC7dUUzHdZtZE4aTb2b8G2EcUOID+0OgkYFAY8+pNwkkwz4fg2bVo1vAIZ9drhmSN
	 PfUF7lpelpI6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Valtteri Koskivuori <vkoskiv@gmail.com>,
	Jonathan Woithe <jwoithe@just42.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hdegoede@redhat.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 1/5] platform/x86: fujitsu-laptop: Support Lifebook S2110 hotkeys
Date: Mon, 26 May 2025 22:37:41 -0400
Message-Id: <20250527023745.1017153-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.30
Content-Transfer-Encoding: 8bit

From: Valtteri Koskivuori <vkoskiv@gmail.com>

[ Upstream commit a7e255ff9fe4d9b8b902023aaf5b7a673786bb50 ]

The S2110 has an additional set of media playback control keys enabled
by a hardware toggle button that switches the keys between "Application"
and "Player" modes. Toggling "Player" mode just shifts the scancode of
each hotkey up by 4.

Add defines for new scancodes, and a keymap and dmi id for the S2110.

Tested on a Fujitsu Lifebook S2110.

Signed-off-by: Valtteri Koskivuori <vkoskiv@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/20250509184251.713003-1-vkoskiv@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/fujitsu-laptop.c | 33 +++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index ae992ac1ab4ac..6d5300c54a421 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -17,13 +17,13 @@
 /*
  * fujitsu-laptop.c - Fujitsu laptop support, providing access to additional
  * features made available on a range of Fujitsu laptops including the
- * P2xxx/P5xxx/S6xxx/S7xxx series.
+ * P2xxx/P5xxx/S2xxx/S6xxx/S7xxx series.
  *
  * This driver implements a vendor-specific backlight control interface for
  * Fujitsu laptops and provides support for hotkeys present on certain Fujitsu
  * laptops.
  *
- * This driver has been tested on a Fujitsu Lifebook S6410, S7020 and
+ * This driver has been tested on a Fujitsu Lifebook S2110, S6410, S7020 and
  * P8010.  It should work on most P-series and S-series Lifebooks, but
  * YMMV.
  *
@@ -107,7 +107,11 @@
 #define KEY2_CODE			0x411
 #define KEY3_CODE			0x412
 #define KEY4_CODE			0x413
-#define KEY5_CODE			0x420
+#define KEY5_CODE			0x414
+#define KEY6_CODE			0x415
+#define KEY7_CODE			0x416
+#define KEY8_CODE			0x417
+#define KEY9_CODE			0x420
 
 /* Hotkey ringbuffer limits */
 #define MAX_HOTKEY_RINGBUFFER_SIZE	100
@@ -560,7 +564,7 @@ static const struct key_entry keymap_default[] = {
 	{ KE_KEY, KEY2_CODE,            { KEY_PROG2 } },
 	{ KE_KEY, KEY3_CODE,            { KEY_PROG3 } },
 	{ KE_KEY, KEY4_CODE,            { KEY_PROG4 } },
-	{ KE_KEY, KEY5_CODE,            { KEY_RFKILL } },
+	{ KE_KEY, KEY9_CODE,            { KEY_RFKILL } },
 	/* Soft keys read from status flags */
 	{ KE_KEY, FLAG_RFKILL,          { KEY_RFKILL } },
 	{ KE_KEY, FLAG_TOUCHPAD_TOGGLE, { KEY_TOUCHPAD_TOGGLE } },
@@ -584,6 +588,18 @@ static const struct key_entry keymap_p8010[] = {
 	{ KE_END, 0 }
 };
 
+static const struct key_entry keymap_s2110[] = {
+	{ KE_KEY, KEY1_CODE, { KEY_PROG1 } }, /* "A" */
+	{ KE_KEY, KEY2_CODE, { KEY_PROG2 } }, /* "B" */
+	{ KE_KEY, KEY3_CODE, { KEY_WWW } },   /* "Internet" */
+	{ KE_KEY, KEY4_CODE, { KEY_EMAIL } }, /* "E-mail" */
+	{ KE_KEY, KEY5_CODE, { KEY_STOPCD } },
+	{ KE_KEY, KEY6_CODE, { KEY_PLAYPAUSE } },
+	{ KE_KEY, KEY7_CODE, { KEY_PREVIOUSSONG } },
+	{ KE_KEY, KEY8_CODE, { KEY_NEXTSONG } },
+	{ KE_END, 0 }
+};
+
 static const struct key_entry *keymap = keymap_default;
 
 static int fujitsu_laptop_dmi_keymap_override(const struct dmi_system_id *id)
@@ -621,6 +637,15 @@ static const struct dmi_system_id fujitsu_laptop_dmi_table[] = {
 		},
 		.driver_data = (void *)keymap_p8010
 	},
+	{
+		.callback = fujitsu_laptop_dmi_keymap_override,
+		.ident = "Fujitsu LifeBook S2110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK S2110"),
+		},
+		.driver_data = (void *)keymap_s2110
+	},
 	{}
 };
 
-- 
2.39.5

