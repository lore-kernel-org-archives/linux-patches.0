Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BEC503BE9;
	Mon, 19 Oct 2026 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418809; cv=none; b=U1xzzXOlRJ0oYoQL2u6cq5AzythkH05kVYfZn17cVmNLEx7y3N+maZxlY91/fIFbBLGG8P3rzVu9Ij9kXrZr7Nxufb4khxJoRqzK5+iKjTWzJKqCadE6YG1Va6E+nQLfZgG6yr05GXjF/p2R8T7Q7cAy3O2pj+hhOeixri7zSpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418809; c=relaxed/simple;
	bh=8HTGKz/1NgVU+pDsV/Bim2NeNHfDYKv/D+EClCVs6Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nke4RCeJyZ0++QaY+ju5P7zn6gcJpBGD9oJUGOsSlqh7GMPf5pLng4CxVeWWa+QngoRNE9WLM3AgvuyxPTaLvbNQLMknv9fGE56oxHC72vh4nAXnW+q0mFgBbTXfeLJaIxrUiUeuBVIEY9jhg4k240kC6e3SgSKMqU2dmBxHD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVS9jDb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVS9jDb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BC41F000C6;
	Mon, 19 Oct 2026 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418803;
	bh=WI7wYpsNMkdXcklVicKth9S9t37805X7PofsGlT4fB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVS9jDb7x1yRx0hBUr2N6Ud9RJWEikoPVpNghCh2HJEnWCPi/d3jA42fzeiiuD9sK
	 MlnX70NgtKFM+xmahYs0TjiUckNZdjEqfgYp3jvFMVx/eohlROLIeovC6v2aIc1Fen
	 YyCgNEA/Rmxdq/6OwNe1OUi5Mkunww824JCWq4NOzW5oTvvhsfBPTUjKhRiWgCW6Q2
	 HDxfd5wH1XIJ3JZnxdhzfLjkHUZRb3ki6kT2IV5gzfs/I1zAjDX3AvvAapNtTwdYUY
	 tWreaMnzqxupa7oT9zqZwzlibbr8kg6pGI0cCtR9w1QFvVwK9YJr6o5t30uC302T1K
	 VaUHGaGGe38Og==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Mon, 19 Oct 2026 09:53:18 -0400
Message-ID: <20261019135441.1420968-507-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 273806f38ce95c95c288a03d3de1e423cd3e5543 ]

snd_hda_add_new_path() returns NULL when no path exists between the
given NIDs, but olpc_xo_update_mic_pins() passes dc_mode_path
straight to snd_hda_activate_path() which dereferences it without
checking. Add the missing NULL guards, same as the local path
variable already has in the same function.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable backport analysis: `ALSA: hda/conexant: Add NULL check for
dc_mode_path`

Local tree: **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). Evaluation is
for this checkout only. The conexant OLPC XO path exists here; the
change is a two-site NULL guard in `olpc_xo_update_mic_pins()`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `ALSA: hda/conexant`
- Action verb: **Add** (NULL check)
- Claimed intent: stop passing a possibly-NULL `dc_mode_path` into
  `snd_hda_activate_path()`

Record: `[ALSA/hda/conexant] [add] [NULL-check dc_mode_path before
snd_hda_activate_path]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>` (author)
- `Link:
  https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com`
  (patch 2/2)
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer;
  applied)
- No `Fixes:`
- No `Reported-by` / `Tested-by` / `Reviewed-by` / `Acked-by`
- No `Cc: stable` (expected for this review pipeline)
- Pipeline `Signed-off-by: Sasha Levin` is absent from the real commit
  and is ignored anyway

Record: Maintainer SOB only; no crash reporter, syzbot, or Fixes tag.
Msgid `-2` shows this is **patch 2/2**.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The body says `snd_hda_add_new_path()` can return NULL when no path
exists between the given NIDs, and `olpc_xo_update_mic_pins()` passes
`spec->dc_mode_path` to `snd_hda_activate_path()` with no check. The
local `path` variable in the same function is already NULL-checked. No
stack trace, reproducer, or version range.

Record:
- [Bug] Unchecked NULL from `snd_hda_add_new_path()` used later
- [Symptom] NULL deref / oops in `snd_hda_activate_path()`
  (`path->active = enable`)
- [Version info] none in the message
- [Root cause] missing NULL guards, unlike the sibling `path` checks

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not disguised. It is an explicit NULL-deref guard. Not a feature or
refactor.

Record: `[Not a hidden fix; stated NULL deref guard]`

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- File: `sound/hda/codecs/conexant.c` (+4 / -2)
- Function: `olpc_xo_update_mic_pins()`
- Classification: single-file surgical fix

Record: `[conexant.c +4-2] [olpc_xo_update_mic_pins] [surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Hunk 1 (`!spec->dc_enable`, default path): always called
`snd_hda_activate_path(..., dc_mode_path, false, false)` to disable the
DC path → now skipped if `dc_mode_path` is NULL.

Hunk 2 (`spec->dc_enable`): always activated the DC path → now skipped
if NULL.

Both are the normal OLPC mic-pin update path (init, jack, capture,
mixer), not a new error-handling framework.

Record: `[unconditional activate_path → NULL-guarded activate_path on
both branches]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **memory safety / NULL pointer dereference**.

`cxt_fixup_olpc_xo()` does:

```c
spec->dc_mode_path = snd_hda_add_new_path(codec, 0x1e, 0x14, 0);
```

`snd_hda_add_new_path()` is documented to return NULL if no valid path
is found, and also returns NULL if `is_reachable_path()` fails,
`snd_array_new()` fails, or `snd_hda_parse_nid_path()` fails.
`snd_hda_activate_path()` immediately does `path->active = enable` with
no NULL check.

Record: `[NULL deref] [add_new_path NULL stored, later deref in
activate_path]`

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct and matches the existing `if (path)` pattern in the
same function. Minimal. Skipping activate on NULL cannot activate a
missing path anyway, so behavior is “don’t oops” rather than a new
feature. Regression risk is very low: no locking, no API, no data-
structure change.

Record: `[obviously correct, 2 ifs] [regression risk: very low]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Unchecked `snd_hda_activate_path(codec, spec->dc_mode_path, ...)` and
the assignment of `dc_mode_path` come from `3a00c6605b7709` (“ALSA:
hda/conexant - Re-implement OLPC XO workarounds via fixup”), Takashi
Iwai, 2014-01-27, first contained in **v3.15-rc1**. Present as an
ancestor of this HEAD.

Record: `[3a00c6605b7709, v3.15-rc1] [code present ~12 years]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. Introducer verified by blame as above. `git merge-base
--is-ancestor 3a00c6605b7709 HEAD` succeeded.

Record: `[no Fixes tag] [buggy code exists in this tree since v3.15]`

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `conexant.c` work is headset/LED/pin quirks. Only related hit for
`dc_mode_path` is this commit. Standalone relative to later conexant
changes.

Record: `[no prerequisites in recent file history] [standalone vs later
work]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
wangdicheng is a regular ALSA contributor, not the subsystem maintainer.
Nearby work includes other defensive checks. Same-day series: this patch
plus `[PATCH 1/2] ALSA: hda/conexant: Fix EAPD pin array overflow`.

Record: `[regular contributor] [2/2 series; patch 1 was rejected]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Needs `olpc_xo_update_mic_pins`, `dc_mode_path`, and
`snd_hda_activate_path` — all present. Patch 1/2 is **not** a
dependency; Takashi NAK’d it (“No, it checks right after the increment…
overwrite won't happen”), and this tree still has the original EAPD
write-then-check order. This NULL-check applies standalone.

Record: `[no functional dependency on 1/2] [applies standalone]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 273806f38ce95` matched:
https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com

`b4 dig -a`: **v1 only** (no v2/v3). Thread saved to mbox.

Takashi on 2/2: “Applied to for-next branch now. Thanks.” No NAK, no
stable nomination, no concern about this patch.

Takashi on 1/2: explicit rejection — the claimed EAPD overflow does not
happen.

Record: `[lore msgid 20260729070935.548050-2] [v1 only] [2/2 applied;
1/2 NAK’d] [no Cc: stable in review]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` recipients: `tiwai@suse.com`, `broonie@kernel.org`, `linux-
sound@`, `linux-kernel@`, author. Subsystem maintainer was To: and
applied the patch.

Record: `[Takashi Iwai applied; Mark Brown CC’d; linux-sound CC’d]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No `Reported-by`, no bugzilla, no syzbot. HTTP fetch of lore.kernel.org
returned 403; discussion recovered via `b4 dig -m` instead. No evidence
of a user-reported oops.

Record: `[no user/syzbot report found] [static/code-review style
finding]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
2/2 of “conexant defensive fixes”. Patch 1 was a false positive. Patch 2
does not depend on patch 1.

Record: `[series 2/2; sibling not needed and not in tree]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable HTTP search: **UNVERIFIED** (403). No
`dc_mode_path` discussion in this tree’s git history besides this
commit.

Record: `[UNVERIFIED: stable list search via HTTP] [no in-tree stable
discussion]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Modified: `olpc_xo_update_mic_pins()`
- Related: `cxt_fixup_olpc_xo()`, `olpc_xo_automic()`,
  `olpc_xo_capture_hook()`, `olpc_xo_dc_mode_put()`,
  `olpc_xo_dc_bias_enum_put()`, `snd_hda_add_new_path()`,
  `snd_hda_activate_path()`

Record: `[olpc_xo_update_mic_pins only in the diff]`

**Step 5.2: TRACE CALLERS**
`olpc_xo_update_mic_pins()` is called from:
1. `olpc_xo_automic` — `mic_autoswitch_hook`
2. `olpc_xo_capture_hook` — PCM PREPARE/CLEANUP (capture start/stop)
3. `olpc_xo_dc_mode_put` — “DC Mode Enable Switch” mixer
4. `olpc_xo_dc_bias_enum_put` — if `dc_enable`

`olpc_xo_automic` is invoked from `call_mic_autoswitch()` in generic
HDA, including `update_automute_all()` from **codec init**
(`snd_hda_gen_init` path at generic.c:6029). So a NULL `dc_mode_path`
oopses on the **default** `!dc_enable` branch during init or jack
handling, not only when DC mode is turned on.

Record: `[init, jack, capture, mixer] [reachable without enabling DC
mode]`

**Step 5.3: TRACE CALLEES**
`update_mic_pin` / `snd_hda_codec_write_cache`,
`snd_hda_get_path_from_idx`, `snd_hda_activate_path`, pin-target
helpers. The dangerous callee is `snd_hda_activate_path` → `path->active
= enable`.

Record: `[activate_path dereferences path unconditionally]`

**Step 5.4: FOLLOW THE CALL CHAIN**
Quirk `SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT_FIXUP_OLPC_XO)`
plus model hint `olpc-xo`. Probe sets the hook and path; gen init calls
automute; userspace capture/mixer also reach it. Unprivileged capture on
that machine can hit it if the pointer is NULL.

Record: `[userspace-reachable on OLPC XO-1.5 and model=olpc-xo] [init
also hits it]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Same function already NULL-checks `snd_hda_get_path_from_idx()` results.
`snd_hda_activate_path()` itself does not check NULL (generic helper;
callers must).

Record: `[inconsistent NULL check vs local path; helper assumes non-
NULL]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `sound/hda/codecs/conexant.c`: `dc_mode_path` on the spec,
assignment in `cxt_fixup_olpc_xo`, use in `olpc_xo_update_mic_pins`.
Introduced v3.15, long before 7.3. (Current HEAD already contains
273806f38ce95; that is the original upstream commit, not used as a
“already selected for stable” argument.)

Record: `[buggy pattern exists in this lineage; file present at
sound/hda/codecs/conexant.c] [since v3.15]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
On **this** 7.3-rc4 tree the path and context match the candidate diff.
Codec drivers were moved in `6014e9021b28e` (v6.17 era); that does not
block this tree. No conflicting local edits.

Record: `[clean apply on this tree]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No earlier alternate fix for `dc_mode_path`. Patch 1/2 is not in the
tree (correctly, it was wrong).

Record: `[no alternate fix] [EAPD sibling correctly absent]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
ALSA HD-audio, Conexant codec, **OLPC XO-1.5-only** fixup. Criticality:
**PERIPHERAL** (one PCI quirk / one model hint), but still a real
shipped platform.

Record: `[ALSA HDA conexant / OLPC XO] [PERIPHERAL]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
conexant.c still gets headset/LED/pin quirks. The OLPC block itself has
been stable since 2014.

Record: `[driver active; OLPC XO block mature]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
OLPC XO-1.5 (`0x152d:0x0833`) and anyone forcing `model=olpc-xo` on a
Conexant codec. Not a generic conexant bug.

Record: `[driver/platform-specific; tiny population]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
NULL only if `snd_hda_add_new_path(0x1e, 0x14)` fails: unreachable NIDs
(wrong hardware + olpc-xo fixup) or `snd_array_new()` ENOMEM. On real
XO-1.5 the path was designed to exist; **no oops reports in ~12 years**.
If it is NULL, codec init or first jack/capture hits it on the default
`!dc_enable` branch. Unprivileged capture can trigger it once the
pointer is NULL.

Record: `[rare: ENOMEM or wrong model] [init/jack/capture] [unprivileged
if already NULL]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
NULL deref in `snd_hda_activate_path` → kernel oops. Not data corruption
or a security hole by itself.

Record: `[oops] [HIGH if triggered; LOW likelihood on intended
hardware]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Benefit: prevents oops on a real (if narrow) error path; same pattern
  already used for `path`.
- Risk: two extra NULL tests; no API/lock/behavior change when the
  pointer is valid.
- Ratio: **low benefit, very low risk**. The crash-prevention bias still
  favors taking it.

Record: `[benefit: modest] [risk: very low] [favorable for a 4-line oops
guard]`

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Verified unconditional deref in `snd_hda_activate_path()`
  (`path->active = enable`)
- `snd_hda_add_new_path()` documented to return NULL; return is stored
  unchecked
- Default `!dc_enable` path also calls activate, including codec init
  via `update_automute_all()`
- 4-line, obviously correct, matches existing `if (path)` in the same
  function
- No new API/feature; no dependency on the NAK’d 1/2
- Buggy code has been in this tree’s lineage since v3.15; file exists
  here
- ALSA maintainer applied it
- Crash-class failure if the pointer is NULL

AGAINST:
- No `Reported-by`, syzbot, or stack trace in 12 years
- Only OLPC XO-1.5 / `model=olpc-xo`
- Same series’ patch 1 was a false positive NAK’d by Takashi (static-
  analysis/LLM-style noise)
- On intended hardware the 0x1e→0x14 path is expected to exist
- Not nominated for stable in review

UNRESOLVED:
- HTTP lore.kernel.org/stable search (403); thread itself was recovered
  with `b4`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — correct by inspection;
   maintainer applied (no extra Tested-by)
2. Fixes a real bug that affects users? **PASS** — real NULL-deref
   defect; user population is small
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   oops if triggered (HIGH, narrow)
4. Small and contained? **PASS** — 2 if-statements, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — matching file and function in
   7.3-rc4

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
None (not a device ID, quirk table add, DT, build, or docs fix).
Qualifies as a normal crash-prevention bugfix.

**Step 9.4: MAKE YOUR DECISION**
The hardware audience is tiny and there is no field report, but the
defect is a real oops on a reachable init/capture path, the patch is two
NULL tests with essentially no regression surface, and it does not need
the rejected sibling. For this tree, that meets stable rules. Borderline
impact is resolved in favor of including a crash fix.

---

## What the commit solves and why it matters here

`cxt_fixup_olpc_xo()` stores `snd_hda_add_new_path(codec, 0x1e, 0x14,
0)` in `spec->dc_mode_path` and never checks it.
`olpc_xo_update_mic_pins()` later passes that pointer into
`snd_hda_activate_path()`, which writes `path->active` immediately. That
runs on codec init, jack autoswitch, and capture — even with DC mode
off. If the path is missing (ENOMEM or `model=olpc-xo` on a codec
without 0x1e→0x14), the result is an oops, not a clean skip.

Stable users of this 7.3 line who have that quirk get a 4-line guard
already used for the other path in the same function. Risk is
negligible; the only real caveat is limited hardware, which is not a
reason to leave a verified NULL deref unfixed.

---

## Verification

- [Phase 1] Parsed tags: author SOB, maintainer SOB, msgid Link
  `...548050-2`; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: two `if (spec->dc_mode_path)` wrappers in
  `olpc_xo_update_mic_pins()`; +4/-2
- [Phase 2] Read `snd_hda_activate_path()`: first use is `path->active =
  enable` with no NULL check
- [Phase 2] Read `snd_hda_add_new_path()`: documented NULL; also NULL on
  unreachable path, `snd_array_new` failure, parse failure
- [Phase 3] `git blame`: introducer `3a00c6605b7709` (2014); `git
  describe --contains` → v3.15-rc1
- [Phase 3] `git merge-base --is-ancestor 3a00c6605b7709 HEAD`: yes
- [Phase 3] `git show 273806f38ce95^:sound/hda/codecs/conexant.c`:
  confirmed unguarded calls before the fix
- [Phase 3] No `Fixes:` tag to follow
- [Phase 3] Author log on `sound/`: regular ALSA contributor; 2/2 series
- [Phase 4] `b4 dig -c 273806f38ce95`:
  https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: tiwai, broonie, linux-sound, linux-kernel
- [Phase 4] `b4 dig -m`: Takashi applied 2/2; NAK’d 1/2 EAPD overflow as
  incorrect
- [Phase 4] WebFetch lore.kernel.org: 403 — discussion taken from mbox
  instead
- [Phase 5] Callers of `olpc_xo_update_mic_pins`: automic, capture hook,
  two mixer puts
- [Phase 5] `update_automute_all()` → `call_mic_autoswitch()` from gen
  init (generic.c:6029)
- [Phase 5] Quirk: `SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5",
  CXT_FIXUP_OLPC_XO)`; model `olpc-xo`
- [Phase 6] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 6] File present at `sound/hda/codecs/conexant.c`; pre-fix code
  in parent of 273806f38ce95
- [Phase 6] `git merge-base --is-ancestor 273806f38ce95 HEAD`: original
  commit is in this history
- [Phase 8] Failure mode: NULL deref oops; severity HIGH if hit,
  population OLPC XO-1.5 / model override
- UNVERIFIED: lore.kernel.org/stable HTTP search (403)
- UNVERIFIED: whether 0x1e→0x14 is reachable on every CX codec if
  someone forces `model=olpc-xo` (not required for the decision; ENOMEM
  and missing-path cases are already documented in
  `snd_hda_add_new_path()`)

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 sound/hda/codecs/conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index fe7445fabb887..56d6fbdd9b06d 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -457,7 +457,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -493,7 +494,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 		update_mic_pin(codec, 0x1b, 0);
 		/* enable DC bias path and pin */
 		update_mic_pin(codec, 0x1e, spec->recording ? PIN_IN : 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
 	}
 }
 
-- 
2.53.0

