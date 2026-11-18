Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060950;
	b=qx0j0oWkonydyNj8HBgYWE+BI3HxvhMelsM0DArw7SEV6n/VUOtF+X8ULuD4c2iiKD/z
	 Gymh0eTrgtjKTkoii+gQtWDVAQNWf/SzVxSfwUniTiwAgFuda/f/qrvSuAQXcyDLiCZUL
	 TauYPOijcynGD0le/0W2bAixdmhW8gCjR6VPi60EjOQLilC+YTKFvtv1uSTjsy/pRWVvM
	 PBdBHCMKuzUxcpR7KiaJFxUt3+7T9Axnuvz68QGYv9ImusI6uRcIyGH/0UzA92LgQt7Hr
	 tw25CSsW2PQbU+H6c1bs6y0mBFk6yAIyG/On6M3o5ZyBo6pw6MbCf9Pr7YA05JvHI/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ipVUmqOS91xyhS0X5ef5hdjXsRwVGOTO307GFdIL+Q=;
	b=Xg4R/1QKuypQ87ubqt/O2of8JymZuXI+ehk8B61gIXOBZrT2Pw9M7yw7NZFskg6ZspvK
	 vMrY9AFe01gpX+EgoNB3Ft55fjF1Gku87AQY7PLILFGU+RteULzDUGtn6xa9C22cgXu2H
	 bhuQDHWXzmFZ0ed0jWN1Wy66QsJhimxy9xAGC1BO165vbrkMmobeuIjB28OH4CSegO5dO
	 z9xoZd9Z2ab7qxW4w4moA4hseyolH52bdhdFuJOC7ES7mghxYHp1xqb0KxrDrkCoJIZXK
	 bOSEaKUFa4VjOJBrz73sqkLUE6PccvEM4iCYYZ7HJDIWaG0KnEQT82R+BXEBXJI/DrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEHlBBdq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD2606A320;
	Thu, 19 Nov 2026 04:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEHlBBdq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FAA1F000C4;
	Thu, 19 Nov 2026 04:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060949;
	bh=7ipVUmqOS91xyhS0X5ef5hdjXsRwVGOTO307GFdIL+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEHlBBdqli0pqHp2gD/Xx0oPCQXfcathq9IWupP2b1AfUVBM1B0Z+7cz6LaCpAG0k
	 CDFu6FX1qWK+8cNwRx2CyVqneLvYUre16ZQrwYEYu67g0IhWaUbP2J0FEHXjcCGwLp
	 GilPrJduSX/JukreNQjW2lNafGbcZHtg63JN72mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1383/1848] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:57:01 +0100
Message-ID: <20261118150017.380574613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 154d88ce88131..496e212c80cc5 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1247,11 +1247,7 @@ static int snd_via8233_playback_open(struct snd_pcm_substream *substream)
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
@@ -1337,10 +1333,7 @@ static int snd_via8233_playback_close(struct snd_pcm_substream *substream)
 
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



