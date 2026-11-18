Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016449;
	b=K8CZTr8DqsAMs2GyyxK4CbAZZHztsKMuRnzFStru7iICbLG4MNiFsIQ8LrtsofJDIo9Z
	 uJsFzs8cZG5u5jYxXbcCgdZhu556X+6V16DRq6PbmiK3sz4PVS76RouDmXZzH0seqtjyh
	 sToDUTrK/aMP6kwmRy6Su8EgQsz6hAg0BzvE3dHjSGZvRGuQLdDBXL4uZMw8omEZs8Kjw
	 sG/+jtb4uPpuQ4JPh62goC+hrqIQ11MY029cuRPqS1nALtKS1t7KIsJqVkmBPRaDp452y
	 x8PlULg/4ykNgrzpveqwDD4F4CtWjoOEre4NAx09fCri+4rzFpSvLH8VEcQHfZWL7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4UvoBXpgd9hv4bPCCSNT4Peiln9+GjAhCOd58V9qHE=;
	b=yyZpCypIRIMyJXA+OPjJH+nEdTJDKCVwcFTxm/O8TEr2Mc0dnLJt1uEmGLL4lekJhCR3
	 CozADvzPMdJytQPdMyGrzXmbXVhHH2ciRR+1RE2SYkjFLoLRK7dimvULwUVefJR97DjgB
	 u3zjXtWocbUuRzRO6RJcVvkIkvgkHDOQglFIrNxPSTKcxhnxfgczT+dCYByt3ZP+ZyHve
	 fJLxX8TsFbSX0Uk3R0IfIIeAVd/0lZHeQJo0LsH+1x2H0pjgnkqEenlygHmft1WIK/xZt
	 /udPIh6MMFA/+0ebbPqEIurt84rVdyRK8ZG0wR1SKEvDAr0pivcdKEElZILzna/yksg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DeHAq3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70757606A320;
	Wed, 18 Nov 2026 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DeHAq3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B51F000C4;
	Wed, 18 Nov 2026 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016449;
	bh=P4UvoBXpgd9hv4bPCCSNT4Peiln9+GjAhCOd58V9qHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DeHAq3RxlYqjh6I9kuO1WZLXkRx2N9EFbnTO95lD0ZEqO941ll2iacQDLWDa0Vw5
	 IW+ux3v9LyhqTIF809vIBt59gLLqqrbwRoVTaU2b2WAO57Ky/fPEgIza3xkKixNNc6
	 lt+EKoeh2lyQJMBstvMqmUBcE877fu3RuvnxIrzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0533/2651] ASoC: mediatek: mt8189: Propagate TDM clock errors
Date: Wed, 18 Nov 2026 15:29:33 +0100
Message-ID: <20261118150306.952131239@linuxfoundation.org>
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

[ Upstream commit 242d0280eabba05c085a51ad0a9c9a7a3afa7b03 ]

mtk_tdm_bck_en_event() and mtk_tdm_mck_en_event() currently ignore
errors returned by the MCK enable and disable functions.

Propagate these errors.

Fixes: 9f202872ba04 ("ASoC: mediatek: mt8189: support TDM in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260916050020.14575-12-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-dai-tdm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c b/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
index 5d68a55ccc45c..9aebd0320614e 100644
--- a/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
+++ b/sound/soc/mediatek/mt8189/mt8189-dai-tdm.c
@@ -261,22 +261,24 @@ static int mtk_tdm_bck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8189_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x, dai_id %d, bck: %d\n",
 		w->name, event, dai_id, tdm_priv->bck_rate);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8189_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
+		ret = mt8189_mck_enable(afe, tdm_priv->bck_id, tdm_priv->bck_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
-		mt8189_mck_disable(afe, tdm_priv->bck_id);
+		ret = mt8189_mck_disable(afe, tdm_priv->bck_id);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
@@ -288,23 +290,25 @@ static int mtk_tdm_mck_en_event(struct snd_soc_dapm_widget *w,
 	struct mt8189_afe_private *afe_priv = afe->platform_priv;
 	int dai_id = get_tdm_id_by_name(w->name);
 	struct mtk_afe_tdm_priv *tdm_priv = afe_priv->dai_priv[dai_id];
+	int ret;
 
 	dev_dbg(cmpnt->dev, "name %s, event 0x%x, dai_id %d, mclk %d\n",
 		w->name, event, dai_id, tdm_priv->mclk_rate);
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
-		mt8189_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
+		ret = mt8189_mck_enable(afe, tdm_priv->mclk_id, tdm_priv->mclk_rate);
 		break;
 	case SND_SOC_DAPM_POST_PMD:
 		tdm_priv->mclk_rate = 0;
-		mt8189_mck_disable(afe, tdm_priv->mclk_id);
+		ret = mt8189_mck_disable(afe, tdm_priv->mclk_id);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct snd_soc_dapm_widget mtk_dai_tdm_widgets[] = {
-- 
2.53.0



