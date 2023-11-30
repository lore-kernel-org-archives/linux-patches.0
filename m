Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD46C54F92;
	Thu, 30 Nov 2023 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3BrKMk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EB9C433C7;
	Thu, 30 Nov 2023 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361627;
	bh=xopBy8s5sP98Ujk0ZYc+cBov0VzPPMCpbI4zOVybMvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3BrKMk2ECCgSAs4e49JdXSxGPxoFdl7t5LuJMGZ1zC5sKMp0ZG2G/6f3voQaEMJg
	 JqWyVmL/7tAVOibuVY3l9BURVbmbQ8m9m6GfKcnFExhwjPkDzomKDh8mo17QWKIj22
	 /Y5OtUw2tnK+Z9MFfegf0CtTmi/3O6I6jOaqovf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	stable <stable@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 6.6 079/112] usb: misc: onboard-hub: add support for Microchip USB5744
Date: Thu, 30 Nov 2023 16:22:06 +0000
Message-ID: <20231130162142.827559218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 6972b38ca05235f6142715db7062ecc87a422e22 upstream.

Add support for the Microchip USB5744 USB3.0 and USB2.0 Hub.

The Microchip USB5744 supports two power supplies, one for 1V2 and one
for 3V3. According to the datasheet there is no need for a delay between
power on and reset, so this value is set to 0.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: stable <stable@kernel.org>
Acked-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20231113145921.30104-3-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c |    2 ++
 drivers/usb/misc/onboard_usb_hub.h |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -437,6 +437,8 @@ static const struct usb_device_id onboar
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2412) }, /* USB2412 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2514) }, /* USB2514B USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2517) }, /* USB2517 USB 2.0 */
+	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2744) }, /* USB5744 USB 2.0 */
+	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x5744) }, /* USB5744 USB 3.0 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0411) }, /* RTS5411 USB 3.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x5411) }, /* RTS5411 USB 2.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0414) }, /* RTS5414 USB 3.2 */
--- a/drivers/usb/misc/onboard_usb_hub.h
+++ b/drivers/usb/misc/onboard_usb_hub.h
@@ -16,6 +16,11 @@ static const struct onboard_hub_pdata mi
 	.num_supplies = 1,
 };
 
+static const struct onboard_hub_pdata microchip_usb5744_data = {
+	.reset_us = 0,
+	.num_supplies = 2,
+};
+
 static const struct onboard_hub_pdata realtek_rts5411_data = {
 	.reset_us = 0,
 	.num_supplies = 1,
@@ -50,6 +55,8 @@ static const struct of_device_id onboard
 	{ .compatible = "usb424,2412", .data = &microchip_usb424_data, },
 	{ .compatible = "usb424,2514", .data = &microchip_usb424_data, },
 	{ .compatible = "usb424,2517", .data = &microchip_usb424_data, },
+	{ .compatible = "usb424,2744", .data = &microchip_usb5744_data, },
+	{ .compatible = "usb424,5744", .data = &microchip_usb5744_data, },
 	{ .compatible = "usb451,8140", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb451,8142", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb4b4,6504", .data = &cypress_hx3_data, },


