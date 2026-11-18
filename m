Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030242;
	b=DnKu8O5Sfhl9I4xXlaEsWeVnRAd4jTGPyO2h+RHpCCRRImfaERTPb/7gQiIXlKhUgCXP
	 XVF9jsXco93y5tusWCaYlXHLoHMoHot5VXKJvfrLJM2a3H4abTDRS0mPMp9EsgPzGE0pQ
	 tEkJdiAh9XRm2TBwWJya9ZXNj6xFOgwJYcoPiO3kaVMuWeBzpWOiCJaRrIkfcwfe6UZxI
	 r+stDYuohf8BpLqmT+C33c98FeG2lQsvVBB7RravMDtW8FhBsvHGEASBASrf6BAdICEIV
	 NB95/tGQY/aHqpV0yQjHtNcS0p67TAlLUGgD8Bq0t3pk4fc5LyOQJCyM25VpGEnIJVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCA9Sk81MTCIQARV/msEbT2woM45K7JKClx+cin1Qdg=;
	b=ZIwkdRJ9+ZnSx+/wZ8P+b9ujm8wLkzjAzPl4kUdQ59pU2AP8Zh6TNEpERPN6EfyVEVrg
	 e5dDu1YGtpsUKVqgkGkT9X4Z7Zrlw8RzdKOnbLotSAj52P61moN9+Wh2sCdAMIZHfinFn
	 5uL9EcVF0xFO1+In1UJr/NVM3cTmS4shapESHPCnFWUMLWtUsMgQeyFHbH0odcppjHtK4
	 jCLb4dEfpEf4pGeihOPReSji3lxh+ibGbCzYB/pPwBV7peEspRVhGXlXy6c3o5b3urm+1
	 yuiDZ3B63+rvLLYUvD1R4E8exAlqSFpzCBAWGN8pBkJA04CwFlYISOFf7Gbn2mS0McQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWy2MPk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9D1606F632;
	Wed, 18 Nov 2026 19:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWy2MPk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1F91F000CC;
	Wed, 18 Nov 2026 19:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030242;
	bh=QCA9Sk81MTCIQARV/msEbT2woM45K7JKClx+cin1Qdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWy2MPk7F9d8iD2lqHeGRl2ozKYzVAu5oB7XRRV8Xh1PokLwEG5EKx+4qc3jTM5lf
	 JiGiDepwlMBgn6P8d4sUAEc4biemESMGkXdRkh3UmGnc2s6jo8VCYyRFRxxFtDFsyX
	 a8eCCZlEsuKG/pkDUxXzH4lKLdNJqjC/sbcDabug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0634/1756] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118150034.104155576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 89838b4fb118a..278516107f62d 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1249,11 +1249,7 @@ static int snd_via8233_playback_open(struct snd_pcm_substream *substream)
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
@@ -1340,10 +1336,7 @@ static int snd_via8233_playback_close(struct snd_pcm_substream *substream)
 
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



