Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047248;
	b=aT/qQX6UFim+J1NSGAxREhGl2HIS0inoDPNn3qQHPQq1TtY/pS+c5QzAjScN4IZuaSXh
	 n1+EOgza2sQMcRSEvESOZg8WUuuKobhI5/Xu1uIwWnevlNwq+HaOMq7g3kfK8PoBaG6vH
	 clA3y0BbAbfAK+jCaGO2WUmXtWOC5r9JB9/SqZmDJBkqhZtzSWT1d0djVz+r35/xxpPz8
	 5kx9j0e2UEHWBUuN2IuQkQa63iKv0Tc3TWpFT14rGqzCbBsFpemMQn/U/w+S6Zxw6mxrv
	 6fofVxcglpwpp1jAqilkPs3qLgFAD1RZM+ywf+6tAu1xT7hcWZA/wMNJbHFQ5Fe8/iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GyDc6xdgVzatLtSPQi3eo7ENTulvzOM1cPs3an4jm+Q=;
	b=i3YbeRuN+NDZFzP0YzBSiyiPTdijfYmrclnzChB5MhSWw2xTZN5iEEcmzH7BoIFuXz9K
	 8ASlVzsLfGuHoPGuMalABo0+qhZCD9L3FE3gD9Q0MqnO9XYbkgY8E2vQcoNGBimtfYeFO
	 xGQiXwWThkJnNdCbiF5NEO2VP+yEnZPo0f24b36tLa5HVVBeYt5YHjauZL23MXv0nEfmT
	 bqc8N7sl8qcoHyrQU4i2GSxhBVlmA8f3qNrUwOoHoIGSxeTlUhjruSgSt3inImEWJL3tn
	 d2/g6Jdwp804dUVYAyXjol5xAiTLySIatMi+XZmBqgtA2pTSJQj+gR/jsCyERsbkk/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKojB+3r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6F8606A331;
	Thu, 19 Nov 2026 00:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZKojB+3r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD4A1F000C4;
	Thu, 19 Nov 2026 00:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047247;
	bh=GyDc6xdgVzatLtSPQi3eo7ENTulvzOM1cPs3an4jm+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKojB+3rU+0Tqtl5qAVGTsGkGJnhsTc0kIwQXYPs/b7/AGefs2IEgIPBTeF9MZdRl
	 95nywtoX00HxHiev5BBfYQ2wbe06rwYoR2FdgthUdsa/bmZe7jzRaGEEwibt7hJSxQ
	 GX+GIyUaTeiMx4YWB7b9CWLZ1NWXZ34WuggoNqE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1571/2857] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150257.952545114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to match the existing loopback_check_format() implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 18ca2951d4be6..b14c7a7e90f67 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -346,11 +346,14 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 			check = runtime->format != cruntime->format ||
 				runtime->rate != cruntime->rate ||
 				runtime->channels != cruntime->channels;
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



