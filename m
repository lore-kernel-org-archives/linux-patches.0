Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9AD21578D;
	Wed, 10 Dec 2025 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351938; cv=none; b=S6X2cg9sueo39KZdIyexTONmrlMlgv6yZwkPtubFmedBJheAu5m2TtfQTwtmeJFjWd9I+77UokWoB6uL/6AC5kBKqRrq+o4bkbt+goX5VBsgpGxdUGcqSset8oWaFWfl/nu/++i5pJHLmP5b6k5j8dRBo6S1vgC10KlumH4NPU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351938; c=relaxed/simple;
	bh=hVRaFSpZNziwvegIJ+vLcqwp1EUrwBKpQ6xYV+DpVRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbMlYAg8QnzoI0y07ndSs+x/AhYGvFOhO/5bC+dbnyvNivdLqL6Dl6SV9l1CCgdGcd9c3KnirRhebJt7tCrg0sCNVjx8ETaDXZwiwsHvH/SCF9Md1dKGxfGwcOIBtU043DL1Ow+ukl0eLamxroHR9hHARUnADCdA1LRfWKvxcqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sl58xM2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sl58xM2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5C3C4CEF1;
	Wed, 10 Dec 2025 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351938;
	bh=hVRaFSpZNziwvegIJ+vLcqwp1EUrwBKpQ6xYV+DpVRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sl58xM2mR0lOKWpRmUDItZgfteh1rbs6BJSEQGuL5oLOF24gEKfN8kAkG8SBefW3C
	 zQGWsrOuI3vuT3U+gmXbnzrrV+AwovplGP4GMmQHHaaikK6C7sd3I/HuFzgS1C+1ys
	 BKS2UrORi528l++pLRLtpomoAoPmPZ1udVgzgajo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naoki Ueki <naoki25519@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 37/49] HID: elecom: Add support for ELECOM M-XT3URBK (018F)
Date: Wed, 10 Dec 2025 16:30:07 +0900
Message-ID: <20251210072949.087597098@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoki Ueki <naoki25519@gmail.com>

[ Upstream commit cdcbb8e8d10f656642380ee13516290437b52b36 ]

The ELECOM M-XT3URBK trackball has an additional device ID (0x018F), which
shares the same report descriptor as the existing device (0x00FB). However,
the driver does not currently recognize this new ID, resulting in only five
buttons being functional.

This patch adds the new device ID so that all six buttons work properly.

Signed-off-by: Naoki Ueki <naoki25519@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elecom.c | 6 ++++--
 drivers/hid/hid-ids.h    | 3 ++-
 drivers/hid/hid-quirks.c | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index defcf91fdd14b..b57b6deb36f42 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -75,7 +75,8 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 20, 28, 22, 14, 8);
 		break;
-	case USB_DEVICE_ID_ELECOM_M_XT3URBK:
+	case USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB:
+	case USB_DEVICE_ID_ELECOM_M_XT3URBK_018F:
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK:
 	case USB_DEVICE_ID_ELECOM_M_XT4DRBK:
 		/*
@@ -117,7 +118,8 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 static const struct hid_device_id elecom_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a85027fbf726a..e0ac6dc07da09 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -445,7 +445,8 @@
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
 #define USB_DEVICE_ID_ELECOM_M_XGL20DLBK	0x00e6
-#define USB_DEVICE_ID_ELECOM_M_XT3URBK	0x00fb
+#define USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB	0x00fb
+#define USB_DEVICE_ID_ELECOM_M_XT3URBK_018F	0x018f
 #define USB_DEVICE_ID_ELECOM_M_XT3DRBK	0x00fc
 #define USB_DEVICE_ID_ELECOM_M_XT4DRBK	0x00fd
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index fa946666969b8..2da21415e676c 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -405,7 +405,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
-- 
2.51.0



