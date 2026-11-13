Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591608;
	b=Jt9Y8FGXcwthn+IqiXsqWKps+UdIbkTAvyvpYydUpNLK0f9zslG8dooWRWAuRmL8h6++
	 PRqYQVvH59fNRwVC5qTyfZs6OXdiDXyiF7eQQY+egwhI/pGzNTZr6i3Di0tMQl0l9yBlR
	 8/NqE0iRGYBz1ZcqGiahUsTDVOOu5k0MU+CC+/Asi3C0r2KcfyXjZ6M1AfcewaxWZ/qAm
	 YkntqKQKMehEodD4ZBaSlkBEuhMP7CzcInLG9H7n1GjJ6ygXtUmxhUhL+MhZOLp4oD+Wl
	 pe/cCY637e69mjKvUOqBOjyh72Ep71StpsRUnwEaqhz/oHuq9F1SNmCvhju/Yy0AFyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5kh/mSLuqrnOc1pVrPSLCMUmgYxvkse2A73SJ4xPvU4=;
	b=BghPqpcNDtXC7AcE5i7qHXfODfUKPwk3SgY1f5SfUvnJ8gYS2mzjoeIySlqn00Z5Vq1G
	 yiu2jvMmE0vHufoi/2jRJUKQE8KjvBtaYeWmSBNkxB9KXlNfE+/BOfPdJ8W08gvjrXTdd
	 5/nkZlCsJakrGjXqtf9vf9LmzLexJvunDqBXVx6TazfouFP+2r1HKmdRNk7kJpY9b6htL
	 74mrWYiirlYW8xn/rjiE9dAzRjmV7T+lVSoyGSEdaQZPUETP3I41bBF3oOqRhzM8ub1pn
	 axLCWbvZRsoYFWuZrp1ZzA4A7lD/lPQYxTVaCRakG6/3abDNtReDiUJtjWcXn8/WyOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJwVA84m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582A606B45B;
	Fri, 13 Nov 2026 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJwVA84m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54461F000C8;
	Fri, 13 Nov 2026 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591608;
	bh=5kh/mSLuqrnOc1pVrPSLCMUmgYxvkse2A73SJ4xPvU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJwVA84mLaRBBrje7ILX3ekrIQilOQ6YW/ohfFOcl44yWBtXQkqasV4H/nKpFtbsV
	 QICHN6jokfM+TvQasIemLSLo3HWv03f4DfpSoRb+v+E0NWj25NXoKjqCzhMDdF6KPr
	 0stfKWAAgQdnKr23UYm4FyITVVxqK8noGOt7lSn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Hofman <pavel.hofman@ivitera.com>,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 648/670] ALSA: aloop: Dont constrain playback params in notify mode
Date: Fri, 13 Nov 2026 10:53:32 -0500
Message-ID: <20261113153833.779005171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 24ab1a7fd773d..94ea73b3869c9 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -991,6 +991,18 @@ static unsigned int get_cable_index(struct snd_pcm_substream *substream)
 		return !substream->stream;
 }
 
+/*
+ * In notify mode the playback side may change format, rate, channels and,
+ * with a sound timer, the period size. A running capture that no longer
+ * matches is stopped by loopback_check_format().
+ * call in loopback->cable_lock
+ */
+static bool loopback_playback_unconstrained(struct loopback_pcm *dpcm)
+{
+	return dpcm->substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+	       get_notify(dpcm);
+}
+
 static int rule_format(struct snd_pcm_hw_params *params,
 		       struct snd_pcm_hw_rule *rule)
 {
@@ -1000,6 +1012,8 @@ static int rule_format(struct snd_pcm_hw_params *params,
 
 	snd_mask_none(&m);
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		m.bits[0] = (u_int32_t)cable->hw.formats;
 		m.bits[1] = (u_int32_t)(cable->hw.formats >> 32);
 	}
@@ -1014,6 +1028,8 @@ static int rule_rate(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.rate_min;
 		t.max = cable->hw.rate_max;
 	}
@@ -1030,6 +1046,8 @@ static int rule_channels(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.channels_min;
 		t.max = cable->hw.channels_max;
 	}
@@ -1046,6 +1064,8 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.period_bytes_min;
 		t.max = cable->hw.period_bytes_max;
 	}
-- 
2.53.0



