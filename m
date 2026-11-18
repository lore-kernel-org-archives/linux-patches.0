Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017614;
	b=p26N6vPSwO3VB68SwSZlr68vYCz1m+aPDd1ZLEVoNxnhs/J5UOurJniHFjLHVkny8O7i
	 z8P3n3xiSnIkzgNo+dUq605VJXL0TSy/m7lmio8C7Sm25AjqXzWTXkHNiHw/dJDirNGn2
	 qK7hxBomaoDilo32tCuX5MMwGa8YO75XSvQeQlUwL7qDdH20Yu2Nvcc41apJYzntNAywP
	 riAOhtcTUFjPKZiWAb0PT+FXDL0pBFGE/0cyxXGdPMik92XatCprqznlNSBZskfbTasm5
	 9hu3qQsLV8XLa4f0gWpPeNYYlJ2jCYBWEEEXVFVEWAqXO32tvlM2RwBmv04E56Amccg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nm1YhjNiXG6r3nv6bbQUliYB2RxM0z6Kz1sCHGJU1vs=;
	b=MYwd6hAcqWJO2AJ3mME25XRyjtk9Om8npf2fGCLRwJ6qpeTx3d5dBT9QYBN5Qnnf5C2O
	 XfkGxZHGvBmhN/NnpyBzFUakO+ZPHSA+qJoR5JsjXWUY+5com5IyBzzdGXasOpgY7TLVu
	 X0rrAu/Ihc+twXNGBga83ERaFUMmLFy/viqXzzU7t7q63hGzTn7d0xnUbEdWBXvG3rw5s
	 COmuD7Dleo5mt2swguJviqu/73H/Hln2lXA3CLsyCl6C65P5rmmiMkpwyDL0VOOIVwKfl
	 38prvlSsfBhHKbpHNuB7Ae8azLs/Ket4VVStjz813GpqY4Y8DtSSGolJhAmyf9nGuEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKXCwoIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1137606A335;
	Wed, 18 Nov 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKXCwoIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB7F1F000CA;
	Wed, 18 Nov 2026 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017613;
	bh=nm1YhjNiXG6r3nv6bbQUliYB2RxM0z6Kz1sCHGJU1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKXCwoIHTNqKYzYyjEEOJGcIw3CNCwaqDC41cDXp9xxE2H1jrYMCVtbWx7c1I5Ird
	 AXCpWxg8VISqGDusepsAeoT+IssuIheSaqMzoiMUZwRJPfy/oNhuP/eY9HKU5q1b45
	 akMh8HbeelPcvKzBbQo8HcLPrf2lD8ScuF9HU1ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0946/2651] ALSA: via82xx: use helper to activate DXS controls
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118150321.959039663@linuxfoundation.org>
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
index 24ee1302f27d3..58816dea49963 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1242,11 +1242,7 @@ static int snd_via8233_playback_open(struct snd_pcm_substream *substream)
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
@@ -1333,10 +1329,7 @@ static int snd_via8233_playback_close(struct snd_pcm_substream *substream)
 
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



