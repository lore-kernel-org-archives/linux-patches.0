Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8867B21D5A9;
	Tue,  6 May 2025 21:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567344; cv=none; b=b1gPIbeuSawm53RQRgHvwPWYt6sZAkDftUoQspPHCbHx7GDNETrqSKVs0Y15sWumkC1EZZGXp+7xJpjuxPECMyd0b9tM/XAmkG4eegTiQHYsxyg0OidIisJOd9TgY3PelXh/OD4K0X2JvRCpNxXQxewN39DurKWSJzjWmMTHXvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567344; c=relaxed/simple;
	bh=wMCRLTcKc3wDEACXR9SAtYR59RHA7zLX2Tt7/4e1Pag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qQt6Ak6F/GGbEi7cirkCiH5YNFRPzne3KJlUNsSdI3NCp2Jf1ZQvOS7+D0e1EdhxvMxGb8vzgkCd8IE09CfMAEiDrOT3HzZpC2BJHCknnBA22SGm1VcCsjfpnKkUG5H7G6AzeHfN31l5NcD+XVolxyBHfWCnBEbh1nG/h5TzFeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qu4rStFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qu4rStFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFB9C4CEE4;
	Tue,  6 May 2025 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567344;
	bh=wMCRLTcKc3wDEACXR9SAtYR59RHA7zLX2Tt7/4e1Pag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu4rStFKQQ+s1C5bzt2k3YI9MXKcTa5GfAFdyZJDT+J5amAoQzD7aEBqAXpg76XaA
	 r6HJo8wAinzlaRxFwXkRJOjWbcYCwZ5PPIut3u8b4wZ4FoldB4aBZBdX69n6HH2XrK
	 qeQssYlb/1rViscIRLYCa1UeI8IoMlS2UujcExCTXXq+UA46sV2NylVm04n7zDQES3
	 6I77nO6rrv9SNHQJVEuc+AgSL32CywgIrSp7ZE3IHnuCqnNbE3zlJnB6Gxw+i+Srbf
	 aO7PMVzBg90Rz33rxcOjNJFJAVheTT/yCpdIdt09p0EcjXLxIAqLg5R5VgWNHw5ts4
	 uzKuDbaImryxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	hdegoede@redhat.com,
	pierre-louis.bossart@linux.dev,
	kuninori.morimoto.gx@renesas.com,
	u.kleine-koenig@baylibre.com,
	tomlohave@gmail.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 09/20] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:35:12 -0400
Message-Id: <20250506213523.2982756-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a549b927ea3f5e50b1394209b64e6e17e31d4db8 ]

Acer Aspire SW3-013 requires the very same quirk as other Acer Aspire
model for making it working.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250420085716.12095-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 6446cda0f8572..0f3b8f44e7011 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -576,6 +576,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{       /* Acer Aspire SW3-013 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW3-013"),
+		},
+		.driver_data = (void *)(BYT_RT5640_DMIC1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-- 
2.39.5

