Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040612;
	b=1RC89/uGd2ht8kBF89DZLU4hVfOK0KilfV/kynaYINghr/+g5xXgDyQZSr1SxI4cG7oG
	 GTozsy6cVab9IMMm225D9cJWXFfG9Sd0epFgI0Oliy48gfFDRw4eQ+jyGXaAreYAhEi2N
	 kQXkGL8CTjsguyE86K9Torex3SvI3HUSxU8DVdNW6nbq98rs0iHRUFmTtiWrDPLYqh/K0
	 K+/FM8q+g9MwWfJ5ztL2KDOMvTa1SGjJYBs+xM2baXsN0rjxR/t1RJ1BIx5yB1NNYcWHt
	 MoBvW0kghIomrmggQ0FQhVxWhDN+L1MsCMQE75Qeb+PVXEozKyLE8/OqybYaIsREpcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgeKiGOpOUzQuK9x55H3VrK3L3PNgQcj2CbpWmS8hFI=;
	b=Eq67Yzen1K85wyDoYF70DoIYTLOKi4GD9Se++s8doLBAof+TYN9mFq2yQJkyCltLWxfT
	 YuwvmFook1IKsZLNxT97lDNANouMl4+ORgAmKS24Jksx4oFvdJjpuAYosfHB/c10CZibm
	 YN953Jqnu775NLQzW6/Fx0Mjj4R1/jcop6oEszfOnHV18HRlPgvwxCymiWM5QSLPi8l15
	 VzOGHz2rgQYPHfGTcs3FAdqLkGQzJiL+/y+K9Vm7q/thYz7VNR2k5iI9sCEFWYp0H3yPz
	 qyztvv63xy5cKFK22N49beF8GE2jAJtbRg47g8uV29vSbRbAcC8xCo+kMUENKAgzexA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4LEVhUJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A17A606A31C;
	Wed, 18 Nov 2026 22:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4LEVhUJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB9F1F000C4;
	Wed, 18 Nov 2026 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040612;
	bh=SgeKiGOpOUzQuK9x55H3VrK3L3PNgQcj2CbpWmS8hFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4LEVhUJ7tohZivPhUUpNxfV+kn5/wzQJuVI11s4IJ9WJgd9WL8uwaICRDUk7QoG6
	 +TJBoJOwp5aFtSxhLKNPK8Yd/asW33br5pO53NfySQV/5zEXVGonqVIBECK95+b0xp
	 9OpvPXycHGkUzFXh9Rslswq4VOhykixlPRU9F5Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Zaporozhets <yuriz@vodafonemail.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2519/3318] ASoC: dwc: Use OF match data again for StarFive JH7110
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150436.937241289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43edad6c887dc..424b9f361fcaf 100644
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



