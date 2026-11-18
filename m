Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020555;
	b=ZuO1+MzcpKCGawgGhzaOaJWm0oOacbnQ3O1u5vwQwKX3d4mb5pF6gglNJVM1pKqbjUX8
	 vE7BKAtNFRoTi5Nvh3Z4W18351c04J7W/P6HwS/5WfVvUm3swdyrNZJXS5Uv5qoRNjdXU
	 U5YmZpswy9UY09rvIFEk0yGDrCuyWT3yZn9wiGf2zuhEJOG7K/LqQqHSQey59PsEMs4FX
	 0ApsEWlCiJPH8pS7JTxpJDt+HDrP301m/7m12G8h7KvZ9yYj/I2N8X3Ip9jqzulgCSmfO
	 XIndpInrjnOFYOVUeGWX5KrmDUf4rsa1O6h+RNt5/3Cju/kXbFGHGFoNCS0VH9bd5gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CI9hfYm4OlH4r16Q3j0waDMR4OV5rIRo3jmLC6m0xOU=;
	b=BWemM5f8qFylTzdc9cLDUAvYmZT4SXz8vZB5FiSss7sj6vUMfaONZyGCTlItCscG0GHA
	 ouABiEFPBd0eYZ0LIm8ORMWZqMJXtqAl1NVVYuJNxujWu3WtwSjZwUjp8a/o5duI7t0D8
	 QI+DU2ZcdyJ6s42Dg2Z/dlckHCRqH4JnCEKvlmsop+IlVEHVRHBiqHqdwBrxC6Yql3WNm
	 s+j+QqBJk24JwxcuJ3v00fAcEHj6ppUb6MI6TV5p7vgqxpaJRn+rodsfgXmBXDEPcT9+X
	 jd2efQBXY6M4wP7B3pM7j2txk41p/aXzhoLEUxN5pwAK1shehRVxwqsKu6GmfVdI1ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0juDYbS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAF8606A333;
	Wed, 18 Nov 2026 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0juDYbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A101F000C6;
	Wed, 18 Nov 2026 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020555;
	bh=CI9hfYm4OlH4r16Q3j0waDMR4OV5rIRo3jmLC6m0xOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0juDYbSIxCsZvKkEmQ+PeTwDtSyeXSA4//t9vzOeXaF1sQxiHcC203pFcDHWfr2Q
	 QTOxBvHPXyO0xaibkXMNzXIvOkNqr/ThzIaJM07FOBo05Dm71cl4WzYF4/cnKDVw44
	 t66WP+TSJaEV3Hk8WOkgIkrsIgmd3lGbAgbtD8hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1993/2651] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 15:53:53 +0100
Message-ID: <20261118150358.100228802@linuxfoundation.org>
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

[ Upstream commit 8e5a2eabb0d7cbd6db0b94f7f30e1ca2c0a8994f ]

Check and propagate errors from mt8195_afe_enable_clk(). If enabling
the tuner clock fails, disable the previously enabled APLL clock.

Fixes: ff5a90173d98 ("ASoC: mediatek: mt8195: enable apll tuner")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 24 +++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 618d8400913a3..ec1ea5b988ffc 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -241,21 +241,35 @@ static int mt8195_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8195_AUD_PLL1:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8195_AUD_PLL2:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mt8195_afe_disable_tuner_clk(struct mtk_base_afe *afe,
-- 
2.53.0



