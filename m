Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB4CC433C8;
	Mon, 28 Aug 2023 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218382;
	bh=/lTPQDvbpAAMUoPATOkJF40EWIk+K/GaDB0v3YrCYIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPVsv9+fRBRkrGLj++5r21+nbKOO6WyQgbxdcLb1coae0Pvl6UA0xxm5rsRPuE8K+
	 RiDVJ1umMie9rzzWBSFN7pkDeWdKofE0BYwajyzuiPMPXvRTyEZpaPbMQt7xC0VZt/
	 qx0p1f2BCZoRanfd4BG/0CtGAAiwnrtkYiJCWroI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	dengxiang <dengxiang@nfschina.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 068/129] ALSA: usb-audio: Add support for Mythware XA001AU capture and playback interfaces.
Date: Mon, 28 Aug 2023 12:12:42 +0200
Message-ID: <20230828101155.815161386@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -3677,5 +3677,34 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
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


