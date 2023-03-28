Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C68D8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6FC4339B;
	Tue, 28 Mar 2023 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015205;
	bh=YqFKyco7U1I0gYHgjJ+6l4kOwci7DgZctRHp6Yk+tuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvlacOXsxPooJIhs/FenhVK9UOtb8j1nGbFNBqUchR2t+QFrXgVWDhVd7AYf+io02
	 f4B2rHHFH5MIpEjuuorB+2gZLj3u/pKZsuo3TQciTyj3/eNexBsUfIWCR0uD7Z375U
	 6191IPAOzHK5NLsxTitiDlTuQfVOTR0V+333feXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	stable <stable@kernel.org>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 6.2 173/240] usb: misc: onboard-hub: add support for Microchip USB2517 USB 2.0 hub
Date: Tue, 28 Mar 2023 16:42:16 +0200
Message-Id: <20230328142626.844317794@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit f7c13cb48e85538709850589b496c4ddb3d3898e upstream.

Add support for Microchip USB2517 USB 2.0 hub to the onboard usb hub
driver. Adopt the generic usb-device compatible ("usbVID,PID").
This hub has the same reset timings as USB2514, so reuse that one.
There is also an USB2517I which just has industrial temperature range.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: stable <stable@kernel.org>
Acked-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20230223073920.2912298-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c |    1 +
 drivers/usb/misc/onboard_usb_hub.h |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -408,6 +408,7 @@ static void onboard_hub_usbdev_disconnec
 static const struct usb_device_id onboard_hub_id_table[] = {
 	{ USB_DEVICE(VENDOR_ID_GENESYS, 0x0608) }, /* Genesys Logic GL850G USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2514) }, /* USB2514B USB 2.0 */
+	{ USB_DEVICE(VENDOR_ID_MICROCHIP, 0x2517) }, /* USB2517 USB 2.0 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0411) }, /* RTS5411 USB 3.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x5411) }, /* RTS5411 USB 2.1 */
 	{ USB_DEVICE(VENDOR_ID_REALTEK, 0x0414) }, /* RTS5414 USB 3.2 */
--- a/drivers/usb/misc/onboard_usb_hub.h
+++ b/drivers/usb/misc/onboard_usb_hub.h
@@ -28,6 +28,7 @@ static const struct onboard_hub_pdata ge
 
 static const struct of_device_id onboard_hub_match[] = {
 	{ .compatible = "usb424,2514", .data = &microchip_usb424_data, },
+	{ .compatible = "usb424,2517", .data = &microchip_usb424_data, },
 	{ .compatible = "usb451,8140", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb451,8142", .data = &ti_tusb8041_data, },
 	{ .compatible = "usb5e3,608", .data = &genesys_gl850g_data, },


