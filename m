Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11941356763;
	Mon, 11 May 2026 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538015; cv=none; b=mL2rexPVFM9yz/VQ/OJKHQh4nB79r4BQsHxPfc28437/usvB6B5MPJalfcqRY+tcbKzRS7ndFDIMSvmsNWCTfCGjkXaMrhIryuk9SKlN5Clf49YsHYRHCccjAifxmg62/sqoKJSBRZVqUM9UPH6pPGMbAJ7lTOOf6n+AqL7m/jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538015; c=relaxed/simple;
	bh=1HMRzZtg0k8/nvIgwDsX4uKJoe+7oD0VtaVUcCoOMMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fc/lmSP6PBjqspRmBx5noB/UriKEevndRxXFY2YUQ6sFKxFPSyNTFkmHBOw4qQRAfJjsuazdze7rGRGbt4tEVXY5xay9DcC93+BCP/ha1nKcdeJXZCsPamGDBxfPoTbjtUYECpLZMgv/wR5D3wny8Bai575vHekIufEUEq5L7EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMzxw/Jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMzxw/Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756C3C2BCFA;
	Mon, 11 May 2026 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538014;
	bh=1HMRzZtg0k8/nvIgwDsX4uKJoe+7oD0VtaVUcCoOMMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMzxw/JoVWVnQ1eJiwxAcnAByVFXFv38D1eDL1fNVXsldJo6RJRSyBEuAdQiuFoFz
	 4Uy0vTNFFUuHxMmiRMhYb3OexCsHiiMweLghpkXNbcF46buv38oL44sJ36Pl2V0vyp
	 0KcGjPruO8HE5BU8IfjZCPwMQHWeuFgJGDQ2vd/g9a0a9KxKRWIvtJIiMXaRRgvay7
	 Ox2pCCtiZRXPBUQo7y29NHerrPU5Gf8Xu/ccZdEUHSYEnrxRAwt2sL3Ye2dMa25DU4
	 tEUwMQkQe1lt7hErhq3pdK8+eqOefLNmSlF9q2so/uIHvd/1L8zArYbvBQx1cHVvVl
	 CfxipbGW/hE1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Derek Fang <derek.fang@realtek.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ASoC: sdw_utils: avoid the SDCA companion function not supported failure
Date: Mon, 11 May 2026 18:19:28 -0400
Message-ID: <20260511221931.2370053-29-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 56d5a9eaf60af5c824a33a83e1468aa143627a62 ]

Treat the companion amp as generic AMP until full support for companion
amp is added.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260430121043.552241-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `ASoC: sdw_utils`; action verb `avoid`;
claimed intent is to avoid SDCA companion amp being treated as
unsupported.

Step 1.2 Record: tags present:
- `Signed-off-by: Derek Fang <derek.fang@realtek.com>`
- `Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>`
- `Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>`
- `Link: https://patch.msgid.link/20260430121043.552241-1-yung-
  chuan.liao@linux.intel.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-by:`, or `Cc:
stable@vger.kernel.org` tags were present.

Step 1.3 Record: the body says companion amps should be treated as
generic amps until full companion-amp support exists. The user-visible
symptom implied by the subject and code is an SDCA companion amp being
classified as unsupported. No stack trace, crash, version statement, or
bug report is included.

Step 1.4 Record: this is a hidden bug fix. The verb “avoid” plus the
one-line mapping change fixes incorrect handling of a valid SDCA
function type that was already accepted elsewhere in the SDCA code.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed,
`sound/soc/sdw_utils/soc_sdw_utils.c`, one line added. Modified
function: `asoc_sdw_get_dai_type()`. Scope: single-file surgical logic
fix.

Step 2.2 Record: before the patch, `SDCA_FUNCTION_TYPE_COMPANION_AMP`
fell through to `default` and returned `-EINVAL`. After the patch, it
returns `SOC_SDW_DAI_TYPE_AMP`, like smart and simple amp function
types. This affects SDCA endpoint detection and SOF SoundWire endpoint
construction paths that call `asoc_sdw_get_dai_type()`.

Step 2.3 Record: bug category is logic/correctness plus hardware
compatibility. The broken mechanism is that a valid SDCA companion amp
function type was known to SDCA parsing code but not known to the SDW
DAI-type mapper, so amp endpoint matching could fail.

Step 2.4 Record: the fix is obviously small and locally correct:
“companion amp” is mapped into the existing amp class. Regression risk
is very low; the only behavior change is for devices reporting
`SDCA_FUNCTION_TYPE_COMPANION_AMP`.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` on the pre-fix switch shows
`asoc_sdw_get_dai_type()` and its default `-EINVAL` mapping came from
`4f8ef33dd44a3d` (“ASoC: soc_sdw_utils: skip the endpoint that doesn't
present”), first contained from v6.16. The actual companion-amp exposure
came later from `f5cb3ee251b4f` (“ASoC: SDCA: Add companion amp
Function”), first contained from v6.19.

Step 3.2 Record: no `Fixes:` tag is present, so no tag target exists to
follow. The likely prerequisite/regression source was verified
separately as `f5cb3ee251b4f`, which added
`SDCA_FUNCTION_TYPE_COMPANION_AMP` to `include/sound/sdca_function.h`
and `sound/soc/sdca/sdca_functions.c`.

Step 3.3 Record: recent history for `soc_sdw_utils.c` shows active
SDCA/SoundWire endpoint work. Related commits include `506cbe36a2ac7b`
exporting `asoc_sdw_get_dai_type()`, `f5cb3ee251b4f` adding the
companion amp function type, and later SDCA/sdw_utils fixes. This patch
is standalone except that it only applies meaningfully to trees already
containing the companion-amp enum.

Step 3.4 Record: Derek Fang has multiple Realtek ASoC codec commits,
including the RT1017 SDCA amplifier driver. Bard Liao has many
SDW/SOF/ASoC commits in this area and is listed as an SDCA reviewer in
`MAINTAINERS`.

Step 3.5 Record: dependency identified:
`SDCA_FUNCTION_TYPE_COMPANION_AMP` must exist. It is present in v6.19
and v7.0, absent in v6.18. The patch should not be applied to older
trees unless that enum support is also present.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 56d5a9eaf60a` matched the original patch by
exact patch-id at the supplied patch link. `b4 dig -a` found only v1 of
a single-patch series. No newer revision was found.

Step 4.2 Record: `b4 dig -w` showed the original recipients included
Bard Liao, Mark Brown, Takashi Iwai, `linux-sound@vger.kernel.org`,
Intel/Realtek audio contributors, and Derek Fang. The patch carries
`Reviewed-by: Charles Keepax`, who is listed as an SDCA maintainer.

Step 4.3 Record: no bug-report link or `Reported-by` tag exists.
Web/lore fetches for the search pages were blocked by Anubis, but `b4`
successfully fetched the actual thread. No syzbot or user bug report was
found.

Step 4.4 Record: `b4 dig -a` shows this is not part of a multi-patch
series. Local related-patch search found `f5cb3ee251b4f` as the
companion-amp type addition, which is the important dependency/context.

Step 4.5 Record: no stable-specific discussion was found in local stable
tag history or web search. No reviewer stable nomination was found in
the fetched thread.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function: `asoc_sdw_get_dai_type()`.

Step 5.2 Record: callers found:
- `is_sdca_endpoint_present()` in `sound/soc/sdw_utils/soc_sdw_utils.c`,
  used while parsing SoundWire endpoints for ASoC machine drivers.
- `is_endpoint_present()` in `sound/soc/sof/intel/hda.c`, present in
  v7.0 and later, used while building default SoundWire machine
  descriptions from detected peripherals.

Step 5.3 Record: key callees/side effects: `is_sdca_endpoint_present()`
gets a SoundWire device by name, checks `slave->sdca_data`, loops over
firmware-provided SDCA functions, and skips endpoints if no matching DAI
type is found. The SOF HDA path similarly checks
`sdw_device->sdca_data.function[]` before adding endpoints.

Step 5.4 Record: reachability is verified through machine-driver setup
paths: Intel `sof_sdw`, AMD ACP SDW SOF, and AMD ACP SDW legacy machine
drivers call `asoc_sdw_parse_sdw_endpoints()`. The HDA default machine
path calls `find_acpi_adr_device()` during SoundWire machine selection.
This is boot/probe-time hardware enumeration, not an unprivileged
syscall path.

Step 5.5 Record: similar pattern search found
`SDCA_FUNCTION_TYPE_COMPANION_AMP` handled in the SDCA name parser but
missing from the DAI-type mapper before this patch. No other
`asoc_sdw_get_dai_type()` companion mapping existed before the fix.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: v6.18 has `asoc_sdw_get_dai_type()` but no
`SDCA_FUNCTION_TYPE_COMPANION_AMP`. v6.19 and v7.0 contain the companion
enum/name support but lack this mapper case. v7.1-rc3 contains the fix.
Therefore the affected stable trees are v6.19.y and v7.0.y, not older
trees lacking `f5cb3ee251b4f`.

Step 6.2 Record: `git apply --check` of the target patch succeeded on
the current checkout, which is v7.0.5. The v6.19 helper context around
`SDCA_FUNCTION_TYPE_SIMPLE_AMP` matches the same missing-case pattern,
so expected v6.19 backport difficulty is clean or trivial.

Step 6.3 Record: local stable history checks for v6.19.y and v7.0.y
found no existing stable commit with this subject. v7.1-rc3 contains
`56d5a9eaf60a`.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is ASoC SoundWire/SDCA audio support.
Criticality is driver/platform-specific, important for affected
SoundWire laptop/audio hardware but not universal core kernel code.

Step 7.2 Record: subsystem activity is high; recent history shows many
SDCA and `sdw_utils` changes across v6.19 to v7.1. This is a newer,
actively evolving area, which reinforces the dependency check.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: affected users are systems with SoundWire SDCA devices
reporting companion amp functions, especially Intel/AMD SoundWire laptop
audio configurations using these helper paths.

Step 8.2 Record: trigger condition is hardware/firmware enumeration
where `slave->sdca_data.function[i].type` is
`SDCA_FUNCTION_TYPE_COMPANION_AMP`. It happens during boot/probe/machine
selection, not from unprivileged userspace.

Step 8.3 Record: failure mode is endpoint/DAI detection failure: the
companion amp can be treated as unsupported and skipped or not included
in generated SoundWire endpoint data. Severity is medium for the general
kernel, high for affected hardware because it can break audio amp
availability.

Step 8.4 Record: benefit is high for affected hardware and low-risk
globally. Risk is very low: one added switch case, no new API, no
locking, no memory lifetime changes, and no behavior change for other
function types.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting:
- Fixes real incorrect handling of an already-defined SDCA companion amp
  type.
- Prevents affected SoundWire audio endpoints from being classified
  unsupported.
- One-line, single-function, single-file change.
- Reviewed by Charles Keepax; applied by Mark Brown; relevant
  maintainers/lists were included.
- Applies to stable trees that already contain `f5cb3ee251b4f`, verified
  for v6.19/v7.0 presence.

Evidence against backporting:
- No crash, data corruption, security issue, syzbot report, or explicit
  stable tag.
- It is hardware/functionality enablement rather than a core reliability
  fix.
- It must not be applied to trees without
  `SDCA_FUNCTION_TYPE_COMPANION_AMP`.

Unresolved questions:
- No external user bug report was found, so exact affected product count
  is unverified.
- I did not run a full v6.19 worktree apply test, but verified matching
  context and dependency presence.

Step 9.2 Stable rules:
1. Obviously correct and tested? Yes for correctness by code inspection;
   no explicit `Tested-by` on this patch.
2. Fixes a real bug? Yes, incorrect mapping of a valid SDCA companion
   amp function.
3. Important issue? Yes for affected hardware audio functionality,
   though not crash/security.
4. Small and contained? Yes, one line in one function.
5. No new feature/API? Yes, it uses an existing enum and existing DAI
   type.
6. Can apply to stable? Yes for v7.0.5 verified; expected trivial for
   v6.19.y; not applicable to older trees lacking the enum.

Step 9.3 Exception category: closest category is hardware
compatibility/workaround for existing SoundWire SDCA audio support. It
is not a new driver or new userspace API.

Step 9.4 Decision: backport to stable trees that already include
`f5cb3ee251b4f` (`SDCA_FUNCTION_TYPE_COMPANION_AMP`), notably v6.19.y
and v7.0.y. Do not backport to older trees unless that prerequisite is
intentionally present.

## Verification
- [Phase 1] Parsed commit `56d5a9eaf60a` with `git show`; confirmed
  subject, body, tags, and one-file/one-line patch.
- [Phase 2] Inspected diff; confirmed only `asoc_sdw_get_dai_type()`
  adds `SDCA_FUNCTION_TYPE_COMPANION_AMP` to the amp cases.
- [Phase 3] `git blame 56d5a9eaf60a^` showed the mapper switch came from
  `4f8ef33dd44a3d`; `git show f5cb3ee251b4f` confirmed companion amp
  enum/name support was added later.
- [Phase 3] `git tag --contains f5cb3ee...` showed companion amp support
  starts at v6.19; `git grep` confirmed absent in v6.18 and present in
  v6.19/v7.0.
- [Phase 4] `b4 dig -c 56d5a9eaf60a` found the original patch thread;
  `b4 dig -a` showed only v1; `b4 dig -w` showed original recipients.
- [Phase 4] Fetched the mbox with `b4`; confirmed Mark Brown applied it
  to `sound.git for-7.1` and no NAK/objection appeared in the fetched
  thread.
- [Phase 5] `rg` found callers in `is_sdca_endpoint_present()` and SOF
  HDA `is_endpoint_present()`; file reads verified endpoint filtering
  behavior.
- [Phase 6] `git grep` across v6.18/v6.19/v7.0/v7.1-rc3 verified where
  the enum and fix exist.
- [Phase 6] `git apply --check` verified the patch applies cleanly to
  current v7.0.5.
- [Phase 7] `MAINTAINERS` verified Mark Brown as ASoC maintainer and
  Charles Keepax/Bard Liao as SDCA maintainer/reviewer contacts.
- [Phase 8] Failure mode was verified from code paths that skip
  endpoints when no matching DAI type is found.
- UNVERIFIED: exact real-world affected laptop/device count; no public
  bug report was found.

**YES**

 sound/soc/sdw_utils/soc_sdw_utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 0e67d9f34cba3..2b4b54e8241e6 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1400,6 +1400,7 @@ int asoc_sdw_get_dai_type(u32 type)
 	switch (type) {
 	case SDCA_FUNCTION_TYPE_SMART_AMP:
 	case SDCA_FUNCTION_TYPE_SIMPLE_AMP:
+	case SDCA_FUNCTION_TYPE_COMPANION_AMP:
 		return SOC_SDW_DAI_TYPE_AMP;
 	case SDCA_FUNCTION_TYPE_SMART_MIC:
 	case SDCA_FUNCTION_TYPE_SIMPLE_MIC:
-- 
2.53.0

