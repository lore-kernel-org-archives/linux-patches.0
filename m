Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026999;
	b=0mDd0vkk5sdsJZg2rn6tlWS7NiBVkkFemV4+dTFnEEz3KOUC0eQ9h+Kwmd+kK6NS0SxL
	 YX+VHAF3FWs49JUFBQFo//7HDN+h/b6N3EHZSYFY89ycfZQLFnfvEWUUPwUh08+Nf7e5H
	 /sN/pL3bBh1hhTxG4xFp24uLuJoOxrpcrW1Y7lKa9n8aWjuMimyP+75PThWtWWT9we+ar
	 Juf/H+ww5gZ6f2DIF2O7N+dkquS8uRzLjyoUVUrHGpkVUjhQNAnoZeHxpz09qYZTiDMNf
	 1Hvii4UI5E3DhOdD1EWJ+G7XQrRbCXpKjzsRbSBUut2ytslCwhE+50mLUxU2GUJbxxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iKRawXgCGK+fvHaoqF98Y3WuHy1bckMFkMI2qtBxXx8=;
	b=39oYaIO+u/uCqRvb95500KuErzP1gQnpnAe/1fCc/cMZR6sgtA1nYHQWmHUAm8BAHTaD
	 gED98ElhYa0NFOMrPYzY9GOMfFVYoQzyiqg+I7YQmRfGXC553X/IUoV0JJpJf0zgKdqRM
	 gqKJj5oLf4E5h9WUk9ScyJnKoTkqQADUisl9tetfKkWFmTzFrSSnYgQt2agO7EvgbSSSb
	 jb+yusz7a8QNaRqi/4JkSFZHZI1EzRFIcsISUwTzStEbDyyJmwWDrhi92pWPujJdbvS91
	 QX4Jp/eGynGKa2r+HW8yFLvY2MpJpiigpG7Pc6VmXGNsqYSzWtIScPYATjVDIcqAIGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8pSf4fm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DF3606A32A;
	Wed, 18 Nov 2026 18:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8pSf4fm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAB61F000C4;
	Wed, 18 Nov 2026 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026999;
	bh=iKRawXgCGK+fvHaoqF98Y3WuHy1bckMFkMI2qtBxXx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8pSf4fmw0oEOhvUDwajQv/ywOFHZRlDbkYDPiuv3qTjhr8lh4qX1zvPVy3gKL34U
	 1Y1rim9HNtGV52P6gpK4pJY9JjTeskpDR9JubispFco0Zn3VEJ3tr3WNeR1p2K5boB
	 ggn0+SmUcoIBB1P3QCzJNVzGRzpVf7lU+3aTcv2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1633/2151] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 15:56:08 +0100
Message-ID: <20261118150221.357426726@linuxfoundation.org>
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
index 9940e95b1dcd3..57c72f8407720 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -671,7 +671,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -682,13 +682,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
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



