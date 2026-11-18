Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041835;
	b=E/agTHWJ2u1SdcY8FFEXSNHFu9KORPLGFdBmC+Cl55HN1eM3pUNb73fWJoYaGlSKbBN1
	 x6yaTuXH8/9aZyq4kXQRxigGgNV0fHPcmGtnt59TOfK1wXDOHAXufVp7pXDi/dY/L0gp4
	 ArpdqbDaXW6yWhYu6aT8txrBT1au6mJlHnTk5bz0zvtGvAJhoOV2mo8mN19ZkWjZhnyyV
	 FI6V566eI/e9CDxB70MS1zlV7MuwUzUc6rtvSN8mx9Pn7eqpv82FNbrkYMnYen6lxprct
	 Mkeq6j3UdVPYU5z2Brk2yT8Ltonmy2o8e2Xor6P4/akANEey6Y9YotsHkNbHOOJLrnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0bfWlAjUuE6Uf6KDJKRIpw22uh31RpD5UCtrS9xW42c=;
	b=YaRGBaeGRLO3pWqJzd/ix7STZmebHhazR7H9qjCLYezxx26BII6qpin6FSqDJrC0ZBN7
	 Y/GEzLpYyj/dxMfYvaXoeKtSbhQKq9a4byZEUec7y2RxjxPVaCVhhOG4Sd85c0CzKN3Yv
	 pccWhVC976rSY8I5oZIikdoyUvM15Wtfk4wPrFftyfA0iB1aeegvWCJ56v1c9e8C/s8fi
	 3KDiiZtfgPsFZfeA3mX3iFZ1UYCdqp4/hAejeUgvQotmnG2Cp7o+baa8TSc8ve2TdUldy
	 8TdsOJHezD8mU6cmgTO3udFtyCyw719I9oifCJVrOx8dbYHoIdVHDFJY7g4PI5h33eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuyL+Ujg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B03606A320;
	Wed, 18 Nov 2026 22:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uuyL+Ujg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D281F000C4;
	Wed, 18 Nov 2026 22:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041835;
	bh=0bfWlAjUuE6Uf6KDJKRIpw22uh31RpD5UCtrS9xW42c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuyL+UjgkfBv3oDl/gWJKMEMQ46NNMz3OdAOG/klsUK598uqL/xLu8A7xceLNJ2Mo
	 fezv/97lkW2vUgsNGOJEQgbJcsCyqQfPtOGXZvTvLbaToNdnuSTMbUGfiicrbiCBb7
	 RQYm0CkUvQp5XkkAkoLEnIOwpYqHMTXEDTof2API=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2955/3318] ASoC: mediatek: mt8195: Fix FE startup error handling
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150448.956668665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d04dc96f0c6b8..602dcca21e336 100644
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



