Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42E8168C6
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CF7C4339C;
	Mon,  8 May 2023 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540953;
	bh=xGAMcCnHDbRWVOogbJQae0UOmzlwX5hiD4oh9pluxW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuVrMgOVl024+3owo0KmPIh1aohFffHX74/bWQ+ZUQzHbZl7asRX5Trv/W6iWTudf
	 NH6cmjjxmby0FdHuhxTHi8UuQU+ao2QHwuUl66utVFzfx1CzdlBnL1guDSPu5x67U7
	 Tz7Zfw+2ZAjmOfqI4CzAyyzHvfCT2EYfwGEyLhW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	=?UTF-8?q?Gr=C3=A9gory=20Desor?= <gregory.desor@free.fr>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 561/611] ALSA: usb-audio: Add quirk for Pioneer DDJ-800
Date: Mon,  8 May 2023 11:46:43 +0200
Message-Id: <20230508094440.213679847@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geraldo Nascimento <geraldogabriel@gmail.com>

commit 7501f472977df233d039d86c6981e0641708e1ca upstream.

One more Pioneer quirk, this time for DDJ-800, which is quite similar like
other DJ DDJ models but with slightly different EPs or channels.

Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Tested-by: Grégory Desor <gregory.desor@free.fr>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/ZFLLzgEcsSF5aIHG@geday
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3884,6 +3884,64 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+{
+	/*
+	 * PIONEER DJ DDJ-800
+	 * PCM is 6 channels out, 6 channels in @ 44.1 fixed
+	 * The Feedback for the output is the input
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x0029),
+		.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 6,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_44100,
+					.rate_min = 44100,
+					.rate_max = 44100,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 44100 }
+				}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 6,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC|
+					USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_44100,
+					.rate_min = 44100,
+					.rate_max = 44100,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 44100 }
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 /*
  * MacroSilicon MS2100/MS2106 based AV capture cards
  *


