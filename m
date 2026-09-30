Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56AC4E36E9;
	Wed, 30 Sep 2026 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783923; cv=none; b=BCh2kakLN4gPwWn1bB4AfOJQtfdv3BeH49FgUnsEvJfI6GdjxC8XrNWD5ePsjKbDopsslcCJ7/NkYMekKkXqNCf/St61OcFpVrC8Ais75UZb9LCUpXOCnGurU5YsjxHwSl7yy8V3gTj1hZ5r4wCDbRKqd4TcfprfBCpCm8XJYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783923; c=relaxed/simple;
	bh=TZRjR2E6IS2gvAGR5OWeVDDkTlqXbJVFJhKjraAeWCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLl9teV6WnSXOvhI+ejZDgLxYd6cJNZX8gBDC+G2LfkHKl3+8m4RUpQqHsQWcFkykZs1SRM+w4GKouU0mxrxeqfJLmcSs/mDCu69oVbg0Oe7jrJQtQlDSgMUy4Sf8oVAOX74WaHvN+ivEsb0J5NjQQpdhCXsNnY8qlYef6fjF78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eycEOWOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eycEOWOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385B01F00893;
	Wed, 30 Sep 2026 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783920;
	bh=GM1/CT9GIlfBCK2M9qUrFoJ3wyU7lLk6Pt1XQ30NhQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eycEOWOOaadG1rjLWnwm3umtdnjU3RLGh+KQOkMOV/TX08XFXT3yYYcNyggszYXgo
	 raaocGgxeIVqrpWYR3HSLGBmKXwcDjspZG4rh3OCb3tmWduAc2ouw2Mex/0LpJUMQD
	 mpD0OOIA+mI6jcaeiLYbP+GdXlIGZXceim8gthjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Carvalho <marcocarvalho.web@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 569/595] HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard
Date: Wed, 30 Sep 2026 17:27:42 +0200
Message-ID: <20260930152359.962687030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

commit cdb669a3b8f844aca71fc3224990157d61562165 upstream.

The SDINNOVATION gaming keyboard (USB ID 36ae:feab) stops reporting
input events after its RGB lighting mode is switched about twice.
Disabling USB autosuspend and unbinding the other HID interfaces make
no difference; the issue does not occur on Windows.

HID_QUIRK_ALWAYS_POLL alone resolves it, verified on 7.1.8 via
usbhid.quirks=0x36ae:0xfeab:0x400.

Reported-by: Marco Carvalho <marcocarvalho.web@gmail.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2514627
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    3 +++
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1084,6 +1084,9 @@
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
 
+#define USB_VENDOR_ID_SDINNOVATION		0x36ae
+#define USB_DEVICE_ID_SDINNOVATION_GAMING_KBD	0xfeab
+
 #define USB_VENDOR_ID_SEMICO			0x1a2c
 #define USB_DEVICE_ID_SEMICO_USB_KEYKOARD	0x0023
 #define USB_DEVICE_ID_SEMICO_USB_KEYKOARD2	0x0027
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -171,6 +171,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SDINNOVATION, USB_DEVICE_ID_SDINNOVATION_GAMING_KBD), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },


