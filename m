Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F4339866;
	Thu, 28 May 2026 20:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998960; cv=none; b=BMSyrlfc54C0EE9IBkR/m6y7/PA/OH1D2Bu4OYjgBtdAvC51Aal1Nj3h7Kw2XfOArG5bEAXE/zTpW1BUd3svvfh+SYmBpLXRXq3eWnJNPc+v6eT1BhM5HBABu8g45RLS1AtgTwfmgKQECc8YAsVUKLPXp2g5ZQL7ElJCS2xEg7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998960; c=relaxed/simple;
	bh=rxt14rpBNI3oh0K90w/idAjb8oIGGFNbADRdzAc/CU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4Eiz4xu+lasIAalzyQrD/w36h+oRxogfrDZY1iK8BU0gytFv/5OnSRq8oZThkeNO6cs/cpTgs7huTFsrj9a1hrtqiBrQ/njmiex470OvMTTOeVVwD3DQlKPgbNsAbRPt0ou7tnoEO5nFehL9ZPANd6gDJWSs3eI3wc2vzLAXKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eviIgvwu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eviIgvwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17B21F000E9;
	Thu, 28 May 2026 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998959;
	bh=7V2aICeyqdwYPi3mrju7GFi+Kpb3yY1UjQlS3nORNTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eviIgvwunurIXilBhzf0za2L0/QQlJ5AjPfWCNPTL3uNBZbSLdILB+92Bxdu61pJf
	 TqYouCe9W2Ehp2wCn2caa1mdmeUC+XwMBNx0OHka9ktYDknHNVJIDXpS4jzU5tacEs
	 etGnwVw12rcwWYhvOyf88s9jgI6FbEXiuYleY1PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 311/461] ASoC: intel: sof_sdw: Prepare for configuration without a jack
Date: Thu, 28 May 2026 21:47:20 +0200
Message-ID: <20260528194656.289638004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit d733fb463834cf97a0c667681e236fea0e833a05 ]

In certain setups of cs42l43 UAJ function may be removed from ACPI and
physically unconnected. Prepare a driver for that configuration by
setting a system clock in the speaker path too.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Link: https://patch.msgid.link/20260403082335.40798-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5a30862dec5a ("ASoC: sdw_utils: Check speaker component string allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_cs42l43.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_cs42l43.c b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
index 2685ff4f09320..4a451b9d4f137 100644
--- a/sound/soc/sdw_utils/soc_sdw_cs42l43.c
+++ b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
@@ -107,6 +107,7 @@ EXPORT_SYMBOL_NS(asoc_sdw_cs42l43_hs_rtd_init, "SND_SOC_SDW_UTILS");
 
 int asoc_sdw_cs42l43_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_dai *dai)
 {
+	struct snd_soc_component *component = snd_soc_rtd_to_codec(rtd, 0)->component;
 	struct snd_soc_card *card = rtd->card;
 	struct snd_soc_dapm_context *dapm = snd_soc_card_to_dapm(card);
 	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
@@ -131,8 +132,15 @@ int asoc_sdw_cs42l43_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_so
 
 	ret = snd_soc_dapm_add_routes(dapm, cs42l43_spk_map,
 				      ARRAY_SIZE(cs42l43_spk_map));
-	if (ret)
+	if (ret) {
 		dev_err(card->dev, "cs42l43 speaker map addition failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = snd_soc_component_set_sysclk(component, CS42L43_SYSCLK, CS42L43_SYSCLK_SDW,
+					   0, SND_SOC_CLOCK_IN);
+	if (ret)
+		dev_err(card->dev, "Failed to set sysclk: %d\n", ret);
 
 	return ret;
 }
-- 
2.53.0



