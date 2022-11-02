Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793DBC433C1;
	Wed,  2 Nov 2022 02:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356543;
	bh=N0jvNb7dfAaA2sWFcSe7IqIDsKX02Yesk7i1dWBVZt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsxakMRhvO+SVrRoSt/KNyeHPWdYkAcAor44fy0tRIjNT+f/yKqvjBMhsRedIN267
	 xmJxq0HBsfq+fpRLqH0jvLxdGCZKb5bO5AJyf4c/Wrc84RFpFXMDP2Uu0CjYdG76ta
	 CRi7Byp8Tg/2zMiIfR7OkAyCWlHEctn9qxaIs3HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannu Hartikainen <hannu@hrtk.in>,
	stable <stable@kernel.org>
Subject: [PATCH 6.0 018/240] USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM
Date: Wed,  2 Nov 2022 03:29:53 +0100
Message-Id: <20221102022111.819403421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hannu Hartikainen <hannu@hrtk.in>

commit fc4ade55c617dc73c7e9756b57f3230b4ff24540 upstream.

NVIDIA Jetson devices in Force Recovery mode (RCM) do not support
suspending, ie. flashing fails if the device has been suspended. The
devices are still visible in lsusb and seem to work otherwise, making
the issue hard to debug. This has been discovered in various forum
posts, eg. [1].

The patch has been tested on NVIDIA Jetson AGX Xavier, but I'm adding
all the Jetson models listed in [2] on the assumption that they all
behave similarly.

[1]: https://forums.developer.nvidia.com/t/flashing-not-working/72365
[2]: https://docs.nvidia.com/jetson/archives/l4t-archived/l4t-3271/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/quick_start.html

Signed-off-by: Hannu Hartikainen <hannu@hrtk.in>
Cc: stable <stable@kernel.org>  # after 6.1-rc3
Link: https://lore.kernel.org/r/20220919171610.30484-1-hannu@hrtk.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f99a65a64588..11b27953ccd0 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -388,6 +388,15 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Kingston DataTraveler 3.0 */
 	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* NVIDIA Jetson devices in Force Recovery mode */
+	{ USB_DEVICE(0x0955, 0x7018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7019), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7418), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7721), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7c18), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7e19), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7f21), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
-- 
2.38.1



