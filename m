Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34FD143C57;
	Tue, 23 Apr 2024 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908614; cv=none; b=pU1lP1wHuQRNZLkGacF1c9NdEaEuKRj1Rt/qp/d+bIRgBLCt3Y7Qz5rq8FnhSpqJA/EwI0duQgQQUKRUjsMN5qKOZXuomWWI/DQezbpYcUQ1oYL2EBWIGPbBuhIZKSyt3j2wKwjTGQWOxp8rN2V2ITGqnCOdNsk9uSqmuY70VGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908614; c=relaxed/simple;
	bh=VC2DR4EHP8aPfUUw534PtERC4Z/MGhQ7Lhj7sWtZuZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzyKhhZJF5NCe81kcjPCy4r0rwt/521Gp01huhFlbSuuyXn7m3uPFi+OkXNwJLMpDeB4KVwLXoevJQAD7T5v90GLLzRgUiNxtgQcCwW8NTlDk2yq/I4u2gDiHYmVVoFGe6LT6erbTjNnDzopzomFZFG0b5nYhUnnYvZ4+RP/tG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEEQYnAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEEQYnAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B14C116B1;
	Tue, 23 Apr 2024 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908613;
	bh=VC2DR4EHP8aPfUUw534PtERC4Z/MGhQ7Lhj7sWtZuZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEEQYnAugDcD6tpF7hXml/CmLYOGblMmZscfV2ojEd0uP0hfxicawFBbZF/Mf/WxD
	 3lLUHshnAzTdptlxHZObrac4pSzJpgq02vOTLQB2jwpGOHs2GIEis6XDvAeTEnNILm
	 1tuuTDch3sDensG9DG5xFD8AzlgZBpnV7rDHnbIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/158] ALSA: scarlett2: Rename scarlett_gen2 to scarlett2
Date: Tue, 23 Apr 2024 14:38:42 -0700
Message-ID: <20240423213858.523163777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit efc3d7d20361cc59325a9f0525e079333b4459c0 ]

This driver was originally developed for the Focusrite Scarlett Gen 2
series. Since then Focusrite have used a similar protocol for their
Gen 3, Gen 4, Clarett USB, Clarett+, and Vocaster series.

Let's call this common protocol the "Scarlett 2 Protocol" and rename
the driver to scarlett2 to not imply that it is restricted to Gen 2
series devices.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/e1ad7f69a1e20cdb39094164504389160c1a0a0b.1698342632.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                          |  2 +-
 sound/usb/Makefile                                   |  2 +-
 sound/usb/mixer_quirks.c                             |  4 ++--
 .../usb/{mixer_scarlett_gen2.c => mixer_scarlett2.c} | 12 +++++++-----
 sound/usb/mixer_scarlett2.h                          |  7 +++++++
 sound/usb/mixer_scarlett_gen2.h                      |  7 -------
 6 files changed, 18 insertions(+), 16 deletions(-)
 rename sound/usb/{mixer_scarlett_gen2.c => mixer_scarlett2.c} (99%)
 create mode 100644 sound/usb/mixer_scarlett2.h
 delete mode 100644 sound/usb/mixer_scarlett_gen2.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 40312bb550f06..72a2880afab7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8142,7 +8142,7 @@ M:	Geoffrey D. Bennett <g@b4.vu>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
-F:	sound/usb/mixer_scarlett_gen2.c
+F:	sound/usb/mixer_scarlett2.c
 
 FORCEDETH GIGABIT ETHERNET DRIVER
 M:	Rain River <rain.1986.08.12@gmail.com>
diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index db5ff76d0e61f..8c657c2753c84 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -12,7 +12,7 @@ snd-usb-audio-objs := 	card.o \
 			mixer.o \
 			mixer_quirks.o \
 			mixer_scarlett.o \
-			mixer_scarlett_gen2.o \
+			mixer_scarlett2.o \
 			mixer_us16x08.o \
 			mixer_s1810c.o \
 			pcm.o \
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index a331732fed890..c8d48566e1759 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -33,7 +33,7 @@
 #include "mixer.h"
 #include "mixer_quirks.h"
 #include "mixer_scarlett.h"
-#include "mixer_scarlett_gen2.h"
+#include "mixer_scarlett2.h"
 #include "mixer_us16x08.h"
 #include "mixer_s1810c.h"
 #include "helper.h"
@@ -3453,7 +3453,7 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x1235, 0x820a): /* Focusrite Clarett+ 2Pre */
 	case USB_ID(0x1235, 0x820b): /* Focusrite Clarett+ 4Pre */
 	case USB_ID(0x1235, 0x820c): /* Focusrite Clarett+ 8Pre */
-		err = snd_scarlett_gen2_init(mixer);
+		err = snd_scarlett2_init(mixer);
 		break;
 
 	case USB_ID(0x041e, 0x323b): /* Creative Sound Blaster E1 */
diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett2.c
similarity index 99%
rename from sound/usb/mixer_scarlett_gen2.c
rename to sound/usb/mixer_scarlett2.c
index e5e70abf5286b..90480b9b9b089 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *   Focusrite Scarlett Gen 2/3 and Clarett USB/Clarett+ Driver for ALSA
+ *   Focusrite Scarlett 2 Protocol Driver for ALSA
+ *   (including Scarlett 2nd Gen, 3rd Gen, Clarett USB, and Clarett+
+ *   series products)
  *
  *   Supported models:
  *   - 6i6/18i8/18i20 Gen 2
@@ -149,7 +151,7 @@
 #include "mixer.h"
 #include "helper.h"
 
-#include "mixer_scarlett_gen2.h"
+#include "mixer_scarlett2.h"
 
 /* device_setup value to allow turning MSD mode back on */
 #define SCARLETT2_MSD_ENABLE 0x02
@@ -4251,7 +4253,7 @@ static const struct scarlett2_device_entry *get_scarlett2_device_entry(
 	return entry;
 }
 
-static int snd_scarlett_gen2_controls_create(
+static int snd_scarlett2_controls_create(
 	struct usb_mixer_interface *mixer,
 	const struct scarlett2_device_entry *entry)
 {
@@ -4339,7 +4341,7 @@ static int snd_scarlett_gen2_controls_create(
 	return 0;
 }
 
-int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer)
+int snd_scarlett2_init(struct usb_mixer_interface *mixer)
 {
 	struct snd_usb_audio *chip = mixer->chip;
 	const struct scarlett2_device_entry *entry;
@@ -4378,7 +4380,7 @@ int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer)
 		entry->series_name,
 		USB_ID_PRODUCT(chip->usb_id));
 
-	err = snd_scarlett_gen2_controls_create(mixer, entry);
+	err = snd_scarlett2_controls_create(mixer, entry);
 	if (err < 0)
 		usb_audio_err(mixer->chip,
 			      "Error initialising %s Mixer Driver: %d",
diff --git a/sound/usb/mixer_scarlett2.h b/sound/usb/mixer_scarlett2.h
new file mode 100644
index 0000000000000..d209362cf41a6
--- /dev/null
+++ b/sound/usb/mixer_scarlett2.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __USB_MIXER_SCARLETT2_H
+#define __USB_MIXER_SCARLETT2_H
+
+int snd_scarlett2_init(struct usb_mixer_interface *mixer);
+
+#endif /* __USB_MIXER_SCARLETT2_H */
diff --git a/sound/usb/mixer_scarlett_gen2.h b/sound/usb/mixer_scarlett_gen2.h
deleted file mode 100644
index 668c6b0cb50a6..0000000000000
--- a/sound/usb/mixer_scarlett_gen2.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __USB_MIXER_SCARLETT_GEN2_H
-#define __USB_MIXER_SCARLETT_GEN2_H
-
-int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer);
-
-#endif /* __USB_MIXER_SCARLETT_GEN2_H */
-- 
2.43.0



