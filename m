Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026963;
	b=yCKnp/CgbfpIAuauM/6cSWQHnlJr2WL7VwkavLgQGsdgB7sJpjyG82lm+4gmkejaH4cx
	 w+js86Yu0N1V3LptTorHUZ8uW6aJoHoNqSHSt4k/nyXtJ2UP7kHrQrOACGUjffNr6HOIj
	 zGifTKNsCF3/0Bhl3jzvY7J5l6yPq7x9CN3AU8cSEM4F0oUTxRkHaCB2ppGRkIm2J2MQT
	 WGYTLr5orFfqcbK2Lsottz1IY6VmN1JtTOz6XIS9KGPWkWFTgxuyxW57O3lL/pdVKfmgz
	 aw+hK/P/XETLAL7vSE9uf0xrRQT1xNIG7pLLy+J7epFLhXacURlzKmO/ZuljdGcXv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gqc53Q69QT9c5k6KFmUHo4xoP8wAlrEtr7mLrs5+nnA=;
	b=sYCQtwRq6nAGPIbJOuhXcVWFm6gnTdRkPgUZfeCV+vbI4pCPyLmrqUN/88KCZ0EiNJxh
	 XTjzdNOw6DdRLRxpcl/1fs+LtVWRsOTavXzEMrRK0wQlZJRipKZq8F8TbwGB8ygxoxRI0
	 7oh+Oe+3QXT0uveZkMX7QEfyT7U0RD75aTbLeH1Qq6pg55cH87x4ldeL8sQycq+gIQmA6
	 5BLslU5gVF60vETFGPX/emKMpkuLdNGoUkSUh7ecepMIfyY+f+/YiXH3gR0xATGQoec+J
	 U6O3hqZzZjAUN7VY2ISq5GvTDCKitRB9vMEnMTeEpgEz4pC+4f+0oPhb9Qsgy7usuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luTWcfbH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B97606A333;
	Wed, 18 Nov 2026 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luTWcfbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C0C1F000C6;
	Wed, 18 Nov 2026 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026963;
	bh=gqc53Q69QT9c5k6KFmUHo4xoP8wAlrEtr7mLrs5+nnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luTWcfbHejFI8nq3iXfwUHfzmX9qRO6bYilSSahx4orP2TqQcJOkboAphgA7R5NJt
	 b62Q5Rfp2w3PhIz0GP/gEbwk5XitJ3FLQ90p+WDmw4j4ZpE3MC4fy6u2/808cq3uNW
	 WJa3LFFSxrWR2M/QUxNnfnSDYZFCHow8QQFC4w5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1621/2151] ASoC: rockchip: rk3288_hdmi_analog: Drop redundant probe error messages
Date: Wed, 18 Nov 2026 15:55:56 +0100
Message-ID: <20261118150220.930085186@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 931f4a1223e154fdea63071074cbaa633ebf394b ]

Remove the probe error messages to avoid duplicate error reporting,
since the error is already reported by the called functions.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260806052136.21034-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f15b2df0b940 ("ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index ffbc5a39b493f..cb9add725a3c3 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -184,10 +184,8 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	gpiod_set_consumer_name(machine->gpio_hp_en, "hp_en");
 
 	ret = snd_soc_of_parse_card_name(card, "rockchip,model");
-	if (ret) {
-		dev_err(card->dev, "SoC parse card name failed %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	rk_dailink.codecs[0].of_node = of_parse_phandle(np,
 							"rockchip,audio-codec",
@@ -222,11 +220,8 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	rk_dailink.platforms->of_node = rk_dailink.cpus->of_node;
 
 	ret = snd_soc_of_parse_audio_routing(card, "rockchip,routing");
-	if (ret) {
-		dev_err(&pdev->dev,
-			"Unable to parse 'rockchip,routing' property\n");
+	if (ret)
 		return ret;
-	}
 
 	snd_soc_card_set_drvdata(card, machine);
 
-- 
2.53.0



