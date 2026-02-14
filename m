Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703341E5B63;
	Sat, 14 Feb 2026 01:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031230; cv=none; b=ih2jFca4lWbN9xwgUpr7XAaPduEjWwaMClETuUgu5ls8ePwIwhNa8U2/H5NV3VbonRwt3AYShcpkWN3x11+F0MOnNYy1M1rW6wpeJWadCXAnlMdCPLGriPjSUFZYXjM/tO9F4KzFCEMMEuVxR3O458APAk6RAm0lm2CyuOUO540=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031230; c=relaxed/simple;
	bh=NafloVcmETdtCDpTqdtRCZBFFO9xJExdWJzXqLVOHJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzQT6g6wQb8YfxFlkonU/cEwz/5YyU60moTTAxuxnf1DV39xrkrjTbNYTWVp7rhbmIY3rzB9Nfv80rSQ70YtWoO+5qg5xmLVkNjN1X2a59VLGpMn6H4712h8C8LnNUunpPTk79+SVAIwbxyrwewJxamB/xwnJhSt61Gf6qmxPqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ucs3nRpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ucs3nRpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3A4C116C6;
	Sat, 14 Feb 2026 01:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031230;
	bh=NafloVcmETdtCDpTqdtRCZBFFO9xJExdWJzXqLVOHJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ucs3nRpHkK5/2xwkbdQcFW22/EvOw7rnbNGJq7VS9kzbW2xdoDj7+lyvr9G7Jqszc
	 QF6ezDzgVxMJ23kBQ1OXsSPkcnQmN8kZtar/Ejme4qAGECI6Uee/zVO8mROR4bn3F9
	 v3heq6DzG9gYtOiqIzCBbOVSYPDxHSfZydfheUW9Wjq1ImMPx/B/50lftBbdNXL2L1
	 1LB5C9C8P61iDLrZSoCNxMp57rzoHucz3al8D6SSuLxBhvhEVpGir4Kd3hnNO+IDB5
	 SMjBDEM4VRJNvfscroAUFDjKAMUJ/7rHQIxF2nsR9hCAmKUwI3YHkv1eubBFoplSlf
	 4xzhqWnw7epHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peter.ujfalusi@linux.intel.com,
	ckeepax@opensource.cirrus.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.12] ASoC: soc-acpi-intel-arl-match: change rt722 amp endpoint to aggregated
Date: Fri, 13 Feb 2026 19:59:53 -0500
Message-ID: <20260214010245.3671907-113-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 08c09899960118ffb01417242e659eb6cc067d6a ]

rt722 is aggregated with rt1320 amp in arl_rt722_l0_rt1320_l2 and it is
the only audio configuration in the ARL platform. Set .aggregated = 1 to
represent the fact and avoid unexpected issue.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260119091749.1752088-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So the RT722+RT1320 support was added in v6.13. This means stable trees
6.13.y and potentially 6.12.y (if it was backported) could be affected.

### Assessment

**What the commit fixes**: The RT722 codec's amplifier endpoint was
incorrectly configured as non-aggregated (`.aggregated = 0`) when it is
actually aggregated with the RT1320 amplifier. This mismatch between the
software description and the actual hardware topology could cause audio
initialization or routing issues on ARL platforms with this specific
codec configuration.

**Is this a real bug fix?** Yes, but it's borderline. The commit message
uses the vague "avoid unexpected issue" rather than describing a
specific observed failure. However, incorrectly describing the hardware
topology is objectively wrong — it's like having wrong device tree data.
Getting the aggregation flag wrong could cause the SoundWire bus manager
to incorrectly handle stream synchronization between the RT722 amp and
RT1320.

**Meets stable criteria?**
- Obviously correct: Yes — the commit sets the aggregation flag to match
  reality
- Fixes a real bug: The hardware description was wrong; this is a
  correctness fix
- Small and contained: Yes — just a few struct field changes in one file
- No new features: Correct — just fixes existing configuration data

**Risk**: Very low. This only affects ARL platforms with the specific
RT722+RT1320 configuration. The change is purely to endpoint metadata
and is reviewed by Intel audio maintainers.

**Concern**: The commit message's vagueness about what "unexpected
issue" means makes it somewhat uncertain whether this causes an actual
user-visible failure or is a proactive correctness fix. However, wrong
aggregation settings in SoundWire can realistically cause audio failures
(amplifier not playing, stream synchronization issues).

This is a hardware configuration correctness fix — similar to a quirk or
device tree fix. It's small, well-reviewed, low-risk, and fixes an
objectively wrong hardware description that could cause audio issues on
ARL platforms.

**YES**

 .../intel/common/soc-acpi-intel-arl-match.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-arl-match.c b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
index 6bf7a6250ddc3..c952f7d2b2c0e 100644
--- a/sound/soc/intel/common/soc-acpi-intel-arl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-arl-match.c
@@ -45,23 +45,22 @@ static const struct snd_soc_acpi_endpoint spk_3_endpoint = {
 	.group_id = 1,
 };
 
-/*
- * RT722 is a multi-function codec, three endpoints are created for
- * its headset, amp and dmic functions.
- */
-static const struct snd_soc_acpi_endpoint rt722_endpoints[] = {
+static const struct snd_soc_acpi_endpoint jack_amp_g1_dmic_endpoints[] = {
+	/* Jack Endpoint */
 	{
 		.num = 0,
 		.aggregated = 0,
 		.group_position = 0,
 		.group_id = 0,
 	},
+	/* Amp Endpoint, work as spk_l_endpoint */
 	{
 		.num = 1,
-		.aggregated = 0,
+		.aggregated = 1,
 		.group_position = 0,
-		.group_id = 0,
+		.group_id = 1,
 	},
+	/* DMIC Endpoint */
 	{
 		.num = 2,
 		.aggregated = 0,
@@ -229,11 +228,11 @@ static const struct snd_soc_acpi_adr_device rt711_sdca_0_adr[] = {
 	}
 };
 
-static const struct snd_soc_acpi_adr_device rt722_0_single_adr[] = {
+static const struct snd_soc_acpi_adr_device rt722_0_agg_adr[] = {
 	{
 		.adr = 0x000030025D072201ull,
-		.num_endpoints = ARRAY_SIZE(rt722_endpoints),
-		.endpoints = rt722_endpoints,
+		.num_endpoints = ARRAY_SIZE(jack_amp_g1_dmic_endpoints),
+		.endpoints = jack_amp_g1_dmic_endpoints,
 		.name_prefix = "rt722"
 	}
 };
@@ -394,8 +393,8 @@ static const struct snd_soc_acpi_link_adr arl_rt711_l0_rt1316_l3[] = {
 static const struct snd_soc_acpi_link_adr arl_rt722_l0_rt1320_l2[] = {
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

