Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059891;
	b=PQJrO/ua1p2rz8q+mVAzhRKd4yO2sNa5lS4BhS1Xlj2SzWF42q6Ty8vst+/JMn/gRE85
	 JhMFt8wUuwYnevdlykSjoayQCY5GBwk+H8FiQisJGEMM8dlnL5CcA4nhTSZdQ3JaCOu6D
	 Rly/vjwtKZGMB/VStfBUMPYCyrXVjPLDOqgu6sdnZaGrVam2iYmPQdmENAMspcEWyjS5u
	 55e/7NRIOJR2E6F5mVVfpx+uBHMus15/U+4UUe9ESzULm15uF/ZchO9huDtU/SeTudOlV
	 qaDr8ZZPX1xZA5EZk8hr+EzwfJOBwCJIkFE64MJBMclf6phdiZ6WDPgxFDOPis5qdxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfbk9UaqTp5sO2lOQSrvBtNiCS14iy8WudEG9Ezbgvc=;
	b=yf6D7uCJWgsawCCycHmAyBpHyqgJkh8krKDix8UeD+liltgi3vHVsTYETG7IQoynz2/e
	 vTLOS/p6L4BqQourzKCy25fgbMaisg9oPFpqj7LNKima51YZxXqzfncG/j94W0bStuQ5W
	 wzoPqb6Oz15B2NMhN1pnJgKzYgM/XFAaSUjKRbue6hsAn0NjiV8lJ67wAJ/EMkiARfIx2
	 nX+Tve8sGRe8Hnkc6kMAKbta731n4+/zwE1l4FHhAjevpKJhycVznJavX+BYhfe5q+fxf
	 nVIjABvU1puDm0Ko16meYWYOnNjPNtiZXzMhE/j8s2ek2OLEK8buRt4cbhTs97Z2z/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtZsFIH5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4856A606A326;
	Thu, 19 Nov 2026 03:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtZsFIH5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967771F000C5;
	Thu, 19 Nov 2026 03:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059891;
	bh=wfbk9UaqTp5sO2lOQSrvBtNiCS14iy8WudEG9Ezbgvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtZsFIH5hzoV7ILuPLxqeKExWOMYS3c7GJ9r3Xa/R7HDDKRV7iN9g0ZNBaQjDPS6k
	 MuaknKV6e+owEZoOWoQ+eLCoC0m70maE+4/fNy2T91OD6lBSOuehnsEEnx8Px0V/BG
	 7JYdDKi6FxvSSknShAi+tYaAolnwsCS3wsaJjcec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Hofman <pavel.hofman@ivitera.com>,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0976/1848] ALSA: aloop: Dont constrain playback params in notify mode
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118145957.817045761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Enquist <henrik.enquist@gmail.com>

[ Upstream commit ded106036984a9dd766e7e1451b02e2d15c81438 ]

With notify enabled (the pcm_notify module parameter or the "PCM
Notify" control), the playback side of a cable may change format, rate
and channels while a capture is running. loopback_check_format() then
stops the capture and notifies the "PCM Slave" controls, so that the
capture application can reopen with the new parameters. For this
reason loopback_open() still gives a notify mode playback the
unconstrained loopback_pcm_hardware.

Since commit 898dfe4687f4 ("ALSA: aloop: Fix racy hw constraints
adjustment") the hw rules refine against the shared cable->hw instead
of the substream's own runtime->hw. This pins the playback side to the
parameters of an open capture whatever the notify setting is. A player
probing the device sees only the capture's rate, format and channels,
and the format change path in loopback_check_format() can't be reached
by a new playback.

Skip the format, rate and channels rules for the playback substream
when notify is enabled. Skip the period bytes rule as well: with a
sound timer source, params_change() already takes the period size from
a notify mode playback, and keeping the old capture's period bytes
leaves a playback at another rate with a period that doesn't match the
timer. The capture side stays constrained to the cable parameters.

The capture stop this makes reachable again was hardened by commit
826af7fa62e3 ("ALSA: aloop: Fix racy access at PCM trigger") and
commit e5c33cdc6f40 ("ALSA: aloop: Fix peer runtime UAF during
format-change stop"), which need to be applied first when backporting.

Reproducer, with notify enabled on the cable:
  arecord -D hw:Loopback,1,0 -r 44100 -f S32_LE -c 2 /dev/null &
  aplay -D hw:Loopback,0,0 96k.wav
Before: aplay is forced to 44100 Hz and the capture keeps running.
After: aplay runs at 96000 Hz, the capture is stopped and "PCM Slave
Rate" reports 96000.

Fixes: 898dfe4687f4 ("ALSA: aloop: Fix racy hw constraints adjustment")
Reported-by: Pavel Hofman <pavel.hofman@ivitera.com>
Closes: https://lore.kernel.org/all/b4af9071-f8d7-5b47-4d7a-c5743bd67394@ivitera.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Henrik Enquist <henrik.enquist@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261003-aloop-notify-fix-v1-1-ba5dfb831bf5@gmail.com
[ sashal: adapted helper-based checks under scoped_guard() to inline checks with explicit mutex_unlock() calls before early returns ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 3901f52164933..5ff8fdaf8989d 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -961,6 +961,11 @@ static int rule_format(struct snd_pcm_hw_params *params,
 
 	snd_mask_none(&m);
 	mutex_lock(&dpcm->loopback->cable_lock);
+	if (dpcm->substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    get_notify(dpcm)) {
+		mutex_unlock(&dpcm->loopback->cable_lock);
+		return 0;
+	}
 	m.bits[0] = (u_int32_t)cable->hw.formats;
 	m.bits[1] = (u_int32_t)(cable->hw.formats >> 32);
 	mutex_unlock(&dpcm->loopback->cable_lock);
@@ -975,6 +980,11 @@ static int rule_rate(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	mutex_lock(&dpcm->loopback->cable_lock);
+	if (dpcm->substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    get_notify(dpcm)) {
+		mutex_unlock(&dpcm->loopback->cable_lock);
+		return 0;
+	}
 	t.min = cable->hw.rate_min;
 	t.max = cable->hw.rate_max;
 	mutex_unlock(&dpcm->loopback->cable_lock);
@@ -991,6 +1001,11 @@ static int rule_channels(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	mutex_lock(&dpcm->loopback->cable_lock);
+	if (dpcm->substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    get_notify(dpcm)) {
+		mutex_unlock(&dpcm->loopback->cable_lock);
+		return 0;
+	}
 	t.min = cable->hw.channels_min;
 	t.max = cable->hw.channels_max;
 	mutex_unlock(&dpcm->loopback->cable_lock);
@@ -1007,6 +1022,11 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	mutex_lock(&dpcm->loopback->cable_lock);
+	if (dpcm->substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	    get_notify(dpcm)) {
+		mutex_unlock(&dpcm->loopback->cable_lock);
+		return 0;
+	}
 	t.min = cable->hw.period_bytes_min;
 	t.max = cable->hw.period_bytes_max;
 	mutex_unlock(&dpcm->loopback->cable_lock);
-- 
2.53.0



