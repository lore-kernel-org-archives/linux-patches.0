Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027236;
	b=esDkjM9buRnVnuGuMmalty+SVk4EfwDiMPh3iF57ENDA2/clGvykoT7gXhAPJ/9Web+X
	 mNFxSjRiceFoQ5YURGjlyfQVqa3ctkfeU6oDrsU7WlhcCm+zWss06npmkZrIO6SMrI/7c
	 tToEdwVKChDbmgixx0gk1lb9OxJZF91Xw6A1hZWKtZ3aLtAdUYHPpRQDW4aK6DBQ71TDs
	 LRcX+1WKY81kHNo+25tE2FRT9dHuBXF0Yaena68v/ahTM3gytdM3pf0tgU7kcIaPWrar4
	 5qka+mXFCHBtm3clvdPftj4U7Kr9I5wzI/oOBtxyNL4/+5LVXnDKsWHO4x62mSbr/hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Rj4YtIADn76TkgAEfZhA4mjDnoxkPop33L0OxCoWO60=;
	b=vShFLt4sQHSUULJbqXu2x4LutGw8rbKjKqb++xWVbgsR/+HYhBi3ucqi3UBWEglIqPLH
	 Yd0Xh61lzm2sXnsO6AzlqisRWUjgbax9Wh3XsOueU6D+b/PH4UExY1IeknhOylUr1m5X7
	 vU6noMDW83v1SHvXlM/cb8HemwSrKpcljFvt1ayYPRLq20TjiYmnVqSGGM1zmjwEa7lH/
	 gVR29aLqt7oBVMPFeBWLtI7PMS8dcv6VjD6lXw1y7Y304bwk6SJVScXG70enbwDABVsjj
	 Jmj9vcZCu9ZN4u2FD8uoN5he8WAz/zZXnxYTiKiCooyefLlCxKSlGpes0EO8GljIoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0hSz3cX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004A860A2619;
	Wed, 18 Nov 2026 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0hSz3cX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E3E1F000C9;
	Wed, 18 Nov 2026 18:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027235;
	bh=Rj4YtIADn76TkgAEfZhA4mjDnoxkPop33L0OxCoWO60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0hSz3cXQMp207HAewaX49iWToxUIeePD1gYI4bBh2RamPvWAHOC7rewuUhlMKNs6
	 D4SZGB176pU8Tsu2EtL+F3bZCetdKJJPDzS7hBycoOKeueP0K5yDKAgWNMIxoOPx4N
	 8/2mh+v1hiWM4fATTsImXY+e2yaoRNMxqnYzOhWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Gli=C5=BAniewicz?= <p.glizniewicz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1691/2151] ALSA: 6fire: take stream_mutex in the Digital Thru control
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150223.427133412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



