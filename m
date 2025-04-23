Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC21819DF4C;
	Wed, 23 Apr 2025 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420261; cv=none; b=BLCc1fuyHysbQwuMeq1N+CcyJl736Az/AIj3sGK63OLrYBhBtW/3xoDHTXG7B8RMSxYyE07wjVQ95aEqUpnc7Bcp2rMMloLM25BHYeLIUNLao+QrXVtCgdTt2G0fXN+7/B91JalhGw6kFP90Ve8sQiBePrMe6SlYjCPwSCHsgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420261; c=relaxed/simple;
	bh=xW2yKJU9Loqc4wDTgmoTNTXD4sZ1UA4uV+59ReUIzKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKha6hXtjAOmz7nvhMcBN2hUiuzWa/aITDbjwO4qtWEpLAYG1bmV+D2te6qpG1nj8VKHJice18kZoBV6fSaHrWH4qhSOT9NVJAZ2EHYu2YySK0Cy0WtTJpeXTTS3qHtI4TCpz2uhntqLy+4q2hg8Q2xi5bgdMop9w42VsxD89P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtODlUck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtODlUck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBD6C4CEE2;
	Wed, 23 Apr 2025 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420260;
	bh=xW2yKJU9Loqc4wDTgmoTNTXD4sZ1UA4uV+59ReUIzKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtODlUckolYDDCc6DmFB4rIDr/RQT2B8iX1ZBbqIv7d/iNQIBbPGQOq0TGrsCHx5h
	 MgD5wrYPpd+WOywtV+z/j1Tp+JKse6xqNl+fe+uAzJouL5/yiHGkq3xxW5l7FVncJQ
	 8yvh2rVsdG8fC6lCJFMdBqqGK3eTCSQjHE1H6cyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/393] HID: pidff: Add PERIODIC_SINE_ONLY quirk
Date: Wed, 23 Apr 2025 16:39:12 +0200
Message-ID: <20250423142645.614463707@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit abdbf8764f4962af2a910abb3a213ecf304a73d3 ]

Some devices only support SINE periodic effect although they advertise
support for all PERIODIC effect in their HID descriptor. Some just do
nothing when trying to play such an effect (upload goes fine), some express
undefined behavior like turning to one side.

This quirk forces all the periodic effects to be uploaded as SINE. This is
acceptable as all these effects are similar in nature and are mostly used as
rumble. SINE is the most popular with others seldom used (especially SAW_UP
and SAW_DOWN).

Fixes periodic effects for PXN and LITE STAR wheels

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-universal-pidff.c | 15 ++++++++++-----
 drivers/hid/usbhid/hid-pidff.c    |  3 +++
 include/linux/hid.h               |  1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 55aad2e4ac1b8..7ef5ab9146b1c 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -168,11 +168,16 @@ static const struct hid_device_id universal_pidff_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FFBEAST, USB_DEVICE_ID_FFBEAST_JOYSTICK), },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FFBEAST, USB_DEVICE_ID_FFBEAST_RUDDER), },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FFBEAST, USB_DEVICE_ID_FFBEAST_WHEEL) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V10) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12_LITE) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12_LITE_2) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_LITE_STAR_GT987_FF) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V10),
+		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12),
+		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12_LITE),
+		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_ID_PXN_V12_LITE_2),
+		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LITE_STAR, USB_DEVICE_LITE_STAR_GT987_FF),
+		.driver_data = HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, universal_pidff_devices);
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index a37cf852a2836..4c94d8cbac43a 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -637,6 +637,9 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 				return -EINVAL;
 			}
 
+			if (pidff->quirks & HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY)
+				type_id = PID_SINE;
+
 			error = pidff_request_effect_upload(pidff,
 					pidff->type_id[type_id]);
 			if (error)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e3a55fd4e9fc4..38e161a827bde 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1225,6 +1225,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks);
 #define HID_PIDFF_QUIRK_MISSING_PBO		BIT(1)
 #define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
 #define HID_PIDFF_QUIRK_FIX_WHEEL_DIRECTION	BIT(3)
+#define HID_PIDFF_QUIRK_PERIODIC_SINE_ONLY	BIT(4)
 
 #define dbg_hid(fmt, ...) pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__)
 
-- 
2.39.5



