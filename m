Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032238;
	b=D101banShwzwHSgYe6F+D1gASietXkf0NZ6oH3NhyoVzUK5FJ0HPACygOJ3+wR3Vgfk6
	 /cgddAiBFQS9NSSYJADoQpC/AiiCPgepw3T1VmmzMsxdXrK3cRprI4GM46hzLy8rSvyVt
	 cC0J9iY1XKpcZGipx33o4y19h3p+b1SS5XLXfyzliTEPbA69Tk7wU3Wnj+bXw391fwh94
	 flzVz5RVcNX0lIkrp9UT0UXibVx59WZsG7bXD4x4OtHewSX7qd85MhOA71br0WxJSAkmC
	 miyLC5E0ob7LMMgF/VjSJIQaMN15kPZvoUBPKHG9CF0Ket5QTUGr2pyBrx2j87PQYYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HVgQHxe5sgeG9L3rwru7HBncDkj/r2kl3yk4tGNkzhA=;
	b=Fdr997tguS/ziClLlovPJeIFI/iuwdcWyIHmo/B4GyA+pvewMss6qCcC8wgvnlveoifZ
	 Nk/90e6Cy1r4NVMBHb/MVnAV13XAKOZikKcGafqD4Lq7w43u0AomaBMD2ZLAjQBtkuNLp
	 aiSV1cZtuoc17lNmLX38i3A3+SIlmqAZXS/ccEWFRV4lkNLAHK36kQ17qSbyEuAi6ewBf
	 i3Q1olk9HyN/xw6YSJpAfBNJYeSSVq5KSaQW0y2g8EyAt3hXfH5oE1Wzg1UlLV8seunCk
	 OaFlE0aq2914TFrIqYPrqZ4KdLITsqyU7YCrkPneMfz2YggDdx5Xdj/24cVsRRGZzyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQmymY9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B9606A330;
	Wed, 18 Nov 2026 20:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQmymY9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC841F000C5;
	Wed, 18 Nov 2026 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032238;
	bh=HVgQHxe5sgeG9L3rwru7HBncDkj/r2kl3yk4tGNkzhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQmymY9I7KsGksQD5B78/TQxWcVR78ByKPmXfBUNKMtFYneSAMqllO+lbfG4RqJoe
	 xq+7vhnAvIEMfuS8YEeOBxRfAzkmtmyTYZF9jUJ+/wLtcrVgTy+VyQdirEkcppOM4S
	 Gt7+xuo6zWPW4MN8sJRcw+KJyWeU5YlSY6SYFhsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Gli=C5=BAniewicz?= <p.glizniewicz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1342/1756] ALSA: 6fire: take stream_mutex in the Digital Thru control
Date: Wed, 18 Nov 2026 15:57:49 +0100
Message-ID: <20261118150102.765617990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



