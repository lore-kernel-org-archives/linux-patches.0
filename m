Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AA5BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD8C4339B;
	Tue,  7 Mar 2023 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215310;
	bh=8aNPWg7IAKoSeH1lG+jWsspclDk2BwBA8nq8ftq2ZJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4tBPWSkt6lq0v/ZOIctxL93+fx55qQJ5fKFNzzdVON5Nug2uOiSyr8+GL9ONzzOL
	 d8WDdhKPB+YnoVkGT/nnr1WawFIRxHJWN3cHR2XVvXu9+SxEmaq6kuJxX/FrzC/Ho6
	 mIad5u1YoWFPQA+x2WHTn/9x130Xlt3vxOJUtEDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 218/567] ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()
Date: Tue,  7 Mar 2023 17:59:14 +0100
Message-Id: <20230307165915.332942464@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit ffe4c0f0bfaa571a676a0e946d4a6a0607f94294 ]

commit d3268a40d4b19f ("ASoC: soc-compress.c: fix NULL dereference")
enables DPCM capture, but it should independent from playback.
This patch fixup it.

Fixes: d3268a40d4b1 ("ASoC: soc-compress.c: fix NULL dereference")
Link: https://lore.kernel.org/r/87tu0i6j7j.wl-kuninori.morimoto.gx@renesas.com
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/871qnkvo1s.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 2050728063a15..e352b06a7b7a3 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -590,7 +590,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
-- 
2.39.2



