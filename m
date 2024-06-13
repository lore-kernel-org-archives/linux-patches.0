Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105E96EB56;
	Thu, 13 Jun 2024 12:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281707; cv=none; b=fqlv6eyGduey9s9rX9YZTjt6Rh+HIjP9kD+pRx5VYEr4jqeSImJkL0uwZaFfuou7bzfDhmqT1EQBLTSX5rv5mEghtlXx12cA/g61tFG51JIUbkrVROnfwwZHXYA8hnooAnLPHI2KOLB6P9usdfp+aSt02w+Dtf3pRfOrkH4nAbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281707; c=relaxed/simple;
	bh=sDjwpFj8LCHiZKbM3bUsEZNVKF6af73XaCgIUGGrqTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihW6HOYRhZCgFyLCCcNyqntVSjPr4hWFH+zbzASeskz2TYQszdAmimxy1yGmOaCdAxW/z13ziQG7/qVUtraCr5MZkB3SR1uAdPx8wFHX+9FSAdTF70jOoNg4CBzTubna6Catnf12GWM7+Jl9V4sfcIvb0BS7X031wQLHn2Hclm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7hPk0r8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7hPk0r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB81C32786;
	Thu, 13 Jun 2024 12:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281706;
	bh=sDjwpFj8LCHiZKbM3bUsEZNVKF6af73XaCgIUGGrqTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7hPk0r8gQA3xaa7703ybPm+F/0la/4ohTMauRNz7Wkgo9s9g+Y2mZ09Cs9iS7LW/
	 Fi6WuznZ2NhMPVc9VBjU48irCulbAoug64ALFUJn+cyCoBQszIBMzLwE+fCCTXd3LJ
	 xo+CaN6+zpWhVlejQcBeQ9LwaUo5IouXEvZjRbls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/402] ASoC: rt715-sdca: volume step modification
Date: Thu, 13 Jun 2024 13:29:46 +0200
Message-ID: <20240613113303.274168585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit bda16500dd0b05e2e047093b36cbe0873c95aeae ]

Volume step (dB/step) modification to fix format error
which shown in amixer control.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/b1f546ad16dc4c7abb7daa7396e8345c@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt715-sdca.c b/sound/soc/codecs/rt715-sdca.c
index bfa536bd71960..7c8d6a012f610 100644
--- a/sound/soc/codecs/rt715-sdca.c
+++ b/sound/soc/codecs/rt715-sdca.c
@@ -315,7 +315,7 @@ static int rt715_sdca_set_amp_gain_8ch_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-static const DECLARE_TLV_DB_SCALE(in_vol_tlv, -17625, 375, 0);
+static const DECLARE_TLV_DB_SCALE(in_vol_tlv, -1725, 75, 0);
 static const DECLARE_TLV_DB_SCALE(mic_vol_tlv, 0, 1000, 0);
 
 static int rt715_sdca_get_volsw(struct snd_kcontrol *kcontrol,
@@ -476,7 +476,7 @@ static const struct snd_kcontrol_new rt715_sdca_snd_controls[] = {
 			RT715_SDCA_FU_VOL_CTRL, CH_01),
 		SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC7_27_VOL,
 			RT715_SDCA_FU_VOL_CTRL, CH_02),
-			0x2f, 0x7f, 0,
+			0x2f, 0x3f, 0,
 		rt715_sdca_set_amp_gain_get, rt715_sdca_set_amp_gain_put,
 		in_vol_tlv),
 	RT715_SDCA_EXT_TLV("FU02 Capture Volume",
@@ -484,13 +484,13 @@ static const struct snd_kcontrol_new rt715_sdca_snd_controls[] = {
 			RT715_SDCA_FU_VOL_CTRL, CH_01),
 		rt715_sdca_set_amp_gain_4ch_get,
 		rt715_sdca_set_amp_gain_4ch_put,
-		in_vol_tlv, 4, 0x7f),
+		in_vol_tlv, 4, 0x3f),
 	RT715_SDCA_EXT_TLV("FU06 Capture Volume",
 		SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC10_11_VOL,
 			RT715_SDCA_FU_VOL_CTRL, CH_01),
 		rt715_sdca_set_amp_gain_4ch_get,
 		rt715_sdca_set_amp_gain_4ch_put,
-		in_vol_tlv, 4, 0x7f),
+		in_vol_tlv, 4, 0x3f),
 	/* MIC Boost Control */
 	RT715_SDCA_BOOST_EXT_TLV("FU0E Boost",
 		SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_DMIC_GAIN_EN,
-- 
2.43.0



