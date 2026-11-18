Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032162;
	b=A2S528EsDz2+17X0A3LGIfC4eY45EgVDrR/OyvcDhq4Ce8DR4PgcaOs62xoGMYvzm67i
	 CeKBxBJmE+dOK7rps+bE2V1oo2QS+ZoZqKOLILOCJh4MX8mdMoJ7hqvY+NVnJTkuGe8wx
	 CQFiMAdcirQtUE32o75igeDid8SpkToeHndBZRL1SSTKLiGv5wz1aDuv0ma6kpvdAh3sK
	 G99xRNWzdu5lUPenqjJloMO72KDX1Y6urDSCvHI95mzuG9RslqEBfky6Q8MKHVtip7uBU
	 tiBcrKrPJqNH0ersifNfSGfXyJZtm/BFuVFLwNjSgLtqjxGNNJ4ICbonGxQs/Zlr2EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DRtptG8R3M90ihd5037oMoXcix7Mj5HqsX5oOCwniN8=;
	b=Q52Mhf02MGiXBcs01GLEUPEer8qbD9HoWgJOIohIyv5pN2Na/OM/c95XQFr6CyQVS9ei
	 Z98e964lIHylHgvADBX1EBvnInhCrG+c43xgIMBMroQD5GcYbKV1tqpqPs7cvNe7Y0tFc
	 daIJ5KxbbIwRJUlYuI0hnLw1r7+eMpGLXwLOeW+lAABdpV/p7++kgCheXIRRcquKDIksJ
	 l8vv5XfudiScCzqEztlUa2+7uzSsXDlmnH2EWFQzCZ4+9QTo7TiXBZuxUiEk3Xx28eJzA
	 opV1EyJmXyL6BPjGq05bbf1A/2eg1QXL1bvYvuAOBctYeMCs//PE2qHJo34dudX7mSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R83QAuIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488D606A31C;
	Wed, 18 Nov 2026 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R83QAuIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F01F000C4;
	Wed, 18 Nov 2026 20:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032162;
	bh=DRtptG8R3M90ihd5037oMoXcix7Mj5HqsX5oOCwniN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R83QAuIU2Q4Ew94y55d3F3pbI68Fz4f+B7ZGZZG2sNMNaXjYd2+d8OlIB1RH3Kvrr
	 jeOQQpcyX6JQS8tMyHdVFvPqDeNRexTFfEuonpGRFBGjzblqYcz7ssmar/WImawwKd
	 xAUY5DyuJDFIIj9aFRc4BshGEI4ZK/U5lLpQfXlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1313/1756] ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150101.737251330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 1d6f1785d90334b66809a57ebfc40a5b1cfa80ec ]

Check and propagate errors when enabling the clock gate and MCLK
during HDMI TX/DP TX startup.

If MCLK enabling fails, disable the clock gate that was already
enabled before returning the error.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-15-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index d6100a6aa7757..66f8468e534a8 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2326,13 +2326,25 @@ static int mtk_dai_hdmitx_dptx_startup(struct snd_pcm_substream *substream,
 	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int cg_id = mtk_dai_etdm_get_cg_id_by_dai_id(dai->id);
+	int ret;
 
-	if (cg_id >= 0)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[cg_id]);
+	if (cg_id >= 0) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[cg_id]);
+		if (ret)
+			return ret;
+	}
 
-	mtk_dai_etdm_enable_mclk(afe, dai->id);
+	ret = mtk_dai_etdm_enable_mclk(afe, dai->id);
+	if (ret)
+		goto err_disable_cg_clk;
 
 	return 0;
+
+err_disable_cg_clk:
+	if (cg_id >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[cg_id]);
+
+	return ret;
 }
 
 static void mtk_dai_hdmitx_dptx_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0



