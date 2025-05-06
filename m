Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD9323BCE2;
	Tue,  6 May 2025 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567494; cv=none; b=qCa9dAJIU5Iff27F41R4nf1h7CH3DFGfW6ItRyj6g9HdNoInx2G+kFvnsBjFC9bP4mRZ0R97F7MSWN3CVNKJTMDI80V6pQRFflGHstK4X6sC1FjFhbZy+AixG3KVCeELxhlblgFj+QGr8gikWyK8wxTpUcMClrwNwSnby0C5KMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567494; c=relaxed/simple;
	bh=aDnm7huKJa/z0lTuguOsNvR4miZcaH7iiLuQTxG1HzU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R90M3ahN1Zh9AY5RH05g0SI5fp+poJBAmrVhIFUuCOxAGtJPkSRl1LcaMhYWQB1/ONMVR+fmutZ5/sKIlhfxj5Wuh94VDCMX5WqIvSErmQ5LU4GQk3gJA5KP+lV66mUhlkmf9aJKZWrHKtZGjt/52ZXK4oRRnHICaKxEQhVmnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/VxsXju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/VxsXju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0404C4CEEE;
	Tue,  6 May 2025 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567493;
	bh=aDnm7huKJa/z0lTuguOsNvR4miZcaH7iiLuQTxG1HzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/VxsXjurL472YzgFpDA9SGtD0p9EuZ4Bq1W30r4a/ieNqaCxKWVSBsnNp2Qq8rEn
	 1/j2XHPHp7lTIk1ZvFd+YWnvuDhmZRUX5GDMR+SICSwegZXLw9FKCtZN42MawqzDDr
	 IjMF1XiBBjGdmC3arglYDr2NT9Pk49kJDltt/ILgp9u0LXCX9tn2oi+Zcki1SKnbXL
	 rwZ9/uvYM4yw5c/Pspsk3UKYl782LI8VbpYxLK8A51tc3IeTC30dtCqwn7697WzzzN
	 sV6rI4b2tz/IOxT45h4LE0a3HUwslnaCxFDFDxQYr1ooL/98jG49vuCs3eFiGhuNKG
	 sBlUXsF4tycJw==
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
Subject: [PATCH AUTOSEL 5.4 2/3] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:38:04 -0400
Message-Id: <20250506213805.2983809-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213805.2983809-1-sashal@kernel.org>
References: <20250506213805.2983809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
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
index 104cfb56d225f..5a8e86ba29004 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -428,6 +428,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

