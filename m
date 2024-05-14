Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC84433CC2;
	Tue, 14 May 2024 11:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687374; cv=none; b=FgCdYEWI4vVLHFL3sNbWinNlzfxLn7FOHXdbP4vVfF7N7Pd/mcpMWKqzKNg5Jd8MtqtXYv1WLaKyloimGz+Tdl7GNshurmbDockS6O3rBWjh6XpbssPtynIuOTQzZJUmIFPquSjxGdv3JrrrZdR825wr7Bg6z9mO1a6unJeJLwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687374; c=relaxed/simple;
	bh=5AOhhxlSwUcJ8dtbHHV2hZheMwMfwvHq9mehyFTI/vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQEmgfeAiGD68DfBNOzJFFmvOoDmPNrV1cArAABiv0ESqIVfCCFmwSFAUOJDfgukCPNxfPDW+z2eeaLv3UsnazOeLV0DaPgVRSVo72HIgpLmSCADzwT4pX32cfHlEkz25wmW3gqyLO3rLY1iivQo0EZvHDVAt3wG6Y1iPkQAbFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/IuWpFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/IuWpFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B3CC2BD10;
	Tue, 14 May 2024 11:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687374;
	bh=5AOhhxlSwUcJ8dtbHHV2hZheMwMfwvHq9mehyFTI/vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/IuWpFTDtKr4KGwQ/Tws7AQyoA1zVor+UIw2MWBKgBoizvy8dKJi05SM3R5BoLy5
	 hzb22cOuEURKwU6etrOJhlYvVffD7M+8v3zkSfD1aqVbjhDPqjwxfXXMP9fwryaonb
	 L5BbVHoXF0axHcyMcqN+b0BFaGbSP0nHuHCo8mF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Shmidt <dimitrysh@google.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/111] ASoC: meson: axg-tdm-interface: Fix formatters in trigger"
Date: Tue, 14 May 2024 12:20:12 +0200
Message-ID: <20240514100959.944310953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5145902360de..60d132ab1ab78 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -362,29 +362,13 @@ static int axg_tdm_iface_hw_free(struct snd_pcm_substream *substream,
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
@@ -424,8 +408,8 @@ static const struct snd_soc_dai_ops axg_tdm_iface_ops = {
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



