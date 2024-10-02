Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC31D0F44;
	Wed,  2 Oct 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880357; cv=none; b=U/tMZun2xVvaNnKFCoXJY+VdNDzQMEUbyS4sVh52gqIoL2Sf/8iyDTjwUuEI1m3ZOxC7J8sEcdlI7jJIcbKIskkP9SXm/qmeOQCImc8lIEg67+Sll4ExFwRs5rAhwwML8H3JT1pvQPva/sH+d1CaOvySVrhvfeVqQC7LJYlboxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880357; c=relaxed/simple;
	bh=8G1gdZNaz69ZCqCAHm/SzYgL3t6obcjlrCDvhgLOLVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujiW4BOz0W2ImezhQM3kz0VDFHQWyd58UY+E7DTS91g2csC/XLGOmBGUq1AhG5eZ+PinyHmyDuBrL3UQeCFlr/5Z1xAmKxQgBL5K9KVpvfzDkaMtVFgCK36B3htr2WqBOA3iXtl70z7u4vTPfyNVSfH2QiCxBWMO4xq/3JB8c/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWacxm5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWacxm5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D034C4CEC2;
	Wed,  2 Oct 2024 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880357;
	bh=8G1gdZNaz69ZCqCAHm/SzYgL3t6obcjlrCDvhgLOLVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWacxm5za0Dp9tJtp2XDL3557XodZ4p6wxJc3TrgIQTfjDOnjfJ1h3UYcfF3+nV8t
	 9tAOPT8EObpz7atSgkSsQaTzMueITMqSJJpI1YlRfHlUOJhhHkvINvHWeUP/cwUaXj
	 Jn/lsmCJ7+7UmTK2cUBk5nKjs8m4WKxv6AmKHRGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 430/538] can: esd_usb: Remove CAN_CTRLMODE_3_SAMPLES for CAN-USB/3-FD
Date: Wed,  2 Oct 2024 15:01:09 +0200
Message-ID: <20241002125809.412493070@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Mätje <stefan.maetje@esd.eu>

commit 75b3189540578f96b4996e4849b6649998f49455 upstream.

Remove the CAN_CTRLMODE_3_SAMPLES announcement for CAN-USB/3-FD devices
because these devices don't support it.

The hardware has a Microchip SAM E70 microcontroller that uses a Bosch
MCAN IP core as CAN FD controller. But this MCAN core doesn't support
triple sampling.

Fixes: 80662d943075 ("can: esd_usb: Add support for esd CAN-USB/3")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20240904222740.2985864-2-stefan.maetje@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/esd_usb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 41a0e4261d15..03ad10b01867 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -3,7 +3,7 @@
  * CAN driver for esd electronics gmbh CAN-USB/2, CAN-USB/3 and CAN-USB/Micro
  *
  * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
- * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
+ * Copyright (C) 2022-2024 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
  */
 
 #include <linux/can.h>
@@ -1116,9 +1116,6 @@ static int esd_usb_3_set_bittiming(struct net_device *netdev)
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		flags |= ESD_USB_3_BAUDRATE_FLAG_LOM;
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		flags |= ESD_USB_3_BAUDRATE_FLAG_TRS;
-
 	baud_x->nom.brp = cpu_to_le16(nom_bt->brp & (nom_btc->brp_max - 1));
 	baud_x->nom.sjw = cpu_to_le16(nom_bt->sjw & (nom_btc->sjw_max - 1));
 	baud_x->nom.tseg1 = cpu_to_le16((nom_bt->prop_seg + nom_bt->phase_seg1)
@@ -1219,7 +1216,6 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {
 	case ESD_USB_CANUSB3_PRODUCT_ID:
 		priv->can.clock.freq = ESD_USB_3_CAN_CLOCK;
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
 		priv->can.bittiming_const = &esd_usb_3_nom_bittiming_const;
 		priv->can.data_bittiming_const = &esd_usb_3_data_bittiming_const;
-- 
2.46.2



