Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC82556E;
	Sat, 14 Feb 2026 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031198; cv=none; b=nUqETCG3dVEThy7IqviX9so+PDseImjp+7Cig/6HbQyzebbzX55LSqr+Hhe1cpqjpNmm/Db/FQeQ2n/3H2Q1wjzLKxIisaDsjUTSuKxdDG1IJT7actYF1b1MvlvejdqNloL25POJtZbi9fx7uhIaIP8E9xrKW6rSK8hZCpHjlTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031198; c=relaxed/simple;
	bh=aV4vdTfh7NaQIzqqYJd97kNC2fRQTqKLlWe4N7Z25sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMX4CCvx+2MXPhihh0YekwQ13BEaIN3SdSI0OEfo+X8gtX7UODxUgL23Jg2c1OMIRig0qHWQBuTUAtBgHWAKYdFI1HkDskIDZgYXb2U/JvrwzaOqIZmIlHYCyjwkzzLfVRHtCIR6k8jnNOSQFQFWt1alz1i8CDTerro0FOSIMrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byIpMeh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byIpMeh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE07C116C6;
	Sat, 14 Feb 2026 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031198;
	bh=aV4vdTfh7NaQIzqqYJd97kNC2fRQTqKLlWe4N7Z25sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byIpMeh4Kxudlolgt9KUiCdnEnjb7Uvkp+2AoD3LpzpGd2UGbdHxAOE9AdJ6ThohF
	 P0nltyEgeLakHbm8OY2D2skFf6Rt36E0BdIb8rCdzaLc1dBp/7hNuZclzhTuX7HV7A
	 IgU/WCwnRpXWJQKjA/79K0cpCK/0ZOKjmQlgpBH8T78Evk2+iFyQjYpk9IKRYWWplY
	 sxWsupTIsIg4t7uCI9TCiDZ7BFEQxXoStHTajtkQG+w4xT6aUzu0EhbBEuImdKF/XN
	 TArkPNv5JPHMvFW7lPL/l0dalEo0cZxq4ICpijF8nHIX4BZsv0okxI2W47YrXJjRjc
	 MK4dPpDTkjNyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mac.chiang@intel.com,
	balamurugan.c@intel.com,
	peter.ujfalusi@linux.intel.com,
	naveen.m@intel.com,
	yelangyan@huaqin.corp-partner.google.com,
	simont@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.19] ASoC: soc-acpi-intel-ptl-match: use aggregated endpoint in ptl_rt722_l0_rt1320_l23
Date: Fri, 13 Feb 2026 19:59:38 -0500
Message-ID: <20260214010245.3671907-98-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 4fbd3b2ec04dc6ef93090ec24733a5c5671fb71f ]

The rt722 amp and rt1320 amps are aggregated in this case.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260119091749.1752088-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit changes the `ptl_rt722_l0_rt1320_l23` configuration to use
"aggregated endpoint" instead of "single endpoint" for the RT722 codec
on link 0 when paired with RT1320 amplifiers on links 2 and 3. The
commit message is brief: "The rt722 amp and rt1320 amps are aggregated
in this case."

### Code Change Analysis

The change does two things:

1. **Adds a new static data structure** `rt722_0_agg_adr[]` which is
   identical to `rt722_0_single_adr[]` except it references
   `jack_amp_g1_dmic_endpoints` instead of `rt_mf_endpoints`.

2. **Switches the reference** in `ptl_rt722_l0_rt1320_l23[]` from
   `rt722_0_single_adr` to `rt722_0_agg_adr`.

The key difference is the endpoint configuration:
`jack_amp_g1_dmic_endpoints` vs `rt_mf_endpoints`. Let me understand
what this means.

### What Problem Does This Fix?

This is a configuration fix for SoundWire audio topology on Intel
Panther Lake (PTL) platforms. When the RT722 codec and RT1320 amplifiers
are used together in an aggregated configuration, they need to use
aggregated endpoints (with group information) so the SoundWire bus
manager can properly synchronize audio streams across multiple links.

Using the wrong endpoint type (single vs aggregated) would cause the
audio topology to be incorrectly configured, potentially resulting in:
- Audio not working at all for this hardware combination
- Incorrect stream synchronization between codec and amplifiers
- Possible audio glitches or failures

This is essentially a **hardware configuration fix** - the wrong
endpoint descriptors were being used for this specific hardware
topology.

### Stable Kernel Criteria Assessment

1. **Fixes a real bug**: Yes - incorrect endpoint configuration for a
   specific hardware combination would cause audio to not work properly.

2. **Small and contained**: Yes - adds one small data structure and
   changes two lines to reference it. Very localized to one file.

3. **Obviously correct**: The change is straightforward - using
   aggregated endpoints when devices are aggregated is the correct
   behavior.

4. **No new features**: This is a configuration correction, not a new
   feature.

### Concerns

1. **Platform maturity**: Panther Lake (PTL) is a very new Intel
   platform. The `soc-acpi-intel-ptl-match.c` file contains match tables
   for this new platform. The question is whether this code even exists
   in current stable trees. PTL support was likely added in very recent
   kernel versions (6.12 or later), so it may only be relevant to the
   most recent stable branches.

2. **Dependencies**: The `jack_amp_g1_dmic_endpoints` and
   `rt_mf_endpoints` structures must already exist. Since this file is
   already using both elsewhere, there shouldn't be dependency issues.

3. **Risk**: Very low. The change only affects one specific hardware
   configuration (`ptl_rt722_l0_rt1320_l23`). It cannot affect any other
   hardware.

### Classification

This falls into the category of a **hardware configuration fix** for
audio on a specific platform. It's similar to hardware quirks - it
corrects the configuration for a specific hardware combination to make
it work properly. Users with this specific hardware (RT722 + RT1320 on
Intel PTL) would have broken audio without this fix.

### Risk vs Benefit

- **Risk**: Extremely low - only affects one specific hardware topology
  table entry
- **Benefit**: Makes audio work correctly for users with this hardware
  combination

### Decision

This is a small, well-contained fix that corrects incorrect audio
hardware configuration data for Intel Panther Lake platforms. It's
similar in nature to device ID additions or hardware quirks - it makes
specific hardware work correctly. The change is low risk and high value
for affected users. However, PTL is a very new platform, and this fix is
only relevant to kernel versions that already have PTL audio support.
For those versions, it should be backported.

**YES**

 sound/soc/intel/common/soc-acpi-intel-ptl-match.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
index e297c8ecedb72..1055fb4838f61 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
@@ -383,6 +383,15 @@ static const struct snd_soc_acpi_link_adr ptl_rt721_l3[] = {
 	{},
 };
 
+static const struct snd_soc_acpi_adr_device rt722_0_agg_adr[] = {
+	{
+		.adr = 0x000030025d072201ull,
+		.num_endpoints = ARRAY_SIZE(jack_amp_g1_dmic_endpoints),
+		.endpoints = jack_amp_g1_dmic_endpoints,
+		.name_prefix = "rt722"
+	}
+};
+
 static const struct snd_soc_acpi_adr_device rt722_0_single_adr[] = {
 	{
 		.adr = 0x000030025d072201ull,
@@ -536,8 +545,8 @@ static const struct snd_soc_acpi_link_adr ptl_rt722_l3[] = {
 static const struct snd_soc_acpi_link_adr ptl_rt722_l0_rt1320_l23[] = {
 	{
 		.mask = BIT(0),
-		.num_adr = ARRAY_SIZE(rt722_0_single_adr),
-		.adr_d = rt722_0_single_adr,
+		.num_adr = ARRAY_SIZE(rt722_0_agg_adr),
+		.adr_d = rt722_0_agg_adr,
 	},
 	{
 		.mask = BIT(2),
-- 
2.51.0

