Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A954AF9F2;
	Mon, 31 Aug 2026 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184183; cv=none; b=owUxHNASZUlWGPJl12BJPLFb8DJqDrEXOvGpGq6PdZp8qodCDFiTbaI6Np5X4K3E2EtufLFQJEKhfEpZ6wmLrEg/WPHLdD6/7y9SkFzcuHgeOPCMWFaA7z2UzMfqfv2NjdsgMiJbpflLptSNhX3PxPJXOLizh2Ypos7U7GlQc74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184183; c=relaxed/simple;
	bh=P3d7zi5R0VxGtimnWy+k6qfrZJA7wnkGEa4G2Drc5fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvDww6TT/4KyeLidAa/+EAyEMlnifA/tfcTuNC7uePOuWf/ZEkp6cGQ1glKF9328ybcTVNXlpv3x5lCq1XTkWKJWtEQwEobPK2Xfe3Ns980OSehVjHfKW46tLu3EVrUMMhgRj3OvWlm/DeE1vKyKlwzVbbGxAHB6v6cUjdOD7uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fyv9Qo4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fyv9Qo4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118721F00A3E;
	Mon, 31 Aug 2026 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184178;
	bh=oCpTmdjqNHfuxs6x2yeRnovpfa7f0fMHVA9az58zuxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fyv9Qo4SUECPLlRXXtXzStqZ6BgiGo41toIDjls7RMWKvciQP1qnlMt8s14/iLh5L
	 bLq5I7vvLhqWZa72ZzgUmnmKZdTTQOvz9Ao9TIfmJXWPil06re8F4Oy8xw5Q49IYiz
	 qLChY/GgLDtRlVM0zydjzIsiA7PcszHUYH+jfXMEA1lmgGSAkly2Mp9o/E21MZUIpt
	 1P0EojrwylWxNWyrok1EdWL/WgIaN+3Qwg/5BIbGeDjhzw9XNi2JA0LEd5oK4/cN8I
	 VXsEIADl0oGKV6A3O+WZOqS29MwHY8Sh2OG+BzIR2CJWbS3v/b8MEu41yPPgj3M+Rj
	 rbebooUQ6V5ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	srini@kernel.org,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: qcom: q6apm: return error code to consumers on failures
Date: Mon, 31 Aug 2026 09:29:26 -0400
Message-ID: <20260831133314.4125787-538-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 3075ae5abbc370d2a9a01bd6d554a412d406f5bd ]

Return errors from audioreach_set_media_format() to ensure callers are
notified when media format setup fails.

This could hide failures while programming media format parameters for
individual modules and allow graph setup to continue with incomplete
configuration.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260528185806.6316-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: qcom: q6apm: return error code to
consumers on failures

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[ASoC: qcom: q6apm]` `[return]` — propagate error codes
from `audioreach_set_media_format()` to callers of
`q6apm_graph_media_format_shmem()` and `q6apm_graph_media_format_pcm()`.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Signed-off-by:** Srinivas Kandagatla
  `<srinivas.kandagatla@oss.qualcomm.com>` (author)
- **Link:** https://patch.msgid.link/20260528185806.6316-3-
  srinivas.kandagatla@oss.qualcomm.com
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Cc:
  stable@vger.kernel.org
- **Notable:** No user or fuzzer reports; maintainer-reviewed and merged
  by Mark Brown. Absence of Cc: stable is expected per review pipeline
  rules.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `q6apm_graph_media_format_shmem()` and
  `q6apm_graph_media_format_pcm()` discard return values from
  `audioreach_set_media_format()` and always return 0.
- **Symptom:** DSP media-format programming failures are hidden; audio
  graph setup continues with incomplete module configuration.
- **Root cause:** Wrapper functions ignore errors from underlying DSP
  IPC (`audioreach_graph_send_cmd_sync()` and related helpers).
- **Version info:** None stated in commit message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Yes — despite not using "fix" in the subject, this is a real
error-handling bug. Callers are written to check return codes, but
wrappers always report success even when DSP commands fail.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **File:** `sound/soc/qcom/qdsp6/q6apm.c` — 5 insertions, 5 deletions
  (net 0 lines)
- **Functions modified:** `q6apm_graph_media_format_shmem()`,
  `q6apm_graph_media_format_pcm()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`q6apm_graph_media_format_shmem`):** Before: call
  `audioreach_set_media_format()`, return 0. After: `return
  audioreach_set_media_format(...)`.
- **Hunk 2 (`q6apm_graph_media_format_pcm`):** Before: loop over
  modules, call `audioreach_set_media_format()` without checking return.
  After: capture `ret`, return immediately on first failure.
- **Paths affected:** PCM/compress prepare and LPASS DAI setup — all
  paths that configure DSP media format.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Logic/correctness — swallowed error codes.
- `audioreach_set_media_format()` returns errors from DSP IPC
  (`audioreach_graph_send_cmd_sync()` at line 1213 of `audioreach.c`)
  and allocation failures (`-ENOMEM`, `-EINVAL`).
- Wrappers discarded these; callers checking `ret < 0` could never
  detect failures.

### Step 2.4: Fix Quality
**Record:** Obviously correct — standard error propagation. Minimal
change, no API changes, no new symbols. Regression risk very low; only
changes behavior when underlying call already failed.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:** Both functions introduced in `25ab80db6b133c` (Oct 2021,
"ASoC: qdsp6: audioreach: add module configuration command helpers").
Bug present since introduction. Code exists in this 6.18.44 tree.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File History for Related Changes
**Record:** Recent stable-tree q6apm fixes include NULL deref
(`ca028334343a1`), remove ordering, queue ptr reset. On master, this fix
(`3075ae5abbc37`) is patch 2/6 of "add push/pull module support" series,
but the diff is self-contained and does not depend on push/pull code.
Related master-only commits (push/pull, watermark) are separate
features.

### Step 3.4: Author's Other Commits
**Record:** Srinivas Kandagatla is primary Qualcomm QDSP6 contributor.
Recent stable backports from same author include `90983f841dfa9` (q6asm-
dai error handling) and `ca028334343a1` (q6apm NULL deref).

### Step 3.5: Prerequisites
**Record:** No dependencies. `audioreach_set_media_format()` already
returns `int` in this tree. `git apply --check` on commit
`3075ae5abbc37` against HEAD succeeds cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260528185806.6316-3-
  srinivas.kandagatla@oss.qualcomm.com
- **Series:** v1 (2026-05-19) and v2 (2026-05-28); committed version
  matches v2 patch 2/6
- **Lore fetch:** Blocked by Anubis bot protection — could not read
  thread content
- **UNVERIFIED:** Reviewer stable nominations, NAKs, or specific review
  comments

### Step 4.2: Reviewers
**Record:** b4 dig -w shows CC to Mark Brown (maintainer), Liam
Girdwood, Takashi Iwai, Krzysztof Kozlowski, linux-sound@, linux-arm-
msm@. Appropriate subsystem coverage.

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or bugzilla/syzbot links.

### Step 4.4: Related Patches
**Record:** Part of 6-patch push/pull series on master; this specific
patch is standalone error propagation with no push/pull code changes.

### Step 4.5: Stable Mailing List
**Record:** Not searched (lore blocked). Commit lacks Cc: stable; not
used as negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `q6apm_graph_media_format_shmem()`,
`q6apm_graph_media_format_pcm()`, callee
`audioreach_set_media_format()`.

### Step 5.2: Callers
**Record:**
| Caller | File | Error handling |
|--------|------|----------------|
| `q6apm_dai_prepare()` | `q6apm-dai.c:246-254` | Returns on shmem
failure; logs pcm failure but **does not return** (pre-existing caller
gap) |
| `q6apm_dai_compr_set_params()` | `q6apm-dai.c:683-689` | Returns on
both failures |
| LPASS DAI hw_params | `q6apm-lpass-dais.c:195-199` | Returns and goes
to `err` |

### Step 5.3: Callees
**Record:** `audioreach_set_media_format()` dispatches to module-
specific setters, ultimately calling `audioreach_graph_send_cmd_sync()`
for DSP IPC. Returns negative errno on failure.

### Step 5.4: Call Chain / Reachability
**Record:** Reachable from userspace audio operations (PCM prepare,
compressed offload, LPASS DAI hw_params) on Qualcomm Snapdragon
platforms with `CONFIG_SND_SOC_QDSP6`. Common audio playback/capture
path for those devices.

### Step 5.5: Similar Patterns
**Record:** Precedent in this tree: `ba6474f19fd1b` "ASoC: qcom: qdsp6:
Set error code in q6usb_hw_params()" — same class of fix (don't return
success on failure), backported by Greg Kroah-Hartman to stable.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Current `q6apm.c` lines 206-208 and 385-390 ignore
`audioreach_set_media_format()` return values. Bug since 2021; present
in 6.18.44.

### Step 6.2: Backport Complications
**Record:** Clean apply verified (`git apply --check` passed). No
conflicting refactors in this file between stable and master for these
functions.

### Step 6.3: Related Fixes Already Present?
**Record:** Fix `3075ae5abbc37` is **not** in 6.18.44 (`git log --grep`
on HEAD returns empty). Bug remains unfixed in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **ASoC / Qualcomm QDSP6 audio driver** — **PERIPHERAL**
(platform-specific: Snapdragon/MSM devices). Critical for audio on those
platforms; not universal.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained in 6.18.y — multiple recent q6apm/q6asm
stable backports from same author/maintainer chain.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of `CONFIG_SND_SOC_QDSP6` on Qualcomm platforms
(phones, tablets, embedded). Not universal kernel users.

### Step 8.2: Trigger Conditions
**Record:** Triggered when DSP media-format IPC fails during graph setup
(DSP not ready, invalid params, allocation failure, IPC timeout).
Unprivileged users can trigger via normal audio open/prepare. Not a race
— deterministic on DSP command failure.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: silent failure, graph continues with incomplete
DSP configuration → no audio, broken audio, or unpredictable DSP
behavior. **Severity: MEDIUM** — functional correctness bug, not
demonstrated kernel crash/oops/deadlock. Could theoretically stress DSP
firmware, but that is unverified.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — restores broken API contract; enables proper
  failure detection in 3 of 4 call sites (shmem in prepare, compress
  offload, LPASS DAI)
- **Risk:** VERY LOW — 10-line change, only affects already-failing
  paths
- **Ratio:** Favorable — trivial fix for long-standing bug in actively
  maintained subsystem with direct stable precedent

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verified bug: error codes swallowed since 2021
- Callers written to handle errors but cannot detect failures today
- Trivial, obviously correct fix; applies cleanly to 6.18.44
- Same subsystem/author as recent stable backports (`90983f841dfa9`,
  `ca028334343a1`)
- Direct precedent: `ba6474f19fd1b` (error propagation in qdsp6)
  backported to stable
- Prevents continuing DSP graph setup after failed format programming
- Maintainer-reviewed (Mark Brown)

**AGAINST backport:**
- No user reports, syzbot, or CVE
- Failure mode is functional (broken audio), not demonstrated
  crash/corruption/deadlock
- Platform-specific peripheral driver
- One caller (`q6apm_dai_prepare` pcm path) still doesn't abort on pcm
  format failure — fix is partially undermined there (pre-existing
  separate issue)
- Part of larger feature series on master (though patch itself is
  standalone)

**UNRESOLVED:**
- Lore review thread content (Anubis blocked)
- Whether DSP firmware can crash from incomplete configuration

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — trivial error propagation;
   maintainer merged, no Tested-by
2. Fixes real bug affecting users? **PASS** — broken error reporting on
   Qualcomm audio platforms
3. Important issue? **PASS (borderline)** — not crash/security, but
   prevents silent continuation with failed DSP setup; same class as
   prior stable backport `ba6474f19fd1b`
4. Small and contained? **PASS** — 1 file, ~10 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply; buggy code
   present

### Step 9.3: Exception Categories
**Record:** N/A — not device ID, quirk, DT, build, or docs fix. Standard
error-handling bug fix.

### Step 9.4: Decision Rationale

This commit fixes a long-standing error-swallowing bug in Qualcomm QDSP6
audio graph setup. While the failure mode is primarily functional rather
than a kernel crash, the fix is trivially correct, applies cleanly to
6.18.44, restores a broken API contract that callers already depend on,
and matches a directly analogous fix (`ba6474f19fd1b`) already
backported to this stable tree. The risk is negligible and the subsystem
is actively receiving similar stable fixes from the same maintainer
chain.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  3075ae5abbc37`
- **[Phase 1]** Confirmed no Reported-by, Fixes:, or Cc: stable tags
- **[Phase 2]** Read diff: 1 file, 2 functions, error propagation only
- **[Phase 2]** Read `audioreach_set_media_format()` at
  `audioreach.c:1281-1335` — returns `rc` from DSP IPC
- **[Phase 2]** Read `audioreach_pcm_set_media_format()` at
  `audioreach.c:1213-1217` — returns `audioreach_graph_send_cmd_sync()`
  result
- **[Phase 3]** `git describe HEAD` → v6.18.44
- **[Phase 3]** `git blame` → buggy code from `25ab80db6b133c`
  (2021-10-26)
- **[Phase 3]** `git log --oneline -20 -- sound/soc/qcom/qdsp6/q6apm.c`
  — subsystem history
- **[Phase 3]** `git apply --check` on `3075ae5abbc37` against HEAD —
  clean apply
- **[Phase 3]** `git log HEAD..master -- q6apm.c` — fix on master, not
  in stable
- **[Phase 4]** `b4 dig -c 3075ae5abbc37` — found lore URL, v1/v2 series
- **[Phase 4]** `b4 dig -c 3075ae5abbc37 -w` — Mark Brown, linux-sound@
  CC'd
- **[Phase 4]** WebFetch lore URL — blocked by Anubis (UNVERIFIED review
  discussion)
- **[Phase 5]** `grep q6apm_graph_media_format` — 4 call sites in q6apm-
  dai.c and q6apm-lpass-dais.c
- **[Phase 5]** Read caller error handling in q6apm-dai.c:246-254,
  683-689 and q6apm-lpass-dais.c:195-199
- **[Phase 6]** Confirmed buggy code at q6apm.c:206-208 and 385-390 in
  current tree
- **[Phase 6]** Confirmed fix not present: `git log --grep="return error
  code" HEAD` empty
- **[Phase 7]** Kconfig confirms `CONFIG_SND_SOC_QDSP6` platform-
  specific driver
- **[Phase 8]** Precedent: `git show ba6474f19fd1b` — similar error
  propagation backported to stable
- **[Phase 8]** Precedent: `git show 90983f841dfa9` — q6asm-dai error
  handling backported to 6.18.y
- **UNVERIFIED:** DSP firmware crash from incomplete configuration
- **UNVERIFIED:** Lore review thread stable nominations

**YES**

 sound/soc/qcom/qdsp6/q6apm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm.c b/sound/soc/qcom/qdsp6/q6apm.c
index 6326649ba31b4..73c5dc0e5cc55 100644
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -203,10 +203,7 @@ int q6apm_graph_media_format_shmem(struct q6apm_graph *graph,
 	if (!module)
 		return -ENODEV;
 
-	audioreach_set_media_format(graph, module, cfg);
-
-	return 0;
-
+	return audioreach_set_media_format(graph, module, cfg);
 }
 EXPORT_SYMBOL_GPL(q6apm_graph_media_format_shmem);
 
@@ -374,6 +371,7 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
 	struct audioreach_sub_graph *sgs;
 	struct audioreach_container *container;
 	struct audioreach_module *module;
+	int ret;
 
 	list_for_each_entry(sgs, &info->sg_list, node) {
 		list_for_each_entry(container, &sgs->container_list, node) {
@@ -382,7 +380,9 @@ int q6apm_graph_media_format_pcm(struct q6apm_graph *graph, struct audioreach_mo
 					(module->module_id == MODULE_ID_RD_SHARED_MEM_EP))
 					continue;
 
-				audioreach_set_media_format(graph, module, cfg);
+				ret = audioreach_set_media_format(graph, module, cfg);
+				if (ret)
+					return ret;
 			}
 		}
 	}
-- 
2.53.0

