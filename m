Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0258634A;
	Mon,  6 Jan 2025 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177977; cv=none; b=noKFoDCVMV4eSF5rRqgyk26tRwNowO5lP2hvvaZuo/6uxGM1Ir2cpzG1Dz1Ln7bQkFqDyaN4lmj6I/7AlPp15WBptW3zK49rSzG8P7iOS3U5Y1Qmr90NHgF8YaCdEyrXcRN31rjJjgjowZMU9Or8ez6GkE0PAerGPDl4+QWmkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177977; c=relaxed/simple;
	bh=KO0piPf1Uj2CH2GoN6IMbKBSh2cbsk0FsbmmFqM2q44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL1eCLRvu28Lu3rmBK3p0tktRoZmBA87g7VXAEkTqZWo8l7emNYRwT9W5dBI0gFdd5LntW+qCAvcj735Xa4G1WFawG15G/7mGTZ2a767pJXVUwhaiza1F7hna2KouWVvKS+RaEyMdiyzd7I69zgcJuRA586VN7pW1Cul+VBsA3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvdejwkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvdejwkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9CBC4CED2;
	Mon,  6 Jan 2025 15:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177977;
	bh=KO0piPf1Uj2CH2GoN6IMbKBSh2cbsk0FsbmmFqM2q44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvdejwkXki0fKBqebJxwwVyDW66TcxI1I9NO8Hzc0faP266Im+//aZMuuC/AkVrni
	 wBRWwJbTi83yykQVv3L0erwygOUhbnLVUD+obAHCzMSVLy8K5eIoocBXMV3BRPGt/C
	 l/yeFI9zI61jDPUW3pjRClWbh/rejO/imm+DxXgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/156] sound: usb: enable DSD output for ddHiFi TC44C
Date: Mon,  6 Jan 2025 16:16:15 +0100
Message-ID: <20250106151145.081321000@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a0767de7f1b7..8ba0aff8be2e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2325,6 +2325,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



