Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6C226534;
	Tue,  6 May 2025 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567390; cv=none; b=n9AEydlW/q64hio/OQyQ7NGETMSXugWdEuhLKxIPoEO3Ppl2BiU7LLkkn+4QOmQtE/xvEzDQVp0pgK/cTp8UNyYvfI/ASBDRF7aHLEebAOwzYFwMyuhTaJlCnVfiBH0YHCBC5KGbfkOSFyXLQ/Md4C7cgGTi0yIhjzouk1JgS5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567390; c=relaxed/simple;
	bh=nlaEgpaDQBMyHvjy7zDgOKh99eHzrodD58zina0Ab+4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N5IMDuJkRknu/MdWHq4QLzKSdtJPuBAyp8ly1XELVDGGuDPFN9QSCyIEo5TEUj/BqQ7E0QHFRjB4vz/oaIsMssJq+ifTUM5pJ48bHztaZ4ETuSPiGR9Wh7wwAgI4xmA8NzPWITEx0DWABUjWcyIwvKGyHHT3AMpSdPcj3pem6oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlDJD7B3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlDJD7B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCF9C4CEE4;
	Tue,  6 May 2025 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567389;
	bh=nlaEgpaDQBMyHvjy7zDgOKh99eHzrodD58zina0Ab+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlDJD7B36wMcuETtun7ZAwjohwet3rzDsIGoTXSDuWrjuJL3NowzOspLwNcl62sjh
	 8Nc87rk/kSgQ7ApLRndOMsSCtySrlMxIX1Q/dFsi5tYBCTPpB5uHaMeubt44GCOrdM
	 m2GYFeLXXHozafANzlZ6fIcTc5502WcIaBy9ngerrvPoybU2mmANDVbXPF9HNQkv0u
	 Y4506xUO3steljWNUONs3F6l/DwXL85uFKei48dlW6gw3ScRpNqwTJrIEZe7zRkN03
	 oCUXwD2QA1XulvcPgYssPOp6hv/EVJQm+jIEVyWJEU9Jw2y65pHyNwGruaklnLFo95
	 dCMeClT6Mggaw==
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
	tomlohave@gmail.com,
	u.kleine-koenig@baylibre.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 09/18] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:36:01 -0400
Message-Id: <20250506213610.2983098-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
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
index 1148e9498d8e8..b6434b4731261 100644
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

