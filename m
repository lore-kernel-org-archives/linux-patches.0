Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040413;
	b=devVXVF1FUngZJCS5tJ/Hbs8SyYUOcLifl0Jp54Bsw1/1I4jTM1/duVAe0CREdRhor8V
	 CZ0wzPD595TLSbp8KFqFuYxjGbDKYmCbV0hpp8oAtgMLGTwO/o3PSrYAwSjihK0YRMm4X
	 wRoGuDhWeLAExe2NB650VPfrhzM+zZyGwXFVZ1eAShmtVaYvkzgZwrRMuDaWhl6up2FQH
	 bKwttPrSjSzPUFEOgtHBxo4lklJL6rb1U3wLYoxHq5jUZWdI+3qTz6r99IdKZUWzFsagN
	 M5PI1795MGk1d9Cdy7DRInJzYscNk2Ow0Er+KVK/gNANef+pTP1jX66BL8Z0tuL+fCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=al6pPgqU46dbl5IR7jwf4hnC/vFLrOGmAUb0NPWp5Ao=;
	b=lv+jdvKWHciBYxJfpBobHBwwNIo0UZEdX3J++SqO90m/rZzg8oTuSbcswIFBypIpRhVX
	 Y7vG6D5CT9s1+gMoK8ozU2aJon0BTu2I3MEOCqQIm2YEze91zcGJaEADSsFe9gxRT7wZh
	 DynnZ2HnwFWwawlqQhrZx8sOB7llNy9n2cbPLyHLZu5gmJg6kPKIsJ2uP8Fvz0OUAwwvi
	 tGfbhHexlARJT5vWWyiqnFh9E+T0Tb2Mo7wBOpTR7jBdbsTuMBstFParFaQoHFXmwdWt9
	 hFI46TknF5PxjjQUnjMyMqMNDBYWmfBKMowfN7MbV60AGG4d/KlQNmRdbtaR0b+7StA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJHgq1gB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABD606A31C;
	Wed, 18 Nov 2026 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJHgq1gB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290E01F000C4;
	Wed, 18 Nov 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040413;
	bh=al6pPgqU46dbl5IR7jwf4hnC/vFLrOGmAUb0NPWp5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJHgq1gBCMhVfQJ8aRRkTcRmqgxx8AaPLbLYK3KKPiZEonGyVVVaxFdvKKULs8ouG
	 FECfhOkCYZd8v79v1p+AUxETkTP55YqAJ+XQ+aSWslqDLJSobMN4tenPMxA/5iIfeM
	 ICQLD/HkQlLZTbp13NgDsY8q5sU3AdLETORzS8jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2407/3318] ALSA: oxygen: use helper to activate the SPDIF PCM control
Date: Wed, 18 Nov 2026 15:50:29 +0100
Message-ID: <20261118150433.702947637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



