Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6F356A3A;
	Wed, 21 Jan 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019550; cv=none; b=b6TAm8UtWr+jIpZ2VgyE2j5BCa/2pZk8Bf8RU/jilkAVHmh/PW9Qxt4IJcfjEVAnyofMDMIsmPVA101RtOZEtyDX0SPw3HEfCN3GW/wgFcKktcdzDGvNQo7CTB0xjCiIXD5SEyxWaEIGbX9UDCFfqYLiYc4trnXShQJzPT9GnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019550; c=relaxed/simple;
	bh=7dpDafrdBFm0nkKHZAtenBxq/f6mJ2L/4c3mh02/alI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY1l8gDQ1/+gNrvpZgG+fQqd63uJAoOEJWPmsUE8C7M3mza9uRq9UIs4uF6g96oEuFhGi0jdonVAQaX+dAuAX1IGv8SpEe9Ed3fvL2xBj/WkR7w1yx/F1fffyVXclrVi62ILAtF8FN5TxmFPqZvmIPRtJIuOz/2rYUUT8Nhx5KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WobvXq4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WobvXq4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D62C4CEF1;
	Wed, 21 Jan 2026 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019549;
	bh=7dpDafrdBFm0nkKHZAtenBxq/f6mJ2L/4c3mh02/alI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WobvXq4FHiftuBuK+Zr0aLlZJqHGkMGNCyvvFv9AQ4gnSvEIPV1gVcP9Z39ZNgk29
	 KaY/VBTWdVAJ7D+gp54y8uZ9S8kbx7/q7e2sZecMKswiwQrTqgRDh6d935EY260IHP
	 fk6rrhkD2Sjj9MS34eDBwmAn+qKxFc7XUmYMff5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/139] ASoC: tlv320adcx140: fix word length
Date: Wed, 21 Jan 2026 19:14:47 +0100
Message-ID: <20260121181412.861705698@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Svendsen <emas@bang-olufsen.dk>

[ Upstream commit 46378ab9fcb796dca46b51e10646f636e2c661f9 ]

The word length is the physical width of the channel slots. So the
hw_params would misconfigure when format width and physical width
doesn't match. Like S24_LE which has data width of 24 bits but physical
width of 32 bits. So if using asymmetric formats you will get a lot of
noise.

Fixes: 689c7655b50c5 ("ASoC: tlv320adcx140: Add the tlv320adcx140 codec driver family")
Signed-off-by: Emil Svendsen <emas@bang-olufsen.dk>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20260113-sound-soc-codecs-tvl320adcx140-v4-4-8f7ecec525c8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index ccfec4c0c159a..62d936c2838c9 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -727,7 +727,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 	struct adcx140_priv *adcx140 = snd_soc_component_get_drvdata(component);
 	u8 data = 0;
 
-	switch (params_width(params)) {
+	switch (params_physical_width(params)) {
 	case 16:
 		data = ADCX140_16_BIT_WORD;
 		break;
@@ -742,7 +742,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 		break;
 	default:
 		dev_err(component->dev, "%s: Unsupported width %d\n",
-			__func__, params_width(params));
+			__func__, params_physical_width(params));
 		return -EINVAL;
 	}
 
-- 
2.51.0



