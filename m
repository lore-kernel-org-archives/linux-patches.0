Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6753FCB3F;
	Mon, 20 Apr 2026 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691596; cv=none; b=TlmWFZRbbgW9OakvzM+9TRjsXFw01hnx85HnKiiZswPwfo5fuu6ufojTJLjwM0NJ0X542E6wHMj4RbbclF1vC5ZG4EJGzSlW86Tlgng+iwjBhrR+YsbBShAIjfeVTgVmhd0qY7A6CTEhRVsDNMIddIyeO+G62rrjuFoygJf3WLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691596; c=relaxed/simple;
	bh=V+alE2lt89EW7uBktHMOkU7hkJ8KnMV77nCZ9lz/DPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFNvDs220MHd+Wxp9vkuDjPudidKXZMdbbDVPoBCCoJJiVOj+MRgxRy9V87X54KcQYEmb6oov8GFt2apn5bqC0joabTQ9VirisueNcSiGoluF28Ttoo2CG1ibO+e1uYDMhqdMTcAtb6Cnajf1SEAG8anO9EkvJDZcw7blEdInf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eivn99xw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eivn99xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ABBC2BCC6;
	Mon, 20 Apr 2026 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691595;
	bh=V+alE2lt89EW7uBktHMOkU7hkJ8KnMV77nCZ9lz/DPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eivn99xwL/8acIpU2hnHtBK8d2ttVMChQgpxiXgSZvTJKtBK4fYB9sVZD26J68m2t
	 QKPvQILQi5iTcCyWwonk7KNJX947/NiGxTHSMH6umVqESRex3gvATLtGzmKur0ZGdn
	 8x8wqzj5WfyuEpvhtBG9pzhRvbqMQV02Rccv7I/LluJCDEvnry4AQkh/ZWRKYZjR/9
	 Qf63xhq9j7O8nLdMDY+/f5CtxoPV9TIidCR8QI5M1ooBmOl4+hMT8jmPqGLYzPoBPo
	 4cQ0zz6nvx3kAxeE25B6HdO6kve2YQNwE8m6ODmA+hR9jliFOk2ib8ZHXtHCWRwLzu
	 /2LUK5pU6wQdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	superm1@kernel.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: amd: acp: update DMI quirk and add ACP DMIC for Lenovo platforms
Date: Mon, 20 Apr 2026 09:18:36 -0400
Message-ID: <20260420132314.1023554-122-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit 6b6f7263d626886a96fce6352f94dfab7a24c339 ]

Replace DMI_EXACT_MATCH with DMI_MATCH for Lenovo SKU entries (21YW,
21YX) so the quirk applies to all variants of these models, not just
exact SKU matches.

Add ASOC_SDW_ACP_DMIC flag alongside ASOC_SDW_CODEC_SPKR in driver_data
for these Lenovo platform entries, as these platforms use ACP PDM DMIC
instead of SoundWire DMIC for digital microphone support.

Fixes: 3acf517e1ae0 ("ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260408133029.1368317-1-syed.sabakareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 504b700200660..2b2910b1856d5 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -99,17 +99,17 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YW"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YW"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YX"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "21YX"),
 		},
-		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+		.driver_data = (void *)((ASOC_SDW_CODEC_SPKR) | (ASOC_SDW_ACP_DMIC)),
 	},
 	{
 		.callback = soc_sdw_quirk_cb,
-- 
2.53.0

