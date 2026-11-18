Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054147;
	b=1bZWGFMO0WXYxxOxbCUEI3zjxakR2kjk/NlITZ9sO8xhtJFHaU/rE1u3POhakoQVZ+5s
	 77QnHom0KcUNS2llVKF1WBhI1lU6d53/u+eZuafgKA6shv2AW7pFLXPP6K2n6MEc/Fnxb
	 IXschnOcy0ToH0Yurc4odL3fkD4imknfpqPrWzGjA/iDidc7p17vMNj/Orgq8Q03onFmR
	 wl4UYGWOCY6f18b2Y0ys4L6LbC61INGfX/nTN//cTtA1IXyCFpSgP1lsA6Qf3d5tLWwKa
	 vKoMkVgHJQi3vVSLPXGR9QYCq/mPVHv/PU5i0JslZuvW7lmnLc8SIxp0RU31EfAS2Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VdmNnG3tr7uNCfqM+kHyy45Qx7X6+TkIBBAPG2argiQ=;
	b=g34CiW04sK88NR8ydzrudKaLlBAjnwHknW0LyQfRkZvYgVdiWx92MeBU3tsWcqZBguMC
	 mTqj02UHUi/1MbqVySgasvReNl7aY+W8QMd6nWaWrzPY4I4uRPfWb94iz6n4x7UjV7vgY
	 x7hkA//LvEHgLS6y7ZM168aBhR0DaxAGTDwoml5043c8XIKBPKKONthWVHQz/UK+r65p3
	 okwGAo7uintMV8lLg1h2f/KTeWFhLkAQgsDz8x9ESii1zQYsrMKyXRsZAx/W4rW+HW2jn
	 HjHcOdtovjyNA+qXX8Rug2BCWPQviODM0yNwoekex0VNzxF0WeSy/VZ4jOHfmoMZt6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCbYQ6Vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8836D606A320;
	Thu, 19 Nov 2026 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCbYQ6Vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4291F000C4;
	Thu, 19 Nov 2026 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054147;
	bh=VdmNnG3tr7uNCfqM+kHyy45Qx7X6+TkIBBAPG2argiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCbYQ6VfloKiTHQoFZfYu1MKUP8jXyGnzjVtHtIaV/YSayGRxHJcvskj0pXbYCBjQ
	 BrLBz1HEJuN+Ba0XF330f3wN9MeE33xqeF0Am+XBEGqxNiXZg2ayq+wjd4LDqWEZaQ
	 fp0m3EW1CSMkmplhbmDWV0OnCPrN133VCjgoL04Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1172/2214] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Wed, 18 Nov 2026 15:47:28 +0100
Message-ID: <20261118150058.875956359@linuxfoundation.org>
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

From: Henrik Enquist <henrik.enquist@gmail.com>

[ Upstream commit c3bde2beacbcb40790f0e3c3f909f9e16bbced9c ]

The "PCM Slave" format, rate, channels and access controls report the
parameters of the playback side of a cable. loopback_check_format()
updates them when a playback starts, but returns early when a capture
is open and its parameters match. The controls then keep the module
defaults, or the parameters of an earlier stream.

A playback that joins an open capture with the same parameters is the
normal case without notify, where it is constrained to the capture's
parameters, and also with notify whenever the player happens to use
them. An application that reads the controls to find the playback's
parameters, for example to reopen the capture side at the right rate
after a restart, then gets the wrong values.

Only skip the capture stop when the parameters match, and update the
controls in every case. A value event is still sent only for a control
whose value changes.

Reproducer:
  arecord -D hw:Loopback,1,0 -r 44100 -f S16_LE -c 2 /dev/null &
  aplay -D hw:Loopback,0,0 -t raw -r 44100 -f S16_LE -c 2 /dev/zero &
  amixer -c Loopback cget "iface=PCM,name='PCM Slave Rate',device=1"
Before: the control reports 48000, the module default.
After: it reports 44100.

Fixes: 597603d615d2 ("ALSA: introduce the snd-aloop module for the PCM loopback")
Cc: stable@vger.kernel.org
Signed-off-by: Henrik Enquist <henrik.enquist@gmail.com>
Link: https://patch.msgid.link/20261021-aloop-slave-controls-v1-1-62297727177f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Retained explicit locking with goto unlock cleanup instead of upstream’s scoped locking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 7c76f702296e1..caedc3c2d7647 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -351,12 +351,15 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 		check = runtime->format != cruntime->format ||
 			runtime->rate != cruntime->rate ||
 			runtime->channels != cruntime->channels;
-		if (!check)
-			goto unlock;
-		if (stream == SNDRV_PCM_STREAM_CAPTURE) {
+		/*
+		 * Matching params also go on to the update below, so that
+		 * the setup controls follow a playback that joins an open
+		 * capture.
+		 */
+		if (check && stream == SNDRV_PCM_STREAM_CAPTURE) {
 			err = -EIO;
 			goto unlock;
-		} else if (snd_pcm_running(dpcm_capt->substream)) {
+		} else if (check && snd_pcm_running(dpcm_capt->substream)) {
 			/* close must not free the peer runtime below */
 			atomic_inc(&cable->stop_count);
 			stop_capture = true;
-- 
2.53.0



