Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0306A145B07;
	Thu, 11 Apr 2024 10:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830205; cv=none; b=Co+0X7nNycwQzZ+bjXj1MCT2ZY7Zp5d31Trk7sr8B7LLGX0BIonUKNbI2oUCEhFzUAB8M+uV2PoDU/kXQJ7lxquDgBMzJpIRR1/0mJ0mbzR4fvLRA4rUquv6YFsNITm7RYG4boOUtdG2rb4MPzhcrZOHBReTwRZtfCGBfMnx1Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830205; c=relaxed/simple;
	bh=fDv47FkCYUnjH1Wa8jgj9qbc8CdehNNsQoLojAxD5BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NChf5DyNovS2+uS8FKcHjxr/kpGHa228rsuWhbSu7tP6yQ4ZB2BZpZRlIawmPXUuyJ91y6Cs8DOGYzRckZ/6/XzknpA0fN9ApeALaotblztS6HdJu/DkNZnsrBlN3qKtdSp+kCCA0XBAlLNvjO1MhP8fQmPaXgNwhL5sXb2Bk4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgYO4GbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgYO4GbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C898C433F1;
	Thu, 11 Apr 2024 10:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830204;
	bh=fDv47FkCYUnjH1Wa8jgj9qbc8CdehNNsQoLojAxD5BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgYO4GbSZvaPDQ6w66fdFBo4h+H7TsOWSGDfGemVtDR0iPHihGAtRsYdkGDWKS8ZY
	 Iq9Y5gGZ0UZYwqRkxUTfLzQWpS3Q90J8aA2hv0HKrCiEagnbCba/zVrd0yJQdUuZyT
	 F60xnVdta0OQqthjgPgL+9EVBYYWa4YACiAB6pkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Brent Lu <brent.lu@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 071/143] ASoC: Intel: sof_rt5682: dmi quirk cleanup for mtl boards
Date: Thu, 11 Apr 2024 11:55:39 +0200
Message-ID: <20240411095423.052027638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brent Lu <brent.lu@intel.com>

[ Upstream commit 7a2a8730d51f95b263a1e8b888598dc6395220dc ]

Some dmi quirks are duplicated since codec and amplifier type are
removed from board quirk. Remove redundant quirks.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Brent Lu <brent.lu@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240208165545.93811-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_rt5682.c | 40 -----------------------------
 1 file changed, 40 deletions(-)

diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index cd50f26d1edbe..02705034e5713 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -154,46 +154,6 @@ static const struct dmi_system_id sof_rt5682_quirk_table[] = {
 					SOF_RT5682_SSP_AMP(2) |
 					SOF_RT5682_NUM_HDMIDEV(4)),
 	},
-	{
-		.callback = sof_rt5682_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Rex"),
-			DMI_MATCH(DMI_OEM_STRING, "AUDIO-MAX98360_ALC5682I_I2S"),
-		},
-		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
-					SOF_RT5682_SSP_CODEC(2) |
-					SOF_RT5682_SSP_AMP(0) |
-					SOF_RT5682_NUM_HDMIDEV(3) |
-					SOF_BT_OFFLOAD_SSP(1) |
-					SOF_SSP_BT_OFFLOAD_PRESENT
-					),
-	},
-	{
-		.callback = sof_rt5682_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Rex"),
-			DMI_MATCH(DMI_OEM_STRING, "AUDIO-MAX98360_ALC5682I_DISCRETE_I2S_BT"),
-		},
-		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
-					SOF_RT5682_SSP_CODEC(2) |
-					SOF_RT5682_SSP_AMP(0) |
-					SOF_RT5682_NUM_HDMIDEV(3) |
-					SOF_BT_OFFLOAD_SSP(1) |
-					SOF_SSP_BT_OFFLOAD_PRESENT
-					),
-	},
-	{
-		.callback = sof_rt5682_quirk_cb,
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google_Rex"),
-			DMI_MATCH(DMI_OEM_STRING, "AUDIO-ALC1019_ALC5682I_I2S"),
-		},
-		.driver_data = (void *)(SOF_RT5682_MCLK_EN |
-					SOF_RT5682_SSP_CODEC(2) |
-					SOF_RT5682_SSP_AMP(0) |
-					SOF_RT5682_NUM_HDMIDEV(3)
-					),
-	},
 	{
 		.callback = sof_rt5682_quirk_cb,
 		.matches = {
-- 
2.43.0



