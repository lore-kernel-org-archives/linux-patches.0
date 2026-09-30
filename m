Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC934E324B;
	Wed, 30 Sep 2026 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782895; cv=none; b=tKaqPTVpAZwktZN/MO5+Ono1LQ75yhJvzXYv0ChauEelJGFJuVd9i4FkOV2lUeeKe5tuqpfCzuv+9S+wFtxmwVj8VtZjHfP/Yvu4rrwqq7LvGFJs9hzy93nymK6BRHP+9CDPGyiYaNAUMUvbw9V9yvXdDRNT3vghMBVe1OcHD6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782895; c=relaxed/simple;
	bh=j4DnTEWB56j/x37brKv3aqxGqNsFg+jDXYstabcF7VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H79OV5g9vOVyc3TxC+V6btCq3he1JH5fBq4Tur5zz0qSOeAMLgEeQnBpLEdP9wZXjbQWja5AQGIZ5XOzUbSTz67uLIM5Ww6jpZ3feU4EhBE1YkYAWoOnqCZWvTwK3L+Ks6Rva3pQeQB7okOthdU7TcnefmlHGBJcDaEh5X7vmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpOD4KYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpOD4KYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE181F00898;
	Wed, 30 Sep 2026 15:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782891;
	bh=GXXleHvK5wciPgctq6ARtt1oEfUM/lBkcSx2B0Soe+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpOD4KYiBIy6IZE6aUPVvl+VAYxr4Bu+n/5af9CytRcS/elsPDfOH2x0KmwriYNxG
	 ao7YVvkoBbYKZndiPnXntKQS1QO9xfBqI+7QC4x3GqXKgGbpvL6eyxUTImXYRjaCOl
	 vMmukzDoKFNLpDx1/cXvXhSnfoDEpU8XVQ9o0daA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/595] ASoC: ab8500: Update to modern clocking terminology
Date: Wed, 30 Sep 2026 17:21:37 +0200
Message-ID: <20260930152352.124167008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit ef92ed2623ead917e4f10465451aa12cd7977241 ]

As part of moving to remove the old style defines for the bus clocks update
the ab8500 driver to use more modern terminology for clocking.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210916141335.43818-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f98785adf004 ("ASoC: ab8500: Correct digital interface format setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 663188d01b460..f58260e5884f1 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2103,26 +2103,26 @@ static int ab8500_codec_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 			BIT(AB8500_DIGIFCONF3_IF0MASTER);
 	val = 0;
 
-	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
-	case SND_SOC_DAIFMT_CBM_CFM: /* codec clk & FRM master */
+	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
+	case SND_SOC_DAIFMT_CBP_CFP:
 		dev_dbg(dai->component->dev,
-			"%s: IF0 Master-mode: AB8500 master.\n", __func__);
+			"%s: IF0 Master-mode: AB8500 provider.\n", __func__);
 		val |= BIT(AB8500_DIGIFCONF3_IF0MASTER);
 		break;
-	case SND_SOC_DAIFMT_CBS_CFS: /* codec clk & FRM slave */
+	case SND_SOC_DAIFMT_CBC_CFC:
 		dev_dbg(dai->component->dev,
-			"%s: IF0 Master-mode: AB8500 slave.\n", __func__);
+			"%s: IF0 Master-mode: AB8500 consumer.\n", __func__);
 		break;
-	case SND_SOC_DAIFMT_CBS_CFM: /* codec clk slave & FRM master */
-	case SND_SOC_DAIFMT_CBM_CFS: /* codec clk master & frame slave */
+	case SND_SOC_DAIFMT_CBC_CFP:
+	case SND_SOC_DAIFMT_CBP_CFC:
 		dev_err(dai->component->dev,
-			"%s: ERROR: The device is either a master or a slave.\n",
+			"%s: ERROR: The device is either a provider or a consumer.\n",
 			__func__);
 		fallthrough;
 	default:
 		dev_err(dai->component->dev,
-			"%s: ERROR: Unsupporter master mask 0x%x\n",
-			__func__, fmt & SND_SOC_DAIFMT_MASTER_MASK);
+			"%s: ERROR: Unsupporter clocking mask 0x%x\n",
+			__func__, fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK);
 		return -EINVAL;
 	}
 
-- 
2.53.0



