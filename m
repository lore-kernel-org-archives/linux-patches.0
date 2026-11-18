Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055592;
	b=eI+Ho3XgTOSTrfzPoTmDZmdi/D3i6PU4z/3RauhG3KXIqj7BZ0Lxr1PkBoTD5e0U0P/1
	 7sbt8YrKNogIJ2f3gETeBjkY/uDMnEKklRYVsSrdOVqiEfiDokRwEskT9jRxIfPLj1o6q
	 2lFvKD7Rbx0kbo3hecJNykTVLLcXVmwSSADQ2wILyWh0/NohfkB/PtHV07YiCecURTags
	 0PQYRn8PpSQKqatF5IUY4YHHRxXM7nQTwRnJ/ewJ7r5peljc+1YR7RyVnKoLSAAcdicZK
	 7RXDFi8/matpkXZuU2PEmJiJ/imALWyaHmdxfAH+MUEe3ri1i8/cMk3zoVqlnheRkoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4YKqbUFUzPLqDIX5wlw70epr2rpOstPoC9g80kt/Fvo=;
	b=IzpwsaXf5cBz/vDI+bIGOH1TR0+4sNfeYN51qno20xoO4Wcfz0bdVYaHRdHX7qNnsBoZ
	 5IjpJ4Nq4OQh/7oPRmj4//7dTI5fb5sKgUWIFZ+VcmyDTN1YoHN3fjXy7UgonNPUW5a0N
	 ruHPQj3E0f2Y4bnH9+/id8Q5WEzTWrNyGgurIak6OmW3iJ04jTrpTIeohbWB5iHFFm0+9
	 DhOqaaiQtjF1gs1AAKfmYNpaM5mMX0496YfrccGQUem+RYq/EFfbNj1PScPdKUn2RceMY
	 IWT3m2HukHG/vIA8yg5XNB71Q9Ggy2ORslePquOlvs+db0RdH7784f1kq1/2+H4xohQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzBPm6Au;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44124606A32A;
	Thu, 19 Nov 2026 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzBPm6Au
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E461F000C4;
	Thu, 19 Nov 2026 02:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055591;
	bh=4YKqbUFUzPLqDIX5wlw70epr2rpOstPoC9g80kt/Fvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzBPm6AuL7vmq14JGFNckB120KzpA9MfOyCoIBOO2xkLiSO/i133sxgT8sdwgUkiV
	 2M8L5TXja+g1RnDtG+Dd08/i9p03ebXG40EKo5E48ytgUoPeJEcg7uWzwKwgNzW6W/
	 ybEFi4fPL/v61jvEwgEXXD8WGK3tx0jXjiHPRuZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1636/2214] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150117.386309380@linuxfoundation.org>
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
index 361b83fd721e6..02118de732a4e 100644
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



