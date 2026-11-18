Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025138;
	b=d2gp9txpyoJByr3OHrFMW3lYvBnZG92wOc1tP+jELj/VvvJKvR5eg36d17g9WFZlpv9V
	 dOGKGGmHTJRjNKVsaLDX2A0zh0J4mieUmscKaJcChfr8MuXXlLHdJF1W4OV2vGviMmsRf
	 IFLyAwllPgf9HIVRanhlev+kkr8RCX3600NuNp5cK4yHd0eeIEMjcd4IguFMFVENKpQGu
	 RCg/f6/U3Ykl+9Jhb9v0cDFvuxAHW7VfCVnylmJhvkJceZg/0hJtF1XF3cVBTRfBP2+JC
	 +cqBJxE9UYy0y/A7m0UQdej3gHUM4szlxqBC3iTOk9kIemiFfZeRr7DSBwaGgfr1Icw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJykLREWtP5aMR/35D9bvTduwTP6yDQ9ge7hci+Gw/M=;
	b=w0LZ17qn6KCr7s7GkTBo7JtWl8lvm36TmfVntxcvkld6nfVwmBwnxXCPMghzpm378dEU
	 bvbDSbnwN1SYLSu200qvI2MnZBoYZXQ5G9KLCyp0DwHudtuWdHvenVg3ZopmLL+23P9z8
	 eOjOkw0cRgQVurh+QuS5w/7w2aZ1jKpg+lPTFmYkcGPxOMgaZYVmCmQs6nanCYEnOvSbQ
	 qmDa1T4xkQF0hthJ9s9QZR6LK67pqonjDhvMG7t7BDgQtQIoP2MavmHNMm/VhucyhZt80
	 Mce5EgNGHHSYUIkQDZITcuG6hkCwF2mPrckc8IeI8QF33PbY+8C16jdBXJX5AHdktbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjC0MQPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78895606A325;
	Wed, 18 Nov 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjC0MQPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C21F000C4;
	Wed, 18 Nov 2026 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025138;
	bh=uJykLREWtP5aMR/35D9bvTduwTP6yDQ9ge7hci+Gw/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjC0MQPvsOhpbcT56/Ra/lVNB7mQ4ThfhLEfvD3vcSuL3bfbGSdeUHMh7q+NJmqfA
	 TrvTu2gExXai5wllPtDAOSMDetdu+ZcRRCyuDqIAd8yCuMHn78ZwvuAUGcmvZdXdj+
	 RVyBuP3+NRRizx228vuWqTUanRuWnTg/aI0qTfqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Zaporozhets <yuriz@vodafonemail.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0971/2151] ASoC: dwc: Use OF match data again for StarFive JH7110
Date: Wed, 18 Nov 2026 15:45:06 +0100
Message-ID: <20261118150157.877550944@linuxfoundation.org>
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

From: Yuri Zaporozhets <yuriz@vodafonemail.de>

[ Upstream commit d532e2f5c288556075dc429941861391118787a0 ]

Commit d6d6c513f5d2 ("ASoC: dwc: Use ops to get platform data") made
dw_i2s_probe() fetch its platform data with of_device_get_match_data(),
and commit 52ea7c0543f8 ("ASoC: dwc: i2s: Add StarFive JH7110 SoC
support") put the JH7110 configuration into the OF match table. Commit
9c97790a07dc ("ASoC: dwc: Fix non-DT instantiation") then went back to
pdev->dev.platform_data so that non-DT users such as AMD work again.

Since then the JH7110 match data is never read. The probe runs neither
the JH7110 clock and reset setup (i2s_pd_init) nor uses its capability
flags; it configures the DAI from COMP_PARAM_1 instead. On the
VisionFive 2, i2stx0 drives the bit and frame clocks for HDMI audio, but
COMP_PARAM_1 reports it as slave-only, so the sound card fails to probe:

  designware-i2s 120b0000.i2s: ASoC error (-22): at snd_soc_dai_set_fmt() on 120b0000.i2s
  asoc-simple-card sound-hdmi: probe with driver asoc-simple-card failed with error -22

Take the OF match data first and fall back to the platform data when
there is none, so that both DT and non-DT users get their configuration.

Tested on a VisionFive 2 v1.3B (v7.0.3 with local HDMI audio patches):
the HDMI sound card now probes and plays through i2stx0. The non-DT
path is build-tested only.

Fixes: 9c97790a07dc ("ASoC: dwc: Fix non-DT instantiation")
Assisted-by: LLM
Signed-off-by: Yuri Zaporozhets <yuriz@vodafonemail.de>
Link: https://patch.msgid.link/20261001192552.2904-1-yuriz@vodafonemail.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/dwc/dwc-i2s.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/dwc/dwc-i2s.c b/sound/soc/dwc/dwc-i2s.c
index 28001e9857d9d..bbd4da8323a49 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -21,6 +21,7 @@
 #include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <sound/designware_i2s.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -916,13 +917,16 @@ static int jh7110_i2stx0_clk_cfg(struct i2s_clk_config_data *config)
 
 static int dw_i2s_probe(struct platform_device *pdev)
 {
-	const struct i2s_platform_data *pdata = pdev->dev.platform_data;
+	const struct i2s_platform_data *pdata = device_get_match_data(&pdev->dev);
 	struct dw_i2s_dev *dev;
 	struct resource *res;
 	int ret, irq;
 	struct snd_soc_dai_driver *dw_i2s_dai;
 	const char *clk_id;
 
+	if (!pdata)
+		pdata = dev_get_platdata(&pdev->dev);
+
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-- 
2.53.0



