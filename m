Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE56B28E03
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iItQI5If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBCCC433C7;
	Mon, 16 Oct 2023 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468287;
	bh=CJ0YD7BWlS7Du92oIv/5SV1t4+hN2zFZ4VDycHEx0WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iItQI5If5w6kN0sPECN7NfeC/NkIfu3Y7BftqhI33Nbic5X4dEGM3jllKUrGXzY5Y
	 XL5qguKU4IywGISvjhE6dUnwccOCBcBEKx0XSCBonzMCfrgc9qTAlOV/pTOAZb1iIw
	 Wbw2Lk+kR+pl1yqtdWwYUV4Wsg6SH9o8lh5Z693Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco@wolfvision.net>,
	stable <stable@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 6.5 180/191] usb: misc: onboard_hub: add support for Microchip USB2412 USB 2.0 hub
Date: Mon, 16 Oct 2023 10:42:45 +0200
Message-ID: <20231016084019.575683212@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco@wolfvision.net>

commit e59e38158c61162f2e8beb4620df21a1585117df upstream.

The USB2412 is a 2-Port USB 2.0 hub controller that provides a reset pin
and a single 3v3 powre source, which makes it suitable to be controlled
by the onboard_hub driver.

This hub has the same reset timings as USB2514/2517 and the same
onboard hub specific-data can be reused for USB2412.

Signed-off-by: Javier Carrasco <javier.carrasco@wolfvision.net>
Cc: stable <stable@kernel.org>
Acked-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20230911-topic-2412_onboard_hub-v1-1-7704181ddfff@wolfvision.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c |    1 +
 drivers/usb/misc/onboard_usb_hub.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -409,6 +409,7 @@ static void onboard_hub_usbdev_disconnec
 static const struct usb_device_id onboard_hub_id_table[] = {
 	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0608) }, /* Genesys Logic GL850G USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0610) }, /* Genesys Logic GL852G USB 2.0 */
+	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2412) }, /* USB2412 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2514) }, /* USB2514B USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2517) }, /* USB2517 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0411) }, /* RTS5411 USB 3.1 */
--- a/drivers/usb/misc/onboard_usb_hub.h
+++ b/drivers/usb/misc/onboard_usb_hub.h
@@ -35,6 +35,7 @@ static const struct onboard_hub_pdata vi
 };
 
 static const struct of_device_id onboard_hub_match[] = {
+	{ .compatible = "usb424,2412", .data = &microchip_usb424_data, },
 	{ .compatible = "usb424,2514", .data = &microchip_usb424_data, },
 	{ .compatible = "usb424,2517", .data = &microchip_usb424_data, },
 	{ .compatible = "usb451,8140", .data = &ti_tusb8041_data, },


