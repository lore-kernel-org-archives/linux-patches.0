Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040416;
	b=z1x0v9Mpq9O5V6HQeCSyfkrYIKOOKU6UNbutt71a1TkAtMiJMx43QNAR7sQvu8rTG8ro
	 IxbzDHXwqpyeHik7v9Zu1357/IsDhnfoav0RRqnGFzCkzhucyDcMDyww0MwUucWXeso47
	 KRwIyYEo9q9JozHe3013EBeBYPWvhKttP+6QY5wQAIzU6Z0FgZyfHG9lYjll7BY0LMVZ9
	 6zgdOIJ1n2vBI73p3NLHkzzqXtboBgRnympTSzlH/J6bkP8TZLT2UHaTS+IVl7eY7r5Et
	 FcBjwa1D3O6Rfzo0fmygrXPdWm7zCwg1JZm7JRlvcCooWktsjNqklnB53a72HjXBYow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oyF+Ep8oVTT6qkkGzbpPNNgW1wZPuF8ye83zqsZL1Ss=;
	b=OwKeWstYorSv7y2EappW/ZOrzxeJhdo5AqbQVJ9dPqujBpxPCHLKMxuzKv3l8hZ9v/iu
	 uc0b3Pib765ki62nSJRNuYOvsK4+Js6m9MO9xqOKGJfqBbSDH/qPe+BH5XZmPIFY6DqBw
	 Jd5txUNfvr773O4hcYeLQCRm53j6UYSxyqB2THTL902FlBbqRH8BcL0DXHyAZ3OCFdAFR
	 IN74DLuJvfwnmD694lMlVfEvPi2kTzbhlfAo5b5UJ/O6DZZorihLkE9ZzXx+/vrEDSpOZ
	 wS9MfQHW0fUTWlavwqmbR41BnYFSoMpzO8h97wvwbAa7QNja9SqyWbX3PzIhhr/0MTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBREgku4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741D2606A325;
	Wed, 18 Nov 2026 22:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBREgku4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDD11F000C4;
	Wed, 18 Nov 2026 22:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040416;
	bh=oyF+Ep8oVTT6qkkGzbpPNNgW1wZPuF8ye83zqsZL1Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBREgku4tnU+nMbF+HG9oN84db0w82J5sdiq3J8jxmYcQJ62AA6AoFXoWuE6EtOGM
	 2Ww2HTZNVDd5OTHCIdzFH71m/WHj9bDzXOE+8ybhUtknj9y56IOxH1NG/a/9wSu4rT
	 1i4nDp2y2ejspEy8t0QuPWMJhqCOfUJCfXPnipKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2408/3318] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118150433.732956141@linuxfoundation.org>
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

[ Upstream commit aee7c43126e3184d7eefde6545b3b88628e5591a ]

The VIA DXS playback callbacks modify control access flags directly when
a stream opens or closes. This bypasses the control core locking and
notification path.

Use snd_ctl_activate_id() for both transitions so access changes are
serialized by the control core and reported with the expected info event.

Fixes: 3d00941371a7 ("sound: via82xx: deactivate DXS controls of inactive streams")
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260927141447.788664-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/via82xx.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index d8666ff7bdfae..372061c5a2a4a 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1251,11 +1251,7 @@ static int snd_via8233_playback_open(struct snd_pcm_substream *substream)
 				VIA_DXS_MAX_VOLUME - (dxs_init_volume & 31);
 		chip->playback_volume[stream][1] =
 				VIA_DXS_MAX_VOLUME - (dxs_init_volume & 31);
-		chip->dxs_controls[stream]->vd[0].access &=
-			~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-		snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_VALUE |
-			       SNDRV_CTL_EVENT_MASK_INFO,
-			       &chip->dxs_controls[stream]->id);
+		snd_ctl_activate_id(chip->card, &chip->dxs_controls[stream]->id, 1);
 	}
 	return 0;
 }
@@ -1342,10 +1338,7 @@ static int snd_via8233_playback_close(struct snd_pcm_substream *substream)
 
 	stream = viadev->reg_offset / 0x10;
 	if (chip->dxs_controls[stream]) {
-		chip->dxs_controls[stream]->vd[0].access |=
-			SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-		snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_INFO,
-			       &chip->dxs_controls[stream]->id);
+		snd_ctl_activate_id(chip->card, &chip->dxs_controls[stream]->id, 0);
 	}
 	return snd_via82xx_pcm_close(substream);
 }
-- 
2.53.0



