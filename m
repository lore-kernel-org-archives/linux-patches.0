Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854C3F44CD;
	Wed, 20 May 2026 11:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276050; cv=none; b=nn1gl/WxNArQB7XjiH2+JtaAV/KpnQ0vgtPr1OUfL4zjfVEBVKUfieGyDQo/HHcx0FzAylOPwymS1oYMSph2jifKNWuSsBsm7qqQ/XH8ct2trIzV1gWjbecgiV2QLiltHByvlE5YeQD6JFS6GdHkm8O0jcSIkHkEs8P9dKBoc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276050; c=relaxed/simple;
	bh=DotTfYlnWGlDGzuOXR8CxwwZH5o6jTDJhvilNPWgClU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpW/JC1sQZc4s/d1nrVvsN5S1ChGV2xZgImp+8e7TCJyJn51gIpPbhfnQhsWiOI0WchVoNF7tz2xRPjausVUqqEkQXJ/UkDnERpIUpgKnod0JtH4o++qtR4EAmYyrpK5iGPKAVGyHNZ4K2goaPLhmlvw7o9HGw6DG2YG8R01G84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMHgRdmg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMHgRdmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69C81F00893;
	Wed, 20 May 2026 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276048;
	bh=YPTzNFpjlVe5kcQOHv0NqMcIrPZdQr29o1Wc7/jrtEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMHgRdmgP2VkCRi8QX+BayshQ9UnTEOiW1fZTvpjOeSCv56dOYf0e2XIBiitQ2X2J
	 pWnH1ZHFz7sZh3PcBrvGQEHu8cLMm9y+P6erzSgTjHB7NK3mk6JRoLgBf1UpnDnT6O
	 KyYX/NsC5p/JRROcJYEDfBqIPaiuxSNbQN3Q6vyUUVImMDjSegQdXbLiakYOn1JVGO
	 iwPPkmh2WQQU2eCWgvfMzVgwtYEKBo1Q1b4nU/kUInF9LTsvcUAl90IFrsztKtC+/C
	 LJ6c9B1LBk/i9uSw2hBupSfBKmjQEjH1Ab2FPsQz/kjvIgQvE1UlEObWUwsmaEYtG4
	 XZWRgZq73AzjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bob Song <songxiebing@kylinos.cn>,
	gannovera <gannovera@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VE
Date: Wed, 20 May 2026 07:19:16 -0400
Message-ID: <20260520111944.3424570-44-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 0e60d96616640ffcf51b81a87c71e30d92385a93 ]

The laptop requires a quirk ID to enable its internal microphone. Add
it to the DMI quirk table.

Reported-by: gannovera <gannovera@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218402
Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260430014920.141276-1-songxiebing@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Stable Backport Review

### Phase 1: Commit Message Forensics
Record 1.1: Subsystem is `ASoC: amd: yc`; action verb is `Add`; claimed
intent is adding a DMI quirk for MSI Bravo 15 C7VE internal microphone
enablement.

Record 1.2: Tags found: `Reported-by: gannovera <gannovera@gmail.com>`,
`Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218402`, `Signed-
off-by: Bob Song <songxiebing@kylinos.cn>`, `Link: https://patch.msgid.l
ink/20260430014920.141276-1-songxiebing@kylinos.cn`, `Signed-off-by:
Mark Brown <broonie@kernel.org>`. No `Fixes:` tag and no explicit `Cc:
stable`.

Record 1.3: The message states the laptop requires a quirk ID to enable
its internal microphone. Symptom is missing internal microphone support
on MSI Bravo 15 C7VE. Version info is not stated. Root cause described
is absence from `yc_acp_quirk_table`.

Record 1.4: This is a hardware quirk fix, not a hidden cleanup bug. It
fits the stable exception category for DMI quirks/workarounds.

### Phase 2: Diff Analysis
Record 2.1: One file changed: `sound/soc/amd/yc/acp6x-mach.c`, 7
insertions, 0 deletions. Modified object is the static
`yc_acp_quirk_table[]`. Scope is a single-file surgical quirk addition.

Record 2.2: Before: the DMI table matched nearby MSI models such as
`Bravo 15 B7ED` and `Bravo 15 C7VF`, but not `Bravo 15 C7VE`. After:
exact vendor/product match for `Micro-Star International Co., Ltd.` and
`Bravo 15 C7VE` maps to `&acp6x_card`. Affected path is platform probe
hardware matching.

Record 2.3: Bug category is hardware workaround / DMI quirk. Mechanism:
`acp6x_probe()` calls `dmi_first_match(yc_acp_quirk_table)` and, on
match, sets platform driver data to `acp6x_card`; without a match, the
driver can return `-ENODEV` if ACPI did not already enable the card.

Record 2.4: Fix quality is high: it adds only one exact DMI table entry
using an existing pattern and no new logic. Regression risk is very low
and limited to machines reporting that exact DMI product/vendor pair.

### Phase 3: Git History Investigation
Record 3.1: `git blame` around adjacent MSI entries in the checked-out
7.0 tree traced those lines to the local merge base, not a useful
original introducer. The “bug” is absence of this model entry, not a bad
line introduced by a known commit. Verified file absent in `v5.15` and
present in `v5.16`, `v6.1`, `v6.6`, and `v6.12`.

Record 3.2: No `Fixes:` tag, so no introducing commit to follow.

Record 3.3: Recent history of `sound/soc/amd/yc/acp6x-mach.c` contains
many similar DMI quirk additions, including HP, ASUS, MSI Thin/Vector
entries. No prerequisite refactor was identified for this specific
7-line addition.

Record 3.4: Author history in the fetched maintainer branch showed Bob
Song’s related commits for this path consist of this patch. The patch
was committed by Mark Brown, the ASoC maintainer.

Record 3.5: Dependency check found the needed symbols and structure
already exist in stable-relevant trees: `yc_acp_quirk_table`,
`acp6x_card`, and `dmi_first_match()` are present in `v6.1`;
`SND_SOC_AMD_YC_MACH` exists in `v6.1` and `v6.6`. The exact submitted
hunk applies cleanly to the current 7.0 tree; older trees such as `v6.1`
lack the nearby MSI `Bravo 15 B7ED` anchor and would need a simple
context adjustment.

### Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c 0e60d96616640ffcf51b81a87c71e30d92385a93` found
the lore thread at `https://patch.msgid.link/20260430014920.141276-1-
songxiebing@kylinos.cn`. `b4 dig -a` found two same-subject submissions
dated 2026-04-22 and 2026-04-30; the April 30 version is the applied
one.

Record 4.2: `b4 dig -w` showed the April 30 submission included Takashi
Iwai, Jaroslav Kysela, Liam Girdwood, Mark Brown, Vijendar Mukunda,
`linux-sound`, `linux-kernel`, and the reporter.

Record 4.3: Direct `WebFetch` of Bugzilla was blocked by Anubis. Search
results and the lore thread corroborate that Bugzilla #218402 is tied to
this MSI Bravo 15 C7VE microphone issue.

Record 4.4: Related pattern found: a similar MSI Bravo 17 C7VE quirk
thread describes the same ACP6x DMIC not-enabled problem on a related
MSI model. No dependency between that patch and this one was found.

Record 4.5: Stable-list search found no stable-specific discussion for
`Bravo 15 C7VE`.

### Phase 5: Code Semantic Analysis
Record 5.1: Modified object is `yc_acp_quirk_table[]`; key consuming
function is `acp6x_probe()`.

Record 5.2: `acp6x_probe()` is the `.probe` callback of platform driver
`acp6x_mach_driver`. The platform device named `acp_yc_mach` is
registered by `snd_acp6x_probe()` in `pci-acp6x.c` when ACP6x PDM mode
is set.

Record 5.3: Key callees in `acp6x_probe()` are ACPI property checks,
`_WOV` evaluation, `dmi_first_match()`, `platform_set_drvdata()`,
`platform_get_drvdata()`, and `devm_snd_soc_register_card()`.

Record 5.4: Reachability is hardware enumeration/probe on AMD Yellow
Carp ACP systems, not a syscall-triggered path. For the affected laptop,
the issue is encountered at boot/device probe when the internal DMIC
card is not registered.

Record 5.5: Similar pattern is widespread in the same table: many
laptop-specific entries all set `.driver_data = &acp6x_card`.

### Phase 6: Stable Tree Analysis
Record 6.1: `v5.15` lacks `sound/soc/amd/yc/acp6x-mach.c`; `v5.16`,
`v6.1`, `v6.6`, and `v6.12` contain it. This is relevant to stable trees
with the AMD YC machine driver, especially `v6.1+`.

Record 6.2: Current 7.0 tree accepts the patch cleanly via `git apply
--check`. `v6.6`, `v6.12`, `v6.18`, `v6.19`, and HEAD have nearby MSI
entries; `v6.1` has the quirk machinery but not the same adjacent MSI
context, so it needs minor manual placement.

Record 6.3: Searches found no existing `Bravo 15 C7VE` entry in current
HEAD, `v6.6`, `v6.12`, `v6.18`, or `v6.19`.

### Phase 7: Subsystem Context
Record 7.1: Subsystem is ALSA SoC / AMD YC machine driver under
`sound/`. Criticality is peripheral but user-visible: it affects audio
capture on a specific laptop model.

Record 7.2: The subsystem/file is actively receiving DMI quirk
additions, verified by recent history listing multiple ASoC AMD YC quirk
commits.

### Phase 8: Impact And Risk
Record 8.1: Affected users are MSI Bravo 15 C7VE owners using kernels
with `CONFIG_SND_SOC_AMD_YC_MACH`.

Record 8.2: Trigger condition is device probing on that hardware when
firmware/ACPI does not otherwise enable the DMIC path. It is not an
unprivileged-user-triggered security issue.

Record 8.3: Failure mode is loss of internal microphone functionality,
not crash, data corruption, or security impact. Severity is medium for
affected users.

Record 8.4: Benefit is high for affected hardware because it restores
the internal microphone. Risk is very low because the patch is seven
lines, exact-DMI-scoped, and uses existing driver data.

### Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real user report, Bugzilla closure
tag, accepted by ASoC maintainer, exact hardware quirk, tiny scope, no
API/behavior change outside the matching laptop, and stable rules
explicitly allow hardware quirks. Evidence against: no explicit `Cc:
stable`, no `Tested-by`, Bugzilla direct fetch blocked, and `v6.1` needs
trivial context adjustment. None of these outweigh the quirk benefit.

Record 9.2: Stable rules: obviously correct yes; fixes a real user-
visible hardware bug yes; important enough for affected users yes,
though not crash-level; small and contained yes; no new APIs/features
yes; applies cleanly to current 7.0 and should be straightforward for
stable trees containing the driver.

Record 9.3: Exception category applies: hardware-specific DMI
quirk/workaround in an existing driver.

Record 9.4: Decision is to backport to stable trees that contain the AMD
YC machine driver, with minor context adjustment where needed.

## Verification
- [Phase 1] Parsed fetched commit
  `0e60d96616640ffcf51b81a87c71e30d92385a93`: confirmed subject, tags,
  author, committer, and 7-line stat.
- [Phase 2] Read `sound/soc/amd/yc/acp6x-mach.c`: confirmed
  `yc_acp_quirk_table[]` and `acp6x_probe()` DMI behavior.
- [Phase 3] Ran local history/blame checks: nearby blame was not useful
  for original introduction; verified file absent in `v5.15` and present
  in `v5.16+`.
- [Phase 4] Ran `b4 dig -c`, `-a`, `-w`, and saved/read mbox: confirmed
  lore thread, two submissions, maintainer recipients, and Mark Brown
  application to `for-7.1`.
- [Phase 5] Read `pci-acp6x.c`: confirmed PCI probe registers
  `acp_yc_mach`, which invokes the machine driver probe.
- [Phase 6] Checked stable tags and entries: no `Bravo 15 C7VE` in
  checked stable/current trees; patch applies cleanly to current 7.0
  tree.
- [Phase 7] Checked Kconfig/Makefile: confirmed `SND_SOC_AMD_YC_MACH` is
  the relevant config and exists in `v6.1`/`v6.6`.
- [Phase 8] Impact assessment is based on verified probe flow plus the
  commit’s reported Bugzilla/user report.
- UNVERIFIED: Direct Bugzilla contents could not be fetched due Anubis.
  Exact original file introduction commit was not determined from local
  history, but tag presence verifies stable relevance.

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2f7a51d7eb115..daa6b9a526565 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -479,6 +479,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 B7ED"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7VE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

