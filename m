Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E31BEF85;
	Thu, 30 Jan 2025 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245582; cv=none; b=W4YogkABSqv/AmYClWnghNqgOu62YFwrE2ofpoq/vWDmrPHkF9XNwJxx/lLHgZkbG7/xywbOpXe47ikVPsVgG6OUvv6wc5RLVlkAjw8GyrrY7f+M3V5/Fve2OQtSFAgUn+GFha63Hur7joYhqaSfrip0J/Zshc+BeNjGl4cTkcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245582; c=relaxed/simple;
	bh=fzE7lCc4Df/nZWsxpA+JJrwRe7xMSADFt1Bx4EHRsXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkHVweB9qI8LXXs/7/HEDM4bG6RrZ2fA+LQ9qJR6sNNL+uS9SF9SfKA3ka7Ov3dK0/AfOcPO5mEK96SfBXHoUZ1fAlglZ0qqrbGSJR0gk/YGiumA5qiJVqf2xremE+7EEZuGb802BQgl6JuatyzNWc5aCrF7EHdFs0sUtKbFxyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpJYBkiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpJYBkiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBDDC4CED2;
	Thu, 30 Jan 2025 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245582;
	bh=fzE7lCc4Df/nZWsxpA+JJrwRe7xMSADFt1Bx4EHRsXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpJYBkiHv58bOdvJPYaKu4QmmhUIDk2jXJNLT0ZG5MR26K9iZoucByzeu2zP7tj88
	 ZMd3El0vaWg4wf9hyNO1Gly5INo4cnFqIcfMWvm1mKaOYCVQjS95z8F2PGAwRs9LwI
	 zPBpsXMTgoaiZcGmbpoREARKx+xNfQCS3s6Q28ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.13 16/25] wifi: rtl8xxxu: add more missing rtl8192cu USB IDs
Date: Thu, 30 Jan 2025 14:59:02 +0100
Message-ID: <20250130133457.593483572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 31be3175bd7be89e39c82b3973c9d4ff55a17583 upstream.

The rtl8xxxu has all the rtl8192cu USB IDs from rtlwifi/rtl8192cu/sw.c
except for the following 10, add these to the untested section so they
can be used with the rtl8xxxu as the rtl8192cu are well supported.

This fixes these wifi modules not working on distributions which have
disabled CONFIG_RTL8192CU replacing it with CONFIG_RTL8XXXU_UNTESTED,
like Fedora.

Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2321540
Cc: stable@vger.kernel.org
Cc: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107140833.274986-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -8147,6 +8147,8 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8186, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818a, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x317f, 0xff, 0xff, 0xff),
@@ -8157,12 +8159,18 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x1102, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x11f2, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x06f8, 0xe033, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x07b8, 0x8188, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x07b8, 0x8189, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9041, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9043, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x17ba, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x1e1e, 0xff, 0xff, 0xff),
@@ -8179,6 +8187,10 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x13d3, 0x3357, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x13d3, 0x3358, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x13d3, 0x3359, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x330b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0x4902, 0xff, 0xff, 0xff),
@@ -8193,6 +8205,8 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x4856, 0x0091, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x9846, 0x9041, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0xcdab, 0x8010, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x04f2, 0xaff7, 0xff, 0xff, 0xff),
@@ -8218,6 +8232,8 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0586, 0x341f, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x06f8, 0xe033, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x06f8, 0xe035, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0b05, 0x17ab, 0xff, 0xff, 0xff),
@@ -8226,6 +8242,8 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0df6, 0x0070, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x0df6, 0x0077, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x0789, 0x016d, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x07aa, 0x0056, 0xff, 0xff, 0xff),
@@ -8248,6 +8266,8 @@ static const struct usb_device_id dev_ta
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x330a, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x330d, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0xab2b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192cu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x624d, 0xff, 0xff, 0xff),


