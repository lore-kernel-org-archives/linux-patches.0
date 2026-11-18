Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026994;
	b=t2dlKTN8+O/dSeBV7FOpuWxhhsWzmDvEyKGqPEe3pQEFn4Q6Tc0DBpj0RYjANVfbVVAF
	 n2TdDkTpMld1Z/TxEET0otDwT0+fGhRyfp4a7o+0jX9ya69jRxM+pVsaMH07/+l44F0pE
	 2VHYr4GGtg6Lwccy/GAHNC34kVDusOp2mlS/uhRGZLUd0tz1w3G/RZYRfBxFdtyfwJbtY
	 Tn8rr2RgWUGmkERlq1lOu59j30otICOcBOyGQ2dmulqq2fP7UlKqQjXS21tDUGBx1nLI+
	 AiD+3pCmCGeHmihJxqNNqjLTBMi5lszTJCeL/lvHg9SSCD4VCf4tqNOKNgFjZWkXftA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CFK/KpKEZOgepPXNLWygToDserJEVKm7kTAGyw0sy+U=;
	b=x5k4jhQFx+qILLCevTM3yMxCvo0oNBB8yuGJSulGiv42KRbUQbejNapeyLvdPH9m1WOS
	 os7bKlFAJ9kboOrXTybmWklJy6tsQwFScOEK19ZDHIiaYhvsua23hDhLwJqQ9fC9LYo1H
	 cWGoYSgUVKHysgpmtsY/t/Vk0uSNvPxSGq5U9NgspA2Ne05z+cIBr4fqf4mbtlYEgFz5g
	 Hyh7fG3EfPgyxyqR6A1VxJy+JgInSW5c0b1C664AVZ0tw4wb6QnGteRX4h9ceqbY4oxoO
	 YsycV9f3JpqzZdHlkOwo6z1APaXUMEks/dgzr0UGYLSUBqbDycLkfG7eFDY3bp6s0bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz6vjc8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306F606A31C;
	Wed, 18 Nov 2026 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cz6vjc8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FAE1F000C4;
	Wed, 18 Nov 2026 18:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026994;
	bh=CFK/KpKEZOgepPXNLWygToDserJEVKm7kTAGyw0sy+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz6vjc8GR7G+wTobGXJa6b1dmXEIfRjdDCG0NXIW83JdDP424oCaskyXE663fsKxk
	 J+Qc7KyNTcm2Mixo5VD7Rm0LP4z26Xv8ttMTZVAR3J038GyrAYkh7AsPcyjL1BEm7p
	 ojkGtvc7kJnwquCHv4FZD1jlEHhawtruRI1LZhUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1631/2151] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150221.287304112@linuxfoundation.org>
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
index f35318ae07392..5d4ba88ceaef1 100644
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



