Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C051B16C;
	Wed, 30 Sep 2026 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791313; cv=none; b=K7JWQxOHQYUCxYKjiX76ydCNff8VQJq2pQip3+5V+PBsd46XMH8hoqvT9Iquu/AEouVVS4SAYAWLaicb6rH0d/yy8XIvUl4C2RgLr+p/Vmtohj2y+1HXwCpnFPwAwuP7AOT4bQ5J7Rz1bVQatrKWFOVMYrtVk1gSNYxa+O/N0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791313; c=relaxed/simple;
	bh=I/UpgXO+mlcoHBXZ1uFcEhCWdGZ0Vnlrs+tDm45u+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSoSHGonNZeOrErzjsBgup95OFTVyC8ibt9EmVuDkpEulhln3AeCIhS3/CTa5xjHh2jVzXJW4VZ+DkPkHa2sbJUmD4Sa799PDBWPKdYJ9Q3sH7irvdww6a/RjBdkZoxOzynKAEpOjNMyw+bCZxnrETsgvTAv2IcECEUN83qnsmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Zhj7Go; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Zhj7Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1391F000FF;
	Wed, 30 Sep 2026 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791312;
	bh=yNt6276Ui2cfgOaHMU1dIeVFe/RUITPlm3ApZphCWoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0Zhj7GoL6WLRDrsgMXT4GTh/rGhFrJYLdV5lexUxwjdWT6H9WHh9u5f3sQRc00H/
	 QxyBQYTkd+r2MGPsx8JJiSJQ9lwwu6Z1de4YBq4Vf1hte0Hj7/JrR+pmZM4bIhNSRh
	 Pz7CGfeL+zp3AKu2Usl7YmePJC4BfnmtrgLjWhDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/752] ASoC: ab8500: Update to modern clocking terminology
Date: Wed, 30 Sep 2026 17:22:07 +0200
Message-ID: <20260930152403.839952111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0569978e436bf..0add0db540d89 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2096,26 +2096,26 @@ static int ab8500_codec_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
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



