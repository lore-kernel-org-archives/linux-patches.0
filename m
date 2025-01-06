Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B4715854A;
	Mon,  6 Jan 2025 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177074; cv=none; b=pHmQksFafm0W7igfKdGPPY/06uP/FzHIGKTER9Yrr1LhCWVVTJ83KaChj4tDElieaHiGjcVi1ZskIZg72jeHr+l/tbQEwp2lrUHgYp4l1CCh7UFEya7K1Xy3aaY1E29PsWrBo/GuA0ovGaPkNSsnrtJ6twj3wsmc0JjCBVo1iaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177074; c=relaxed/simple;
	bh=SDwDePgkAc4VsmLg0msTwZWZmEVYValRYbx7RneUbkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uq81T964axrjl0025SqcDnqExMJ/D1+y/u38vWB1vYGI+roeNQeBuFR7rjvexNgrzxRIuDpR16RPIJoqMsMzF8szyPuqi9FViZeyLXUrcI/Kq2g1xBLNvQtsn8lvWWubHGwiIv7D4KdZyPUiutmK+YdBhQ3rcwNx8zPdjckDxSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyRQfEL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyRQfEL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB1DC4CED2;
	Mon,  6 Jan 2025 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177074;
	bh=SDwDePgkAc4VsmLg0msTwZWZmEVYValRYbx7RneUbkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyRQfEL3SZWYxc6kv8uHOKQQTxjAdcuayzXrnZEXo4tpGqaZwt0Pez7syeC40lP0e
	 lh+YhZhoVtKLfoQDAr/ElodaSmwwl9T8k56nm1qtftnoYeBt55DJBMdFXoXxGQAk5G
	 SYhGvOKzk+aaS/hJER45JLO2YR2cq2MpHGwRqtZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/222] Bluetooth: btusb: Add USB HW IDs for MT7921/MT7922/MT7925
Date: Mon,  6 Jan 2025 16:14:06 +0100
Message-ID: <20250106151152.196601793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit 129d329286f624b0ccd66e904a2c27eb4d5196e5 ]

Add HW IDs for wireless module specific to Acer/ASUS
notebook models to ensure proper recognition and functionality.
These HW IDs are extracted from Windows driver inf file.
Note some HW IDs without official drivers, still in testing phase.
Thus, we update module HW ID and test ensure consistent boot success.

Signed-off-by: Jiande Lu <jiande.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: faa5fd605d20 ("Bluetooth: btusb: Add new VID/PID 0489/e111 for MT7925")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index fd57a02046ae..dc0bba7f4028 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -620,6 +620,9 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0e8d, 0x0608), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3606), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* MediaTek MT7922A Bluetooth devices */
 	{ USB_DEVICE(0x0489, 0xe0d8), .driver_info = BTUSB_MEDIATEK |
@@ -661,11 +664,32 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x35f5, 0x7922), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3614), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3615), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x04ca, 0x38e4), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3605), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3607), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* Additional MediaTek MT7925 Bluetooth devices */
+	{ USB_DEVICE(0x0489, 0xe113), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 	{ USB_DEVICE(0x13d3, 0x3602), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x13d3, 0x3603), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
-- 
2.39.5



