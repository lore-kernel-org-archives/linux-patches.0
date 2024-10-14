Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAF21D278A;
	Mon, 14 Oct 2024 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919013; cv=none; b=hundd+cdlDjJrpeu1Q8J5zCkcoFtxDMqJFgQhVd3JmE8mCY9fpLtnpzpSUUuWa7M3bZZ41jr8jy0rXGX3OqqsF2jpLLY601j6w/tqEgOdhxiqzAvgv6Frve1ZCwA/Ri+0XD5WCeQnwI93rut04BtMs9yWczXlkzhnBLtYORvd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919013; c=relaxed/simple;
	bh=DeRYgW+xUUEySSRqxgxQW/OjH4GGwnd0kmq6c0vE+Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSsMxYCq/HkxWxLp2nwcnY/xvIf8GMs5Nxno2VRvVB3v02xVfMfBjPVWPGpQgqWpxaRJZjb8egyz3KXX+meP9BD3PjTASRuYdsQ13DU1SO9a7GX3lvmXd5ngPXRXn4IPs9UQTAGBQ74tlAxVKGxl0FKjMBZG+wDLdtYg4ZMMrTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRgWta6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRgWta6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A00C4CEC7;
	Mon, 14 Oct 2024 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919012;
	bh=DeRYgW+xUUEySSRqxgxQW/OjH4GGwnd0kmq6c0vE+Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRgWta6gpjYfhwonJ+zcRSYQ1Yig+/XNE4naG3eLziNWzr/qVuyN5iwYi/411BTrm
	 kgqR8kU0GvCpj6Wbq9ynBshje8qhCHUW5o/3tkJKL71LmxkKGfGPZ/PsqL5tbEVJtN
	 nIaagfF5uy3PKc3lWzJ5Wk4pA5CpiC3bWxMIEZZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 488/798] HID: multitouch: Add support for Thinkpad X12 Gen 2 Kbd Portfolio
Date: Mon, 14 Oct 2024 16:17:22 +0200
Message-ID: <20241014141237.142962636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Sankar <vishnuocv@gmail.com>

[ Upstream commit 65b72ea91a257a5f0cb5a26b01194d3dd4b85298 ]

This applies similar quirks used by previous generation device, so that
Trackpoint and buttons on the touchpad works.  New USB KBD PID 0x61AE for
Thinkpad X12 Tab is added.

Signed-off-by: Vishnu Sankar <vishnuocv@gmail.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3359a24ca2419..ede3a052ead55 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -786,6 +786,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
+#define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 8ef41d6e71d42..6d76463f5896f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2116,6 +2116,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB) },
 
+	/* Lenovo X12 TAB Gen 2 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X12_TAB2) },
+
 	/* Logitech devices */
 	{ .driver_data = MT_CLS_NSMU,
 		HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH_WIN_8,
-- 
2.43.0



