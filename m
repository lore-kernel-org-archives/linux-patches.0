Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F541CCB32;
	Tue,  8 Oct 2024 12:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391970; cv=none; b=lZM0oJOnIHDfAkDt1PSih4Ge/lhmPofK4/O800xhK+stn78IoPR4HDPYQOyH4K8kWY5YYJdIW9HkQK5s0vPtsX0AxvdJ3dhWKMSCcoHx6djX8Ay+s10HSJIrd+TFCESGVX98tj1ZSEgaZ5vGG0DbfY7hCMwETAH7t8ECTYoj2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391970; c=relaxed/simple;
	bh=jyFA3vhtwsDQTwzA1Qfm12YPcWkZ7Abs4nwDAjeZO+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKLnIzFAitA4BOLo4H7qS8Jf0RsQHYZFoEUW71ajjoATumJaZ6hJG7VTGha2I1M5qCeGNT3ZjMe6/cIaevOTj8WPTnX3ypIP5mZrXwtKFnFeVa1T8u4VhJofJZYPHMHRIANyc/fxtt/f8xWFax5w5AqSrhcsbxavgfkG9t7QroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNjJljZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNjJljZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3DBC4CEC7;
	Tue,  8 Oct 2024 12:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391970;
	bh=jyFA3vhtwsDQTwzA1Qfm12YPcWkZ7Abs4nwDAjeZO+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNjJljZ/zaUHj4coRW9mmCQ17ufomz0gD8Wgw8uL3MBWJzAwUQmhuwOPX6LvNHNBQ
	 nDC14/rjUBeahEOBuhBrB0zsRrEkBUqj3XWcXmwL58bGxnK9kdQMUC6d6+rAgby2Kx
	 DYsxrG7xDvIFXwYr3hVCJgP7tSovhBF3Rf27Dypg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 246/558] HID: multitouch: Add support for Thinkpad X12 Gen 2 Kbd Portfolio
Date: Tue,  8 Oct 2024 14:04:36 +0200
Message-ID: <20241008115712.019945952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 53655f81d9950..06104a4e0fdc1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -794,6 +794,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
+#define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 99812c0f830b5..c4a6908bbe540 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2113,6 +2113,12 @@ static const struct hid_device_id mt_devices[] = {
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



