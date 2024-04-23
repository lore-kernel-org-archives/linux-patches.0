Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105191474D6;
	Tue, 23 Apr 2024 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908713; cv=none; b=tcTrh16soHSVxSJILx7d7S1aznpQ5h0p4zguRfySYF/WUQWJsNxfdSYSvlcHqU7q4qrjaPvnO9idKGdDuRvcE56PpNEEqHbg1R9Zlu63KBMouoqcvOiiE9Y9D+c18ZD2LEZ4FsKXsygIE8xHYXCtX671Fw1WAgL8wI14PdHYnl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908713; c=relaxed/simple;
	bh=lRT14J3Dy5A4J9zER+4d1r8pDhbQGPaLLXhzzw0h8ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWU2wqxFgiqVc2k54i7ctdYgCVSiPRPQTtIUdco4Vyx6vyz0EStAss3iH2n9uYtUQM+GsZ/VW0zlG0lYGCskkFuNGwpn86Iey8uOyh13NjHV2bdH9wRjJhdteFm/3Kbfegh9R6ekVo2IwMBvY8cJbUJ9LQ1WjKMTko0R74oanVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LInUS4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LInUS4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D709CC116B1;
	Tue, 23 Apr 2024 21:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908712;
	bh=lRT14J3Dy5A4J9zER+4d1r8pDhbQGPaLLXhzzw0h8ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LInUS4U82QdaGk9o6A+IjaiPdp0TALWXbuZSTI0bF5/B9tHod+bUd6Gh5HcmWxLK
	 ulGUBzL/s08NKOiy/SbTXIokmBVz+rlDArH/jdrG8JTNascHw8YdQvZkso1ff0iDE/
	 yatpvJtFkQ2E/MqLxHAm4ZikkH+wtIoUTVw3SBCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Perrot <philippe@perrot-net.fr>,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/141] ALSA: scarlett2: Add support for Clarett 8Pre USB
Date: Tue, 23 Apr 2024 14:38:58 -0700
Message-ID: <20240423213855.496027102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit b9a98cdd3ac7b80d8ea0f6acd81c88ad3d8bcb4a ]

The Clarett 8Pre USB works the same as the Clarett+ 8Pre, only the USB
ID is different.

Tested-by: Philippe Perrot <philippe@perrot-net.fr>
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/e59f47b29e2037f031b56bde10474c6e96e31ba5.1694705811.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c        |  1 +
 sound/usb/mixer_scarlett_gen2.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 1f32e3ae3aa31..b122d7aedb443 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3447,6 +3447,7 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x1235, 0x8213): /* Focusrite Scarlett 8i6 3rd Gen */
 	case USB_ID(0x1235, 0x8214): /* Focusrite Scarlett 18i8 3rd Gen */
 	case USB_ID(0x1235, 0x8215): /* Focusrite Scarlett 18i20 3rd Gen */
+	case USB_ID(0x1235, 0x8208): /* Focusrite Clarett 8Pre USB */
 	case USB_ID(0x1235, 0x820c): /* Focusrite Clarett+ 8Pre */
 		err = snd_scarlett_gen2_init(mixer);
 		break;
diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 2668bc1b918ba..f949d22da382d 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *   Focusrite Scarlett Gen 2/3 and Clarett+ Driver for ALSA
+ *   Focusrite Scarlett Gen 2/3 and Clarett USB/Clarett+ Driver for ALSA
  *
  *   Supported models:
  *   - 6i6/18i8/18i20 Gen 2
  *   - Solo/2i2/4i4/8i6/18i8/18i20 Gen 3
+ *   - Clarett 8Pre USB
  *   - Clarett+ 8Pre
  *
- *   Copyright (c) 2018-2022 by Geoffrey D. Bennett <g at b4.vu>
+ *   Copyright (c) 2018-2023 by Geoffrey D. Bennett <g at b4.vu>
  *   Copyright (c) 2020-2021 by Vladimir Sadovnikov <sadko4u@gmail.com>
  *   Copyright (c) 2022 by Christian Colglazier <christian@cacolglazier.com>
  *
@@ -56,6 +57,9 @@
  * Support for Clarett+ 8Pre added in Aug 2022 by Christian
  * Colglazier.
  *
+ * Support for Clarett 8Pre USB added in Sep 2023 (thanks to Philippe
+ * Perrot for confirmation).
+ *
  * This ALSA mixer gives access to (model-dependent):
  *  - input, output, mixer-matrix muxes
  *  - mixer-matrix gain stages
@@ -899,7 +903,8 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x8214), &s18i8_gen3_info },
 	{ USB_ID(0x1235, 0x8215), &s18i20_gen3_info },
 
-	/* Supported Clarett+ devices */
+	/* Supported Clarett USB/Clarett+ devices */
+	{ USB_ID(0x1235, 0x8208), &clarett_8pre_info },
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info },
 
 	/* End of list */
-- 
2.43.0



