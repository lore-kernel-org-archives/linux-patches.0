Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020559;
	b=2vJEGfqZjb6V37Vrj5yf6CGlBBjeXfZxGEaQSioEU8OiicoyuvZkYDqvY26mVLb/fa0i
	 YRkKrRpMrw46o54kKows0b9uKwessc1w4hf6nldGW7WkXWlcL72/4CjuEDHaRVoSxyjAE
	 W1j5rJPh82lx721zoMV8FPYz/FhKLYBwrAiGU/8/gR0c5vb2xTxddFCM2Y37QXP1BRocz
	 1qfQ0cE5Wh7VE94iREsHEk5ULpsGpZN8fvx/QcQm4SPVno6oWiMpDxACViPaYFrVClM7K
	 FIVa1uY4Nckmbin3QexxVGM3wUy9kXk8p5s17CpEpFJU+U6/0p9Jt3wt56eqWx2Yy+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jEVW2mDmpk5oKHE+zSHeobJWi5VsIobFlfov+RKYvtM=;
	b=FOCu12GbItGN9xnSywD5FdnkvSAC/i+kj65IQYO6zJ0YWKx2joCyKbg8uG1Huawu36qM
	 F7d5uRnysLU7VH3wpLyo9K79xNOQiephwxMzLNquryk9v8VqSOtXjdyGHFrE0/I12bgy4
	 ckMh6VTuIw7uwxTsqTR0UxMPvAaKle05gJfKXrjFbENvFfDz63/a39kGZY/UzRox0OCMF
	 oqTygs7+3sNRsW5wTasY1TWVYSKqIhptCB6thXgISGkhFBz6uy0k1ht1un0N1+AkTQFrN
	 IjLuUavZm/sS7fypee1xQqiwJYS5aHAIfCKKTypT4CWzmEUSPCMVIfFSV3MhVULgXWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrjdeMsv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FF0606A31C;
	Wed, 18 Nov 2026 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CrjdeMsv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68B11F000C5;
	Wed, 18 Nov 2026 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020558;
	bh=jEVW2mDmpk5oKHE+zSHeobJWi5VsIobFlfov+RKYvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrjdeMsvBD47QDvWr5sdqf3zWvmPhE/FK3dUNjNLnF8Jk6Df267W74aANn1gZhl5d
	 vYBQdmp/mWssCguAvPOC0hkqbz/o7+58HkFCtXcsUEBHLNBebemtbm7XibkoeH85vX
	 tYiL9AR9zkzbfqk+XXwJgfPZC3y3DoDNRXMPqTEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1994/2651] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 15:53:54 +0100
Message-ID: <20261118150358.132044705@linuxfoundation.org>
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

[ Upstream commit c23390ecf5c068976f25d9c8bfa8e298fa12ea3d ]

Check the return value of mt8195_afe_enable_clk() when enabling the
register access clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index ec1ea5b988ffc..0b56a3335d501 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -602,7 +602,7 @@ static int mt8195_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_SCP_ADSP_AUDIODSP, /* bus clock for infra */
 		MT8195_CLK_TOP_AUDIO_H_SEL, /* clock for ADSP bus */
@@ -614,10 +614,19 @@ int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 		MT8195_CLK_AUD_A1SYS, /* AFE HW clock */
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 int mt8195_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
-- 
2.53.0



