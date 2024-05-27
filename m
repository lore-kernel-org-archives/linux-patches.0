Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB794168C4;
	Mon, 27 May 2024 19:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837571; cv=none; b=DcNIBSx17S7OgqhGPH6gQwfGMBY0oKVSSiok2ujWclK2cB/cGczzyc25X75BJ9ondvx5zvXw4UkhCb9aObyOvlAlfOdCzBoD7f//OY5Wvg7emk2iyAdy3/KMh1OErWg8LTmI/bsW1HyQBJNUFeUzjtmlAvJOojNEa3ahBj+6/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837571; c=relaxed/simple;
	bh=ltqszpaEtrYTv8NfJvYsN3scVWE9/Bz6PsNDdL8o8c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErOEqX2xEsa5HQGs7OLviOM0igDLpSChiziDP+QUbw4nVBEuFTJgamW9DzkOWUtUufWuT2dHCejtDMM/Kfka9kzLeHyfgdSboNMOYoHPhwktCceSy3i9OxOSRbGiNWEj8xscMxKBtW6R9dJcV1vgXvPdizCcqVqIDqZJE6WaOxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5T2NIBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5T2NIBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF7C2BBFC;
	Mon, 27 May 2024 19:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837571;
	bh=ltqszpaEtrYTv8NfJvYsN3scVWE9/Bz6PsNDdL8o8c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5T2NIBeDZ0jd4hPhHYNVsUuc3imuzsWifqIJJf2PSwPHskK+kTanZPXXu5ilWBKy
	 IEV+SyCLJAhGaWIgkTf4MewLhi8mU10TMFFF9Jnv+KfjvP6iVdR5gppgNkdUaC+SVu
	 KwrKZKrHRw2cYPZvMjaTy7JRA2We2Vcb0Djij2tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/493] ASoC: Intel: bytcr_rt5640: Apply Asus T100TA quirk to Asus T100TAM too
Date: Mon, 27 May 2024 20:51:04 +0200
Message-ID: <20240527185631.582380140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e50729d742ec364895f1c389c32315984a987aa5 ]

The Asus T100TA quirk has been using an exact match on a product-name of
"T100TA" but there are also T100TAM variants with a slightly higher
clocked CPU and a metal backside which need the same quirk.

Sort the existing T100TA (stereo speakers) below the more specific
T100TAF (mono speaker) quirk and switch from exact matching to
substring matching so that the T100TA quirk will also match on
the T100TAM models.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://msgid.link/r/20240407191559.21596-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 05f38d1f7d824..b41a1147f1c34 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -636,28 +636,30 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_USE_AMCR0F28),
 	},
 	{
+		/* Asus T100TAF, unlike other T100TA* models this one has a mono speaker */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TA"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TAF"),
 		},
 		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
 					BYT_RT5640_JD_SRC_JD2_IN4N |
 					BYT_RT5640_OVCD_TH_2000UA |
 					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
 	{
+		/* Asus T100TA and T100TAM, must come after T100TAF (mono spk) match */
 		.matches = {
-			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "T100TAF"),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T100TA"),
 		},
 		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
 					BYT_RT5640_JD_SRC_JD2_IN4N |
 					BYT_RT5640_OVCD_TH_2000UA |
 					BYT_RT5640_OVCD_SF_0P75 |
-					BYT_RT5640_MONO_SPEAKER |
-					BYT_RT5640_DIFF_MIC |
-					BYT_RT5640_SSP0_AIF2 |
 					BYT_RT5640_MCLK_EN),
 	},
 	{
-- 
2.43.0



