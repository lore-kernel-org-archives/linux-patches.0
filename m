Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2F622DA18;
	Tue,  6 May 2025 21:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567422; cv=none; b=kWa9S6T0pT5701rqrW72yBN0ZJP8AxE+LeAmkkoc1Kn3p4QqMlwMvexXwW6l+ZhO7BAZNaLcsd96j+wKq9bCqItS0gvvIc3oi6S8gYI/kX58W+0YhjndMPK60nKStSuEoZOhXyK1kc4HHyurHhPBpfVE9+xSl0JgfYx8AagAwYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567422; c=relaxed/simple;
	bh=gCQtUy2FXFpyFzd/xZBO7QA5ttv7YMPT9eMgP4La28s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mxXTDpMLBflE5x/5jZlEtyTGDqbt2406ghKLK5+YhJSAdmQI6QhBlOJCPy8Sfffseak4v2qrVDeiJIQmIOLTrUT4ksHOgpLphBJoDbMf4/BmcCwqIJ2Pf7vczCW0FYbwZyEHrVhRNsifkO7LZlX2pOVIM1q8VDAVhglMh595Hac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/Pkucn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/Pkucn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFD5C4CEE4;
	Tue,  6 May 2025 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567422;
	bh=gCQtUy2FXFpyFzd/xZBO7QA5ttv7YMPT9eMgP4La28s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/Pkucn3nb7h3P87gjlRMAC8FoOfUZcDbpeYyCeK7m+2qKLmE53yoOqPn7ID6h7FR
	 7R59dTmEtvxdtL9TTJL8ZH6mdQnEz8NL8EPEYvEgkaY7N6D2rFbt4xZhYmawIwzvIi
	 3+T22QBQGYIKk6Bzc4LaVacGkNocaSVX2U2w6942JIAvqM3r8ka0cQLvKVmeR7SgiX
	 qy5hgW6uqKakUsytUb4IaC2syewu3lFSDsVqAA+/1p5wV/9ReQ0BZUl9+Bq6ZPcRag
	 0DBOWKSyx8P/vjMWEYU+2ERsAOV8xsHZYXWqq5Yuit0B+Vi1r1pM6spDG6aiDCaO78
	 j13IjI9OWeT7g==
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
	u.kleine-koenig@baylibre.com,
	kuninori.morimoto.gx@renesas.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 05/12] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:36:40 -0400
Message-Id: <20250506213647.2983356-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index ce80adc30fe94..6a85e8fdcae64 100644
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

