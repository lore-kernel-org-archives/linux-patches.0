Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030599;
	b=Zzu1hNbq7f7kH9zLLic2jdxyOYUmPFpB5OagzAcpG0uEEZHoBci7xkgjgzIgr6WLG8T4
	 pd3tTVw63mxqSlGYdpET8L/rScFqZPwW6K9p2Id1KioCh/44O7kFLyQsnSj+SEtX/odUn
	 TfPddZT7S3iYJEdwCn+fz44EhMSLDHZLACDqk0O5YuSYWxJOi+lOp4wX0IWTLv/k8Tbfq
	 cfONWHX4buLDgm9nAIQ3OhyGqrylAmbmJ/H27xsXbUKgkglpHlbGsT/kHSHQsS/jCZNdi
	 RZNZzo1TNuvRYHyTVsX9Mf1x5QPREnY9JiAnG21UjE7sVUMmiLASeY6v4q+Fn1Cc1hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pnqpc1EgkxgThsCVFWQKxUovBqX/NUyZkJNzVSI7STo=;
	b=v4foFQw8jMvVyi0+QFRwFeIy8+SEP1C4ICSAM8ZXqbzZVydKuOuc4bd5ozTUxNnwEwd/
	 qsut8iA4MGo0gdsOh6inWpE7XsBF1x7ZFDVCzMGVPcBu7ak7JB2fYODNhHaGvkk4uFzJU
	 HWqp8NRAOG1olQrAJ52JEO6Etm/Dbezyr86J3Os7mHQA6cpwhvAatuEt7Jk00Oh6CX0Yw
	 U1PZgecI6IgXa7vJSKBWhj7F1JpL3akd0Ex92nnV8a5GkPj38iqpmxjzQkWsZ0NRmfT8X
	 xsLJZHhNUfijMKABHcVZq0mF6m9VsRF1fnjMqGtKWZykaYE4K7qmZQ4Yoa4/H408wUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1S7kXPt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CF9606F256;
	Wed, 18 Nov 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1S7kXPt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DAC1F000CC;
	Wed, 18 Nov 2026 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030599;
	bh=pnqpc1EgkxgThsCVFWQKxUovBqX/NUyZkJNzVSI7STo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1S7kXPt5zAdmgTXNV2uvIuXmx5Z4aj3kEag/J5kMcucJh7ih6UIHfUNpuOEPZAMt7
	 Cqajs2vCcEgJwO2JP7OfAwt4qDhfKX+AwIjNocPYNjEqzKzGR1MW1FvHaQLtdL1jiS
	 pEYB8vS7zqvK1AWAfT0oraKU9Chyn7nOlWtz8DV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Zaporozhets <yuriz@vodafonemail.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0762/1756] ASoC: dwc: Use OF match data again for StarFive JH7110
Date: Wed, 18 Nov 2026 15:48:09 +0100
Message-ID: <20261118150039.970863071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b4f20dbf7bba..2ca74a02b30ac 100644
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



