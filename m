Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510A35A93C;
	Wed, 28 Jan 2026 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614079; cv=none; b=tLRwi31Na2Ipv28ahPCboKVa8VtFc0jg4UyLyJrG+0jgkahNiJV0B0yUIHoNpcIayxNx7Ez+3SUxGieQ6m/2Kfb9Yi25hVHgPb8H5i2jdwRP9Z/Ime6ZiAgG/PlmZ6IlhybkodsyX+w88vZanuoFuWvMY8XGK9biHzgb+07HJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614079; c=relaxed/simple;
	bh=4IOZ4dkA/aFRUedbe/812t+rmDKDldtQx0iELt/PVLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaW32i+KTaMU4GHNyILoa9U1o5L0c6MkrO5s0sY6TbRFShe9gt76JhXpJzkiQ8bn+9rAUkQhMEXikwXS8Pdz8Rkchr0gCTpVSM9kr9Wm9+w4MXq/DF+BOjWqDMXNy/dosrH99ildQnszmG024IqOwPMuRZJii5nQC4VX8MngzDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMK0lC55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMK0lC55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47127C4CEF1;
	Wed, 28 Jan 2026 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614078;
	bh=4IOZ4dkA/aFRUedbe/812t+rmDKDldtQx0iELt/PVLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMK0lC55tKZEdEOZ24yEBfyP6YTB8LlWii5Z40m24ZhRdnfPtrx9iPRUSRcKmDJmn
	 VilYwgts/c+bQjv3UBHUKGbZhYt4iKELK3vnPuoASrTsVg3YiZ7nz6LVPhKffd0U9A
	 L5/zycPXkAP13RNehgxC+B6ztqJ8r047lPK47Q3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/254] ASoC: tlv320adcx140: fix word length
Date: Wed, 28 Jan 2026 16:20:05 +0100
Message-ID: <20260128145345.752360436@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d366c1c51f07a..78d95b8be2f29 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -728,7 +728,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 	struct adcx140_priv *adcx140 = snd_soc_component_get_drvdata(component);
 	u8 data = 0;
 
-	switch (params_width(params)) {
+	switch (params_physical_width(params)) {
 	case 16:
 		data = ADCX140_16_BIT_WORD;
 		break;
@@ -743,7 +743,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 		break;
 	default:
 		dev_err(component->dev, "%s: Unsupported width %d\n",
-			__func__, params_width(params));
+			__func__, params_physical_width(params));
 		return -EINVAL;
 	}
 
-- 
2.51.0



