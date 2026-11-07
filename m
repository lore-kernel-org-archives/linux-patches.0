Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063132;
	b=0W8wnsn3fT1oqu8MJaSEXn7JumdOYFh6m4cYCM1Kmjd21SAiBMipyXS0wS4Vz77L7MT5
	 BZTin1cebFBF9yl12uVF252EaC36jDwjGt9MPZPAV3LWR01yRms47bZhkp4AzMkDB4Lk4
	 +hHVsHyVWBgLK45z0E+9TJEvZpiL5eub0HnufHHxIa0J0uIAOaIpBSuuDkOCDr4NvBlbB
	 0V9TYZE/Kpotg+cXKnyuGClQsWa2RRM4lTOBr4U/fLyGGp4VuzknnCaXhFy7nfO/SPNds
	 0++fHW68fZjf0LKtR+g6Vae5Ta/v872Y9GwOkRZFRfFis3s9tDbkjcp1jHi0sSK99Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnZ56G6RI2wF5pp1/h3ZppHt83G4Hl6nXue+QLp/L/U=;
	b=rCC6yMZ8HOKvgA2CrB5zeAJyFVrsA62xL4Ooj5Dn7iWPJstIW5f+9+8HpSyT7fFnYdJw
	 P2cHN3zC4ZeLcHGcUTasBxdBK6UPDMe4TLFK9r1AnKX01GOyqWMNBwDeUq0RKkfMSlZc8
	 AL8NMUqPNuF8tZx4FuDxKuaP49lfFrR2ixkFT9rmi1hrpPZwKhe12t0jQs8AmJsQWk86G
	 fSz4EcjhsBVFvHSdxMe7C3UnQpcDGaSRFNkDCm70RWTfT1n3q/fzwuh6h7Ge5RNM2w0M5
	 yJOzhLx/vBdhCKEemGtCZT5b7va6oj2U966jaRtgB+aPe9S0Pa80QVKlr9fu67ywj5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXr7RCcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84543606D817;
	Sat,  7 Nov 2026 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXr7RCcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BDB1F0089F;
	Sat,  7 Nov 2026 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063132;
	bh=gnZ56G6RI2wF5pp1/h3ZppHt83G4Hl6nXue+QLp/L/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXr7RCcwKtlomaCXq/IjjCKVHD8vKof+0l5Q4UYnnrkYZAELtkqql3NceACc0JP4z
	 UCa38T7fpnSpzAaRf2dIyo80Ppi9wasWMp9gwUuLYzIoI0xVBmRggjf+4ySLplrosN
	 BCgbORTAQ703JysgOvMFALiXICb65iReZv51PkKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Hofman <pavel.hofman@ivitera.com>,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/869] ALSA: aloop: Dont constrain playback params in notify mode
Date: Sat,  7 Nov 2026 08:50:44 -0500
Message-ID: <20261107134904.822032414@linuxfoundation.org>
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
index d08027681c373..eefc41f628462 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -988,6 +988,18 @@ static unsigned int get_cable_index(struct snd_pcm_substream *substream)
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
@@ -997,6 +1009,8 @@ static int rule_format(struct snd_pcm_hw_params *params,
 
 	snd_mask_none(&m);
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		m.bits[0] = (u_int32_t)cable->hw.formats;
 		m.bits[1] = (u_int32_t)(cable->hw.formats >> 32);
 	}
@@ -1011,6 +1025,8 @@ static int rule_rate(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.rate_min;
 		t.max = cable->hw.rate_max;
 	}
@@ -1027,6 +1043,8 @@ static int rule_channels(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.channels_min;
 		t.max = cable->hw.channels_max;
 	}
@@ -1043,6 +1061,8 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
 	struct snd_interval t;
 
 	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		if (loopback_playback_unconstrained(dpcm))
+			return 0;
 		t.min = cable->hw.period_bytes_min;
 		t.max = cable->hw.period_bytes_max;
 	}
-- 
2.53.0



