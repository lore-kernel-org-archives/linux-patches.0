Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024665;
	b=mTJzwH1sLSe/FAYgagpIzv4AZSWZZuxgxWnj3rGRQ3rC5BvGxA7m2QQpF4eqJSzpBmcJ
	 5GbGXcseO/TCXHlZ2Ayyfc+H1W16+yLnkjY2YFZttu8VCX+seSryyS8Q19kNLWye9/qeT
	 zDajUolhRa3uZbtifbeQyro/KjzdgAriBM8jWC2uFvo2A+9bKuPYD/AwrICcvY8Km1dfl
	 MnSO4mSpMIpfYoIMMkULtf9NIN5675FZCLrjg9l5JLVnJjE7tCKCTuxEn04+yrQTTgv+j
	 vz3/9/6uWFIJQrwdTEBbLIQslTF65qYOqExpxmfWqczpVpGnO3LiM+B/wpHBBnnSrpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsKF63oC3KXgRzBeo62BpePNpfd60yg9EcxREhzDOfg=;
	b=V0sOosFCP8pUoya5pSUQ2lGpCdKLtTpdnfNGvu3B5wMIzj6dBdfrh2HrluRj7S5rlSiK
	 msFMLvlYO7xcM7OVLsi0J7V0UmXSD2MVdOAmKnDIN8pW7PdS9Y7i5fwPmGuGXD1OcDTSO
	 j0K1Ud6/HvxV2zh+Q5/ETn3K0sorDWx8Q0KL1S890L6TahceLXxD3Fl59Jil79KQkfW1l
	 TRb9NXcK5jlnS8L5Pwa278DBfUW8BpLsQ/vUR/UUUaz8S1IFNrKD5QaW/7DpVxWHjt7XD
	 0JN2lNxsXbn+HHythqXKCaFaL9LK7VWqWpj8umdwfIlvZw/RKpWQUmsWckf1ik9HOFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ittpc4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA0606A31C;
	Wed, 18 Nov 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ittpc4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE631F000C4;
	Wed, 18 Nov 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024665;
	bh=UsKF63oC3KXgRzBeo62BpePNpfd60yg9EcxREhzDOfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ittpc4USrAtgLv2eDp4gBCW2DnOtAZuAFVoh8sZajrHKbmwHHhShC/a6nP0aGNnA
	 2Tb25vWoMiod3ytuGtIFfl1tfFC7GhxDS2roq/b35IcnzmSsN+7BxPrk15cddE6qwo
	 IgIcxxCT6fow+KZ99Co++J96DdzSk52QjQX7DZvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0806/2151] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118150151.417210199@linuxfoundation.org>
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
index 2b0f9e38863ed..220fd86d43a06 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1244,11 +1244,7 @@ static int snd_via8233_playback_open(struct snd_pcm_substream *substream)
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
@@ -1335,10 +1331,7 @@ static int snd_via8233_playback_close(struct snd_pcm_substream *substream)
 
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



