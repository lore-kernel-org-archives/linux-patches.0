Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E325F988;
	Thu, 17 Apr 2025 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914067; cv=none; b=jhDXhfFyn2CWHfpVkKenEHliKEfcj+oD7kTP+DQb4xjy+0flmNp1DNTGr8ARTgm8CjIk7OA51MbFCuUVsTxaUzmZ9phf8jFq3a7APSnJl8jnZPfLsMRgq6bT4I8OITCOQC1Kssuo89jvIjuN3jHkR370HeGH976w+7HVsO4k/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914067; c=relaxed/simple;
	bh=fUGT2ULvmQb5qgc8sxCgTjCH56+HNGb80VrUJwiGaJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax9fFAJ1AO4Z7aEhlPVKiqc2an8t0lvaw2jOo8xIWzpZUn0QyxxhFLlwQZsQiUEMqZS0rB1atd4RSivBx3ERlV8+7yYtl1uqQupO5g2iytxWe1t15pq/sdHv1q7meVOrfhPns4IdUDe8jye35jAkoSNh/pHjMC/XSSAvH6ctvtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLNuJUc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLNuJUc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE3C4CEE4;
	Thu, 17 Apr 2025 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914066;
	bh=fUGT2ULvmQb5qgc8sxCgTjCH56+HNGb80VrUJwiGaJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLNuJUc3/6dsZs0EgL5p125xzrCqz0gLp4QS8wXOy08/xSvBAhtW8w/TPvjEryBts
	 HwTatrVRkourLQX6DC9glqbATLTm2FxoMN3y6pB2ZvRBKh+CF9dNK0Bc1Yqhdbjtmh
	 peBC3n0I/mtN/kszrtDm/Z5MJKquEDDyzAlpyEvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Schulze <max.schulze@online.de>,
	David Hollis <dhollis@davehollis.com>,
	Sven Kreiensen <s.kreiensen@lyconsys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 095/414] net: usb: asix_devices: add FiberGecko DeviceID
Date: Thu, 17 Apr 2025 19:47:33 +0200
Message-ID: <20250417175115.261162902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Schulze <max.schulze@online.de>

[ Upstream commit 4079918ae720e842ed7dff65fedeb9980b374995 ]

The FiberGecko is a small USB module that connects a 100 Mbit/s SFP

Signed-off-by: Max Schulze <max.schulze@online.de>
Tested-by: Max Schulze <max.schulze@online.de>
Suggested-by: David Hollis <dhollis@davehollis.com>
Reported-by: Sven Kreiensen <s.kreiensen@lyconsys.com>
Link: https://patch.msgid.link/20250212150957.43900-2-max.schulze@online.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 57d6e5abc30e8..da24941a6e444 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -1421,6 +1421,19 @@ static const struct driver_info hg20f9_info = {
 	.data = FLAG_EEPROM_MAC,
 };
 
+static const struct driver_info lyconsys_fibergecko100_info = {
+	.description = "LyconSys FiberGecko 100 USB 2.0 to SFP Adapter",
+	.bind = ax88178_bind,
+	.status = asix_status,
+	.link_reset = ax88178_link_reset,
+	.reset = ax88178_link_reset,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
+	.rx_fixup = asix_rx_fixup_common,
+	.tx_fixup = asix_tx_fixup,
+	.data = 0x20061201,
+};
+
 static const struct usb_device_id	products [] = {
 {
 	// Linksys USB200M
@@ -1578,6 +1591,10 @@ static const struct usb_device_id	products [] = {
 	// Linux Automation GmbH USB 10Base-T1L
 	USB_DEVICE(0x33f7, 0x0004),
 	.driver_info = (unsigned long) &lxausb_t1l_info,
+}, {
+	/* LyconSys FiberGecko 100 */
+	USB_DEVICE(0x1d2a, 0x0801),
+	.driver_info = (unsigned long) &lyconsys_fibergecko100_info,
 },
 	{ },		// END
 };
-- 
2.39.5



