Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FBE171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F8FC433D2;
	Mon, 22 May 2023 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784565;
	bh=F5grBt5yyAVbdzZgMTIbqVhy0XTYwJT8GjYCAdJiQ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hapyeSKPgMw0+NESBwtk/+YgFdjWtQ1Lc9MU7dfiMneJikyPVNW8WXpj2CxgBBk7b
	 wiUxq1JyiPKsqbnQnPBVGSxNx05VDpEjMIIc8M2pqPmoO53uM+i2IFHkwRXx8XlxoK
	 1BBO1ZDmWg0b7sO3j0oH/O2e6w4+w2MPGtPo3sKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reese Russell <git@qrsnap.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 126/364] wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support
Date: Mon, 22 May 2023 20:07:11 +0100
Message-Id: <20230522190415.950824770@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reese Russell <git@qrsnap.io>

[ Upstream commit 03eb52dd78cab08f13925aeec8315fbdbcba3253 ]

Issue: Though the Netgear AXE3000 (A8000) is based on the mt7921
chipset because of the unique USB VID:PID combination this device
does not initialize/register. Thus making it not plug and play.

Fix: Adds support for the Netgear AXE3000 (A8000) based on the Mediatek
mt7921au chipset. The method of action is adding the USD VID/PID
pair to the mt7921u_device_table[] array.

Notes: A retail sample of the Netgear AXE3000 (A8000) yeilds the following
from lsusb D 0846:9060 NetGear, Inc. Wireless_Device. This pair
0846:9060 VID:PID has been reported by other users on Github.

Signed-off-by: Reese Russell <git@qrsnap.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 70c9bbdbf60e9..09ab9b83c2011 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -18,6 +18,9 @@ static const struct usb_device_id mt7921u_device_table[] = {
 	/* Comfast CF-952AX */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3574, 0x6211, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	/* Netgear, Inc. [A8000,AXE3000] */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ },
 };
 
-- 
2.39.2



