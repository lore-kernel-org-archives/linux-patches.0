Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE354EB86F;
	Thu, 17 Sep 2026 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665870; cv=none; b=F5l8KGJhKZMmQyNU5onrTbe8Wp2oPWTbaDQ0Q5o5UtUp96Fmxk3b4/jmAohvBgyUeE9w7ENEtX06QbVosFdOc0qa2k1tN3k6gG+7g36YJmPBSkS7DmCEYCK4Ew4ZGOmLvdyEmsm2WOyJrRIi7K+/RVhCdg9t+SdtkyaK8IyLAiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665870; c=relaxed/simple;
	bh=CHBpPxbJ5WYZComAAV3Ml8Pqsw7wbLFgdYeWgvAvAo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzbHcapHJLaY5MD9lYidG2tCqV6glybK68KMrKOrGPjQRmaqFM1Zkn4opRth3b3UMDltC53hsAEV7PqHq2W9X30V0mcoYynrOwlKt0xG1vFEQGPUFBe1YjFn7hmIqxgoF/kzoCqoc3grPltckTHTYr9DsJsV3eSKKPN1G5W/htg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzF+QNON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzF+QNON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998D31F000FF;
	Thu, 17 Sep 2026 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665869;
	bh=G1PNsgOpdzMefx5HKYEoVhDROxnsDgMELwRmSy3tNTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzF+QNON9+Z+rsswiFq0KHCw49hKOjyOGNqsV6R/RTieWv9FQOduhfU1FhrcTqg+l
	 mrDK7axnbgJ/cHk8AgU7GYMmMU8SuqO6xdXcSw9/ots2zDIxzpKqQL8xWytg9il2wc
	 JiO/shE76ttg5W4ejwd8B5rb4X1MGnCvChWO7jS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0846/1250] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Thu, 17 Sep 2026 16:10:41 +0100
Message-ID: <20260917151614.890254569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 32689f0fc54fd801f1cd11637666e534984cb04a ]

The BCM63xx I2S platform driver matches brcm,bcm63xx-i2s using
snd_soc_bcm_audio_match. With SND_BCM63XX_I2S_WHISTLER=m, the platform
bus emits an OF modalias but snd-soc-63xx does not publish that table.

Export the existing OF IDs for module autoloading. The PCM companion
and the probe path remain unchanged.

Fixes: 88eb404ccc3e ("ASoC: brcm: Add DSL/PON SoC audio driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133103.63432-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/bcm/bcm63xx-i2s-whistler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/bcm/bcm63xx-i2s-whistler.c b/sound/soc/bcm/bcm63xx-i2s-whistler.c
index c47ed1e6ea2b6..14d111fe29d83 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -285,6 +285,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0



