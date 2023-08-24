Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEB8134A1
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F71C433C8;
	Thu, 24 Aug 2023 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889059;
	bh=ogb8c5+e5ob+kz4HLGZ1nfAimY3Azz4UbOohnc/VHuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elxDRkpjlgA08DVCCeDlttZwY6m3eWxI/gZHvNzzhVKusDPYXmLGpWd7SGD0yHL2s
	 XIMbF1dGKRSt5wYiSmZMxWp4Hr2tXyb+JD5rW9h8IE22NMvZWOvaT5rJejj6f4T7Rk
	 LWubFUVk9m+aJ+m2nUtbz94QvaLnezvMXtvuc1ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	dengxiang <dengxiang@nfschina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 110/139] ALSA: usb-audio: Add support for Mythware XA001AU capture and playback interfaces.
Date: Thu, 24 Aug 2023 16:50:33 +0200
Message-ID: <20230824145028.300962306@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: dengxiang <dengxiang@nfschina.com>

commit 788449ae57f4273111b779bbcaad552b67f517d5 upstream.

This patch adds a USB quirk for Mythware XA001AU USB interface.

Signed-off-by: dengxiang <dengxiang@nfschina.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230803024437.370069-1-dengxiang@nfschina.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -4431,6 +4431,35 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/* Advanced modes of the Mythware XA001AU.
+	 * For the standard mode, Mythware XA001AU has ID ffad:a001
+	 */
+	USB_DEVICE_VENDOR_SPEC(0xffad, 0xa001),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Mythware",
+		.product_name = "XA001AU",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_IGNORE_INTERFACE,
+			},
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE,
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE,
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE


