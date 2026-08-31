Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B734BCACA;
	Mon, 31 Aug 2026 13:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183539; cv=none; b=QQnDNkRpzDk6PKpFdFgg3npGbxY7QeEe/H3UeNhuLyXQaDNVzyKFs6vaIyBhE1bVm3E5EbetUeiILI66LqCBfrCRFNvtkKfqhA2X7JhzPCr4TCN2ApWAbSIuxbd3k053HGAxJZyGaTmTtEa4StR508H+7VsgIu8GP46PaizF9LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183539; c=relaxed/simple;
	bh=UE+NdVnIkweEAuxI6ridtErApdFrI8hQmc1IsUupI84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUMw3aIJg1HqusevNhB62c5kI6+fuYjlw/nZbbkZ8Q0x9JbGn+zizgCj+Y3I4J+lTfgw6T4UmdC4GyRz2LoDZDS5D4PoGjgcejyRs8AfsZNVNbs22dmJTApihRlD///BPJpoDZFnFSw9Tx8SFtb9myaX4ele4f8ObxWiLJO3Bo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ksd0zHQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ksd0zHQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C151F00ACA;
	Mon, 31 Aug 2026 13:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183536;
	bh=i1r2weoEmOco69zx8/TYt1CBtAw9qoWCTQIKGW9E1tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ksd0zHQmV1a57AGWyKORbF8QsNeaSHwD8y//Q5ZmJL1ebJmXBGadMAEFOnElVaRjs
	 FZXuT1eTDVUwVqmHrU2WuCL/AFbYMHE51dJR/nuFeiwADyW3kMg/rawGvae9c6YH8E
	 OD6ayS+7UCPPOKLhJkwWIbS3UyhuM4Jo+WhNOeHwCWZQMmMaEgal0w4jmIsV/jDqTK
	 2i8rtaA2zHHCpV88cTzksGPeZiprVgY74Yl7v48pGLZUYo5JHjm4sfy/qZKKI7LfH4
	 mj5yvI79JfzO36IAFK5tFONHFa+s75GWOWVDAraR+cFK4WQ1mcdqn5JDEy5rmdnWhC
	 QJtzfsLSeBkow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: Intel: sof_sdw: append dai type to dai link name unconditionally
Date: Mon, 31 Aug 2026 09:23:03 -0400
Message-ID: <20260831133314.4125787-155-sashal@kernel.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c84179a1d36bebe99d9694502737ae9f3a90d2bc ]

The dai_type is used to select function topologies. Since the topology
stream name and DAI link name use partial matching, unconditionally
appending the dai_type provides necessary selection metadata
without breaking existing topologies.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20260515083043.1864426-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[ASoC: Intel: sof_sdw]` `[append]` — unconditionally append DAI
type to DAI link names for SoundWire/Intel SOF board driver.

**Step 1.2 — Tags**
Record:
- **Signed-off-by:** Bard Liao `<yung-chuan.liao@linux.intel.com>`
  (author)
- **Reviewed-by:** Kai Vehmanen `<kai.vehmanen@linux.intel.com>`
- **Reviewed-by:** Liam Girdwood `<liam.r.girdwood@intel.com>`
- **Link:** https://patch.msgid.link/20260515083043.1864426-1-yung-
  chuan.liao@linux.intel.com
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags
- Notable: reviewed by Intel SOF maintainers; Dell engineer
  (`Deep.Harsora@Dell.com`) CC’d on submission

**Step 1.3 — Body analysis**
Record:
- **Bug:** `dai_type` metadata is required for function-topology
  selection, but is only appended when `ctx->append_dai_type` is true.
- **Symptom:** Function topologies cannot be selected on machines where
  `append_dai_type` stays false (common single-dailink configs).
- **Mechanism:** Topology stream names and DAI link names use partial
  matching; without the type suffix (`SimpleJack`, `SmartAmp`,
  `SmartMic`), selection fails.
- **Claim:** Unconditional append is safe because partial matching
  preserves compatibility with existing topologies.
- No explicit crash/oops; this is an audio/topology correctness bug.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although the subject uses “append” rather than “fix”,
this corrects broken function-topology selection logic, not a cosmetic
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **Files:** `sound/soc/intel/boards/sof_sdw.c` only (+12 / -11)
- **Function modified:** `create_sdw_dailink()`
- **Scope:** Single-file surgical fix in Intel SOF SoundWire board
  driver

**Step 2.2 — Code flow change**
Record:
- **Before:** `sdw_stream_name[]` had both plain (`"SDW%d-Playback"`)
  and typed (`"SDW%d-Playback-%s"`) formats; typed suffix used only when
  `ctx->append_dai_type` was true.
- **After:** Always uses typed format; sets `ctx->append_dai_type =
  true`; removes conditional branch.
- **Path affected:** DAI link / stream name creation during card probe
  for all SDW streams.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic / correctness fix for topology selection metadata.
- **Mechanism:** `ctx->append_dai_type` is set in
  `asoc_sdw_parse_sdw_endpoints()` only when `num_link_dailinks > 1`.
  For common single-dailink machines, names become `"SDW0-Playback"`
  with no type token. `sof_sdw_get_tplg_files()` matches
  `dai_link->name` via `strstr(...,
  "SimpleJack"/"SmartAmp"/"SmartMic")`, so selection fails and the
  callback returns 0.

**Step 2.4 — Fix quality**
Record:
- Fix is minimal and logically consistent with
  `sof_sdw_get_tplg_files()`.
- Reviewed by ASoC maintainer and Intel SOF maintainers.
- Low regression risk: commit explicitly states partial matching keeps
  existing topologies working; only Intel `sof_sdw.c` is touched (AMD
  paths unchanged).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: In this checkout, `git blame` attributes the conditional block
to the tree root commit (`a112b91dd6349`) because history is flattened.
The conditional `ctx->append_dai_type` code is present at lines 899–907
in current `sof_sdw.c`.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag in commit message.

**Step 3.3 — Related file history**
Record: `git log` on `sof_sdw.c` / `soc_sdw_utils.c` is not useful here
(single synthetic root commit). Related infrastructure verified present
in tree:
- `include/sound/soc_sdw_utils.h`: `append_dai_type` field
- `sound/soc/sdw_utils/soc_sdw_utils.c`: sets `ctx->append_dai_type |=
  (num_link_dailinks > 1)`
- `sound/soc/intel/common/sof-function-topology-lib.c`: function-
  topology selection via `strstr(dai_link->name, ...)`
- Many machine entries in MTL/PTL/ARL/LNL ACPI match files use
  `.get_function_tplg_files = sof_sdw_get_tplg_files`

**Step 3.4 — Author context**
Record: Bard Liao is an Intel SOF/ASoC contributor. Patch
reviewed/applied by Mark Brown (ASoC maintainer).

**Step 3.5 — Dependencies**
Record: Standalone one-patch fix. All required code exists in v6.18.43:
- `append_dai_type` logic
- `sof_sdw_get_tplg_files()`
- `get_function_tplg_files` machine hooks
- Fix commit `c84179a1d36b` exists in repo but is **not** in current
  HEAD (`NOT IN HEAD`).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- **URL:** https://lore.kernel.org/all/20260515083043.1864426-1-yung-
  chuan.liao@linux.intel.com/
- Thread has 2 messages (patch + Mark Brown “Applied”)
- No reviewer objections, NAKs, or explicit stable nominations
- Mark Brown applied to `broonie/sound` for-7.2; noted it may merge
  sooner if it is a bug fix

**Step 4.2 — Reviewers**
Record: CC’d to `broonie@kernel.org`, `tiwai@suse.de`, `linux-
sound@vger.kernel.org`, Intel maintainers, and `Deep.Harsora@Dell.com`.

**Step 4.3 — Bug report**
Record: No external bug report, syzbot link, or stack trace. Impact
inferred from code path and commit description.

**Step 4.4 — Series context**
Record: Standalone `[PATCH]` (1/1), not part of a multi-patch series.

**Step 4.5 — Stable list history**
Record: Not searched separately; no stable nomination found in the
thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `create_sdw_dailink()`, `asoc_sdw_init_dai_link()`,
`sof_sdw_get_tplg_files()`, `snd_sof_load_topology()`,
`asoc_sdw_parse_sdw_endpoints()`

**Step 5.2 — Callers**
Record:
- `create_sdw_dailink()` ← `create_sdw_dailinks()` ← card setup in
  `sof_sdw.c` during machine probe
- `sof_sdw_get_tplg_files()` ← machine `.get_function_tplg_files` hooks
  on MTL/PTL/ARL/LNL ACPI tables
- `snd_sof_load_topology()` called during SOF component probe

**Step 5.3 — Callees**
Record: `devm_kasprintf()`, `asoc_sdw_init_dai_link()` (sets
`dai_links->name` and `dai_links->stream_name`), firmware lookup in
topology loader.

**Step 5.4 — Reachability**
Record: Triggered at boot/probe on Intel laptops/desktops using
`sof_sdw` with SoundWire codecs and function-topology-enabled machine
tables. Common user-visible path for affected hardware.

**Step 5.5 — Similar patterns**
Record: AMD ACP SDW machine drivers (`acp-sdw-sof-mach.c`, `acp-sdw-
legacy-mach.c`) still use the same conditional `ctx->append_dai_type`
pattern, but this commit only fixes Intel `sof_sdw.c`.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.43)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Current `sof_sdw.c` still has the conditional at lines
899–907 and plain name formats at lines 870–872. Function-topology
infrastructure is also present.

**Step 6.2 — Backport complications**
Record: **Clean apply expected** — one file, localized hunk. No
conflicting local changes observed.

**Step 6.3 — Related fixes already present?**
Record: **No.** `git merge-base --is-ancestor c84179a1d36b HEAD` → `NOT
IN HEAD`.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem / criticality**
Record: **sound / ASoC / Intel SOF SoundWire board driver** — IMPORTANT
for Intel laptop/desktop audio users, not core-kernel-wide.

**Step 7.2 — Activity**
Record: Intel SOF SoundWire and function-topology support is actively
developed in this tree (2025 copyright on `sof-function-topology-lib.c`,
many recent machine entries).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of Intel SOF + SoundWire machines with
`.get_function_tplg_files = sof_sdw_get_tplg_files` (MTL, PTL, ARL, LNL,
and related platforms), especially single-dailink configurations
(`link_mask = BIT(0)` etc.).

**Step 8.2 — Trigger conditions**
Record:
- Boot/probe of supported Intel SOF SDW hardware
- Function topologies enabled (default unless overridden)
- `num_link_dailinks <= 1` → `append_dai_type` remains false without
  this fix
- Common on simple laptop configs (single codec/link)

**Step 8.3 — Failure mode / severity**
Record:
- Without fix: `sof_sdw_get_tplg_files()` hits the unsupported-link path
  and returns 0 when `dai_link->name` lacks
  `SimpleJack`/`SmartAmp`/`SmartMic`.
- `snd_sof_load_topology()` then falls back to monolithic topology.
- **Severity: MEDIUM–HIGH for affected hardware** — function-topology
  feature is effectively broken for the common single-dailink case;
  users may get wrong/missing audio functionality depending on whether
  monolithic fallback is complete for their platform/firmware. Not a
  kernel crash, but real hardware audio breakage risk.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH for affected Intel SOF SDW users — restores intended
  function-topology selection.
- **Risk:** LOW — ~20 lines, one file, maintainer-reviewed, behavior
  change aligns with existing partial-matching design.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Evidence FOR backport
- Real logic bug: function-topology selection cannot work when DAI names
  lack type suffix.
- Affects common Intel laptop/desktop SOF SoundWire configurations.
- Small, surgical, maintainer-reviewed fix.
- All prerequisite code exists in v6.18.43; fix not yet present.
- Hardware-relevant (Dell CC, Intel maintainers reviewed).

### Evidence AGAINST backport
- No explicit user bug report, CVE, or crash trace.
- Monolithic topology fallback may mask issue on some machines.
- Function topologies are relatively new infrastructure.

### Unresolved questions
- Whether every affected machine fails audibly without the fix, or only
  when function-only firmware/topologies are required (not directly
  testable from kernel tree alone).

### Stable rules checklist
1. Obviously correct and tested? **PASS** — logic matches
   `sof_sdw_get_tplg_files()`; reviewed by subsystem maintainers.
2. Fixes a real bug affecting users? **PASS** — broken function-topology
   selection on common configs.
3. Important issue? **PASS** — hardware audio functionality on widely
   used Intel platforms (MEDIUM–HIGH).
4. Small and contained? **PASS** — one file, ~23 lines changed.
5. No new features/APIs? **PASS** — corrects existing function-topology
   behavior.
6. Can apply to local tree? **PASS** — buggy code and dependencies
   present in v6.18.43.

### Exception category
Record: N/A (not device ID/quirk/DT/docs/build fix; this is a driver
correctness bug fix).

### Problem summary for stable users
On v6.18.43, Intel SOF SoundWire machines that rely on function
topologies often generate DAI link names like `"SDW0-Playback"` without
the codec-function suffix. `sof_sdw_get_tplg_files()` requires
substrings such as `"SimpleJack"` in `dai_link->name`, so function-
topology loading fails for the common single-dailink case. The patch
unconditionally appends the DAI type, restoring correct topology
selection without changing unrelated subsystems.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit and
  fetched lore mbox.
- [Phase 2] Diff analysis: conditional removed in
  `create_sdw_dailink()`, `ctx->append_dai_type = true` added.
- [Phase 3] `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`; Makefile
  → 6.18.43.
- [Phase 3] `git merge-base --is-ancestor c84179a1d36b HEAD` → NOT IN
  HEAD.
- [Phase 3] Verified `append_dai_type` set in `soc_sdw_utils.c:1494`.
- [Phase 3] Read current buggy code in `sof_sdw.c:868-907`.
- [Phase 4] `b4 mbox 20260515083043.1864426-1-yung-
  chuan.liao@linux.intel.com` → 2-message thread saved; Mark Brown
  applied, no objections.
- [Phase 4] lore web fetch blocked by bot protection; used b4 mbox
  instead.
- [Phase 5] Traced `sof_sdw_get_tplg_files()` `strstr()` matching at
  `sof-function-topology-lib.c:54-81`.
- [Phase 5] Traced fallback in `topology.c:2512-2534` when callback
  returns 0.
- [Phase 5] Confirmed `get_function_tplg_files` hooks in MTL/PTL/ARL/LNL
  ACPI match files.
- [Phase 6] Confirmed buggy conditional present in local tree.
- [Phase 6] Confirmed fix commit exists (`c84179a1d36b`) but is absent
  from HEAD.
- [Phase 8] Failure mode inferred from verified code path; exact user-
  visible severity per machine model UNVERIFIED without
  hardware/firmware testing.

**YES**The background check finished: commit `c84179a1d36b` is **not**
in the current `v6.18.43` tree, so the buggy conditional
`append_dai_type` logic is still present in `sof_sdw.c`. That supports
backporting the fix to this stable tree.

 sound/soc/intel/boards/sof_sdw.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 465bf5fafecf7..c9f4fe84c7eed 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -865,10 +865,16 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 	}
 
+	/*
+	 * The dai_type is used to select function topologies. Since the topology stream name
+	 * and DAI link name use partial matching, unconditionally appending the dai_type provides
+	 * necessary selection metadata without breaking existing topologies. Although
+	 * ctx->append_dai_type is not checked here, we overwrite it to ensure consistency in case
+	 * it is referenced elsewhere.
+	 */
+	ctx->append_dai_type = true;
 	for_each_pcm_streams(stream) {
 		static const char * const sdw_stream_name[] = {
-			"SDW%d-Playback",
-			"SDW%d-Capture",
 			"SDW%d-Playback-%s",
 			"SDW%d-Capture-%s",
 		};
@@ -896,15 +902,10 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 
 		/* create stream name according to first link id */
-		if (ctx->append_dai_type)
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      sdw_stream_name[stream + 2],
-					      ffs(sof_end->link_mask) - 1,
-					      type_strings[sof_end->dai_info->dai_type]);
-		else
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      sdw_stream_name[stream],
-					      ffs(sof_end->link_mask) - 1);
+		name = devm_kasprintf(dev, GFP_KERNEL,
+				      sdw_stream_name[stream],
+				      ffs(sof_end->link_mask) - 1,
+				      type_strings[sof_end->dai_info->dai_type]);
 		if (!name)
 			return -ENOMEM;
 
-- 
2.53.0

