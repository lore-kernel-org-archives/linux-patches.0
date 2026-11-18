Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032138;
	b=xKpMoxo9/Q+aWGl0qZivNmEmytjbMOgMl0D2vIP6A+f9GZoitwXB62sj8RP2qPQcEpr6
	 AKNmFLWKQHSX+ai1CXFjmsYg9aHm+Fq/oRANT+cq+Ecy/9sXygK4OvulAAaiOXXf2T/zz
	 Lblrz83pkkzFrnzNTaXHjaCWOtwJwRDWlsdi3uo3buxCUV3lRxYg3/3OaMzZ8Tp20n8Hl
	 dYonrDVkBuYT8yWbYA6wQn22/odPDGO1I79tybtX1aytgEAZNZzN3LjHi9/aXq/RkguIT
	 /xUkIfz19gMvd+767sNEh58FZG1m7o9Zq1X6ubkjsFvg+shJbbx8leKsrq6jEoXHpIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2G1MUY/KOdoh+fIcXtTKY211inH+f0RvKZA+fuSyyoQ=;
	b=Y7PUC7BP8ZFo+mpxISsjlnYZjbZeu3rNx7LjWTbcOlas1hMlJBBQyzfbjfSwjuHxAZgM
	 iJ3dK6JGZAXdGt5ts/yolplmaE31m6Ompvg8ZEnRajsBVvBbM4MUyhDpztH/1c0BfaRPL
	 hb9M9+ak94ZP53Mi9cbTyHkH6VMMuSdpNnGRa70tsGZ7AI60mYHwN16Izn96H67VCHzYr
	 b8pQGRQCngPIYpbAdSGBW4Sg6PeLaVqB/6uLMGG87DGAziZcKW3aAmGbrJHLaSEWmRNS4
	 ACDZMRbpkstjdaDmVvc2TYTAqldf9JCl8HEYdJKuI9dLDx0AN+MJZ87HVlGIDzD5/xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlA2D4X0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA656606A31C;
	Wed, 18 Nov 2026 20:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlA2D4X0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137E71F000C4;
	Wed, 18 Nov 2026 20:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032138;
	bh=2G1MUY/KOdoh+fIcXtTKY211inH+f0RvKZA+fuSyyoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlA2D4X0DYY49/M/FANdKyqa+1b8mM5MW2rbfayvOvEHuYiRsKzaidAPUEpMegCqS
	 kMctq7JJyW3yl2iVHFGG0aY+HCzzINk/Ak0KBVwZbu/bznIjgSyBuzYFJrawLeAgFl
	 8TzP/gadVQrKnb5ZkEvkc+q3ap1jkF9i0jaACohI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1306/1756] ASoC: mediatek: mt8195: Fix paired memif clock error handling
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150101.487170215@linuxfoundation.org>
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

[ Upstream commit c0ec135cf3fd7c7c7cdefd234111e5d4f069a7e6 ]

Check and propagate errors when preparing and enabling the paired
DL8/DL10 memif clocks.

If enabling the second clock fails, undo the clock that was already
prepared or enabled to keep the clock state balanced.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-7-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 24 ++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 8016bfb350150..a68113ced8ab9 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -286,15 +286,23 @@ mt8195_afe_paired_memif_clk_prepare(struct snd_pcm_substream *substream,
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int id = snd_soc_rtd_to_cpu(rtd, 0)->id;
 	int clk_id;
+	int ret;
 
 	if (id != MT8195_AFE_MEMIF_DL8 && id != MT8195_AFE_MEMIF_DL10)
 		return 0;
 
 	if (enable) {
 		clk_id = MT8195_CLK_AUD_MEMIF_DL10;
-		mt8195_afe_prepare_clk(afe, afe_priv->clk[clk_id]);
+		ret = mt8195_afe_prepare_clk(afe, afe_priv->clk[clk_id]);
+		if (ret)
+			return ret;
 		clk_id = MT8195_CLK_AUD_MEMIF_DL8;
-		mt8195_afe_prepare_clk(afe, afe_priv->clk[clk_id]);
+		ret = mt8195_afe_prepare_clk(afe, afe_priv->clk[clk_id]);
+		if (ret) {
+			clk_id = MT8195_CLK_AUD_MEMIF_DL10;
+			mt8195_afe_unprepare_clk(afe, afe_priv->clk[clk_id]);
+			return ret;
+		}
 	} else {
 		clk_id = MT8195_CLK_AUD_MEMIF_DL8;
 		mt8195_afe_unprepare_clk(afe, afe_priv->clk[clk_id]);
@@ -315,6 +323,7 @@ mt8195_afe_paired_memif_clk_enable(struct snd_pcm_substream *substream,
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int id = snd_soc_rtd_to_cpu(rtd, 0)->id;
 	int clk_id;
+	int ret;
 
 	if (id != MT8195_AFE_MEMIF_DL8 && id != MT8195_AFE_MEMIF_DL10)
 		return 0;
@@ -322,11 +331,18 @@ mt8195_afe_paired_memif_clk_enable(struct snd_pcm_substream *substream,
 	if (enable) {
 		/* DL8_DL10_MEM */
 		clk_id = MT8195_CLK_AUD_MEMIF_DL10;
-		mt8195_afe_enable_clk_atomic(afe, afe_priv->clk[clk_id]);
+		ret = mt8195_afe_enable_clk_atomic(afe, afe_priv->clk[clk_id]);
+		if (ret)
+			return ret;
 		udelay(1);
 		/* DL8_DL10_AGENT */
 		clk_id = MT8195_CLK_AUD_MEMIF_DL8;
-		mt8195_afe_enable_clk_atomic(afe, afe_priv->clk[clk_id]);
+		ret = mt8195_afe_enable_clk_atomic(afe, afe_priv->clk[clk_id]);
+		if (ret) {
+			clk_id = MT8195_CLK_AUD_MEMIF_DL10;
+			mt8195_afe_disable_clk_atomic(afe, afe_priv->clk[clk_id]);
+			return ret;
+		}
 	} else {
 		/* DL8_DL10_AGENT */
 		clk_id = MT8195_CLK_AUD_MEMIF_DL8;
-- 
2.53.0



