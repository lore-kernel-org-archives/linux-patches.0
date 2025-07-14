Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E796295528;
	Mon, 14 Jul 2025 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534463; cv=none; b=bVpAwtczStbApOwkjk+jzHRUZiDGKFOooaFIRYI2o3lxm14lxr8mmU3/bzyrBIUDNF8jwa84w9qmOYJA+HFy2jULc/A/sHQwiBGie/XZynrkKZz3fedcPHifOA68L5jsFoY3mj2+z9eX/uz5mugsSrvgdy74cTIYsfkknn9zN3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534463; c=relaxed/simple;
	bh=1kU9lnXA5F/aBk30lqfDmRfnnQdoC9xNpESB88nao8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BKEXTVoAUkuGfCV/8QckJhU1KOZgKH9LWMmL/+6oJFd0cxdWkZDZh7mGzmDFoPUy4VAQl2hZYJQHwPkbW0QzplCFF/w4IYkZlkzUeHp2f9BSq20So7GIWgaIkFtstBnUwC+98xkg6BTiyyXJlXNYkcQ9XIc37JP93b289ORVDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jlfCM7eH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jlfCM7eH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F6BC4CEED;
	Mon, 14 Jul 2025 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534463;
	bh=1kU9lnXA5F/aBk30lqfDmRfnnQdoC9xNpESB88nao8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlfCM7eHzpccjXH6mrVsqtt7J4gqWipGGuTnQL3+NH8kWkOAYgRXqwKllLJEA8lzQ
	 N3OJOFBSlXBKZqwXZtn6ztGcfsG0J9jj4c00O60fb4XThT4AlH1fUnqFRLAWGkSsGD
	 UAfvcjudlFUAhYopRBrL/QAcvCORorLJcIKzQB/1izPOfK5hSFccJxm6/DlJXVhUdi
	 UHx91MMRTA2jIB8DGAOqJN376yY7YZq6B1Duz6llOQlpj5TZQ7nHb6d8JL/rBhLy7D
	 FRh7SFYmRvCTurH2PlXrWhM1lb2gTfhVXJKN6zSi5im3K6fD/dfxTSan67NiDktHqW
	 S/AUt/T0KH64A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	pierre-louis.bossart@linux.dev,
	Vijendar.Mukunda@amd.com,
	liam.r.girdwood@intel.com,
	ckeepax@opensource.cirrus.com,
	rf@opensource.cirrus.com,
	mstrozek@opensource.cirrus.com,
	deep_harsora@dell.com
Subject: [PATCH AUTOSEL 6.12 12/12] ASoC: Intel: sof_sdw: Add quirks for Lenovo P1 and P16
Date: Mon, 14 Jul 2025 19:07:15 -0400
Message-Id: <20250714230715.3710039-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230715.3710039-1-sashal@kernel.org>
References: <20250714230715.3710039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.38
Content-Transfer-Encoding: 8bit

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit f7690d058170dbc1520b0bfbc3d9daf046b59326 ]

These Lenovo Laptops have the DMICs connected to the host instead of the
CS42L43 and so need the SOC_SDW_CODEC_MIC quirk.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://patch.msgid.link/20250702112235.377479-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code context, I
can now provide my assessment:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Hardware Functionality**: The commit fixes audio
   functionality on specific Lenovo laptop models (P1 and P16) where the
   DMICs (Digital Microphones) are incorrectly routed. Without this
   quirk, the microphones on these laptops won't work properly because
   the system would expect them to be connected to the CS42L43 codec
   when they're actually connected to the host.

2. **Small and Contained Change**: The patch only adds three lines to
   the `sof_sdw_ssid_quirk_table[]` array:
  ```c
  SND_PCI_QUIRK(0x17aa, 0x2347, "Lenovo P16", SOC_SDW_CODEC_MIC),
  SND_PCI_QUIRK(0x17aa, 0x2348, "Lenovo P16", SOC_SDW_CODEC_MIC),
  SND_PCI_QUIRK(0x17aa, 0x2349, "Lenovo P1", SOC_SDW_CODEC_MIC),
  ```
  This is a minimal, low-risk change that only affects the specific
  hardware identified by the PCI subsystem IDs.

3. **Follows Established Pattern**: The commit follows the exact same
   pattern as the previously backported commits shown in the similar
   commits list:
   - "ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S16" (marked as
     YES for backporting)
   - "ASoC: Intel: sof_sdw: Add quirk for Asus Zenbook S14" (marked as
     YES for backporting)
   - Multiple other Lenovo quirk fixes that were marked YES for
     backporting

4. **No Architectural Changes**: The commit doesn't introduce any new
   features or make architectural changes. It simply adds device IDs to
   an existing quirk table that tells the driver to exclude the CS42L43
   microphone DAI link for these specific models.

5. **Critical for Affected Users**: Without this fix, users of these
   Lenovo laptop models would have non-functional microphones, which is
   a significant usability issue that affects basic functionality.

6. **Zero Risk to Other Systems**: The quirk only activates for systems
   with the specific PCI subsystem vendor ID (0x17aa for Lenovo) and the
   exact subsystem device IDs (0x2347, 0x2348, 0x2349). There's no risk
   of regression on other hardware.

The commit is a straightforward hardware enablement fix that restores
proper microphone functionality on specific Lenovo laptop models by
correctly identifying their DMIC routing configuration. It follows
stable tree rules by being a targeted bug fix with minimal changes and
no risk to unaffected systems.

 sound/soc/intel/boards/sof_sdw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 5911a05586516..677e78ac151e8 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -689,6 +689,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x2347, "Lenovo P16", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x2348, "Lenovo P16", SOC_SDW_CODEC_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x2349, "Lenovo P1", SOC_SDW_CODEC_MIC),
 	{}
 };
 
-- 
2.39.5

