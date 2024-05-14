Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948B12BEBD;
	Tue, 14 May 2024 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686854; cv=none; b=iVBNS5qZM2fVo7snGDr1U2zfXznLros6q1vZi2owjFk4m9lK3/F9GCxR39v+Lr5HFoRCUmF4x05aLeFgOlBqRXv3GL8V9jxwfDHWJfWyKJhud3HX0lCSALAY/Bg6U5PSxFioC3l4Ym9jmhE2taCC37v7akJx4B+H5Cgueb3yhWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686854; c=relaxed/simple;
	bh=fwAidzG+ZLNlJB4+nz/UvaTi8Vj7R16/D0/g/8fXhD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sucQsvG+0kqDOerJzAj3O5mnGynUN1pB2ywWOrw7BL28F8wl+R60fqwNqbbgTxHL7YbTQNfeSOZpT7wg2XWE1rZZyV4jWoKA2Y6fIhnVdeRohsJxtiAXkZaACxj9iPlIcQneg3Dbg6P00PB4d1XafMqheFGq9hfXj7ksMTEfL8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StWs6MZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StWs6MZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A2CC2BD10;
	Tue, 14 May 2024 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686854;
	bh=fwAidzG+ZLNlJB4+nz/UvaTi8Vj7R16/D0/g/8fXhD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StWs6MZpIocIiNqcGHe9YMMY+cz5Uv2tE7ME1yIBzATB4TXlE5TrkKnyG6oKbZ4jy
	 hHBOylIqsG9Wl7jw2j0wzv0TVjxgznepyfaVT1wVHlx+bc3NsTVIHu9V1E2fKLvR4h
	 aeMApL938IZ8gFwDLkTUYC6R2mpesCE+RwSwVo5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Shmidt <dimitrysh@google.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/63] ASoC: meson: axg-tdm-interface: Fix formatters in trigger"
Date: Tue, 14 May 2024 12:20:05 +0200
Message-ID: <20240514100949.679461983@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit c26830b6c5c534d273ce007eb33d5a2d2ad4e969 ]

This reverts commit bf5e4887eeddb48480568466536aa08ec7f179a5 because
the following and required commit e138233e56e9829e65b6293887063a1a3ccb2d68
causes the following system crash when using audio:
 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:282

Fixes: bf5e4887eeddb4848056846 ("ASoC: meson: axg-tdm-interface: manage formatters in trigger")
Reported-by: Dmitry Shmidt <dimitrysh@google.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20220421155725.2589089-1-narmstrong@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdm-interface.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/sound/soc/meson/axg-tdm-interface.c b/sound/soc/meson/axg-tdm-interface.c
index 05d63cd7ac8ba..2a7ea41fc49e5 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -343,29 +343,13 @@ static int axg_tdm_iface_hw_free(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int axg_tdm_iface_trigger(struct snd_pcm_substream *substream,
-				 int cmd,
+static int axg_tdm_iface_prepare(struct snd_pcm_substream *substream,
 				 struct snd_soc_dai *dai)
 {
-	struct axg_tdm_stream *ts =
-		snd_soc_dai_get_dma_data(dai, substream);
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		axg_tdm_stream_start(ts);
-		break;
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-	case SNDRV_PCM_TRIGGER_STOP:
-		axg_tdm_stream_stop(ts);
-		break;
-	default:
-		return -EINVAL;
-	}
+	struct axg_tdm_stream *ts = snd_soc_dai_get_dma_data(dai, substream);
 
-	return 0;
+	/* Force all attached formatters to update */
+	return axg_tdm_stream_reset(ts);
 }
 
 static int axg_tdm_iface_remove_dai(struct snd_soc_dai *dai)
@@ -405,8 +389,8 @@ static const struct snd_soc_dai_ops axg_tdm_iface_ops = {
 	.set_fmt	= axg_tdm_iface_set_fmt,
 	.startup	= axg_tdm_iface_startup,
 	.hw_params	= axg_tdm_iface_hw_params,
+	.prepare	= axg_tdm_iface_prepare,
 	.hw_free	= axg_tdm_iface_hw_free,
-	.trigger	= axg_tdm_iface_trigger,
 };
 
 /* TDM Backend DAIs */
-- 
2.43.0



