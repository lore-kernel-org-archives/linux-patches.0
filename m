Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018238;
	b=YHaQ450gqMJTKwaRgfUHVhnShyQXaB8Kl8Cl2g4EZwZolG+UL+4qg568swFa+APy0ryT
	 fvt8t8isp3HsOYnYC73Imu25C371rpiKkXXCCbBPP1UoaxgzLc+MIp/Dp6p08rvt4dy8I
	 EcQW2ByE+XTnEP9+oSngvjEN1KTtWw5fpwE24ANjm1l1mjx4IOk1LEYHT3d/4uXtglhUN
	 K4nqlO2daVRaK9B8Plv4REzcbQKAnqfkFvnJXSx84bK0AlcTFAEwlwFGXS3qUt4wUJigF
	 r3HfiIjWQMEy5+MdLQ0VolIyjQdurVdkIUIObERSaiXblT5ag5p6f1omwoN63nZkdRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RleclYZA7wFpbFhtW8Yx8Z8bkHYrmNaRpRpOuKRokW0=;
	b=4/PPEHeOYu0mYzvFomxqrBWi6Vxzt7tHJ0guwlbIfOiuVIcfnJ6+ygWaTmOTabcGA90z
	 f8QOCmCo7gzH6AiI09/nJmvPiIRp5IkxxL3UFMIantqfhbHgXiri/9EEEE750Q9FNCENx
	 sQ+DKRap63xfbrpHMZSZ0gljlxapEH7Q+UTa4exjrETQ62MwSvKMmNP9XYrYkVohRpMrN
	 H4CxBB5mixG4p3XdEMg4LVjLBrqRgcnSmKTNGs4Xx/hAbc0210B+xDBxHsL8mRTgFpEua
	 ovjmb7KCGbwansb3Jlk+OLBUR+fKjNeX9FC4G8Ri9L8pVXVESmSuhltEUzQBLSPSiUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUkU59Xy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6598A606A330;
	Wed, 18 Nov 2026 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUkU59Xy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50FB1F000C7;
	Wed, 18 Nov 2026 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018238;
	bh=RleclYZA7wFpbFhtW8Yx8Z8bkHYrmNaRpRpOuKRokW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUkU59XyDJzolL2dnPYfg3W6Ffrbb81tznjNp1gFcrPs8NHrRRqcIo4QuCdOdKabr
	 WyGMjmWO1soMlgZczphxRQar2LsoEf/eZt+9ySyGxkfmJ/AONw2jqB7grNmvMMwP96
	 mIh9LeVP9tKJKyLdNA0EO/mVOP7wgZxIHIa1NkV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Zaporozhets <yuriz@vodafonemail.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1168/2651] ASoC: dwc: Use OF match data again for StarFive JH7110
Date: Wed, 18 Nov 2026 15:40:08 +0100
Message-ID: <20261118150330.059378790@linuxfoundation.org>
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
index 2e9fb79b1cd8b..2f483b78a2279 100644
--- a/sound/soc/dwc/dwc-i2s.c
+++ b/sound/soc/dwc/dwc-i2s.c
@@ -18,6 +18,7 @@
 #include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <sound/designware_i2s.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -913,13 +914,16 @@ static int jh7110_i2stx0_clk_cfg(struct i2s_clk_config_data *config)
 
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



