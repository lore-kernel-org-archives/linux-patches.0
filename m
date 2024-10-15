Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D71E633E;
	Tue, 15 Oct 2024 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993598; cv=none; b=Rethp5qofhgHq4R3GvAuDN22ZPmufREYiwftRe97azKnEncLwhJFXLGk1jq/hdkYqmU9Ez+vDBcfAQo1l9URilC9tmeiPVLEY19ZDrnTzmD1za/KEHNJu2X8k9oZDogYKl+lTWo33YuIBAkS484xjYJl/m5rwERsKwZRRr9b08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993598; c=relaxed/simple;
	bh=p4v8Lvs4tsCWeSvgsaDmQ+cT5Jzts8vUYSyLeLb6MvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHdkVCiohanTolgw75jlNy1nuEWgk7UMpixgW88HzkIWPkIfP0dxadgT8bbv4qA2FttU02KlRHuKCdjn7B+yi1rj+z0+QjBdtADS/q5FHdzHLbRvQ45vb0edjQofaOZy5Rrq7tQ4NT6y7BedH8iDE+Bhzst6dDf1LChpT4aecP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3kioWN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3kioWN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06361C4CEC6;
	Tue, 15 Oct 2024 11:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993598;
	bh=p4v8Lvs4tsCWeSvgsaDmQ+cT5Jzts8vUYSyLeLb6MvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3kioWN/Pnt3K2q9HTLdnHXfRu7HkI/o0X+8x4ZH42K5n6i2lDOySz7eV3j84cDHu
	 QAenMjZ8760OgY4+CQy7uqkefuqB/3HefN2kEM3cpd3PelR5xhVMJZuADUd5NYkmO1
	 omzXDnwJcxl0wNs2dvbJwepXaYZOYPKHJhdvCs08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/691] HID: multitouch: Add support for Thinkpad X12 Gen 2 Kbd Portfolio
Date: Tue, 15 Oct 2024 13:26:48 +0200
Message-ID: <20241015112458.603533354@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 917207b0deef9..c74b518221129 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -762,6 +762,7 @@
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
 #define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_X12_TAB	0x60fe
+#define USB_DEVICE_ID_LENOVO_X12_TAB2	0x61ae
 #define USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E	0x600e
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 36226f43ac5e9..6a3f4371bd109 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2114,6 +2114,12 @@ static const struct hid_device_id mt_devices[] = {
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



