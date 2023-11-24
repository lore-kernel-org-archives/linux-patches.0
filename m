Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2025A3306F;
	Fri, 24 Nov 2023 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdcP0JPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5670C433CA;
	Fri, 24 Nov 2023 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853990;
	bh=Z8BMcyb/+woExFS5faO8x931uO7Z28+rz1YQ5V0UbZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdcP0JPsSZQGdk9RIf1LQzDHZP9dc/AT2yCBximyZ/KOgFRak2KD3ZH9icC5kUDto
	 o7EXk9gbbzaSbeUR2YzPfKGMHAipEWTilXqRTMuZv9HtTtpoNFCSGo40ql9xfP/sXY
	 nQLfunHMRcdgVm5gRVgt42V7TorbDPRFi9sdGpYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Hwang <josephsih@chromium.org>,
	Alain Michaud <alainm@chromium.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/159] Bluetooth: btusb: add Realtek 8822CE to usb_device_id table
Date: Fri, 24 Nov 2023 17:55:28 +0000
Message-ID: <20231124171946.499760665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Hwang <josephsih@chromium.org>

[ Upstream commit 33bfd94a05abb5a63e323dd1454bc580d4bf992c ]

This patch adds the Realtek 8822CE controller to the usb_device_id
table to support the wideband speech capability.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: da06ff1f585e ("Bluetooth: btusb: Add 0bda:b85b for Fn-Link RTL8852BE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c42324ae8eeff..854bf20353d3b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -353,6 +353,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_IGNORE },
 
+	/* Realtek 8822CE Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_REALTEK },
-- 
2.42.0



