Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056444;
	b=kEwCWM8/rV3eyE9+MmpIKhdob1VpWHstIiFQ3IbMNKe4XDEkn1bJQgUqMLKpmsT9jnXa
	 i0unYGLlUczUnkgK7/2fDzDbKomCj4Et4uL3Klhkggz95kCT/0Cw1pkBWOM6A0bs167fF
	 K8oQ5wNvmrjNEojFd/HiZ/LbQaQzYBRlrvA5iK7deZ7bwdWB3xPSQpBn6fThechVSuDBM
	 J9nrKLpvEYdEVAW691t2Ptor56FgU1T0Mdb53OZ1omj43dkSa7fTHoIIcuha9x9hY8899
	 aqmuFmMYCfCr1c/rhjT7it+wW68930jbnn6BFpsOXuKxv1EKp/Y9Z+EkN+IgMlBCDWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7Z5AjlH0Xds6CHGi+hQpt4XoJTVdpDt+xswQBDncmI=;
	b=IPTKWYqsEHiquDXK6zzQ93yDGPCVlN/ER2I6izk3a71Lqqs/uG55QjNUHzOLemf0ZmkQ
	 9dy9FeYbCe12t2ytdgI/dFwktkflR+28Cl61wqYUyuv/P0pIspUc+o/b+bgNVTjcq2UoD
	 a0b4suaFTwAzMinuutlpq0sYd4frIL7/v++7AigorTyr3Q4E+10QqRVuVnc5dhaW8dWSz
	 fp+V5DtxSrPaOxQisE1ekO28IzHs6ZD3Kj0etfu16puN9AmW6fsn55Ja3aVcM3gz5Z7N6
	 khW5aXnCcKQNc5yNRe3sM54gJ4IBEUpHOohSIOpSbfwbZXuQmVMQ8W/7cvULngoFh6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJ5OnipF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B43606A331;
	Thu, 19 Nov 2026 02:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJ5OnipF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2861F000C4;
	Thu, 19 Nov 2026 02:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056443;
	bh=d7Z5AjlH0Xds6CHGi+hQpt4XoJTVdpDt+xswQBDncmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJ5OnipFCmpYhRyGIIT7PNU60GbBm4HaJdPAGG3X3PGlZQbg8rmrsTZNU2wz9RxqB
	 sXSQvm1NLRguwt0/j8iktwq2tg11JlzGmk7V3QiblSOhdjIZkRXVkZIl2O46MbpAG0
	 g7TlpueVE0UHvuX1XcunyKRW27+4uCb2kRdJzS7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1988/2214] ASoC: mediatek: mt8195: Fix FE startup error handling
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150130.368390802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5ebc86ee8843..6dbecae658748 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -362,24 +362,38 @@ static int mt8195_afe_fe_startup(struct snd_pcm_substream *substream,
 	int id = asoc_rtd_to_cpu(rtd, 0)->id;
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



