Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063998;
	b=rLM32XJuyPDvO0vJEvNZQ0lndzmE3DsZ83TQHBkXxgEX+0mi/eXTnTMGASWFuZLG5snR
	 mcE7bn5ZmU61QDfK1LgZJCJRrBgJCX1+lrESr62Ky2Wrwk2Y/KRi3PlSF+qosSQBpxlTO
	 TwGKsnLzjtLOGuUqDy0cYcpK+wT3INcRYtsvojNpUsCAhteZlUKvaMhKkUV/8pb+kODud
	 eJ574c57M0lUZ3MOfhUg0LBE6+Jyx0FISXS1MiRXjFpLKBFAPMa9XBdKCCbeQ+/Twie1/
	 RH5CDK9YO81xsNZnsDSUHMw75IJ0ojNXI1kyjzJw3D6PwWFvU4PKcfOfOFI3j3SCdVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcmgNHkMiT7s6ZxGxuJG8zsbz4v6y2zpxhpWSlhQt5I=;
	b=LEUm+uvpw7MWAC47rwxreo+ajFZR6fjU0YA1tKBy7Q1NOoXhml38a1blBgfz1yCJf4Je
	 Ci/NH4Q0e3EYxQ4Ce+MnLinEOlzbHa51JtUBSklcJmlOZdS1WKEf9ae8dTY/z5dkprFGS
	 +Y2HMZphTC4hlvTjguftyeD9Hflu2UFNOGtaLmU5n7AysKYZscIfwyKZZNi5MCjh6pqjH
	 KTrsLy6Y7tY+NShLMBuTzXi8tM9eO/sd7bwbNJGT5RApCx+OQDn98fn5SB64tiuLRtPiU
	 3CoyxCS/c79Q8l62Wpb4qYtg3PNRGfevaZkjWHPxVCmsoiTRnm+JJ4/X+1GDtt0CQ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVHOXFIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639D0606EEA6;
	Sat,  7 Nov 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVHOXFIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1257B1F008A1;
	Sat,  7 Nov 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063998;
	bh=DcmgNHkMiT7s6ZxGxuJG8zsbz4v6y2zpxhpWSlhQt5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVHOXFIp1LknbSt9gcgjMa6Ar68z3BtITvqO0ShLrUG0jy3M8fvywOsHSNnPtZoiW
	 yJXlbCEaznfK5xnGobVqBqogODLU+6LYSib+yXbGhLov46Fec6MkUwyjBJd0awDb1U
	 6ZZP/VhBX/6gft154b7S3DK9R1npzuBEFbgoTwk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0180/1257] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Sat,  7 Nov 2026 08:41:16 -0500
Message-ID: <20261107134944.422555446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 8bf58a6a8af7c..0d1b4b1fcecda 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4340,6 +4340,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_1, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO1 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
@@ -4352,6 +4353,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_6, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO6 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
-- 
2.53.0



