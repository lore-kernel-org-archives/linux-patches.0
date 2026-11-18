Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020572;
	b=H89V2RrJlfP3S2Adxn1gFoRkZJvoGJtgBCgBVOdnklutslygVVg7+VGVsEdUoHqRdfNx
	 Rf4zZTQ/Uc6VHrydeI4CTs5t42Vo4UXnnEGshf7gA+EiKdC2fZ2DnPqkIcFAgq5ktju4b
	 rdMhd123sWbjyFLyPg4KX6/N8f54+zWPYrZqWX7QGpY9IxNedXa6AYWZBGRYpujGoD2wu
	 mF5T9f2OCTsY7/FRbwg6gdkmeswwN+PJDWMsWVcQOF++iCOSemzMsBDLM9UiAH8m2WED1
	 5X/sTkQo2XuC4T1fM4gW40qRFvaQb+FheWtMMZjWnYCQ26EOLCLMokiGBA8baToihhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21ChMn6Q91vcXa4CE7SBOLX5fB0Koj0966KN73GApUA=;
	b=Es79o1sGsO5LOd+qZFySqytnhXlxhVDZAvnPo4E7jsKNx4sa1LUTiWdm8p0MNr+qsHYe
	 3ZcuYATXafZzIN615eaH54rwhrx2v/+pjjgWMkp3OaSYUQyiLLFl7tNNxCsRFnPhuDnO7
	 e4o8djtq8IC08MWGwJUR7KxAHePYyb6fDOi0bAi3oNl7NhYPzcnQPJDS83STB7lng5bK6
	 d0GiS3R8bku6jzFdj3TY+1s4BqEykQsXQhT6wz31MbRelMng0leinkYJDuxk62onx69uC
	 nxcHHro7GGwwVae4Y+z9Rj15iwQ1/UJDttPudlfn7brfdVlfONnHn29KTQYFcziVQyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QS3MOgY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E174606A330;
	Wed, 18 Nov 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0QS3MOgY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80EC1F000CA;
	Wed, 18 Nov 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020572;
	bh=21ChMn6Q91vcXa4CE7SBOLX5fB0Koj0966KN73GApUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QS3MOgYlib/3w6KT36LYUudQwYPaK/GIeb/VX7u+0lRRiGudec3Qv8VgbrSen6Yd
	 9hpdISFcBX2afbZZFR+2KnENPaObayyXBv+Egud2SLZJMNXs/n/RaXgrOsfgDa8oTg
	 jkDnHQ74LumvqI3cDMct13hEQ4oFwW8xMFPtg398=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1998/2651] ASoC: mediatek: mt8195: Fix FE startup error handling
Date: Wed, 18 Nov 2026 15:53:58 +0100
Message-ID: <20261118150358.254089833@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit b1db7408c8e0761d17b49b74f8f2d60c0c1929e8 ]

Check and propagate errors from paired memif clock preparation and
PCM hardware constraints during FE startup.

Unprepare the paired memif clocks and shut down the FE when a later
startup step fails to avoid leaving resources enabled on error.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 40 +++++++++++++++-------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 889f2df71fd3b..b3e01d2839765 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -364,24 +364,38 @@ static int mt8195_afe_fe_startup(struct snd_pcm_substream *substream,
 	int id = snd_soc_rtd_to_cpu(rtd, 0)->id;
 	int ret = 0;
 
-	mt8195_afe_paired_memif_clk_prepare(substream, dai, 1);
+	ret = mt8195_afe_paired_memif_clk_prepare(substream, dai, 1);
+	if (ret)
+		return ret;
 
 	ret = mtk_afe_fe_startup(substream, dai);
+	if (ret < 0)
+		goto err_clk_unprepare;
 
-	snd_pcm_hw_constraint_step(runtime, 0,
-				   SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
-				   MT8195_MEMIF_BUFFER_BYTES_ALIGN);
+	ret = snd_pcm_hw_constraint_step(runtime, 0,
+					 SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+					 MT8195_MEMIF_BUFFER_BYTES_ALIGN);
+	if (ret)
+		goto err_fe_shutdow;
+
+	if (id == MT8195_AFE_MEMIF_DL7) {
+		ret = snd_pcm_hw_constraint_minmax(runtime,
+						   SNDRV_PCM_HW_PARAM_PERIOD_SIZE,
+						   1,
+						   MT8195_MEMIF_DL7_MAX_PERIOD_SIZE);
+		if (ret < 0) {
+			dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
+			goto err_fe_shutdow;
+		}
+	}
 
-	if (id != MT8195_AFE_MEMIF_DL7)
-		goto out;
+	return 0;
+
+err_fe_shutdow:
+	mtk_afe_fe_shutdown(substream, dai);
+err_clk_unprepare:
+	mt8195_afe_paired_memif_clk_prepare(substream, dai, 0);
 
-	ret = snd_pcm_hw_constraint_minmax(runtime,
-					   SNDRV_PCM_HW_PARAM_PERIOD_SIZE,
-					   1,
-					   MT8195_MEMIF_DL7_MAX_PERIOD_SIZE);
-	if (ret < 0)
-		dev_dbg(afe->dev, "hw_constraint_minmax failed\n");
-out:
 	return ret;
 }
 
-- 
2.53.0



