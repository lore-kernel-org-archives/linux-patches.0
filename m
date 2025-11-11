Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B626560B;
	Tue, 11 Nov 2025 01:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824572; cv=none; b=Mt0Iqbu2t8lTivdoo9hqqw4h1vECdIGLMejdcroqqs2gpjMYU6tdFvIEm4BGr1zcuW1x9K/wdih2WVGIQyxb45S6QnEK0W5Wyqk8Bb1Cd8S3dbHxGSTqTgLVKZza2i3EAsVkJRbKF7HaTbYiqIWbvDQBLmRWN4/0hEMHO62CITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824572; c=relaxed/simple;
	bh=dg0C5Poynn2Q7UnDJ/hSJHoAaTGrlYdJ5Jl4yzw2Gy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL9KE45uRevATa4l7EP0HsqVAtFf+Nb9H3RmU/F4ueaAQOJZ/4izk4azRHevGnaKozb4oHDqu1D6z1q1/zzjtODV9kkkxIQ5nkiyX68fAW/2usDRkAA73k9Bpm07tHn2aQ9KUXaNnd+T3IE5MfAXjFno5qt5IPk1o6VjlACRe80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOqmXBOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOqmXBOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5226C4CEFB;
	Tue, 11 Nov 2025 01:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824572;
	bh=dg0C5Poynn2Q7UnDJ/hSJHoAaTGrlYdJ5Jl4yzw2Gy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOqmXBOI8cYnoMNxHwuwjoOlcEajz0Yp5jFuE7TvG5+pb7NK7KH3ed4AgMY6UrZ6j
	 GvfOESFr++2rRPMgSoMW6L/qgXsIiJyEHKx4gp+aPSDJ3tImkVjL/zSIeOpwF7GR7B
	 zXwtdF02ydSx+fdX0w4dCz/luDaUCTpLOkmt9j10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 526/849] HID: asus: add Z13 folio to generic group for multitouch to work
Date: Tue, 11 Nov 2025 09:41:36 +0900
Message-ID: <20251111004549.136543847@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit b595974b4afe0e171dd707da570964ff642742e3 ]

The Asus Z13 folio has a multitouch touchpad that needs to bind
to the hid-multitouch driver in order to work properly. So bind
it to the HID_GROUP_GENERIC group to release the touchpad and
move it to the bottom so that the comment applies to it.

While at it, change the generic KEYBOARD3 name to Z13_FOLIO.

Reviewed-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 6 +++---
 drivers/hid/hid-ids.h  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 8db9d4e7c3b0b..a444d41e53b6c 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1387,9 +1387,6 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
-	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3),
-	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
@@ -1419,6 +1416,9 @@ static const struct hid_device_id asus_devices[] = {
 	 * Note bind to the HID_GROUP_GENERIC group, so that we only bind to the keyboard
 	 * part, while letting hid-multitouch.c handle the touchpad.
 	 */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		USB_VENDOR_ID_ASUSTEK, USB_DEVICE_ID_ASUSTEK_ROG_Z13_FOLIO),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		USB_VENDOR_ID_ASUSTEK, USB_DEVICE_ID_ASUSTEK_T101HA_KEYBOARD) },
 	{ }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ded5348d190c5..5721b8414bbdf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -223,7 +223,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_KEYBOARD3 0x1822
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD	0x1866
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2	0x19b6
-#define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3	0x1a30
+#define USB_DEVICE_ID_ASUSTEK_ROG_Z13_FOLIO		0x1a30
 #define USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR		0x18c6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY		0x1abe
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
-- 
2.51.0



