Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026946;
	b=j+GK7nLpbYL732kmewqG/3OpokTKexFlmdEL6nShj2Uj32qFTILqbAq/Zq/XPPDoimFb
	 eDaqzZuJxq849VXy5Qgd0zRNKxcwv0xZl17qEX4X1hkfbWFaQHrnoiKD+8pM5MEkLRMmf
	 pBeST9Cnowec5S+LsGFkKT5QOmp8DUU0XJaR2ZmbHDc/VKm3DFIRqrfUW1F2L2BU0xSvu
	 zpforNYQ3UwPB0zs2XDMG/0TthrddTgTafYMonmKv4tD0zU4FtzGrRbjNNmpTrZOgd13H
	 3AvsKTCsOuq1yLbw/zhN3KT5U2PNoAnfvs/jvGTglI6HaZvkqEV+MLfzYPJmSGV/Ceg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4VKRfXX8easZZy7R94ynOYez4D+9Ll8Xp19V5P9/hOU=;
	b=3ICBgTUG2/FEuGhvH5KDBemuNgAzecfXhVR9aNUhIMRzXwfrWhNsazIWQr+SqMxnWqNG
	 4QawxkTnYRzSxskLeNwwrJUaVRdrsaCwRAyOXK8b/CrFVODDdH5eGvsQ7uEBVwcv8KE3h
	 PvJPcI9+y+sQG5O5aWQzFQWi2wt/V4uNfSnUTlOxSwLp0JPyaHjqqxtpKlFs/KXqrZbsU
	 CWd5afcuo2AgXtz4JmZD8H6KK9xEGW3BJe4YCI9PoI/WGbGnh4Rjsua4RMRi4xTsGMYVZ
	 beYP4A2TG6g7Nge6q9aBDO+aQIhBPlqgOIZ2+z6f+RjnETkXqGGU9Q4jnJv48P8VXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MERssce7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5B606A332;
	Wed, 18 Nov 2026 18:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MERssce7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908E81F000C4;
	Wed, 18 Nov 2026 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026946;
	bh=4VKRfXX8easZZy7R94ynOYez4D+9Ll8Xp19V5P9/hOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MERssce7aUve7o9ThM2dOTx0UQkM6djYZBvoFulyRbXMoHorHcUZdwEf5yEE7Fn4/
	 h4z22ZsoNKx2GZEtWTBlkLOVhEGSQAkkt/VqJO/y//GYUaUd1EWjutRnXTBZ8VCik5
	 J2Fc5d3Th3inYYsUe71UxC9A3yChJXBdoFzlvqiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1616/2151] ASoC: Intel: avs: Unprepare a stream when recovery occurs
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150220.747566817@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 85bc213f96ac03d74a3e531968c68861e5598281 ]

Recovery on alsa-lib side is handled with either:
1) snd_pcm_prepare(state=XRUN)
2) snd_pcm_drop/drain() -> snd_pcm_prepare(state=SETUP)

before starting the PCM anew. Relying solely on state=XRUN leaves 2)
unaccounted for. sound/core/pcm_native.c ensures correctness of the
state machine so plain state!=PREPARED check suffices.

This is the BE equivalent of job done previously for FE side only with
commit cfca1637bc2b ("ASoC: Intel: avs: Unprepare a stream when XRUN
occurs") and its follow up titled: ("ASoC: Intel: avs: Reset the stream
unless it is already prepared").

Link: https://lore.kernel.org/linux-sound/20261010103753.16969-1-stiraspo@gmail.com/T/
Fixes: d070002a20fc ("ASoC: Intel: avs: HDA PCM BE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 8f09d539e2246..8088e13c3bb9e 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -461,6 +461,8 @@ static int avs_dai_hda_be_prepare(struct snd_pcm_substream *substream, struct sn
 	link_stream = data->link_stream;
 	p = &be->dpcm[substream->stream].hw_params;
 
+	if (substream->runtime->state != SNDRV_PCM_STATE_PREPARED)
+		link_stream->link_prepared = false;
 	if (link_stream->link_prepared)
 		return 0;
 
-- 
2.53.0



