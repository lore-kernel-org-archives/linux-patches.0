Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5158933987D;
	Fri,  9 Jan 2026 11:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959474; cv=none; b=WIeo0XAR0GeYc3rHsV1yK3rAuZfQuByANvjNg76mSFvIhflg215geXSKgpSz+l4nYfzpm4e8zUEu6F8SlkWmC0ApDVDYPfCdU6QhpgmMQsfoQtCL6P888IFytb+iR0oSrQ5j640hIVSheHN0w9t7/rHpf2yMRXcM4PddzmiiI9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959474; c=relaxed/simple;
	bh=gyBcjtvaIMyyrVVqlCHM3kYAvovODLID5DqsWWJZdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPTFQICGFn83tFzVlTKa2+k07MEpbD7wiuXNv76AsNt5cu2zStwJeWcS1uUZBa2WXGRWoj7qiyNPoX8cIr0AmfZkk2IQfOCCayzwI/uWx6gXRnPFHC0Z6sqmH2ftPaV/YVsyMcZ0u1/Z2nvsFbKlebYVTv3ek54xbTqh6gx/sDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlfF8z5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlfF8z5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89441C4CEF1;
	Fri,  9 Jan 2026 11:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959473;
	bh=gyBcjtvaIMyyrVVqlCHM3kYAvovODLID5DqsWWJZdo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlfF8z5HkH78AsSf8Y7Vme3T8qxY0n11qrFj3jE41sF7XSIu3DIOZI+ydcFzqHAES
	 EEs5qfUe9gC1z/UFwA3yeViewgR1CG1VsNp6ItzffMVxT1c1HG6+ISbB1yYEsdhhk1
	 yXK0uKa2wGVI49JYAxxKt7X/gTAnV8lARAWi4EGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naoki Ueki <naoki25519@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/737] HID: elecom: Add support for ELECOM M-XT3URBK (018F)
Date: Fri,  9 Jan 2026 12:32:56 +0100
Message-ID: <20260109112135.391169847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4fa45ee77503b..f76fec79e8903 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -75,7 +75,8 @@ static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 20, 28, 22, 14, 8);
 		break;
-	case USB_DEVICE_ID_ELECOM_M_XT3URBK:
+	case USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB:
+	case USB_DEVICE_ID_ELECOM_M_XT3URBK_018F:
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK:
 	case USB_DEVICE_ID_ELECOM_M_XT4DRBK:
 		/*
@@ -117,7 +118,8 @@ static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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
index 6a538dca21a9a..ca9c70c8f3cf1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -439,7 +439,8 @@
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



