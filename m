Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056577;
	b=g4phmSg+JQEDOIKc04aBP1j4UD8beB7gyjEeMca/1UiYpFXD2kOrlzCYXaZg1gPl4Bxv
	 CSgisLh4cr711LQ1CZnEm5vY67jIavF5C61NE62hJSNvC/fnefpjkiGojXBTTWWUY9ati
	 +rc4uhOX7BlrXxvw7bRzm2FmRzDujINq0y2nU7Zq4mVwIiBUUTAO4HeB5Ko4NM15NA3zf
	 mbXb7HKQbPFRI+t3U/DAK0cjngWSkPAwXgFFAxFzjCICNpDLbr6zFV3ZlTT3CIvD49ktV
	 +4mNBLnG7uZ4+fcJeg8l/6TkoVWZNKRxaeRZHjl5p2nSjMALZKFka78mcooK5Rn0IkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZkAxgotohyOzI/GYkcTngaq9x+7ZgwqLT/hXOGUDVaY=;
	b=phG6jkDiNYOpGxX+5j9FiqEjUKXu3Wd1Ti/FicpPurbuDooO5samliYrxTFEGnJPB5gx
	 Iyz3COlVlPKbglENNM+jQdftclvGmdFxTTgrAtX6SiZZ9/slbKXvp8W94IHww47ojt4XJ
	 nY3WIlVDNRscmzseHd9qM/MZc0/PiPPy9II4zN8evuq5VFfPTY9s3JAPc9uLkKkWPcDGW
	 MUm0zO0b1ye26sut93DkOr4jit3iMtdZULx35h7ZLm20cywf3soKWq/H2Rq/KzgPxxJti
	 joGfv2m/zT9NJiuGQgRR0UxdhRuRhsFOVD2rJvU7M6/2qiVgYbojKpn3C+kwX+5b/Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPLyek04;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72BA606A331;
	Thu, 19 Nov 2026 02:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPLyek04
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEB51F000C4;
	Thu, 19 Nov 2026 02:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056577;
	bh=ZkAxgotohyOzI/GYkcTngaq9x+7ZgwqLT/hXOGUDVaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPLyek04E95hCDgpSAWDWtgb4qN0uQ5dAJUKXiGb0D9L8HfcVq6Y6MCxjFhQz5oYY
	 XwzkwzA7WeoJe5+wluFIsv1FakhXgydhx6Wc85CMlHKhz31MXXOLQijpCY/+xrglTT
	 UemWMkDtTAIBGNQjUj0QsfHE/3skif4HnLWKtDLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1996/2214] ASoC: mediatek: mt8195: Fix HDMI TX startup error handling
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150130.649284793@linuxfoundation.org>
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
index e7cd6f38fdc4f..30244775a4433 100644
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



