Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5450E220F49;
	Tue,  6 May 2025 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567465; cv=none; b=odwaI4LFQgTKMypuoHCtQ+lTcp1g/yR/kgmm5yw1JKquq0vlDaoog0Xt9Hfz00PSqhEdyoN+YbwwB3tpIdvJSP49RWUPeVfjSsuT8hlbVGwBCQyFU1vjD7SGZBhPqmeC4D9z/I2ufDPQhWk58qGh22SUTlJTB1GuWSvhmb1C8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567465; c=relaxed/simple;
	bh=qGx8MQ+e85kv2jkI5StnipDH0UHucdAD1pRSwU0WMbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XS1O/03wsR55sxvoAQ2vNg+shWoeAI7r/c0qshjfJZqXmZwkNaS/2s1d/2sVPi1mToGxG3VDluZ46WofflJiOpzOZw4VrP9izTJXoMcIF8rY3TRWppYlHr6sa4NvxESrOzKNwq8oCvMUz2A+SYtkFWQcYI7gUOf6A0GmOvgXVsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlEWJ8Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlEWJ8Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6B0C4CEE4;
	Tue,  6 May 2025 21:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567465;
	bh=qGx8MQ+e85kv2jkI5StnipDH0UHucdAD1pRSwU0WMbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlEWJ8Ssgs850rz1Zh49P2FEmi3I9pkAJstaNuuAgO4kE7TlcTLkZVCTjqgQVW3QB
	 SJs4zYwgybxA0OcXbWdTvDIRZrEhfnKcJI6rM1gMsJKjDje1oWP5HuXpsvbEuYJIIE
	 IdcF94CV7Wd4H59V9D1EmmSWzJizAe2Tb3smua9MBTWsVo7hFH5dA6q0PLCccCG3j6
	 Zmdyu1ylfF/pJSi9P4Sjub+0wkeon9FIjNqv36Z491p/QbeiJby8yf817o9VuTOs0l
	 bU6jfvm7EOjtFuvqWOaIx5p43mSw7MOP4Aa0I+gGxC+JEHWL+pAu2s/CR+fxW1X3PB
	 ZQORizX5n5jiQ==
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
	tomlohave@gmail.com,
	kuninori.morimoto.gx@renesas.com,
	u.kleine-koenig@baylibre.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 3/5] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:37:32 -0400
Message-Id: <20250506213734.2983663-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213734.2983663-1-sashal@kernel.org>
References: <20250506213734.2983663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
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
index 721b9971fd744..4954e8c494c6d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -573,6 +573,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

