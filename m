Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E0436A01A;
	Mon, 23 Feb 2026 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850299; cv=none; b=J45sqqFxo02QsiDSxiEoSuBx5pKaddmsgu3bglxJjuXB8a0E/96oZOkkhPASN6mqtrsBruKxFu5p/tSvm5PRuJBa3VEnPSNMed+KmsrFa9Dfjqyl4deZBbdU1ha3Z9W1iAxxYn0B10IYm2o4DHplUt1pyAy66cSZ6OQN6KE0WH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850299; c=relaxed/simple;
	bh=Fo2TTCrL23JTnvwLSa7O1VY0MTzUpKoJ14wxo0Y86/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLe+M0Tra9Wk5BjLzKFU+pIeVFFFMdyi4qKRCD4jnPUcyk0lo7F15oUZABRcXYzA1kfLZ59LEPJq93MUOHvsQPdi2QNBs8f0DKPLs2CRuYm8c39VmVlSPgeLjnx4E0s8yxOmFVS9PRt3W5jcpNe6z4HxjXhDZyAs0SmvRqA/OuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXkR6Fng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXkR6Fng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF755C116C6;
	Mon, 23 Feb 2026 12:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850298;
	bh=Fo2TTCrL23JTnvwLSa7O1VY0MTzUpKoJ14wxo0Y86/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXkR6FngxlrOrxEvIR4WMnWImxbWLJj5hbnnN/tYX/RnrMkfSlYaiN47FUC1dFoaz
	 jrFceP+wZwKAokeSSiQc5hGuHAk1nTkKfpyQ0WnPfSOPI7EPEerfqY4Lpikvp6AV9S
	 MXvidabOzXfWRidFTwVdvO0gwOTwpLNt1KdScGY0rbIOuFcm2kNSb7545+kSjHM6nO
	 buw/Y+5JpTGa7xJ+d1EShwa4dGqNmVZz5GTrddy98YP7rUmLhEoezwqckdkwgspy5F
	 P4/0AX1kk/p6Gl02woq1ucxg1Uu+B6tJ7jsTMSGUa8KpgXxlmKuml1KF80ttNFInva
	 qnm2ezCCLp3Ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models
Date: Mon, 23 Feb 2026 07:37:31 -0500
Message-ID: <20260223123738.1532940-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 3acf517e1ae05ef66561b7a2782690387ce46e21 ]

This patch adds a quirk to include the codec amplifier function for Lenovo
models listed in the quirk table.

Note: In these models, the RT722 codec amplifier is excluded, and an
external amplifier is used instead.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260218104734.3641481-3-Vijendar.Mukunda@amd.com
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Summary
This commit adds two DMI quirk entries for Lenovo laptop models (SKUs
"21YW" and "21YX") to the AMD SoundWire legacy machine driver quirk
table. The quirk flag `ASOC_SDW_CODEC_SPKR` tells the driver that these
models use an external amplifier instead of the RT722 codec's built-in
amplifier.

### Code Change Analysis
The change is purely additive - two new entries in the
`soc_sdw_quirk_table[]` DMI table, following the exact same pattern as
the existing Dell entries. Each entry:
- Matches on `DMI_SYS_VENDOR` = "LENOVO"
- Matches on a specific `DMI_PRODUCT_SKU`
- Sets `.driver_data` to `ASOC_SDW_CODEC_SPKR`

The change is 16 lines of addition, no deletions, no logic changes.

### Classification: Hardware Quirk
This falls squarely into the **QUIRKS and WORKAROUNDS** exception
category. Without this quirk, these Lenovo models would attempt to use
the RT722 codec amplifier which is not connected - meaning audio through
speakers would not work correctly (or at all) on these laptops. The
quirk tells the driver to use the external amplifier instead.

### Stable Kernel Criteria Assessment
1. **Obviously correct and tested**: Yes - follows identical pattern to
   existing entries, reviewed by AMD maintainer Mario Limonciello.
2. **Fixes a real bug**: Yes - without this, speakers on these Lenovo
   models won't work properly.
3. **Important issue**: Yes - broken audio on specific hardware.
4. **Small and contained**: Yes - 16 lines of table additions only.
5. **No new features/APIs**: Correct - just enables existing driver
   functionality on new hardware.
6. **Clean application**: Should apply cleanly as it's a simple table
   addition.

### Risk Assessment
**Extremely low risk.** The entries are DMI-matched to specific Lenovo
SKUs, so they cannot affect any other hardware. The pattern is identical
to existing entries. The worst case if the quirk were somehow wrong is
that audio routing would be incorrect on only these two specific models.

### Verification
- Verified the diff adds only DMI table entries following the exact same
  structure as existing Dell entries in the same table.
- The `ASOC_SDW_CODEC_SPKR` flag is already used by multiple existing
  entries (Dell SKUs 0D83, 0DD3, 0DD4), confirming it's established
  functionality.
- Reviewed-by tag from Mario Limonciello (AMD) confirms subsystem
  maintainer review.
- The file `sound/soc/amd/acp/acp-sdw-legacy-mach.c` is the correct
  location for these AMD SoundWire quirks.
- Could NOT verify exactly which kernel version this file was introduced
  (unverified), but given it's in mainline and the pattern matches
  existing entries, the prerequisite driver infrastructure exists.

### User Impact
Without this patch, owners of these specific Lenovo laptop models (SKUs
21YW and 21YX) will have non-functional or incorrectly-routed speaker
audio. This is a significant usability issue for real hardware.

**YES**

 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index fae94b9edd5a3..4f92de33a71a0 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -95,6 +95,22 @@ static const struct dmi_system_id soc_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YW"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
+	{
+		.callback = soc_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "21YX"),
+		},
+		.driver_data = (void *)(ASOC_SDW_CODEC_SPKR),
+	},
 	{}
 };
 
-- 
2.51.0

