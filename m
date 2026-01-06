Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C7352FB6;
	Tue,  6 Jan 2026 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721488; cv=none; b=iapTCECnEdpvc7r+B+NsRz9zUSnKCU4lzvP1pqdwezL2llW/PftWulBFw1MqRcU0541gIIE0YRp4HdJE1BTEfYdDanvpFMsqUjd8G2bIbaBu9PVwp4z9ly4DOunb6MtXd+iW7Ik2snDEj2zyO1kdtNwTcZXQ1avK37Wi3DnhTaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721488; c=relaxed/simple;
	bh=3opyZ+hVVVMN+f3pKd7dXCcp1i8teKGhR1AEuG4+ukM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ+G2L5yqewpsGKQUu9aHyVYgi6lj9CE1bdxl7Mdj76uklTKxH9SeVNnmsOYsGPfV9zNIZNFRz63rw2aJyu0xh+XHkwKzi/7L4FgNCXbJCkTUzlUk2M+eP804/tJnb8ZTrFOTFoBN53QTqNVSQPCrCRpYKXjr5rpzM5+Hm9GYrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0F+Fo8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0F+Fo8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F75C116C6;
	Tue,  6 Jan 2026 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721488;
	bh=3opyZ+hVVVMN+f3pKd7dXCcp1i8teKGhR1AEuG4+ukM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0F+Fo8JEjBSV8peph/pUvSqW7MdnQBT711cV7j4gFmxfeYK/uFX/ex7s8zEYaNEb
	 cYreKrQVhJ+ERGgaCQoL7XSjAHac8d3ZsoKZ5uAKi/Hmh53PG0Ln2lRb3dXGxzN2hu
	 KF0e3LCebuIduItnKNvAbHrNthkPRE4FBGpSxf2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 551/567] ASoC: renesas: rz-ssi: Fix rz_ssi_priv::hw_params_cache::sample_width
Date: Tue,  6 Jan 2026 18:05:33 +0100
Message-ID: <20260106170511.795959568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 2bae7beda19f3b2dc6ab2062c94df19c27923712 ]

The strm->sample_width is not filled during rz_ssi_dai_hw_params(). This
wrong value is used for caching sample_width in struct hw_params_cache.
Fix this issue by replacing 'strm->sample_width'->'params_width(params)'
in rz_ssi_dai_hw_params(). After this drop the variable sample_width
from struct rz_ssi_stream as it is unused.

Cc: stable@kernel.org
Fixes: 4f8cd05a4305 ("ASoC: sh: rz-ssi: Add full duplex support")
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251114073709.4376-3-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sh/rz-ssi.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
+#include <sound/pcm_params.h>
 #include <sound/soc.h>
 
 /* REGISTER OFFSET */
@@ -85,7 +86,6 @@ struct rz_ssi_stream {
 	int fifo_sample_size;	/* sample capacity of SSI FIFO */
 	int dma_buffer_pos;	/* The address for the next DMA descriptor */
 	int period_counter;	/* for keeping track of periods transferred */
-	int sample_width;
 	int buffer_pos;		/* current frame position in the buffer */
 	int running;		/* 0=stopped, 1=running */
 
@@ -231,10 +231,7 @@ static inline bool rz_ssi_is_stream_runn
 static void rz_ssi_stream_init(struct rz_ssi_stream *strm,
 			       struct snd_pcm_substream *substream)
 {
-	struct snd_pcm_runtime *runtime = substream->runtime;
-
 	rz_ssi_set_substream(strm, substream);
-	strm->sample_width = samples_to_bytes(runtime, 1);
 	strm->dma_buffer_pos = 0;
 	strm->period_counter = 0;
 	strm->buffer_pos = 0;
@@ -960,9 +957,9 @@ static int rz_ssi_dai_hw_params(struct s
 				struct snd_soc_dai *dai)
 {
 	struct rz_ssi_priv *ssi = snd_soc_dai_get_drvdata(dai);
-	struct rz_ssi_stream *strm = rz_ssi_stream_get(ssi, substream);
 	unsigned int sample_bits = hw_param_interval(params,
 					SNDRV_PCM_HW_PARAM_SAMPLE_BITS)->min;
+	unsigned int sample_width = params_width(params);
 	unsigned int channels = params_channels(params);
 	unsigned int rate = params_rate(params);
 
@@ -980,16 +977,14 @@ static int rz_ssi_dai_hw_params(struct s
 
 	if (rz_ssi_is_stream_running(&ssi->playback) ||
 	    rz_ssi_is_stream_running(&ssi->capture)) {
-		if (rz_ssi_is_valid_hw_params(ssi, rate, channels,
-					      strm->sample_width, sample_bits))
+		if (rz_ssi_is_valid_hw_params(ssi, rate, channels, sample_width, sample_bits))
 			return 0;
 
 		dev_err(ssi->dev, "Full duplex needs same HW params\n");
 		return -EINVAL;
 	}
 
-	rz_ssi_cache_hw_params(ssi, rate, channels, strm->sample_width,
-			       sample_bits);
+	rz_ssi_cache_hw_params(ssi, rate, channels, sample_width, sample_bits);
 
 	return rz_ssi_clk_setup(ssi, rate, channels);
 }


