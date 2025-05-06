Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134C220F23;
	Tue,  6 May 2025 21:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567447; cv=none; b=DeDbfdOy+ExdW8OrhmCqFQgFX96+o8/DEW1Jp/QwL+Vr6/A9Kly5tDQ7XNm1Q9EH9eSn8WguMmA4YrtW1Jvneh+EJi+EX3jiuSZ60USBgkjh1eD150jI69MkY94FB5UCE9W0/byHzhs2apVg3Mx+zVrxI1I4IkLp3IJpYbiZ3GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567447; c=relaxed/simple;
	bh=nh5sgCwbmBgaLzSmEHQegDwA+CqYdpX911aZWYlNnE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g3ACoHyXAUkcLwwdohWFnzq1iOXa0Gr+22/+X215oN76nTOOckT3WMUS0wfOmQ0T2eHeL2j/agP8Q3WP/F88ChBVemjAn6OSg7mKJIHdNR8wD++4680uFR+NqCGJR0fR3aEqY0XaGOa79+12GQ7wRmAPScOiihBjYNVEXB1fS0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0AqCLXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0AqCLXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04DCC4CEE4;
	Tue,  6 May 2025 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567447;
	bh=nh5sgCwbmBgaLzSmEHQegDwA+CqYdpX911aZWYlNnE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0AqCLXxhcv0eIM6+MFAJprogDjRi1VTlKjcJNaZclys2nofxUgcODiEPffYCKsC2
	 bvYb54lPfK8P12PYvNXPPY8nhVzEh/MIbwuCbTbqPyl3aufq5kW/FkClS5yXjxMFRl
	 6eqrXmIF/tuIYa+jlcRPk3Z5ca5TcHZGekhxlLKFqK/ZshmwQHd7IIf2KOWR0jp9cG
	 9jCVj2Pmzwt9iLgjCkQ+VroFL/P2kRJC7Bnj8QjMboqH70cR4kLOntj6BXkBsE3tPt
	 5gi4/JfhNsxkIAajs7KftWf6P1tp3YOukU3xKCAamGqiIfzFlmlbafb0utbcnPKtNX
	 DeU8EF8R4Hkag==
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
	u.kleine-koenig@baylibre.com,
	kuninori.morimoto.gx@renesas.com,
	tomlohave@gmail.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 3/6] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:37:11 -0400
Message-Id: <20250506213714.2983569-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213714.2983569-1-sashal@kernel.org>
References: <20250506213714.2983569-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.137
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
index 67b343632a10d..b00a9fdd7a9cc 100644
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

