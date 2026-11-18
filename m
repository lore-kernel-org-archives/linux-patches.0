Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055502;
	b=R3rQLpcH+4A/HSSHEffUxhDKMiAoH/7sbU2gvwKnlVJnmSMHbGH0hACtfz6RYJJ1KJH2
	 kUo8yleB1b6q52inBUNpftRqqAr8MccMeg/9MovD6GsCDNiUSWsF3i//lDWI8MdG5EhV2
	 YY5eOkdNMzYTvEZEXaLIf0zchFIqPI/QLsY1jywwuDSSqEEs3tAje5zO4n/FMIKuc+Bks
	 9waYl811736ZN+qHGB9rngkQmUH68iaEDR/3sXTcj86H/vUbT76SURlPKri6WbDw7T7ju
	 DNxYEbGOYvbZLw03i0sCfRZjyMjCt5BJYr/dNSK/6cSQpCDQnX7HAipuTq5u1dTeDkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HaNI4CByPfoI7PcyhkHsFg/49Zgmnpi/hfvxs2emlmY=;
	b=J6mjGtO8J8Zc2luhAEBDAo22lStvLlPfvmomxCoRwPJSAmn9QtZquT9Evb/v9N65cX0N
	 y1zpmQeZugstgOTUros5E6t6Jvm+i9gZ4q/G924IScGB/FtEppkKolV/7Vv9SOFzRHKP/
	 BWUMoxOL+m+N3vF4yjutebi6rg21p7K5uj8FhmCRg5K5qOnJ0Nmu5iHtUe0B1wTjUOVgA
	 1hoD98Ig4VFCMi3K5J8AW5nWWk4284Xad+ef5xK3+50svqqXiZa+f8IX2P+x13cRO4QjW
	 5qsN7fkALOKfp8KIYfdWRgKt7nFR/cGCdk+9j8B/fnUBnRr/etmMJH9WwrNnaSte6Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQHBAxHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00EC606A325;
	Thu, 19 Nov 2026 02:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQHBAxHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D51F000C4;
	Thu, 19 Nov 2026 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055501;
	bh=HaNI4CByPfoI7PcyhkHsFg/49Zgmnpi/hfvxs2emlmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQHBAxHn0f4uw5inWMPZ9CsQeuNq45I9iJqx6ITTlrtm/SHyzXStcmUYZd6WmNLgh
	 RvgYfnDvh1/ove4R1czTCRwN3Q2vBmPGCzOO17UflVo+p9sIK8B6n/YqRe4pynFWko
	 i8AGuaUtJ7YWrGWEQ5kOVc+EPoAEgRLZhO8J+3is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1655/2214] ASoC: mt8192: Remove function name log messages
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150118.094873158@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado via Alsa-devel <alsa-devel@alsa-project.org>

[ Upstream commit f147ca85d6ecaf65106d1650f3c2e8afacbc833f ]

There are some log messages in the mt8192 sound code that print the
function name, presumably to aid in tracing. However this can also be
achieved by ftrace and without spamming the console, so remove these
messages.

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/167874298172.26.17917791030607314817@mailman-core.alsa-project.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d6c8a0b5bf69 ("ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c              | 4 ----
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c              | 4 ----
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c              | 2 --
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c | 2 --
 4 files changed, 12 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index c26f68ec6040f..9b9a3465ddb52 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -216,8 +216,6 @@ int mt8192_afe_enable_clock(struct mtk_base_afe *afe)
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int ret;
 
-	dev_info(afe->dev, "%s()\n", __func__);
-
 	ret = clk_prepare_enable(afe_priv->clk[CLK_INFRA_SYS_AUDIO]);
 	if (ret) {
 		dev_err(afe->dev, "%s clk_prepare_enable %s fail %d\n",
@@ -296,8 +294,6 @@ void mt8192_afe_disable_clock(struct mtk_base_afe *afe)
 {
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 
-	dev_info(afe->dev, "%s()\n", __func__);
-
 	clk_disable_unprepare(afe_priv->clk[CLK_AFE]);
 	mt8192_set_audio_int_bus_parent(afe, CLK_CLK26M);
 	clk_disable_unprepare(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index dd325ce6aaa81..13e0ed6f11ba5 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2055,8 +2055,6 @@ static int mt8192_afe_runtime_suspend(struct device *dev)
 	unsigned int value;
 	int ret;
 
-	dev_info(afe->dev, "%s()\n", __func__);
-
 	if (!afe->regmap || afe_priv->pm_runtime_bypass_reg_ctl)
 		goto skip_regmap;
 
@@ -2097,8 +2095,6 @@ static int mt8192_afe_runtime_resume(struct device *dev)
 	struct mt8192_afe_private *afe_priv = afe->platform_priv;
 	int ret;
 
-	dev_info(afe->dev, "%s()\n", __func__);
-
 	ret = mt8192_afe_enable_clock(afe);
 	if (ret)
 		return ret;
diff --git a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
index dfb125ad37e65..e3a8273159d2f 100644
--- a/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-dai-tdm.c
@@ -762,8 +762,6 @@ int mt8192_dai_tdm_register(struct mtk_base_afe *afe)
 	struct mtk_afe_tdm_priv *tdm_priv;
 	struct mtk_base_afe_dai *dai;
 
-	dev_info(afe->dev, "%s()\n", __func__);
-
 	dai = devm_kzalloc(afe->dev, sizeof(*dai), GFP_KERNEL);
 	if (!dai)
 		return -ENOMEM;
diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index c1d225b498513..fca228ea781b3 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -142,8 +142,6 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 	int counter;
 	int mtkaif_calib_ok;
 
-	dev_info(afe->dev, "%s(), start\n", __func__);
-
 	pm_runtime_get_sync(afe->dev);
 	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
 	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
-- 
2.53.0



