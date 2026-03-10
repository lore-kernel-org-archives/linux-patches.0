Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34DA4534A2;
	Tue, 10 Mar 2026 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133343; cv=none; b=ZSIadmyru+A9CpnwfGuoF0ObO6/NTG9Tma4pEowlsHXnXIsdVaH28l36plIRa+aXZYY01+ptpQy7PbAG5X0AVFLiyYL29CCagePKTZ0Wo+gmRj3z41ZYx3BRR2dyNHAGTb5RxCC9wOQfGQrkitFAwKBvgjczTwXFyKZ2FybqnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133343; c=relaxed/simple;
	bh=0X3TJTI4Em9E0FN9ZgAJt3kvFeYp/2AMj6SxzZdNyqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUHy+H1UfnlSPTpuOIZ3484h2HB/YK4ZSln77MM2GX2kbiGelmy15TJ2Xt9WnTjI9mGdI//jP+3k+GFs6o6vnylYd0MAg7JEc8DC4HfrJ7e4L3cO9UftFGeO2RBu02XCmrPXFlq3hmTk9ZcbQZHZ6aNuqZvGDWZmZW0sa4gfgzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCJwjgOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCJwjgOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB2C2BC86;
	Tue, 10 Mar 2026 09:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133343;
	bh=0X3TJTI4Em9E0FN9ZgAJt3kvFeYp/2AMj6SxzZdNyqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCJwjgOCzvpl7dFzqViTfQbfVltDICuTDWVTR686Mo1ovhgr0jOjxxqZ+TRD/146R
	 4LZMquPNL3YdalCHdDH+EOsfSIfxJhPHU5VCwvHL63FTDcRb+nICjDObNmnsOlNNfq
	 ToLjVHSfAin1gHT9fyHhQa5Wf/8LNIiCn5A+MyufLyddfPM3IiiXvs7JnOivd74i86
	 1BxNqi/c0Ub9CYEoKNf3x6ZDX7evTZWNUulazVuJZ40gD2VkAUIXQwRpiU8+W4C3BB
	 oeC1bBLRkKX4hyFpt5vF+kTl0g3sH5WOS1syHAcrAgtCMNVWvBogpg2O8zbQ1q1PXR
	 RyDtrxAGPwxcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>,
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
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCD SKU
Date: Tue, 10 Mar 2026 05:01:25 -0400
Message-ID: <20260310090145.2709021-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Freyermuth <o.freyermuth@googlemail.com>

[ Upstream commit 70eddf6a0a3fc6d3ab6f77251676da97cc7f12ae ]

This adds the necessary quirk for the Alienware 18 Area 51 (2025).
Complements commit 1b03391d073d ("ASoC: Intel: sof_sdw: Add quirk
for Alienware Area 51 (2025) 0CCC SKU").

Signed-off-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Tested-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Link: https://patch.msgid.link/20260224190224.30630-1-o.freyermuth@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This adds a single DMI quirk entry for the Alienware Area 51 (2025) with
SKU "0CCD" to the SOF SoundWire quirk table. It enables
`SOC_SDW_CODEC_SPKR` for this specific hardware, which is needed for the
speaker codec to function. The commit explicitly references a companion
commit (1b03391d073d) that added the same quirk for the "0CCC" SKU of
the same laptop model.

### Classification: Hardware Quirk Addition
This falls squarely into the **"QUIRKS and WORKAROUNDS"** exception
category for stable backports:
- It's a trivial addition of a DMI match entry to an existing quirk
  table
- The driver and quirk infrastructure already exist in stable
- Without this quirk, audio speakers won't work on this specific laptop
  SKU
- The change is 8 lines of a new table entry, identical in structure to
  dozens of existing entries

### Code change analysis
The diff adds one new `dmi_system_id` struct to the
`sof_sdw_quirk_table[]` array, matching:
- Vendor: "Alienware"
- Product SKU: "0CCD" (exact match)
- Quirk: `SOC_SDW_CODEC_SPKR`

This is identical in structure to the immediately preceding entry for
SKU "0CCC" and many other Dell/Alienware entries in the same table.

### Risk assessment
- **Risk: Extremely low** — The entry only matches one specific DMI SKU,
  so it cannot affect any other hardware
- **Scope: Minimal** — 8 lines added to a data table, no logic changes
- **Tested: Yes** — The commit has a Tested-by tag from the
  author/reporter
- **Benefit: High for affected users** — Without this, speakers don't
  work on this laptop

### Stable criteria
- Obviously correct: Yes (copy of adjacent entry with different SKU)
- Fixes real bug: Yes (no audio output from speakers on this hardware)
- Small and contained: Yes (8-line table entry addition)
- No new features: Correct (enables existing driver functionality on new
  hardware)

### Verification
- The diff shows the new entry is structurally identical to the adjacent
  0CCC SKU entry, confirming it's a straightforward quirk addition
- The commit message references companion commit 1b03391d073d for the
  0CCC SKU, establishing precedent
- The Tested-by tag from the submitter confirms the fix works on real
  hardware
- The change only touches the `sof_sdw_quirk_table[]` DMI table in
  `sound/soc/intel/boards/sof_sdw.c`, no logic changes
- The `SOC_SDW_CODEC_SPKR` quirk value is already used by many other
  entries in the same table, so it's well-established functionality

This is a textbook stable backport candidate — a hardware quirk that
makes speakers work on a specific laptop with zero risk to any other
system.

**YES**

 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 50b838be24e95..0186c281296ec 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -763,6 +763,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCD")
+		},
+		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+	},
 	/* Pantherlake devices*/
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.51.0

