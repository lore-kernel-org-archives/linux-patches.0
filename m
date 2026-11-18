Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056427;
	b=1pSUTTYuObj7ylkNYAIZj1rnlJrLGj2e0rpUHKnV2Bl325UYfsa6G3EuzpqWfLkjGEZH
	 jc14bLYK8u64Ka5lLDaXR87BJkPSLixINmY4EpcuK0xmG/6buBstCfhH7nxKZJf+Aq1Oc
	 CuJXaEobZn3VdPeneDB5d7OAKzdfo6kcCs+0XLOfciUK2Nc42UZimXX0WfDUfrnDgSwv/
	 /5OUBtWBJdMKaB9FPYxK7ginZJiMVOMvc9nOD/Q6JcGY0FBvoeUsYALxKiNYwXfo0Kiz7
	 +uqspPVYNQ0OCX71l8KG+tkIdP6mer35M91Bo3ksUvHSmghpp1ev4fGqSdJ6nkl+vDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H7GqZjgldm1fT/E9O1yVdaM1sa14vk/BafjRFypqZR0=;
	b=icAnF2LaTnTctYl+wHejrqv5nkKJIGkZa44d24L/CFz2m1+XG7jZKYDAkZJ/kxl9g1lR
	 QBiAVas+sMq2uSJdSc60NvSRd1YCJptJAMqxclgAWJAgn6cpUA/1AeIGVIz/NpfgbRkc5
	 G4IXHHYiFCRqW7iU55N/1KoCS3JhQxl3kmGif4LZW4BvVpReGbksaTZP86TGEI+3kX6RO
	 BUYwCevy9PUQRsC5WebYiebEdzTMdQMu8Kge6o7wx2PGHXyG7t9wp4PPV4cW63Z5E31VZ
	 m2WPeITrwwNoZqbS/hPPKxemyE3BL05b6vCFS5ztI3HS2rCaXt8NMzH3oobOpF9G+Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EorM7VyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DC3606A325;
	Thu, 19 Nov 2026 02:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EorM7VyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01351F000C4;
	Thu, 19 Nov 2026 02:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056427;
	bh=H7GqZjgldm1fT/E9O1yVdaM1sa14vk/BafjRFypqZR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EorM7VyK86eMOgRbrxBuTmEn2Vi0x0sSoPiHwmrGIhXMKR9rRrlMY93GXDSUG0Kys
	 lsqNlFXqrLZIIutFL2AYZA19S72rITxR2h9JrT/2yCHErVy+WNOo4OcWxcWoMt/LO/
	 lLGHcD2ZiLdrWTgrx6Qq60XrZLynkwXrOeQIZ6H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1983/2214] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150130.185827917@linuxfoundation.org>
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
index d311c5199f0b5..e5c90f4efde80 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -320,7 +320,7 @@ static int mt8195_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_SCP_ADSP_AUDIODSP, /* bus clock for infra */
 		MT8195_CLK_TOP_AUDIO_H_SEL, /* clock for ADSP bus */
@@ -332,10 +332,19 @@ int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
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



