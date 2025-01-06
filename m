Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9D718B46A;
	Mon,  6 Jan 2025 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177505; cv=none; b=BT4+B2Gyqmhsg8omXhO1f+5Rv4XpHkjLrEmjXlvArzjTdEWDHR6TsG1/XSPMeskZG7QsZXxzqW2zWUlPCFgoQIlsGVafVQfgbHvZUaIo1gwWKXoJhftowJWyEUPGWvzaJUrKt7WAMoY3Y9ZrRUPzt/unLqzt1Mw+GjrfXr4nxTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177505; c=relaxed/simple;
	bh=E7+ToMoqz4TbUfg0ddktefrg14EYBlgOP5fPORL+c1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSC4E63zYPem+tvivzvmE2TVaqGCU64wtbp6svR+2xvj+EMRYYqWxlXJTCT/oAKs+FEUKfBI2wh1CDgrULZYR0uyyRkUi7Nj9ugxWf6EkyMXZru/H0wM6OGmjV5xHb8QLDFbXEXkQu5cPkZKD02a/Eg/exPKMQyWArie5dSm5oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF7ZaGgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF7ZaGgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02752C4CED2;
	Mon,  6 Jan 2025 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177504;
	bh=E7+ToMoqz4TbUfg0ddktefrg14EYBlgOP5fPORL+c1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF7ZaGggO89HNk9uU8khk6OwbrELA54usFe/ZumjupBWvzDBfMrNFFaR+81sVd55Y
	 JYGr2GIvVaMY5dmXYR2oPe9K7phiO0w8Ke+qTq9gm3WzOTPT1mW1j4/Og0LoppYtvV
	 4uM4H8P84giAU9N4aEEMIZk5MQRYBd2Coc/xooVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/222] sound: usb: enable DSD output for ddHiFi TC44C
Date: Mon,  6 Jan 2025 16:16:28 +0100
Message-ID: <20250106151157.730014776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ratiu <adrian.ratiu@collabora.com>

[ Upstream commit c84bd6c810d1880194fea2229c7086e4b73fddc1 ]

This is a UAC 2 DAC capable of raw DSD on intf 2 alt 4:

Bus 007 Device 004: ID 262a:9302 SAVITECH Corp. TC44C
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 [unknown]
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x262a SAVITECH Corp.
  idProduct          0x9302 TC44C
  bcdDevice            0.01
  iManufacturer           1 DDHIFI
  iProduct                2 TC44C
  iSerial                 6 5000000001
.......
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      32
      iInterface              0
	AudioStreaming Interface Descriptor:
          bLength                16
          bDescriptorType        36
          bDescriptorSubtype     1 (AS_GENERAL)
          bTerminalLink          3
          bmControls             0x00
          bFormatType            1
          bmFormats              0x80000000
          bNrChannels            2
          bmChannelConfig        0x00000000
          iChannelNames          0
.......

Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
Link: https://patch.msgid.link/20241209090529.16134-1-adrian.ratiu@collabora.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 8eed8d9742fd..ec81b47c41c9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2225,6 +2225,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
 		   QUIRK_FLAG_SET_IFACE_FIRST),
+	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
-- 
2.39.5



