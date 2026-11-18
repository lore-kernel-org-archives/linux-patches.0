Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048708;
	b=nnwbug40+w2JmbI0hCqomblvKFrJen+01ONJM/ZM7jwSay7UCqC4FnKjRy0mb8e0zyoE
	 UOZMn+/Gvp2JZsrXp/tq9eH0SzOBDov9Mk7J3wmeX8N2Eli7k+2N7U1V6QDZCVzyugWTt
	 ozIm6F3AEPSi+k3I6oAz6lMN33nvGorAFqTsqeZh42g2z7kvb3zUoP5HapX6A2PU8W2zH
	 Rd2Vr0WeUrSzo0HNYQy7tvlhgYSGRJSvp7SSY7p2f9pfbaiIIxmxenTMVIGKrgLdsgBmi
	 KIxCNNmYWFnbmuf+q8modi7Cy83fsfriMGoH3s48TgiSqyxUKwB5T1ykCcOlQpqMWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ug8sEivZPdDzr60CY3SK4AalvFs0v7RNSzFT1UKuNiE=;
	b=Jwzd1IiTdFvWYgkS+hJWj1cU5wHrqEJZNrFbxabiIqH64p8DFAZjRktlq8eGfrjAhrOF
	 X4eH2bNmym57t6LkK+jQTGGnHxDEgCq7HksBeWtuHUgcMrv3I4/mXyXEIWwP5qjEG0t7d
	 J1EFjUw7GLpLsE/XohGijKVQFK0TuwZwvgANKRd/ZEDPRVEx0aXr4dbU9OV+VLJ+juiVN
	 pSDnElNJnpJc8JzJb7EkPXpbdtFTOP71O+ZytlotUstBQzYHcphP/d1EApQBbPthsW246
	 oEZuIOgAYxPAtxYrpfSEYQHZTH75vY9QoSToXGKABw+ws0TbSdIMEUX85BdTqXY4rGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Oy3zaI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA8606A334;
	Thu, 19 Nov 2026 00:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Oy3zaI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDC91F000C7;
	Thu, 19 Nov 2026 00:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048708;
	bh=ug8sEivZPdDzr60CY3SK4AalvFs0v7RNSzFT1UKuNiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Oy3zaI4Gkyw+hBh1+J3XuduMspQtRZiD4kMP5/v5TaL/kELLgEArIIDUqdq57hsi
	 ijGvpBSMZDoRMPAx95CHmGPSkKcW7gfAlo3Ydi5/N+rE2OMj1YNvgfufJluRFSBldl
	 moI2sJWitAyNq49SRFUEpi0hDHXtSJQzEUvZKxVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2092/2857] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150316.731292692@linuxfoundation.org>
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



