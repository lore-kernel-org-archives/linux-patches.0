Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055507;
	b=nHHHM5AWrsOhz2N5iozJXe6W6lbeui+0C/skTmoSHwO7AZmsAHdtL0fQlna3Vm01N3XC
	 A/U6Ui7ovgdQKx1/djUfNJGVWcew4K6XouBu52TiXMOR0uNA4OxbtudQAQVQtuq4yVPc3
	 T3bsW9ZkUeqiknCHEGERi7867K45Dpr+zV6/Aly/KM2YjOblq6a7R7TlBLTdsneiKOqJr
	 J9NreEgdt3rmwykkxcIgvb5ZF4coDLMd5wvjdfbAuggux/M/BmX5S7sOTIYfXIUsfUHbv
	 RDkp3volMOxrIpVlDdg8MXCvQcRZgxhryoUV6/uo99vbuaA4WgU0PP68XvaqWkdU8tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qe8zqfmS6t6mNCUd0TZ6q42S6U3M6XFWooTLDL9dx/A=;
	b=QNTtzMPDWnhMWmgUVbUpJD/GpNbHuvA0XHo/nLiD5AABWaMSlpO6pgHphKDF9AjBY4XW
	 OCQ5gt9Z3Ugzyl5UZTrDT/NFSSgtHYxOALIFZBtVlFIXmuiFO3aBtA2iXVTY1PnY7xhi9
	 VytN1EXuwgWsF6inARNiQFRHtcJkdJgk8aM/l++RYk8H6VsY1wX5mAfmza5709GGoQmIX
	 tqdClbfdVyxoVpHpjIbkc8h8PSVUGpByJeS+831nsEgaR0G6J0fLJ8iDua/Jqx2UaEVKf
	 h3SgwFR/Sizl1upD8eUhN6xmhrNcDSELTrw5pf4CWMl8XAXN09OgRzTTk/8wCKeQ0cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5ywskDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C560A606A335;
	Thu, 19 Nov 2026 02:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5ywskDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B581F000C4;
	Thu, 19 Nov 2026 02:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055507;
	bh=qe8zqfmS6t6mNCUd0TZ6q42S6U3M6XFWooTLDL9dx/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5ywskDSKjJ2teOt7wjm8K1+18/qrs/T6rrMA+J3mbxlt/BCfHn/Zu1eJmepiacsx
	 Tq4BeYReM1N3bkWZ681yxn3jRk6O96PTeT5sR/EztGDBXDjGGw2wIbwHQHyu1IgKHf
	 EgWpxTrkSby5wXHSMUpFVOJ4XaG8bG2PMiOsfdsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1656/2214] ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibration
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150118.134654924@linuxfoundation.org>
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

[ Upstream commit d6c8a0b5bf696d89350e43bf554362de8929f801 ]

mt8192_mt6359_mtkaif_calibration() ignored the return values of
pm_runtime_get_sync() and mt8192_afe_gpio_request(), which could
leave PM runtime references or GPIO state unbalanced on failure.

Switch to pm_runtime_resume_and_get(), check each GPIO request,
and unwind on error.

Fixes: 18b13ff23fab ("ASoC: mediatek: mt8192: add machine driver with mt6359, rt1015 and rt5682")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-16-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mt8192/mt8192-mt6359-rt1015-rt5682.c      | 37 +++++++++++++------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index fca228ea781b3..6cf0dce4d5a72 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -141,12 +141,23 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 	int chosen_phase_1, chosen_phase_2, chosen_phase_3;
 	int counter;
 	int mtkaif_calib_ok;
+	int ret = 0;
 
-	pm_runtime_get_sync(afe->dev);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 1);
-	mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 0);
+	ret = pm_runtime_resume_and_get(afe->dev);
+	if (ret < 0)
+		return ret;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 1);
+	if (ret)
+		goto err_pm_put;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA, 0);
+	if (ret)
+		goto err_disable_adda_1;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 1);
+	if (ret)
+		goto err_disable_adda_0;
+	ret = mt8192_afe_gpio_request(afe->dev, true, MT8192_DAI_ADDA_CH34, 0);
+	if (ret)
+		goto err_disable_adda_ch34_1;
 
 	mt6359_mtkaif_calibration_enable(cmpnt_codec);
 
@@ -267,10 +278,14 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 
 	mt6359_mtkaif_calibration_disable(cmpnt_codec);
 
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 1);
 	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 0);
+err_disable_adda_ch34_1:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA_CH34, 1);
+err_disable_adda_0:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 0);
+err_disable_adda_1:
+	mt8192_afe_gpio_request(afe->dev, false, MT8192_DAI_ADDA, 1);
+err_pm_put:
 	pm_runtime_put(afe->dev);
 
 	dev_info(afe->dev, "%s(), mtkaif_chosen_phase[0/1/2]:%d/%d/%d\n",
@@ -279,7 +294,7 @@ static int mt8192_mt6359_mtkaif_calibration(struct snd_soc_pcm_runtime *rtd)
 		 afe_priv->mtkaif_chosen_phase[1],
 		 afe_priv->mtkaif_chosen_phase[2]);
 
-	return 0;
+	return ret;
 }
 
 static int mt8192_mt6359_init(struct snd_soc_pcm_runtime *rtd)
@@ -297,9 +312,7 @@ static int mt8192_mt6359_init(struct snd_soc_pcm_runtime *rtd)
 	afe_priv->mtkaif_protocol = MTKAIF_PROTOCOL_2_CLK_P2;
 
 	/* mtkaif calibration */
-	mt8192_mt6359_mtkaif_calibration(rtd);
-
-	return 0;
+	return mt8192_mt6359_mtkaif_calibration(rtd);
 }
 
 static int mt8192_rt5682_init(struct snd_soc_pcm_runtime *rtd)
-- 
2.53.0



