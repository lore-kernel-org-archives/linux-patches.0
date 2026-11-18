Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017611;
	b=yfj5v4GJhON5xgarMZUC50IcpmbdbbHVcyX44XXoQJXGH3zE0ktUJJxNWEnWZ6lJGJ8G
	 2FNdawQYIVCs/P5T0nCOT5aP2FZBgwyblXTuFIH2/M0NrdBGuNgfW4mMJevL/0TyOvcUB
	 ov7gUzw98+plqvXmtpCYKMSnTyiKDeIwRozjWY6laLLwCUAxO3DjZyM5evlaoJFJUtekz
	 GcyKrFh181JTPt+Fx+pFj/vxtkqWGHHq5yPbgJmqOdOf8eYyezO+hllyGwB3MLAe0px4O
	 DHZc4kuqHwJ8VCl+W7DZONmKrLHnuXt4XvLMFxMGWWvmIf6+axihIMnKhr225HHL6kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsnOqL27z9FEHFyW3N71yuLxWR+tn1aML++l53yBLv4=;
	b=aazAqnvk5vbMNeV74fHebVnL1ljcbiOXkQ+FM8aku8EYswqArXJfAM2NexBNGVWLufl1
	 nLz+IM79UWFGgvIl4vEgaA+OKTF4HnjWTJfrE0EddnP7g1T4WHFH9vYiSjChbAFvuyQhw
	 vpYPmxUTer8oplSIaEdx2Nm7Vd8Kfk2O2x5XjbmBETMpPVsh16NTKe7N7lb2+x0ScB/Zn
	 xhuAYfjxdBa3LdZORtFQ8AdNHM8XxazTzqH1104GaxG0KtE5RmDtw0wM/UK5vraS6NWS1
	 0h3hRYaDNRoPDIp8XPlYQrACLo4YrKIGh6rZGicsrhZOH5wVRUyC4iOyes2s/VgSCgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KmLhR0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A559606A334;
	Wed, 18 Nov 2026 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KmLhR0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4321F000C7;
	Wed, 18 Nov 2026 16:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017611;
	bh=dsnOqL27z9FEHFyW3N71yuLxWR+tn1aML++l53yBLv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KmLhR0Z/1h4rmRUHBnhkQTJhYT8Ly4nqzdXW+rQYzkbxaBtmbR/tYFbqIvwBCnyB
	 GI9gJcQNOFgpPI1tLqOYSHFkhAdsIexFrh8SBmtOrtVrL5g2CH8/3S1FBZzGP+bc4E
	 +WVtEM4XDlcTg86NXouY23h8plaAPtdkzG4DxN3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0945/2651] ALSA: oxygen: use helper to activate the SPDIF PCM control
Date: Wed, 18 Nov 2026 15:36:25 +0100
Message-ID: <20261118150321.921322681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b716356010b89..75efbf59a6752 100644
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



