Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822521EA84;
	Wed,  4 Feb 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216182; cv=none; b=SjuMj8BdunDJv9MLvApmi05EYZgx7SqreM15Ppwy3/KUPbS2Z7Lnlv/DFlleSSTdGyGV5oyHQDye0qlttfffb61kVoW6agCb5KUKOo9B/TkEcpO9jNXgWwamogH5ST1Uv7qgrJ7RQz5P/NIZfyo+RRxO7ywd7ubFeSRNQIentOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216182; c=relaxed/simple;
	bh=RJYiHb8U9aMtMJgZxtWW8ZOVhLbriPRTI4/SQyKtbMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpU3/k2up4heTzW74XkyZjbrUF5sBIUIFD6BoZdCgFaq1PAOA295duKE8tSx333S+5C84CSVTbClbHmNO1h37bGnK/cL/dcmz/TJHAKxdx5lB/R5s9G4iZyr2OHp1Yuc2Yjm22OUykh6NNZQGtkKCVBYqc/7hQjEWHnI9vo+t1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTgkf1+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTgkf1+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4865C4CEF7;
	Wed,  4 Feb 2026 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216182;
	bh=RJYiHb8U9aMtMJgZxtWW8ZOVhLbriPRTI4/SQyKtbMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTgkf1+3jOkXnj2Jkwwfldv1wVXxaDtVWSr3xQE3zoR/JgpbscwNww++CRHahZwDk
	 SSv9dk0/zX+vjo4+B885n5wuEo/tbIGEZF/tk7nmJjqxTMteN6nECQWYrVBa7Gbu3k
	 /JCZko0gKn1ipeQDmZyrnIjcFLcilWEAMlVUubOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Svendsen <emas@bang-olufsen.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/161] ASoC: tlv320adcx140: fix word length
Date: Wed,  4 Feb 2026 15:37:55 +0100
Message-ID: <20260204143852.206210428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a6241a0453694..c7a591ee25900 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -673,7 +673,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 	struct adcx140_priv *adcx140 = snd_soc_component_get_drvdata(component);
 	u8 data = 0;
 
-	switch (params_width(params)) {
+	switch (params_physical_width(params)) {
 	case 16:
 		data = ADCX140_16_BIT_WORD;
 		break;
@@ -688,7 +688,7 @@ static int adcx140_hw_params(struct snd_pcm_substream *substream,
 		break;
 	default:
 		dev_err(component->dev, "%s: Unsupported width %d\n",
-			__func__, params_width(params));
+			__func__, params_physical_width(params));
 		return -EINVAL;
 	}
 
-- 
2.51.0



