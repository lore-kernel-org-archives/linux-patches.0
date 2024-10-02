Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8431D0426;
	Wed,  2 Oct 2024 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878731; cv=none; b=k+PHoDnBA2iujKh+uNmrKwnb/k3iVvlCCFHCzXn43Qm5hKc6TYg5sRZa43sTHkwsR/pzmXJkniLURVxEKQrIdC7yrCxp/FZDkqXG42XYrS006JtHzWcM09N0x8epblZ2K/E4IShfyjHeBnDI81MQPTFKZi0hvGFgFpDFDU0PyAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878731; c=relaxed/simple;
	bh=9m+9FuLVZnu2RHATmju/8lpOTFLUMyXyNkAmynF8rjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8RtLTDl7UCU9HCD0YaJdJgTZJFpnZ1BBB7RAkEHoqTTeUcfNbUatqyU76fJi1onYKUNDeThev90KsmAERQ2hdOIhbI+vMRcbLW4rnd4E4pdr0dHuKe6ocsPlT9E9zVkXDGE2SuiCKjNRTTapTxcPmb9k6Ecuwwjt3BJnQwKWCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsGsvkMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsGsvkMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F2AC4CEC2;
	Wed,  2 Oct 2024 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878731;
	bh=9m+9FuLVZnu2RHATmju/8lpOTFLUMyXyNkAmynF8rjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsGsvkMKVN2ZFue8d1NKMDIk8dlcGUcXNChWkedo7toGfIUvH5cjZljeRQczATYmA
	 /S/qofZEvpE3LqL80dySZoRl6Ge5GR+NJv47nfONgfQFAhqVLcN7Q32FR+Mwc5yS6C
	 +65ObdhKjYITkZPJH4A8xzNfzuOqZfi8lahjsUNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.10 514/634] can: esd_usb: Remove CAN_CTRLMODE_3_SAMPLES for CAN-USB/3-FD
Date: Wed,  2 Oct 2024 15:00:14 +0200
Message-ID: <20241002125831.397046998@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/usb/esd_usb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

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
@@ -1116,9 +1116,6 @@ static int esd_usb_3_set_bittiming(struc
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		flags |= ESD_USB_3_BAUDRATE_FLAG_LOM;
 
-	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
-		flags |= ESD_USB_3_BAUDRATE_FLAG_TRS;
-
 	baud_x->nom.brp = cpu_to_le16(nom_bt->brp & (nom_btc->brp_max - 1));
 	baud_x->nom.sjw = cpu_to_le16(nom_bt->sjw & (nom_btc->sjw_max - 1));
 	baud_x->nom.tseg1 = cpu_to_le16((nom_bt->prop_seg + nom_bt->phase_seg1)
@@ -1219,7 +1216,6 @@ static int esd_usb_probe_one_net(struct
 	switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {
 	case ESD_USB_CANUSB3_PRODUCT_ID:
 		priv->can.clock.freq = ESD_USB_3_CAN_CLOCK;
-		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
 		priv->can.bittiming_const = &esd_usb_3_nom_bittiming_const;
 		priv->can.data_bittiming_const = &esd_usb_3_data_bittiming_const;


