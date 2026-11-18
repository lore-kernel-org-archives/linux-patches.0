Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020564;
	b=MrPTGD+ImO4jNB60xwf7VEsAKANeKNSZ2dInnc7O4Z9cNvS/cZhHlcLA4y0FuornuoAt
	 PLCPrrM+7O0x+m8vMVvFeL/SsKJwY6pdsO78gljBRQ5475zvf+uIO3DnCJbrAPiiiDfaS
	 K2jd5pIaTilAJ4Fjj2PQ3HCw0lI0ghbmDG9l0/EK1sj74emLV2Z03Kk3QbjM3wLCFIYM7
	 dsF/uUTya/SJrSS0BPdH8dJZ+FowtTJsYLqKvAoGlENHMBKXDKhC/JjxSmiqkwUyP9r+2
	 1SdZB2KG7RvbAfLzsMrt0kOR5RzPY+HNLDrLJq2IhSA1lZsFok2GaQtOrasPmSawqLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zAY+9DHasRDdwLoYb9+NrR/xGyXp9RExjFz70gAw7Tw=;
	b=KqyfT/eBv2H9Ftt1cni+nLM6nkVTp+zGObstjn8bPIFRnFpDdzZ8PTVVPwOo4N07RK8T
	 RBd1xPRmOUiP9tTpKCspcKuZ+BALz7zmLYNHqvfN8MQd/zsG4H+UjnYzGAWXudvNOxP5c
	 IrYHV5J+vxwXDnC/2CRgnbp8nUowk0k4V6CvIAxHFuJZQnJ1e22sm7o4dAxkswrMmswa8
	 qtJd+12pQRVWVk3gycEB7C7vRIkvW5GXUM9+Nz5aZrXFNxta38RQj03r0KdEtg9dFUd4n
	 fI2mfsUgQAhuiVSEsJeJLUXREvmYA8Ci/RNKc3646bB0AirJP1ANJpQpkiPLQ98WZhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQEyxfb5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F93606A31C;
	Wed, 18 Nov 2026 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQEyxfb5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CF21F000C4;
	Wed, 18 Nov 2026 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020564;
	bh=zAY+9DHasRDdwLoYb9+NrR/xGyXp9RExjFz70gAw7Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQEyxfb5ysoptdDcWtrgGw6bf14+nU19RBJreE87RvQHvZjz4EEO2n7zUlRJ0aFRG
	 hocMTqefh++RiY+TGIFXW7WBO274cGb/d/XICXgLIwO+G5zrV9UK3pkZt1OUzkE4l3
	 Q6Uy97H3hnuxtS18QWGETYQUsmkH8pA9NocyBe+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1995/2651] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150358.160991903@linuxfoundation.org>
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

[ Upstream commit f18c0a8e528eb8844ee362324220ab8df3664afe ]

Check the return value of mt8195_afe_enable_clk() when enabling the
timing system clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller. In
mt8195_afe_enable_main_clock(), return the error instead of continuing
with AFE clock enable.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 0b56a3335d501..dad7dddd9f521 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -665,7 +665,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -676,13 +676,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 		MT8195_TOP_CG_26M_TIMING,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_array); i++)
 		mt8195_afe_enable_top_cg(afe, cg_array[i]);
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
-- 
2.53.0



