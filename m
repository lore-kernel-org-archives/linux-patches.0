Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045024;
	b=oVICF72RcYQtIDvzuuwkizOZAMieG0VwIA6aC1gAECW3Ig3BR19ghoUV+uAA0nFRwpbA
	 2UiBeQL55or+y+QGqYwg1GmOqjbhdoUPvWivKOqTuUbmsN+EMH7Z9lXrJTgnaBZm0VNxJ
	 hUehwmbR7EZZsU1RHXt8B/AWmmyQVxl9hC3r42quLmWnYrMomKh2fa91CDNiEuu6eWH3b
	 qDjKWCJ+eXgYiH97oHEO6InD2L3P7bjkWOmlZet3oK1cs3f2XTMAFPEDd4IqK8SANP6CC
	 DqfGCVS0ei5D6x4GovUuc3U41ZF+FX5Cr7cDNVCv3zlg8CHzrVd4UJLtK8tAOZWUT3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czvbCjMtGJwYfu3RXvtX6cV0QZb0tiltXeoyG247oBw=;
	b=vUVtL7LBTCxiOQ54LqwseTtxhg39nQgn++2hflW/ya/lvu3szF8kUPowUFpb1wKY6HrG
	 RQt0J8d9Ikj9BQlapU9L7SO9RoQY8l7kNYX8J42R2lKoS4DeV9SY6R2e1wg6rXl/YRfBt
	 Eo2qdhIIPoHQSP5setqVibwJb/M0O2CYQMp/vLXZr7qFqvNkPl+KfqlytxVr83FuW/ZZw
	 EN2rNFl+RNPprY3kWe9uI/ezPaLW9jEWIEsgkOBo1I3/5H9/AIHj1zzxH7ti63WwOC2Us
	 8LUKehNuy7hjT1oZMIx4UumQ3TZZRcRHDT4RnFIySH7l3nbz3GAxRzry0fA967pT+Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3RyKn86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A7606A325;
	Wed, 18 Nov 2026 23:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3RyKn86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA90B1F000C4;
	Wed, 18 Nov 2026 23:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045024;
	bh=czvbCjMtGJwYfu3RXvtX6cV0QZb0tiltXeoyG247oBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3RyKn86TP1jpqHBiVr1ynQccNImfaZAw/Fp1qfl0OknMncFrN/3PsmqICntOVQTi
	 qLbEs5z0X9HCEitjxDDTsKlUpkWZZJFywdL9I6lPA4KF+ExLKWdlAMDxbeLEm9fjIw
	 O5Xs8lmfu9w8BdUYVJ0QDiDpeZEzj8ZjW2UiC6qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0774/2857] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Wed, 18 Nov 2026 15:30:08 +0100
Message-ID: <20261118150229.439176886@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 480a5528cb6268d626632d45d4a1f29b4c0c11df ]

In wm8994_component_probe(), pm_runtime_get_sync() is invoked before
reading the GPIO configuration registers. If either regmap_read() fails,
the function jumps to err_irq without calling pm_runtime_put(), leaving
the runtime PM usage count incremented and causing a leak.

Add pm_runtime_put() on both GPIO read failure paths before jumping to
err_irq.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072737.1970990-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 8fe9a75d12357..09e6a2ad506f2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4352,6 +4352,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_1, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO1 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
@@ -4364,6 +4365,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_6, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO6 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
-- 
2.53.0



