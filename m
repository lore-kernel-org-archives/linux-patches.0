Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FA911C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71D1C433C8;
	Thu, 24 Aug 2023 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888758;
	bh=feGQl3AYoMHj72KWyZFAXXH6nLhS5tdc8c2kFQbpuOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O67b5ixZmpGUEzUJZ8FqODkYN6+RpHbjRdUcjnDLOio5MxMyj+F+KuOTa6hsg2WBM
	 A9iYl8YANuG7k2JkZw9AUPuurvuHK6THCnPUTciLvGMj8dXj5ted44Aa5a4Iyo6QnZ
	 Ol02tHy1xXCWRCHv0iAvIVO9iLk1L1GhtfV08sO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Anderson <ruinairas1992@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/139] Bluetooth: btusb: Add MT7922 bluetooth ID for the Asus Ally
Date: Thu, 24 Aug 2023 16:49:14 +0200
Message-ID: <20230824145024.955770664@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Anderson <ruinairas1992@gmail.com>

[ Upstream commit fa01eba11f0e57c767a5eab5291c7a01407a00be ]

Adding the device ID from the Asus Ally gets the bluetooth working
on the device.

Signed-off-by: Matthew Anderson <ruinairas1992@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9eb2267bd3a02..15d253325fd8a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -475,6 +475,9 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0489, 0xe0d9), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
+	{ USB_DEVICE(0x0489, 0xe0f5), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH |
+						     BTUSB_VALID_LE_STATES },
 	{ USB_DEVICE(0x13d3, 0x3568), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH |
 						     BTUSB_VALID_LE_STATES },
-- 
2.40.1



