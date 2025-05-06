Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112D239E61;
	Tue,  6 May 2025 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567480; cv=none; b=ab5vgYGI9OeRf3qUkkI3QMr+Rv/CwafWQf0P0/8eYoBsvUHqBrDlKYJ6tgfTxZ3BiPnHpq6EqeoXP+e794dtkJ0eZ7hu29oP9P2NfMfQxhkyJgNRKBPP2mIIrPBKm6pMS2L5KsL7gAk9QfrDusyNnxPs56KjhLYb29OUDUNVeyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567480; c=relaxed/simple;
	bh=QUTgaCOf/gNg4xZc3yKKXX6S/s8lULioxRawr/xrOf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O78uALloP3caST8X568h5bNbRZrls+p/VS3n4ID4f3sOafgZijLOcb7Wvovt8ZdlAxB003oPUh3SBMJW5Et7COsrnNu/NLZ9+3vOln3rUbxu3vgHy1g0ZutiHc3yGpQH6fIQlIPINcVhr72LZmTwe2h4knP75wLC+yL7dn9Numc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnFYeu4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnFYeu4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE24AC4CEE4;
	Tue,  6 May 2025 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567479;
	bh=QUTgaCOf/gNg4xZc3yKKXX6S/s8lULioxRawr/xrOf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnFYeu4HZ2lSyO71B4Nn0zd4JKF5BNQ7A+0TU85pobz7+8j+tgQsHtBOdieTJwWUq
	 YVM3rw5sVw6/SvHNyeIfe6iM/5P0hkRU2wwJmi0/6HxX61QUjEZZF0LqOPnNB7qzoq
	 9YVYtIGb8cc+tM26Ie46safDzpInFTjXFUETB0uMUy/eBNxT/zahJERrhsAR/q1hOj
	 M+d1Z07+cow8l+HIlwfy3s1jWRIlqu2zOviiwu7k8/fNjUnc7nbgQaShpmWH9s9mi9
	 hPDgmeRnl56BLwj1ixQ7Lne4573zUe8sKKj3Dv9PBxuMIbBcxtQEtTUIIxLNW277KY
	 m2euE48uT8Yow==
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
Subject: [PATCH AUTOSEL 5.10 2/4] ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013
Date: Tue,  6 May 2025 17:37:49 -0400
Message-Id: <20250506213751.2983742-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213751.2983742-1-sashal@kernel.org>
References: <20250506213751.2983742-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.237
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
index 06559f2afe326..b4b2781ad22e8 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -431,6 +431,19 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
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

