Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054144;
	b=HP5X/+umpbsaTnqmk8SutsKgd8scSmZkQsXgIHc2Umx28Yf1w5gCYouf4bdMZxSoqjqP
	 IXQCVrF/GX7FvWEYLFyN6sBGVAII5+AvOd8voNjfOqr78nwx0CHOLUgA0eFGpjw8+4344
	 kAC0wroD+WIg1hghdcJrgm/LbcCNl/qatxMivp1I16z57o3mHOLU5MFl1B3lhL327tJNZ
	 HIslzj1RxR7IEuU/AAcYsTlmgrk6v+c53QUK+AJB1c73KoOqRapunWM9QMv7qaijxdHiL
	 XcxpXVkI8bFeHy2KRyu/sUe0eQ0ephM7Wxl3Ae4SCx9HO1/a/0zXT5v8Z+nPoKa2uBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yPQOFg9JzI7KYYz5XH+mWKfOt02My6HsWhbhnPkrWxk=;
	b=p3+w4vXws7UgCO+OpM+M7XkiRjNmdOjJwZMUFsDkLxlEtXLXCp6dtVib/f/j3PWW/VaA
	 pEWpSAy5rUgJXHlrQocbj/7yxClr/SOvw7tXkwDtmGcj8vHwQn+A3kZEs+fC419CZsDdX
	 I/Hb2ypnK9w4BhObix8Z9U1EPmnDYrfdJ+Sp67bfcMW/dVn+Yl7B5adfy49GsUjVXUk6d
	 kr1wgul2KQ5/ayTeD7xGK3UMsuz8V5KNUWS/h/Ihhg1ZZi1jxzkP0x0Fe6OAq1oI9xI9D
	 wIrvN7I2cWb/wuAAcjNYn8n0J6lBaGVHhiqPsBveh9V4Ass68qkEyJJeDJ/uOqYhnDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2WemSNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87628606A31C;
	Thu, 19 Nov 2026 02:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2WemSNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB4C1F000C4;
	Thu, 19 Nov 2026 02:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054144;
	bh=yPQOFg9JzI7KYYz5XH+mWKfOt02My6HsWhbhnPkrWxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2WemSNpbiKw8gMTIowF8IyZmBktTV1up20LHvh4iD/DTlYlo3nrbJwpNque0XdGJ
	 vWU3JI3vDNeqJCVhv9cazDNIOZpXau0MwqEy4P4vXFizx84rjOEKOZeX1W6RfIG8DO
	 B9/CL249XGOYpS3G1ZYvFQ1EFDJRkQHfFCvS59BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Hofman <pavel.hofman@ivitera.com>,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1171/2214] ALSA: aloop: Dont constrain playback params in notify mode
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150058.841048229@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted scoped_guard() mutex handling to explicit mutex_lock() and mutex_unlock() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index fb507076e006f..7c76f702296e1 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -960,6 +960,11 @@ static int rule_format(struct snd_pcm_hw_params *params,
 
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
@@ -974,6 +979,11 @@ static int rule_rate(struct snd_pcm_hw_params *params,
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
@@ -990,6 +1000,11 @@ static int rule_channels(struct snd_pcm_hw_params *params,
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
@@ -1006,6 +1021,11 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
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



