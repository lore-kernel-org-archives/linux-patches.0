Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048781;
	b=snLE2+ZqsZSBVpJYMI7IG9+/t7J9YBgGASl9+rcj6NAPPDjWxNDGTu66CNj2COk3KUZr
	 JvRbvm3fiNJhSmO9uWsmCUmr9iS9asBgeznyod7maNqVIQ8qArL074rClR7VTimrWH+3b
	 k9jCc1G+FRHnYLbCMxJSlVybgT3CWAcplRc6WWtBTbwjGfjoZmTy/dbLsCnTrHRlIfy7T
	 rrDqPUkSpac3NHw1U3hYo8UUHfKQs+gR2vejfqCnULG8CAPeKR5U+MbT8rKIBsGDQwB+s
	 KoxNCo99mLm0MvaaxhDL4l8prKBvWiiTBeHfoj9W7tTbUuNHh1BlWavuDT33DfByvgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eecbGLEl4F+wZkIPkU6jekzIO1erUaBWgqbL6NpU9f4=;
	b=WD/e0X1A6SLYYP39yEOAY1PqD8dU+4z/8p1vO2JkPHHql4TicLno/csR26+EMe7sk3zz
	 cgjujzQvLf629VQYgGSKlUPX3A6jX2dob3cqSd+tJdMCsujw5E4ho4HVcFtED6SImYqt6
	 Nefb5dpVu7Hv9zRaYKBA8VAygIURseV+u8Qximcbec452aTr4e+K7c75AIw5WUTkymdZf
	 9Lb2vf4Z5VcYwXrwrKdf/yQFHih/u2wMOUGwcQt9TT1aZV+GUNeblahO+sR+r5H9lzvab
	 CVYTv8BiDPYDfXOYdYLjm/0VN5EqgMQLwUr2f+H0goBl8flRnmZv5LX7R3g36JZQxtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfxJ8rec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F104B606A32A;
	Thu, 19 Nov 2026 00:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfxJ8rec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACBB1F000C5;
	Thu, 19 Nov 2026 00:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048780;
	bh=eecbGLEl4F+wZkIPkU6jekzIO1erUaBWgqbL6NpU9f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfxJ8recbNUEwBN0Yo5gpWWyyStZW3wGbYo4jgx+W6sPrSQpyjXgeWaB2qCjf7M3u
	 y+O93YeYI+1W5toFr2fJMCFXUR1jspdO4vZYsDnwQo5k/Sk8pCQH8F3P6a+gusRimq
	 Omut6IQyenebeuT0btFn+8avUscCXqspd3ruuYCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2115/2857] ASoC: mt8192: Remove function name log messages
Date: Wed, 18 Nov 2026 15:52:29 +0100
Message-ID: <20261118150317.562077816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 95b1ea63cc722..b324e82afd4c0 100644
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
index b93c3237ef2d6..6dedcc7aa68cb 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -161,8 +161,6 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 	int counter;
 	int mtkaif_calib_ok;
 
-	dev_info(afe->dev, "%s(), start\n", __func__);
-
 	pm_runtime_get_sync(afe->dev);
 	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
 	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
-- 
2.53.0



