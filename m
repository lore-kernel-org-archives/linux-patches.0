Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1D3DBD6C;
	Mon, 20 Apr 2026 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691448; cv=none; b=JUb9PuWvNw36gtcuxPUuDxTi2SNTWe8YJbLX4fN5eBX8sQmEMuTXD6TbMMcZia7awgfhDsw2/cu8guOQaKjK0DPgkT9osqS6kd819Rq43Fcw9n2ffLHB91JPlhob/ZqX1TLpvl5VOzdvlF21oZlya+w8A4QHn3/MABYYbsGqx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691448; c=relaxed/simple;
	bh=47thKNO+tFGrYMPIi6+M/QsBlK5HIGysFyuKn0jbBk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tew7gwR6hOy4pcqWtRGmKC2brmmmmjtPRu5GoseWxnXRxIEA9E4zTlk1RgGk2+vKQnbJVIkfepmiStk37jMQUcRCW8XGvRq+3qx1YLWSLOp0vNKHc55iz2jdWrFmyycwQHM/RdnNrdA5kJ9j8pZzYzCnbHsV5UG6tvH77LzFXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbeTDkC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbeTDkC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E7C2BCB6;
	Mon, 20 Apr 2026 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691448;
	bh=47thKNO+tFGrYMPIi6+M/QsBlK5HIGysFyuKn0jbBk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbeTDkC4quBuP6Cq1H9hPYDAF1TZEpzs0JD1X6J4/Hn8RRoP/RXxTSF7pALuvpEcM
	 3BenFvNo8YBWG8Vni96VYWnnxuG6c2pO4zuvPOAqk5EigFFpzvKMkm6iAE8yVN5yxU
	 s3dp0vG0sBTRXJwW7Xr+rYdCP5QriRVwBQHNCjcgAkJ9qtUjMn3Pg1SGEHStYV3qy/
	 S2lJ9Gagyl6/fDjSoOPsi2xXh4xtv7HitVGPFYTZXXdyhCTBKHCXsKIUEA+FQ/2Acz
	 lg8Keo3NVUjIc6v5neeJVMSb0A8XZyFtaX2C1UkJvwdXu4ywjQvIhgFGo8VEKDxrpE
	 jllxwj8Ma8cxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	perex@perex.cz,
	tiwai@suse.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: aoa/tas: Fix OF node leak on probe failure
Date: Mon, 20 Apr 2026 09:17:08 -0400
Message-ID: <20260420132314.1023554-34-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 1558905669e4da922fbaa7cf6507eb14779bffbd ]

Add missing of_node_put() in the error path.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260402023604.54682-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `ALSA: aoa/tas` (ALSA Apple Onboard Audio, TAS codec)
- **Action verb**: "Fix"
- **Summary**: Fix OF (Open Firmware) node reference leak on probe
  failure path

### Step 1.2: Tags
- **Signed-off-by**: wangdicheng <wangdicheng@kylinos.cn> (author)
- **Link**:
  `https://patch.msgid.link/20260402023604.54682-1-wangdich9700@163.com`
- **Signed-off-by**: Takashi Iwai <tiwai@suse.de> (ALSA subsystem
  maintainer)
- No Fixes: tag, no Cc: stable, no Reported-by — all expected for
  AUTOSEL candidates
- Takashi Iwai as committer is a strong signal: he is the ALSA
  maintainer

### Step 1.3: Commit Body
The message is very brief: "Add missing of_node_put() in the error
path." This concisely describes a reference counting bug (missing put on
error path).

### Step 1.4: Hidden Bug Fix
This is an explicit bug fix — no disguise. The commit directly states it
fixes a missing `of_node_put()`.

Record: [Reference counting bug fix — missing of_node_put on error path
in probe function]

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`sound/aoa/codecs/tas.c`)
- **Lines added**: 1
- **Lines removed**: 0
- **Function modified**: `tas_i2c_probe()` — the `fail:` error path
- **Scope**: Single-file, single-line, surgical fix

### Step 2.2: Code Flow Change
Before the fix, the `fail:` path in `tas_i2c_probe()`:

```873:876:sound/aoa/codecs/tas.c
 fail:
        mutex_destroy(&tas->mtx);
        kfree(tas);
        return -EINVAL;
```

After the fix, `of_node_put(tas->codec.node)` is added between
`mutex_destroy` and `kfree`. The reference taken at line 864
(`tas->codec.node = of_node_get(node)`) is now properly released.

### Step 2.3: Bug Mechanism
**Category**: Reference counting bug (OF node reference leak)
- At line 864, `of_node_get(node)` increments the OF node's refcount and
  stores the result in `tas->codec.node`
- If `aoa_codec_register()` fails at line 866, execution jumps to
  `fail:`
- Without the fix, the `fail:` path calls `kfree(tas)` which frees the
  struct holding the only pointer to the refcounted node — the refcount
  is never decremented
- The `tas_i2c_remove()` function at line 885 correctly calls
  `of_node_put(tas->codec.node)`, confirming the expected pattern

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — mirrors the cleanup pattern already in
  `tas_i2c_remove()` (line 885)
- **Minimal**: Yes — 1 line added
- **Regression risk**: Essentially zero — only adds cleanup on an error
  path
- **Placement**: Correct — `of_node_put(tas->codec.node)` is placed
  before `kfree(tas)` so the pointer is still valid

Record: [1 file, +1 line, reference counting fix on error path,
obviously correct, zero regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code (`of_node_get(node)` without matching put on error path)
was introduced in commit `f3d9478b2ce468` by Johannes Berg on 2006-06-21
("[ALSA] snd-aoa: add snd-aoa"). This is the initial commit for the
entire snd-aoa subsystem, from the v2.6.18 era.

Record: [Bug has been present since 2006 (v2.6.18). Present in ALL
stable trees.]

### Step 3.2: No Fixes: Tag
No Fixes: tag present — expected for AUTOSEL candidates. However, the
implicit fix target is `f3d9478b2ce468`.

### Step 3.3: File History
The file has had only minor maintenance changes (strscpy, guard()
conversions, kzalloc_obj treewide changes). No related of_node_put fixes
for this specific path.

The related commit `222bce5eb88d1` ("ALSA: snd-aoa: add of_node_put() in
error path") fixed a similar bug in `sound/aoa/core/gpio-feature.c` —
different file, same subsystem, same bug class.

### Step 3.4: Author
The author (wangdicheng) has contributed several ALSA fixes. The patch
was accepted by Takashi Iwai, the ALSA maintainer, giving it strong
credibility.

### Step 3.5: Dependencies
None. The fix is a single `of_node_put()` call — it is completely
standalone and applies cleanly.

Record: [No dependencies. Standalone fix. Accepted by subsystem
maintainer.]

---

## PHASE 4: MAILING LIST

### Step 4.1: Original Submission
b4 dig could not find the original submission (the commit hash is from
the autosel pipeline, not mainline). The Link: in the commit message
points to
`patch.msgid.link/20260402023604.54682-1-wangdich9700@163.com`. Lore was
not accessible due to bot protection.

### Step 4.2-4.5
Could not access lore.kernel.org due to Anubis anti-scraping protection.
However, the commit was accepted by the ALSA maintainer (Takashi Iwai),
which means it passed his review.

Record: [Lore inaccessible. Patch accepted by ALSA maintainer Takashi
Iwai.]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `tas_i2c_probe()` — specifically its `fail:` error path.

### Step 5.2: Callers
`tas_i2c_probe` is the I2C probe callback registered in the `tas_driver`
struct (line 904). It is called by the I2C subsystem when the device is
enumerated. This is a standard device probe path.

### Step 5.3-5.4: Call Chain
The error path is reached when `aoa_codec_register()` fails. Looking at
the function body (`sound/aoa/core/core.c` lines 57-69), it fails when
`attach_codec_to_fabric()` returns an error. This is a plausible failure
scenario during boot or module loading.

### Step 5.5: Similar Patterns
The sibling driver `onyx.c` has the **exact same bug** at lines 980-988:
- `onyx->codec.node = of_node_get(node)` at line 980
- The `fail:` label at line 987-989 calls `kfree(onyx)` without
  `of_node_put(onyx->codec.node)`

Record: [Same pattern bug exists in onyx.c. Probe function called by I2C
subsystem during device enumeration.]

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence
The buggy code was introduced in 2006 (`f3d9478b2ce468`). It exists in
**every** stable tree (5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
etc.).

### Step 6.2: Backport Complications
The only concern is the `kzalloc_obj` conversion on line 848 (from Feb
2026), which exists only in mainline 7.0. In older stable trees, this
will be `kzalloc(sizeof(*tas), GFP_KERNEL)`. However, the fix (adding
one line in the `fail:` path) is completely independent of the
allocation call. The `fail:` label context (mutex_destroy + kfree) has
been stable since 2006. The fix should apply cleanly or with trivial
context adjustment.

### Step 6.3: No related fixes in stable
No previous fix for this specific bug exists in stable trees.

Record: [Bug exists in all stable trees. Fix should apply cleanly with
minor context fuzz.]

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: ALSA (sound), Apple Onboard Audio — codec driver for
  TAS3004
- **Criticality**: PERIPHERAL — only affects Apple PowerPC-based
  machines with TAS3004 codec (PowerBooks, PowerMacs)

### Step 7.2: Activity
The file gets very infrequent changes (mostly treewide cleanups). This
is a mature, stable subsystem with minimal churn.

Record: [PERIPHERAL subsystem (Apple PowerPC audio). Mature code with
low churn.]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
Users with Apple PowerPC hardware using the TAS3004 audio codec. This is
a niche population, but real users exist (retrocomputing, legacy
systems).

### Step 8.2: Trigger Conditions
The bug triggers only when `aoa_codec_register()` fails during probe.
This is an error path, so it's not common, but it represents a real leak
each time it occurs (e.g., resource contention, misconfiguration).

### Step 8.3: Failure Mode Severity
- **OF node reference leak**: The node refcount is never decremented, so
  the OF node structure is never freed.
- Severity: **LOW-MEDIUM** — resource leak on error path, not a crash or
  security issue, but a real correctness bug.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Fixes a real reference counting bug that leaks memory on
  probe failure.
- **Risk**: Essentially zero — 1-line, obviously correct, mirrors
  existing cleanup in the remove function.
- **Ratio**: Very favorable — minimal risk, real correctness
  improvement.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting**:
- Fixes a real reference counting bug (missing `of_node_put()` on error
  path)
- 1-line fix, obviously correct, mirrors cleanup in `tas_i2c_remove()`
- Bug has existed since 2006, present in all stable trees
- Accepted by ALSA maintainer Takashi Iwai
- Zero regression risk
- Classic reference counting fix — standard stable material

**AGAINST backporting**:
- Only affects Apple PowerPC hardware with TAS3004 codec (niche)
- Only triggers on probe failure (error path, not common)
- Severity is LOW-MEDIUM (resource leak, not crash/security)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — mirrors existing cleanup in
   remove()
2. Fixes a real bug? **YES** — OF node reference leak
3. Important issue? **MODERATE** — resource leak, not critical
4. Small and contained? **YES** — 1 line, 1 file
5. No new features/APIs? **YES** — pure fix
6. Can apply to stable? **YES** — standalone, no dependencies

### Step 9.3: Exception Categories
Not an exception category. Standard bug fix.

### Step 9.4: Decision
This is a small, obviously correct reference counting fix. While the
impact is limited (niche hardware, error path only), the fix has
essentially zero risk and addresses a real correctness bug. OF node
reference leak fixes are routinely accepted in stable, and this follows
a well-established pattern.

---

## Verification

- [Phase 1] Parsed subject: ALSA: aoa/tas subsystem, "Fix" verb, OF node
  leak on probe failure
- [Phase 1] Parsed tags: Signed-off-by from author and Takashi Iwai
  (ALSA maintainer), Link to lore
- [Phase 2] Diff analysis: 1 line added in `tas_i2c_probe()` fail path:
  `of_node_put(tas->codec.node)` before `kfree(tas)`
- [Phase 2] Verified `of_node_get(node)` at line 864 takes a reference
  that is not released on error path
- [Phase 2] Verified `tas_i2c_remove()` at line 885 calls
  `of_node_put(tas->codec.node)` — confirming correct pattern
- [Phase 3] git blame: buggy code introduced in f3d9478b2ce468
  (2006-06-21, "[ALSA] snd-aoa: add snd-aoa")
- [Phase 3] git log: only treewide cleanups on this file, no prior fix
  for this specific bug
- [Phase 3] Related commit 222bce5eb88d1 fixed same bug class in gpio-
  feature.c (different file, same subsystem)
- [Phase 4] b4 dig: could not match rebased commit hash; lore.kernel.org
  blocked by Anubis
- [Phase 5] Verified `onyx.c` at lines 980-988 has the same unfixed bug
  pattern (systematic issue)
- [Phase 5] Verified `aoa_codec_register()` in core.c can fail when
  `attach_codec_to_fabric()` errors
- [Phase 6] Bug exists since 2006 — present in all active stable trees
- [Phase 6] Minor context difference in stable (kzalloc_obj vs kzalloc)
  won't affect the fix line
- [Phase 8] Failure mode: OF node reference leak on probe error path,
  severity LOW-MEDIUM
- UNVERIFIED: Could not access lore.kernel.org to check full review
  discussion or stable nominations

**YES**

 sound/aoa/codecs/tas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/aoa/codecs/tas.c b/sound/aoa/codecs/tas.c
index 13da2b159ad0d..25214d3da65d1 100644
--- a/sound/aoa/codecs/tas.c
+++ b/sound/aoa/codecs/tas.c
@@ -872,6 +872,7 @@ static int tas_i2c_probe(struct i2c_client *client)
 	return 0;
  fail:
 	mutex_destroy(&tas->mtx);
+	of_node_put(tas->codec.node);
 	kfree(tas);
 	return -EINVAL;
 }
-- 
2.53.0

