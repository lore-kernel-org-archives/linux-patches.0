Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020516;
	b=vzS3b5YRBxaRck3QlmtG8SA7CGkMlIXjtdoaWvRDd3hFweh5iCKW9yv0OgBwNDEYmGv1
	 LvmkLxIZyl4fzYYHsgrzB/sfbN+gXISF6ec8zKpVgO850+NCc8cunEYFD1CHVVIZR0hEO
	 bPSIGZaKGfy3wMNhHLY2xoyMtSbYHvZM7ZezvrfRdPr5JY/OVL6WoFoZhuycv2E4gpZIh
	 jDdZxmw+2RGgjjxHdGqOSf5ePqqKLAg06weO9XU//s04m2i0ytdlKdEp6IHf+lhaQQcVT
	 pcq0II0/bzmLWW6bRxU/P4hEi0Kn7mMSr0x/DHdbhnrGp9p9cY5+og9eLVypRBZeKuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFZuguYYkvR8/7V6HSM/lvZTlOZHfDtPWlVxBRwaxd8=;
	b=b3GHNFZY/T+59bzzvDLhuU9x9auSJtLFmY1GKySRwJvzastM0MsyRiQ+hq0ppJPaqOm+
	 F8hVeaRlwmoBGo6WVNo5MMSSKIKnXKdP5Zpb5N8qvQBAPSG3OQ4LsV7H19Bjimf/7Wrpi
	 NFKie55am4YUdd6RW35MHDXVLTlnDd0Cs7qBkTMZXwec7mzgjpAT2gXnKcaVb573+46Nh
	 1jD+w7Wj+dqgrHYyZwKnKeLdymU54FK0+1q9eVaT2mVXkVXrt0htgjgl3lhsuBzRSSlp/
	 vSIXrANWcskuhbXCKHolR+/TURwBvwtlIeywmVmDDOMvP1Qob6P1qHVzISa8tzgf2ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUgsiAta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA6C606A31C;
	Wed, 18 Nov 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUgsiAta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A8E1F000C4;
	Wed, 18 Nov 2026 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020516;
	bh=eFZuguYYkvR8/7V6HSM/lvZTlOZHfDtPWlVxBRwaxd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUgsiAtawo8rcipaSdxZlPpHOd2iUrT8KIyQm+qGO69gD4e2470h+NLYvxjcsDJIf
	 JEZEWp3UjSBgQ1uAN0TkdHkMLS1H8VvKoihwqbfA8E6PpZdOQ8RKLDaE+b1BbHFF1t
	 PR8uWUy4UmoIHHnN4uDBie+NsdUgIadv6U8TeatA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1980/2651] ASoC: Intel: avs: Unprepare a stream when recovery occurs
Date: Wed, 18 Nov 2026 15:53:40 +0100
Message-ID: <20261118150357.698349326@linuxfoundation.org>
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
index 880cd7a9fb346..13a38ec8c917e 100644
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



