Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056505;
	b=v6mdyWe5/5GWHukUvRPfXn7tSgSHi2898/NenYMmnOxvq/SLN5Yi08Ztqfyx7ljp1osr
	 RW/75FKf78ThKUupbQkuBY/RxPus+G6bU6nBm4aQ1coHR3nFNYrcZ+PRFL0++ia2y5ib+
	 01/BhHMpmjVyGjjXwykbaNg6TGpt8w+Zp76N9cMmpzFC+GOSXpLYYjjMCFyRFC1s0qxVy
	 Fsddu6luAHgbvGDObmYjPEEs4ZIGXDx+Qd0EUVp7mtsTHLR2XU51vHYveIvhOGiqv1xwc
	 9A5+XEuT5h7MLDH3VDRA0g+J7GEONFp43HbLVAeNIXD5FcllXj/axeDAguYtRGKnkBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2jg16+7Ep+nY4ugsKC3XavxjSqczH0vTsGu5TxoanCM=;
	b=hKVNcsTTPFFMKdMPSLC6iEqTbSdQNUcdAc4Yzz6ZsFisAZxw8bUyXutsCjtHxuxKYm6v
	 HtwYnSnIdxC2Y26hflQ5OZWW5bIj9ePDhgLYuSEWQYMjQe2jhDw2s8CI3ikbEuO0+HymV
	 dvwt3z6y3mzxu5yv7/GaeH507GyD19FXdOCHMB9g3yBmqF8GHcCqwy9NwFAAx3HPJxFd/
	 yl3qRkBeCq00ShkfL/qR8a3DKTPkiQ/Lgsayw3zxzH0Nkn5uhceIkxbQjX4t+PpuZ50B8
	 fMKTvCFvdgu+U1a2G7bSI2/t/lyrt9o8bsdqSzKvCeYACNVdv/l0lN8iY38a9cueIdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOvdj4rg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65560A2601;
	Thu, 19 Nov 2026 02:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOvdj4rg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB811F000C4;
	Thu, 19 Nov 2026 02:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056504;
	bh=2jg16+7Ep+nY4ugsKC3XavxjSqczH0vTsGu5TxoanCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOvdj4rgC85IlRXI0OafpK1jfKOfeTYAOiSTEyDoav3qCwLPprINTWd7oIy2xvs0A
	 +sch3r8IO9b/OPoOCoLjZ6ju5BBpVS7F1qFooKzSBSeeicgr6XGthsE7RkGFbmy6Ji
	 0Vz2wcmOh44cgHw1qNRMlv1DGsQ9aHqBe8I6ep7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Gli=C5=BAniewicz?= <p.glizniewicz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2012/2214] ALSA: 6fire: take stream_mutex in the Digital Thru control
Date: Wed, 18 Nov 2026 16:01:28 +0100
Message-ID: <20261118150131.223742252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Gliźniewicz <p.glizniewicz@gmail.com>

[ Upstream commit d030561d53cb272bb55ba2dd11aaa609e8240b7e ]

usb6fire_control_digital_thru_put() calls
usb6fire_control_streaming_update(), which on an idle card with Digital
Thru on selects altsetting 2 and writes the clock register for 96 kHz
through usb6fire_control_set_rate(). usb6fire_pcm_prepare() calls both
functions through usb6fire_pcm_set_rate() under rt->stream_mutex. The
put does not take stream_mutex, so the two can run at the same time.

500 runs of a 0.2 s aplay at 48 kHz while a second loop toggled
"Digital Thru Playback Route" with amixer (12693 on/off cycles, kernel
7.2.9): in 216 cases the two usb_set_interface() calls ran at the same
time and the kernel logged "sysfs: cannot create duplicate filename
'.../3-2:1.1/ep_82'" with a stack dump. 27 of the aplay runs failed,
and for each of them the kernel logged "could not start pcm stream".

Take stream_mutex in the put. The pcm runtime is created before the
controls and freed with the card, so chip->pcm is valid whenever the
put runs. The put waits for a running prepare, which makes synchronous
USB transfers under stream_mutex; on a card that responds late the wait
can reach about 12 s, or 24 s with Digital Thru on, and during the wait
the other controls of the card can be neither read nor written, because
snd_ctl_elem_write() holds controls_rwsem around the put. Before this
patch the put already made transfers of the same kind under
controls_rwsem. No code that holds stream_mutex takes controls_rwsem.

The same test on kernel 7.2.10 with this patch (12863 cycles) gave no
failed aplay run and no "duplicate filename" message.

Fixes: 2475b0d40761 ("ALSA: 6fire - Add support of digital-thru mixer")
Assisted-by: LLM
Signed-off-by: Piotr Gliźniewicz <p.glizniewicz@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261016073132.109288-2-p.glizniewicz@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/6fire/control.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/6fire/control.c b/sound/usb/6fire/control.c
index 7c2274120c765..4474bdc78e535 100644
--- a/sound/usb/6fire/control.c
+++ b/sound/usb/6fire/control.c
@@ -20,6 +20,7 @@
 #include "control.h"
 #include "comm.h"
 #include "chip.h"
+#include "pcm.h"
 
 static const char * const opt_coax_texts[2] = { "Optical", "Coax" };
 static const char * const line_phono_texts[2] = { "Line", "Phono" };
@@ -383,6 +384,12 @@ static int usb6fire_control_digital_thru_put(struct snd_kcontrol *kcontrol,
 	struct control_runtime *rt = snd_kcontrol_chip(kcontrol);
 	int changed = 0;
 
+	/*
+	 * with Digital Thru on, streaming_update() selects the altsetting and
+	 * writes the clock register of an idle card; prepare does the same
+	 * under stream_mutex
+	 */
+	guard(mutex)(&rt->chip->pcm->stream_mutex);
 	if (rt->digital_thru_switch != ucontrol->value.integer.value[0]) {
 		rt->digital_thru_switch = ucontrol->value.integer.value[0];
 		usb6fire_control_streaming_update(rt);
-- 
2.53.0



