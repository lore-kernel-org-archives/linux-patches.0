Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063575;
	b=13KNHF37iRRA1CNp1YCEOvkhLDo84p4yTDN2h09ZVOCax3MXSdognwhA/XPvSQU/XzGm
	 z62lEk0iqYIn28mBvcYGUnvbHikZzyxktUi17xWAgOan7m3SwI6N4aEnQ860XT++QBBWG
	 Y/lRuxXh3Va7J6KaxIbQ8/N4bheEliXlvl5yMjotrYXjuA4DlIxNan1+s9AmOUp/7kjb5
	 yM8S9y1xoBV2xwtqGK22NuvCfcV3H6+AQGrwoeHiNZhskEyPmSXTJTHDuL2FLDh9D4x31
	 duA4VK0emoN0+8ShezV2UjvpRdG1cdxLXRP8hHsbFzZoQanAM4/2o/IsvpmL9rgJJ6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YaL1WCVFmdannu33Q8dzf9fPZaawq6j9YaT1nIZ+dZY=;
	b=qtxrFdCLzNBaTGXIfN5+GJUV7y/a+IXZOFqLJCxyHh/9gVPa/FmQ8fd4BcmtgLI/vhBE
	 aXDXFms4osXWKDFfopU2NrGhlAO3GZd41jxEBoC3zy6D0E7yPi/PN4Us22KtxHgVygNOn
	 D/SZDwxI6apMGHnCjlh0lhTtoncsjVFEIlT/gd34wX3ZrFnZvEHwgU2Ckd8+I4fM0qaV2
	 RS2EfcnvIcZj/JFEUWrZDOJw/IhMnlBR/5m3LaW9Ba8aetnbmZ5Uv9gX5ZeEtQuHtzt1G
	 Kfx6EX5AuvPSLur31TIc5NIq/QyYjXt8C/E8URVRbfrxjlAxZsoi4Nd6gq45Ar+WxPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g66rqGIG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8F6606EE96;
	Sat,  7 Nov 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g66rqGIG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175DA1F008A5;
	Sat,  7 Nov 2026 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063575;
	bh=YaL1WCVFmdannu33Q8dzf9fPZaawq6j9YaT1nIZ+dZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g66rqGIG7YKunweUAd3Cia5Ag7VvpRrYFz9Ej3o+s+ZiykuMXY8qIvGI/8GXac7wC
	 oTOpfPEGNat3i8Ly5TkJDU+KbPk9iFYNiOcrHcIvD8MTTKlb/VE0LBCGJ+WJA5cuj+
	 q4avwBL6gSjmqg2CZsqprAuUrJogPblEMwn1mVLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 705/869] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Sat,  7 Nov 2026 08:56:27 -0500
Message-ID: <20261107134916.824767909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index eefc41f628462..fd8d6b474e465 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -365,11 +365,14 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 			runtime->channels != cruntime->channels ||
 			is_access_interleaved(runtime->access) !=
 			is_access_interleaved(cruntime->access);
-			if (!check)
-				return 0;
-			if (stream == SNDRV_PCM_STREAM_CAPTURE)
+			/*
+			 * Matching params also go on to the update below, so that
+			 * the setup controls follow a playback that joins an open
+			 * capture.
+			 */
+			if (check && stream == SNDRV_PCM_STREAM_CAPTURE)
 				return -EIO;
-			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING) {
+			else if (check && cruntime->state == SNDRV_PCM_STATE_RUNNING) {
 				/* close must not free the peer runtime below */
 				atomic_inc(&cable->stop_count);
 				stop_capture = true;
-- 
2.53.0



