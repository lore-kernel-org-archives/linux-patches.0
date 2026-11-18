Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027007;
	b=bOvr1ihuFDLvqyH6dH6X1LjuBp6Is2U34Ua5xReSU79cIV3sSE2J04YIWO8gFMCyWTV8
	 vLrbu2wuQUdyrTnXJyYJv5U6wC7cx2g+Q7TMg+vvOJIFRWh8yBV3dtv7zHNQT6FQtg6UA
	 iDm+kRFLXEA5xaDH4RmEZ6UpqRBIx2OCRN4F+SudHi1JG6OS06eSOibhl6B+m3AWdEJij
	 rBn4TSGxSznTwDOrvB53bwxRg9LO6KpmHru8SCPgvqoAtEgC1o4jUZmcgmHwrRND/PzRg
	 JtucMWOoA1PAXwjiK/GRJD1/De4/XAmbNVk7Al2OVMDiRA9MNO70GXoV2d80xT0oxuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XTW7krDmyEjYW9nrpMbWVlld/UwhE+CmnhEgQUxSRRc=;
	b=KV5Jh6ogGnsDlJOhq1IGl7D0VAbelLFG7Pz7NeESqO5iIuiBpa9cq9cDkvg3H8xl29Vc
	 46oLgCmyZ4yb5Y3kXprxMZ3NwLpz/mqOGsv5ObV6LHgincSezSZAtwarykBQKl8HiVXt7
	 nsh2W8XYeOpDb1Tc9rNXjpgeAvXmOa93pzdp9oqf7YRkT844WgdWiUU4MbZF0NM9zCj2e
	 OCVb784b6fIQzb/jfy+vdmBP6ua6qh7K7fcMV1Posasm+broelcx4YPfa7YMO+MnqQ+2K
	 A27Jzo18xzFW6GtVBNpXVLKgiH5oNrhYzTFakITtDXFqsyS+efkj0cFhnTIl8No2N6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKVNlMWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24A4606A32F;
	Wed, 18 Nov 2026 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKVNlMWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266661F000C4;
	Wed, 18 Nov 2026 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027007;
	bh=XTW7krDmyEjYW9nrpMbWVlld/UwhE+CmnhEgQUxSRRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKVNlMWLsRv40Rrs36V/VlMQC4qmHYPzwocTP8U+YkOwPPB01p4hiPksRU9TbrxCz
	 yOeL6rrq45vf0QYAkjhgziAqYPCHa9IUxBuFdlVHPOfe2Fn6yOg+saItTadZBbpgb1
	 uXZEoJLshRBXXR1SWlsEnYYv7OT2nyDNTniToegI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1636/2151] ASoC: mediatek: mt8195: Fix FE startup error handling
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150221.463341022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 91dd4b1b0aaba..5c4e40713fce6 100644
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



