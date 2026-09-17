Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B002B4F93BD;
	Thu, 17 Sep 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668141; cv=none; b=EUjg8R810TARqz37avLfwuLzCp5da3Izn+rOdhZcEum2HOfPDfw2Ulv4xXWfugs+xQmundB9HsKDZLXhuML8AGRmE+uSrdLmK6k7rbfUHFfyCjg1feeJOAkI9SrcKV7y/ldjYVa3nazgkGOrD76NVcn5fbqnLqxczxZrA3ucoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668141; c=relaxed/simple;
	bh=+yL+mG2t7H+UYUJBqQWthlMCUJGebiHq8xGwvyt2JHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnJx/6u5HwtMCUYzMs+p3NLkzR1h9bDFy1VIPWnPMXnsGhbO3MnWJ7dLRktixaXh/kh/2o3StptF4NbO9MtDS3Z5vutJuWVYuNxZIGidHzr0t2I3dK/pwCyc8szmBeaF0k88xAqFySTLw22akvEaGWQiXaO/NDMZQp4BsLe3Y4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duzSIDM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duzSIDM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116471F000FF;
	Thu, 17 Sep 2026 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668140;
	bh=eb5VpsC6JVDtjTiby2gpUbAWA5+CPc+EQdBpPMf5z6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duzSIDM3a4AC7VEeihxdIVdM6U01m9l46H/qLd82bLH2Xdk5D01jPHf8x8J0PenHw
	 5LRcbZdQmuh1hW4/KG8bLHyq9pmBxOFX/CDDQS2Qg0f4gdgFP9x6awwngX8mnkI5qO
	 FNPYAzLwyR7fELYj91DbUKuk5x1N7lKujBL38aNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrvoje Nuic <hrvoje.nuic@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0289/1102] Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV
Date: Thu, 17 Sep 2026 16:03:52 +0100
Message-ID: <20260917151546.870663317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Hrvoje Nuic <hrvoje.nuic@gmail.com>

[ Upstream commit ce21a5cf3d1fd92b84ea9ad2b7c7240aff2162d2 ]

Add the USB ID for the Mercusys MA530 Bluetooth adapter. The device uses
a Realtek RTL8761BUV controller and works with the existing Realtek setup
path.

The device reports vendor ID 0x2c4e and product ID 0x0115, and loads the
rtl_bt/rtl8761bu_fw.bin firmware successfully with this quirk.

Signed-off-by: Hrvoje Nuic <hrvoje.nuic@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 14b0ec6bfb83b..90d098d5c4106 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -771,6 +771,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x2ff8, 0xb011), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8761BUV Bluetooth devices */
+	{ USB_DEVICE(0x2c4e, 0x0115), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x2357, 0x0604), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x190e), .driver_info = BTUSB_REALTEK |
-- 
2.53.0



