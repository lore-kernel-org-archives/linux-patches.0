Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E92B25A344;
	Thu, 17 Apr 2025 18:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914422; cv=none; b=Xm9j3KhPifU660WNlgt3h6NzNXRw/7ZHzRxHN4wfaLrilTRuUs0jxYRVsZMCFW45acnbgoHn0gI6gVKpKLGTdgFNVz6TMeuFS7gzNa5yyoS/yJhr7USTQfy9q8vLu5x1isD08AF5E6jJQrCQfV68SN3eVr1Jn2x1w1h23FB091Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914422; c=relaxed/simple;
	bh=X9inGHsI0uVM8QY2RkavPOIhQmcjges1Zb9BPdBcdzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvE12dON7kPexfID4BKavZ2tVXu5Pk932ZQVSNsBT98WvxsAUxGBVCF8IaFTIs1ZmKbaLWxyysw+TT8omL1GZ0LKSYRNqkf5z+8pjflvNLz2TVfLEni9o1lwWb5KZT/VR9jRTV73raDCQRObqSdQmjPxWVCsoFgjyjeT7bI6sVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSM8n4pW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSM8n4pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A91C4CEE4;
	Thu, 17 Apr 2025 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914422;
	bh=X9inGHsI0uVM8QY2RkavPOIhQmcjges1Zb9BPdBcdzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSM8n4pWa7VUStkXvC9ieCnDrTIxbWJihhb4oCIXz4T7GIK9orC16PKLvTohrhjNt
	 cZ6khJbuC7v0MVt37W+o8IZysxVaXY0q/7gw55rs1hyNLsbAyjz1aHsvPzvC6yTFwu
	 k7ubpaJEONWbK3JC9s7eDAS5VjuaEq9zQMLbCXpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 181/414] HID: pidff: Move all hid-pidff definitions to a dedicated header
Date: Thu, 17 Apr 2025 19:48:59 +0200
Message-ID: <20250417175118.731974227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 0d24d4b1da96df9fc5ff36966f40f980ef864d46 ]

Do not clutter hid includes with stuff not needed outside of
the kernel.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-universal-pidff.c |  3 ++-
 drivers/hid/usbhid/hid-core.c     |  1 +
 drivers/hid/usbhid/hid-pidff.c    |  3 ++-
 drivers/hid/usbhid/hid-pidff.h    | 33 +++++++++++++++++++++++++++++++
 include/linux/hid.h               | 15 --------------
 5 files changed, 38 insertions(+), 17 deletions(-)
 create mode 100644 drivers/hid/usbhid/hid-pidff.h

diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 7ef5ab9146b1c..1b713b741d192 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/input-event-codes.h>
 #include "hid-ids.h"
+#include "usbhid/hid-pidff.h"
 
 #define JOY_RANGE (BTN_DEAD - BTN_JOYSTICK + 1)
 
@@ -89,7 +90,7 @@ static int universal_pidff_probe(struct hid_device *hdev,
 	}
 
 	/* Check if HID_PID support is enabled */
-	int (*init_function)(struct hid_device *, __u32);
+	int (*init_function)(struct hid_device *, u32);
 	init_function = hid_pidff_init_with_quirks;
 
 	if (!init_function) {
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index a6eb6fe6130d1..44c2351b870fa 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -35,6 +35,7 @@
 #include <linux/hid-debug.h>
 #include <linux/hidraw.h>
 #include "usbhid.h"
+#include "hid-pidff.h"
 
 /*
  * Version Information
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index ac6f940abd901..a8eaa77e80be3 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include "hid-pidff.h"
 #include <linux/input.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
@@ -1383,7 +1384,7 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
  * Check if the device is PID and initialize it
  * Set initial quirks
  */
-int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks)
+int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 {
 	struct pidff_device *pidff;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
diff --git a/drivers/hid/usbhid/hid-pidff.h b/drivers/hid/usbhid/hid-pidff.h
new file mode 100644
index 0000000000000..dda571e0a5bd3
--- /dev/null
+++ b/drivers/hid/usbhid/hid-pidff.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __HID_PIDFF_H
+#define __HID_PIDFF_H
+
+#include <linux/hid.h>
+
+/* HID PIDFF quirks */
+
+/* Delay field (0xA7) missing. Skip it during set effect report upload */
+#define HID_PIDFF_QUIRK_MISSING_DELAY		BIT(0)
+
+/* Missing Paramter block offset (0x23). Skip it during SET_CONDITION
+   report upload */
+#define HID_PIDFF_QUIRK_MISSING_PBO		BIT(1)
+
+/* Initialise device control field even if logical_minimum != 1 */
+#define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
+
+/* Use fixed 0x4000 direction during SET_EFFECT report upload */
+#define HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION	BIT(3)
+
+/* Force all periodic effects to be uploaded as SINE */
+#define HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY	BIT(4)
+
+#ifdef CONFIG_HID_PID
+int hid_pidff_init(struct hid_device *hid);
+int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks);
+#else
+#define hid_pidff_init NULL
+#define hid_pidff_init_with_quirks NULL
+#endif
+
+#endif
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e180679ab284c..9ca7e26ac4e92 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1222,21 +1222,6 @@ unsigned long hid_lookup_quirk(const struct hid_device *hdev);
 int hid_quirks_init(char **quirks_param, __u16 bus, int count);
 void hid_quirks_exit(__u16 bus);
 
-#ifdef CONFIG_HID_PID
-int hid_pidff_init(struct hid_device *hid);
-int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks);
-#else
-#define hid_pidff_init NULL
-#define hid_pidff_init_with_quirks NULL
-#endif
-
-/* HID PIDFF quirks */
-#define HID_PIDFF_QUIRK_MISSING_DELAY		BIT(0)
-#define HID_PIDFF_QUIRK_MISSING_PBO		BIT(1)
-#define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
-#define HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION	BIT(3)
-#define HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY	BIT(4)
-
 #define dbg_hid(fmt, ...) pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__)
 
 #define hid_err(hid, fmt, ...)				\
-- 
2.39.5



