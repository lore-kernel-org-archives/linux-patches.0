Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024662;
	b=WxdHRMe4E+h2vYIscVxEMKT/O1DsGL/1S6h+vDI1yVRcijpKl6R+NmoG20tpYo0NbSYO
	 Sc4AGmtbs8TcnDDb6Y2foamM72KjYNMCYsUYe5M7fOgxRRxyjmxMsfLpRegGxW7H62fec
	 GOLnTYVrmmsOj8E+kxrTjZ9CLxIV1FBPZCBeU5Oz/b3QgDK4oXZEhP/ynjGadGJw4sHy6
	 70Azr8lpdMuR931OugSjsaaWhLM7YCTysz+LMDZPY81AM6uAhFP7qtCdqN47fH8EpFOna
	 sq+59jTBmBImGxS8ZiG/vQmcljYFtKiS+jBQ5mSCjxk4zZqjbAywtuTmG0sOK0NJCwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkevG4EnDNpjm7Nzwwqy5iKXu7CTodB9dfqxYpYarM0=;
	b=oM/h/OWIRPkd1Y+d7GmrEP+ELXq+mj+/1nJrgTHcXAgDXsgH67/Fb/RZJkG8Fh7hBmd6
	 uawtXymiz9EOD1/X76L4Xv1lLiXPFk0kuPs/T9PsJ5HkseKdW3oslk5i5GFe6k3WCW29V
	 Z9HeIKbot4YrUTpY6bLz3v/fuQbOqEGra0P+iwcGi/1PJLrLaSzoTnFb2wlIKRNCvtceF
	 KV/Pu8EOPmPOgBGO+mf5gFnlVyZANZy1hUMRzUC4D3p68awT2RjiL9Htn2cw8FAUnK74J
	 Ob5Cvw4XnVjuXondylAUbx3fFHJrdYW64n1msG4se/7Ekp4/Lp3czLRHKGEwdD92aHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGpisUxr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECE6606A330;
	Wed, 18 Nov 2026 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGpisUxr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC8A1F000C4;
	Wed, 18 Nov 2026 17:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024662;
	bh=RkevG4EnDNpjm7Nzwwqy5iKXu7CTodB9dfqxYpYarM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGpisUxrEzx9TByI9JNqFOirC1IoiOidakFWqUvhB6bDRmhCsXcmfo63cBQSK2rmj
	 03Z2WzLfL5S80/x6yPTaTsyvjPSDqcuLzUfW2dVTbgTiWwdLzqEFmC7pC108NSFExr
	 ni9Hj5ijnzQb7hiB4ieRpRWyPfkSFB1A6Lc44Qjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0805/2151] ALSA: oxygen: use helper to activate the SPDIF PCM control
Date: Wed, 18 Nov 2026 15:42:20 +0100
Message-ID: <20261118150151.384004922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



