Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048705;
	b=BffDKL3MDkXIu6vZ8VJwAFZyfssfc7RC8N8nWQUYK558k1UUga9m+3lcx8na4k+lwxYK
	 PKgWGTXZXWUMnidWN+e2WIj8WuvOf2TN7xPbdRnB/1OdGMEJhvByIsPIntekqTPx+F74c
	 FkAGkEFQz4WoZhffj4bt2Rqw4UzCeAOSHzU9RrBZP0aFvX5PNsLQw2Q3H9zYnOy0yYLYw
	 zNRsA8mvPA3tKCBpSHeX+Gn4LjNu4EI0RRf9tpfgpjbCKp19oBfv05D+JYsudOaAxr6Q8
	 8F7fsXrav0H/5UWcVLiKURnJzvF9H1/B4GJg6fx9Ll5W0+qG0/4w42bn4qImwslWG4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mCx80bwRN5lmh9xrnum2W/h8lb+DEsgvQ0Iw7o5JFM8=;
	b=MBW/jYcAN8ha3wrb4oQo72D7tuctSQTCEcU5HYTt08tUew2n92vdydAmqrs1TQFpzCCB
	 V6mm3MCZKwhtuM6gdwDkWNwmFD2syskA0ElVsCDPUOcljMBiJIKNtic7HfV3e1Oo2hjEb
	 Hzi6xw0cuM606o4cYMw4uNfsfGjXOt6ZDMzHkXKTZnbsYsGDGfbL0jYUCl2W7qi+Xcjvl
	 vP41gqLxxTibFRBr+I1hKbafWOAjG+gqeRUPfuXCVxgCpzXFX2GJ2kva697rAcb8quLcO
	 ugwMqCr7YMCCwmglWp9l3aFgbPlU2YeXRzPRcu341v+aVGDUsLZYky5fU9Ih4+YPezw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkADTjvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC15606A32A;
	Thu, 19 Nov 2026 00:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OkADTjvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CBE1F000C5;
	Thu, 19 Nov 2026 00:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048705;
	bh=mCx80bwRN5lmh9xrnum2W/h8lb+DEsgvQ0Iw7o5JFM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkADTjvjwwbQxjCFnwNisERoThbihsI8Kwq1rvu3c0/OG7glnC2KJQBaSlyDujmOq
	 THg4RwcHi1ACxcJgkn/ajUdvFzXdv+07axLWlXzTChWnjQC1GRCGxjo7cyS0m/PClF
	 OJLGPkpxjtg8zPcbYEJXMYF3JM9gxtAz6DlKJ8LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2091/2857] ALSA: oxygen: use helper to activate the SPDIF PCM control
Date: Wed, 18 Nov 2026 15:52:05 +0100
Message-ID: <20261118150316.696903809@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 5bdc232c3094304a7e17df5ddb66dcdacbead6bf ]

oxygen_open() and oxygen_close() modify the SPDIF PCM control access
flags while holding chip->mutex. Direct access changes bypass the control
core locking and notification path.

Move the access transition outside the driver mutex and use
snd_ctl_activate_id(), which serializes the control update with the control
core.

Fixes: d0ce9946c52e ("[ALSA] add CMI8788 driver")
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260927121709.742840-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/oxygen/oxygen_pcm.c | 37 +++++++++++++++--------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/sound/pci/oxygen/oxygen_pcm.c b/sound/pci/oxygen/oxygen_pcm.c
index 8b4f7269753ad..dda8d9897b4ad 100644
--- a/sound/pci/oxygen/oxygen_pcm.c
+++ b/sound/pci/oxygen/oxygen_pcm.c
@@ -171,16 +171,14 @@ static int oxygen_open(struct snd_pcm_substream *substream,
 	snd_pcm_set_sync(substream);
 	chip->streams[channel] = substream;
 
-	guard(mutex)(&chip->mutex);
-	chip->pcm_active |= 1 << channel;
-	if (channel == PCM_SPDIF) {
-		chip->spdif_pcm_bits = chip->spdif_bits;
-		chip->controls[CONTROL_SPDIF_PCM]->vd[0].access &=
-			~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-		snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_VALUE |
-			       SNDRV_CTL_EVENT_MASK_INFO,
-			       &chip->controls[CONTROL_SPDIF_PCM]->id);
+	scoped_guard(mutex, &chip->mutex) {
+		chip->pcm_active |= 1 << channel;
+		if (channel == PCM_SPDIF)
+			chip->spdif_pcm_bits = chip->spdif_bits;
 	}
+	if (channel == PCM_SPDIF)
+		snd_ctl_activate_id(chip->card,
+				    &chip->controls[CONTROL_SPDIF_PCM]->id, 1);
 
 	return 0;
 }
@@ -220,19 +218,16 @@ static int oxygen_close(struct snd_pcm_substream *substream)
 	struct oxygen *chip = snd_pcm_substream_chip(substream);
 	unsigned int channel = oxygen_substream_channel(substream);
 
-	guard(mutex)(&chip->mutex);
-	chip->pcm_active &= ~(1 << channel);
-	if (channel == PCM_SPDIF) {
-		chip->controls[CONTROL_SPDIF_PCM]->vd[0].access |=
-			SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-		snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_VALUE |
-			       SNDRV_CTL_EVENT_MASK_INFO,
-			       &chip->controls[CONTROL_SPDIF_PCM]->id);
-	}
-	if (channel == PCM_SPDIF || channel == PCM_MULTICH)
-		oxygen_update_spdif_source(chip);
+	scoped_guard(mutex, &chip->mutex) {
+		chip->pcm_active &= ~(1 << channel);
+		if (channel == PCM_SPDIF || channel == PCM_MULTICH)
+			oxygen_update_spdif_source(chip);
 
-	chip->streams[channel] = NULL;
+		chip->streams[channel] = NULL;
+	}
+	if (channel == PCM_SPDIF)
+		snd_ctl_activate_id(chip->card,
+				    &chip->controls[CONTROL_SPDIF_PCM]->id, 0);
 	return 0;
 }
 
-- 
2.53.0



