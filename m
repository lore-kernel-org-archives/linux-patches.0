Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049991;
	b=UgvLgJL7N2pogvhLFqppvavSgI6G8JLvY1LBmxGmRylLVkLW3INmKrTjSG6Be5RSHvTC
	 m5gyl1qTfNiXEbE2WGrqkSCnq9eCy/6B1+ccy0SoPudQlLkeBS+tR6olct+0JctO5Rwk0
	 ZHY/2Y4H1lJHWR62w7Z9hfOkltnwc5cunshlZXjdvUlnxBJ2n9j/mbt17N5KD9xbX+p6Y
	 0lpPzq9dv5IcjgBBWpqttQ99ypWIn2iwvhsljnQlssmo7DCeX58Z5T74QQgD9oUpa8aVa
	 SY+yPeBhTjeeEcT9e+udQQT8+aRj22ojXl4XtnloTrVlJVOhZ1onuQ7P+C6DgItoJHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSJK6/uQRiM1xFeFzC/demGmZXfKuet6S0I4D9CDHwc=;
	b=JqtH+c6TEmzvVhnZKsPiindldDfNibF9aQG4zveRYJd5j9LToHaKhQVYajyTYtxFd4dQ
	 XTuTIUnSqkt1MwC0J+2M7iloSNhU+v5qWUo+9hlM/dAMMr06k+KOoB2tmrR8aiRngZakO
	 j/D9R+bGZDnuBvRZKaVQ460RkSmNqUrN7diyIRKSqqV/XyS0ZUG99W3jp5QePw29+PCw1
	 0KZX/SdVFFPfaaEeFyvxdpBPgnRJcd0gKKVr+sYPHHbkHCl6LHFVRPWuz7o3o0Iafs/Rj
	 n3uHa7O1q0B5yCpnUIrEDb8gbCqv72fb61ntTaIuVmlxXnhEhPlQLE6Jjz3OZYqGhiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rf+J62M/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD835606A32C;
	Thu, 19 Nov 2026 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rf+J62M/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2551F000C4;
	Thu, 19 Nov 2026 00:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049991;
	bh=PSJK6/uQRiM1xFeFzC/demGmZXfKuet6S0I4D9CDHwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rf+J62M/S8YZdfS5pLKil4BMhF7epuuZcTjVM8qIndqZVUEEjZJFvIkd80uSriJCR
	 bbwPahAfVAUzV9CarBUSH7jzQNR6MFXQocjMdYJ+NuItOAecNVDfbhQ+k6/Dx8QOqp
	 DK6vYBZX5oJ3RVk9bWVwCN8BAIPBh8metrVNPvZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2550/2857] ASoC: mediatek: mt8195: Fix FE startup error handling
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118150333.331083034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d062a84a46af8..5db4cd4743a2e 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -364,24 +364,38 @@ static int mt8195_afe_fe_startup(struct snd_pcm_substream *substream,
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



