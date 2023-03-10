Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16A847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2F0C433EF;
	Fri, 10 Mar 2023 13:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456041;
	bh=7d8wbGskQghxoGa947+yfi4u1m4w196vyZcrgDbQh90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nQRhFZqV7FBBS/LtB0YP7NdbCQ5cvBoF/vvIu8uGJEpT9pF585ZfWbO/L/XoRsMJ
	 MX8AqHD7YZuzZpH+Ox5oTzwyp4kOZXSt3ImTUJjr5MDSBox/+qja0IqJrSq3CtQ3ZY
	 X3nYB985fQewJRs/9m+TcDTjcjTTNM6ApSsgDxxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/193] ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()
Date: Fri, 10 Mar 2023 14:37:22 +0100
Message-Id: <20230310133713.027305284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
index 2cb8d3b55fbc2..c00f21dbcf11d 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -788,7 +788,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
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



