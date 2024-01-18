Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD920B1C;
	Thu, 18 Jan 2024 11:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575770; cv=none; b=ArrlidaGGzs2jzTzOmQtXn7G6GPmB4Qeue32jfAI+bTkhJy0+T/KFzN5zKy+txNSAkh9lNgN4l9YbHl99Wr3lTwzB/hCbve//ma82G1p6Ztqk61h6db59WwWs1sxA+cNJDR+Ov4Ruu9FF49NvzTlWWhZZXa8AG3Od9H9cdr8Vgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575770; c=relaxed/simple;
	bh=8eOaWwCPJ8VAvmb9nXjr1sxY+vSC4r6olsI4ziHaqac=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=fhGlWJUyOQYR3uXHgp+WGtpxkUZanyJre4BgIMaNNgfz73QzaRg4sUEEbNQO7BTJJlKHfWd6jWf8rTvPr8wSkTc+FcLryvXZi9AC3fT5HNXNSXV7p2kNKnEBbnWF3BXj1QFkmpluY6yVDYF1zlVDoQKNwgLxGxUBbVqvEkLIhKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI9M5v3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI9M5v3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD89BC433F1;
	Thu, 18 Jan 2024 11:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575770;
	bh=8eOaWwCPJ8VAvmb9nXjr1sxY+vSC4r6olsI4ziHaqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XI9M5v3vHshRZ00LWnk5+c+NwR2oDuYFk8I2IPMDbkUL6AIZqWWBAXphWVOK4DKFF
	 yb3kz5LurVaLldPmX0L52QbWCSTLA/kDtv31kqgQS+VSz4fmpBFAYN36dr/jfg74b2
	 lA/1GrKMp79nmWcVhVdj92f42bx6N/C6V46/Gipw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/100] ASoC: Intel: bytcr_rt5640: Add new swapped-speakers quirk
Date: Thu, 18 Jan 2024 11:49:16 +0100
Message-ID: <20240118104313.910850953@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b1b6131bca35a55a69fadc39d51577968fa2ee97 ]

Some BYTCR x86 tablets with a rt5640 codec have the left and right channels
of their speakers swapped.

Add a new BYT_RT5640_SWAPPED_SPEAKERS quirk for this which sets
cfg-spk:swapped in the components string to let userspace know
about the swapping so that the UCM profile can configure the mixer
to correct this.

Enable this new quirk on the Medion Lifetab S10346 which has its
speakers swapped.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20231217213221.49424-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b63c16c67898..797d0a48d606 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -83,6 +83,7 @@ enum {
 #define BYT_RT5640_HSMIC2_ON_IN1	BIT(27)
 #define BYT_RT5640_JD_HP_ELITEP_1000G2	BIT(28)
 #define BYT_RT5640_USE_AMCR0F28		BIT(29)
+#define BYT_RT5640_SWAPPED_SPEAKERS	BIT(30)
 
 #define BYTCR_INPUT_DEFAULTS				\
 	(BYT_RT5640_IN3_MAP |				\
@@ -157,6 +158,8 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk MONO_SPEAKER enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_NO_SPEAKERS)
 		dev_info(dev, "quirk NO_SPEAKERS enabled\n");
+	if (byt_rt5640_quirk & BYT_RT5640_SWAPPED_SPEAKERS)
+		dev_info(dev, "quirk SWAPPED_SPEAKERS enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_LINEOUT)
 		dev_info(dev, "quirk LINEOUT enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_LINEOUT_AS_HP2)
@@ -893,6 +896,7 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
 		},
 		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_SWAPPED_SPEAKERS |
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
@@ -1621,11 +1625,11 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	const char *platform_name;
 	struct acpi_device *adev;
 	struct device *codec_dev;
+	const char *cfg_spk;
 	bool sof_parent;
 	int ret_val = 0;
 	int dai_index = 0;
-	int i, cfg_spk;
-	int aif;
+	int i, aif;
 
 	is_bytcr = false;
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -1785,13 +1789,16 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	}
 
 	if (byt_rt5640_quirk & BYT_RT5640_NO_SPEAKERS) {
-		cfg_spk = 0;
+		cfg_spk = "0";
 		spk_type = "none";
 	} else if (byt_rt5640_quirk & BYT_RT5640_MONO_SPEAKER) {
-		cfg_spk = 1;
+		cfg_spk = "1";
 		spk_type = "mono";
+	} else if (byt_rt5640_quirk & BYT_RT5640_SWAPPED_SPEAKERS) {
+		cfg_spk = "swapped";
+		spk_type = "swapped";
 	} else {
-		cfg_spk = 2;
+		cfg_spk = "2";
 		spk_type = "stereo";
 	}
 
@@ -1806,7 +1813,7 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		headset2_string = " cfg-hs2:in1";
 
 	snprintf(byt_rt5640_components, sizeof(byt_rt5640_components),
-		 "cfg-spk:%d cfg-mic:%s aif:%d%s%s", cfg_spk,
+		 "cfg-spk:%s cfg-mic:%s aif:%d%s%s", cfg_spk,
 		 map_name[BYT_RT5640_MAP(byt_rt5640_quirk)], aif,
 		 lineout_string, headset2_string);
 	byt_rt5640_card.components = byt_rt5640_components;
-- 
2.43.0



