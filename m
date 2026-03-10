Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460543CED8;
	Tue, 10 Mar 2026 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133309; cv=none; b=RaQDobSbR5u8A9k0+P9cLtQ+CjfYpOQlTA3EoNHa+7qZedQ1sHH0BP8I9GhVd5F1/lMZzkGP5Myr/4XvaG1BK/FW1Tn2XKR25MYu4cRj/3sRLNJhybfz3nDJTaAyD87abCPMgSC9rTvM7baf5axHif6xDa5lDDxcj5jTDWZoVZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133309; c=relaxed/simple;
	bh=E9xPhaPQ+P5fGclHM43AYlGV/83k/G6SwZ4P2vVGS0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LXqZzWUcECv/IEttmoo8hh+BdDn/AqigH6TvEl7V7DF+KVyvE70nLqGD0X7sFOgir4jl75mdY5qUv8geub2KcV4IZPP36bPw51ahcwxyBbCiN6RBz9QxSjZM6qWh+Dh2YR/ae+9Mco/TnrR9e2NdnvPjoczDTfJLvBf2USpu5CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3LEspGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3LEspGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7E0C2BC87;
	Tue, 10 Mar 2026 09:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133309;
	bh=E9xPhaPQ+P5fGclHM43AYlGV/83k/G6SwZ4P2vVGS0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3LEspGD7TbE6H1821SAN2fhfm1jRyH1m/dt2OQZEUTVt3i54rElqdRhC7vq5CIq4
	 AYilJuikbAfR33g7PO8YtZpmjFJAxI4qUlUnKeFCGPxCzwJPzRazggoCNw/n1fMxj8
	 4t/YsKfpWf22IRthMBn5v8gByLYRwWb5gMLB5d2465r+lv7r5XHz7nHq7oPvfsrGFk
	 HtZJIiRmbla9BWvHQH8tI1FoytcKJ7XhSHZHoet3FBqrbE8PcB+svA0CW9gttdvCLs
	 tieE5cTvXzxYJ9aqkhPCxKYrJ0qse8wqmjRch4TFTxh2b/A7jBW1ANfGtXWGIBmMfG
	 6QGMhqPVS7WfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: amd: acp: Add ACP6.3 match entries for Cirrus Logic parts
Date: Tue, 10 Mar 2026 05:01:02 -0400
Message-ID: <20260310090145.2709021-2-sashal@kernel.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit fd13fc700e3e239826a46448bf7f01847dd26f5a ]

This adds some match entries for a few system configurations:

cs42l43 link 0 UID 0
cs35l56 link 1 UID 0
cs35l56 link 1 UID 1
cs35l56 link 1 UID 2
cs35l56 link 1 UID 3

cs42l45 link 1 UID 0
cs35l63 link 0 UID 0
cs35l63 link 0 UID 2
cs35l63 link 0 UID 4
cs35l63 link 0 UID 6

cs42l45 link 0 UID 0
cs35l63 link 1 UID 0
cs35l63 link 1 UID 1

cs42l45 link 0 UID 0
cs35l63 link 1 UID 1
cs35l63 link 1 UID 3

cs42l45 link 1 UID 0
cs35l63 link 0 UID 0
cs35l63 link 0 UID 1

cs42l43 link 1 UID 0
cs35l56 link 1 UID 0
cs35l56 link 1 UID 1
cs35l56 link 1 UID 2
cs35l56 link 1 UID 3

cs35l56 link 1 UID 0
cs35l56 link 1 UID 1
cs35l56 link 1 UID 2
cs35l56 link 1 UID 3

cs35l63 link 0 UID 0
cs35l63 link 0 UID 2
cs35l63 link 0 UID 4
cs35l63 link 0 UID 6

cs42l43 link 0 UID 1

cs42l43b link 0 UID 1

cs42l45 link 0 UID 0

cs42l45 link 1 UID 0

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://patch.msgid.link/20260224130307.526626-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Key findings:

1. **File introduced in v6.12** (commit `57677ccde7522`, Aug 2024) — so
   it exists in 6.12.y and later stable trees.

2. **No new types introduced** — `spk_2_endpoint` and `spk_3_endpoint`
   are just new static variables of the pre-existing `struct
   snd_soc_acpi_endpoint` type. All struct types used
   (`snd_soc_acpi_endpoint`, `snd_soc_acpi_adr_device`,
   `snd_soc_acpi_link_adr`, `snd_soc_acpi_mach`) are already in stable
   trees.

3. **No dependencies on other patches** — this is a self-contained data
   addition to existing infrastructure.

### Stable kernel rule assessment:

| Criterion | Assessment |
|-----------|------------|
| Obviously correct and tested | Yes — purely data, merged via
maintainer (Mark Brown) |
| Fixes a real bug | Enables hardware — without these entries, audio
doesn't work on affected systems |
| Small and contained | Changes only one file, all static const data, no
logic changes |
| No new features/APIs | Correct — adds device match entries to existing
driver, no new APIs |
| Applies cleanly | Should apply cleanly to 6.12.y+ |

### Risk vs. Benefit:

- **Risk**: Extremely low. All additions are static const data arrays
  that are only matched if the specific hardware is present. Existing
  configurations are completely untouched. If hardware doesn't match,
  these entries are never used.
- **Benefit**: Enables audio on AMD laptops with Cirrus Logic codecs
  (cs42l43, cs42l45, cs35l56, cs35l63). Without these entries, users on
  stable kernels with this hardware have no audio.

### Concerns:

The change is large (~400 lines added), but every line is static data
definition. This is a common pattern for device ID additions — the
"size" is entirely boilerplate match table entries, not complexity.

### Verification:
- git log confirmed file was introduced in commit `57677ccde7522`
  (v6.12, Aug 2024)
- git log showed 5 commits total to this file; the Cirrus Logic commit
  is the latest
- Code inspection confirmed all struct types (`snd_soc_acpi_endpoint`,
  `snd_soc_acpi_adr_device`, `snd_soc_acpi_link_adr`,
  `snd_soc_acpi_mach`) are pre-existing in `include/sound/soc-acpi.h`
- `spk_2_endpoint` and `spk_3_endpoint` are new static variables of
  existing type, not new types
- Existing match table entries are untouched — only new entries appended
  before the sentinel `{}`
- No logic changes, no control flow changes, no function modifications —
  purely static const data

This is a textbook device ID / match entry addition. It enables real
hardware for real users on existing driver infrastructure with zero risk
to existing functionality.

**YES**

 sound/soc/amd/acp/amd-acp63-acpi-match.c | 413 +++++++++++++++++++++++
 1 file changed, 413 insertions(+)

diff --git a/sound/soc/amd/acp/amd-acp63-acpi-match.c b/sound/soc/amd/acp/amd-acp63-acpi-match.c
index 9b6a49c051cda..1dbbaba3c75b3 100644
--- a/sound/soc/amd/acp/amd-acp63-acpi-match.c
+++ b/sound/soc/amd/acp/amd-acp63-acpi-match.c
@@ -30,6 +30,20 @@ static const struct snd_soc_acpi_endpoint spk_r_endpoint = {
 	.group_id = 1
 };
 
+static const struct snd_soc_acpi_endpoint spk_2_endpoint = {
+	.num = 0,
+	.aggregated = 1,
+	.group_position = 2,
+	.group_id = 1
+};
+
+static const struct snd_soc_acpi_endpoint spk_3_endpoint = {
+	.num = 0,
+	.aggregated = 1,
+	.group_position = 3,
+	.group_id = 1
+};
+
 static const struct snd_soc_acpi_adr_device rt711_rt1316_group_adr[] = {
 	{
 		.adr = 0x000030025D071101ull,
@@ -103,6 +117,345 @@ static const struct snd_soc_acpi_adr_device rt722_0_single_adr[] = {
 	}
 };
 
+static const struct snd_soc_acpi_endpoint cs42l43_endpoints[] = {
+	{ /* Jack Playback Endpoint */
+		.num = 0,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+	{ /* DMIC Capture Endpoint */
+		.num = 1,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+	{ /* Jack Capture Endpoint */
+		.num = 2,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+	{ /* Speaker Playback Endpoint */
+		.num = 3,
+		.aggregated = 0,
+		.group_position = 0,
+		.group_id = 0,
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l56x4_l1u3210_adr[] = {
+	{
+		.adr = 0x00013301FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00013201FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+	{
+		.adr = 0x00013101FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_2_endpoint,
+		.name_prefix = "AMP3"
+	},
+	{
+		.adr = 0x00013001FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_3_endpoint,
+		.name_prefix = "AMP4"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l63x2_l0u01_adr[] = {
+	{
+		.adr = 0x00003001FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00003101FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l63x2_l1u01_adr[] = {
+	{
+		.adr = 0x00013001FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00013101FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l63x2_l1u13_adr[] = {
+	{
+		.adr = 0x00013101FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00013301FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs35l63x4_l0u0246_adr[] = {
+	{
+		.adr = 0x00003001FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00003201FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+	{
+		.adr = 0x00003401FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_2_endpoint,
+		.name_prefix = "AMP3"
+	},
+	{
+		.adr = 0x00003601FA356301ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_3_endpoint,
+		.name_prefix = "AMP4"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs42l43_l0u0_adr[] = {
+	{
+		.adr = 0x00003001FA424301ull,
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints),
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l43"
+	}
+};
+
+static const struct snd_soc_acpi_adr_device cs42l43_l0u1_adr[] = {
+	{
+		.adr = 0x00003101FA424301ull,
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints),
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l43"
+	}
+};
+
+static const struct snd_soc_acpi_adr_device cs42l43b_l0u1_adr[] = {
+	{
+		.adr = 0x00003101FA2A3B01ull,
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints),
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l43"
+	}
+};
+
+static const struct snd_soc_acpi_adr_device cs42l43_l1u0_cs35l56x4_l1u0123_adr[] = {
+	{
+		.adr = 0x00013001FA424301ull,
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints),
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l43"
+	},
+	{
+		.adr = 0x00013001FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_l_endpoint,
+		.name_prefix = "AMP1"
+	},
+	{
+		.adr = 0x00013101FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_r_endpoint,
+		.name_prefix = "AMP2"
+	},
+	{
+		.adr = 0x00013201FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_2_endpoint,
+		.name_prefix = "AMP3"
+	},
+	{
+		.adr = 0x00013301FA355601ull,
+		.num_endpoints = 1,
+		.endpoints = &spk_3_endpoint,
+		.name_prefix = "AMP4"
+	},
+};
+
+static const struct snd_soc_acpi_adr_device cs42l45_l0u0_adr[] = {
+	{
+		.adr = 0x00003001FA424501ull,
+		/* Re-use endpoints, but cs42l45 has no speaker */
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints) - 1,
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l45"
+	}
+};
+
+static const struct snd_soc_acpi_adr_device cs42l45_l1u0_adr[] = {
+	{
+		.adr = 0x00013001FA424501ull,
+		/* Re-use endpoints, but cs42l45 has no speaker */
+		.num_endpoints = ARRAY_SIZE(cs42l43_endpoints) - 1,
+		.endpoints = cs42l43_endpoints,
+		.name_prefix = "cs42l45"
+	}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs35l56x4_l1u3210[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs35l56x4_l1u3210_adr),
+		.adr_d = cs35l56x4_l1u3210_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs35l63x4_l0u0246[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs35l63x4_l0u0246_adr),
+		.adr_d = cs35l63x4_l0u0246_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l43_l0u1[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l43_l0u1_adr),
+		.adr_d = cs42l43_l0u1_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l43b_l0u1[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l43b_l0u1_adr),
+		.adr_d = cs42l43b_l0u1_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l43_l0u0_cs35l56x4_l1u3210[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l43_l0u0_adr),
+		.adr_d = cs42l43_l0u0_adr,
+	},
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs35l56x4_l1u3210_adr),
+		.adr_d = cs35l56x4_l1u3210_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l43_l1u0_cs35l56x4_l1u0123[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs42l43_l1u0_cs35l56x4_l1u0123_adr),
+		.adr_d = cs42l43_l1u0_cs35l56x4_l1u0123_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l0u0[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l45_l0u0_adr),
+		.adr_d = cs42l45_l0u0_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l0u0_cs35l63x2_l1u01[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l45_l0u0_adr),
+		.adr_d = cs42l45_l0u0_adr,
+	},
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs35l63x2_l1u01_adr),
+		.adr_d = cs35l63x2_l1u01_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l0u0_cs35l63x2_l1u13[] = {
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs42l45_l0u0_adr),
+		.adr_d = cs42l45_l0u0_adr,
+	},
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs35l63x2_l1u13_adr),
+		.adr_d = cs35l63x2_l1u13_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l1u0[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs42l45_l1u0_adr),
+		.adr_d = cs42l45_l1u0_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l1u0_cs35l63x2_l0u01[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs42l45_l1u0_adr),
+		.adr_d = cs42l45_l1u0_adr,
+	},
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs35l63x2_l0u01_adr),
+		.adr_d = cs35l63x2_l0u01_adr,
+	},
+	{}
+};
+
+static const struct snd_soc_acpi_link_adr acp63_cs42l45_l1u0_cs35l63x4_l0u0246[] = {
+	{
+		.mask = BIT(1),
+		.num_adr = ARRAY_SIZE(cs42l45_l1u0_adr),
+		.adr_d = cs42l45_l1u0_adr,
+	},
+	{
+		.mask = BIT(0),
+		.num_adr = ARRAY_SIZE(cs35l63x4_l0u0246_adr),
+		.adr_d = cs35l63x4_l0u0246_adr,
+	},
+	{}
+};
+
 static const struct snd_soc_acpi_link_adr acp63_rt722_only[] = {
 	{
 		.mask = BIT(0),
@@ -135,6 +488,66 @@ struct snd_soc_acpi_mach snd_soc_acpi_amd_acp63_sdw_machines[] = {
 		.links = acp63_4_in_1_sdca,
 		.drv_name = "amd_sdw",
 	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = acp63_cs42l43_l0u0_cs35l56x4_l1u3210,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = acp63_cs42l45_l1u0_cs35l63x4_l0u0246,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = acp63_cs42l45_l0u0_cs35l63x2_l1u01,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = acp63_cs42l45_l0u0_cs35l63x2_l1u13,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0) | BIT(1),
+		.links = acp63_cs42l45_l1u0_cs35l63x2_l0u01,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(1),
+		.links = acp63_cs42l43_l1u0_cs35l56x4_l1u0123,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(1),
+		.links = acp63_cs35l56x4_l1u3210,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0),
+		.links = acp63_cs35l63x4_l0u0246,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0),
+		.links = acp63_cs42l43_l0u1,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0),
+		.links = acp63_cs42l43b_l0u1,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(0),
+		.links = acp63_cs42l45_l0u0,
+		.drv_name = "amd_sdw",
+	},
+	{
+		.link_mask = BIT(1),
+		.links = acp63_cs42l45_l1u0,
+		.drv_name = "amd_sdw",
+	},
 	{},
 };
 EXPORT_SYMBOL(snd_soc_acpi_amd_acp63_sdw_machines);
-- 
2.51.0

