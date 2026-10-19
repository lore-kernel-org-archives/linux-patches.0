Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D673534E1F;
	Mon, 19 Oct 2026 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418330; cv=none; b=TOjK4V5sdfD60oLISNwtEvtDYIFFqSdDUpFiPqmAIR37QmR5YzCUdlfQDkoghP8lgOv1uVC5NN24+lsY2frCVhn7eUwO931aXGN3GmKEAKayZmUsntleV/09I7ge273KrPgGjndUxPO98a5MCpTGMxS+NLHd4tW2WvmUmPF9+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418330; c=relaxed/simple;
	bh=UE4NnoT493pvS51GbTL2WfN+oSCVnTbw0457tHTCllk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCaYEt/ijEwHuyPsN1iXlWlW8uSHeTJFiqtVooO1+voLgNEeeeyXfLp1drOJynQdzuWly18NeauvB6vSge/WtrtxG5aYISmoBLOAQievp3ZDsihvsY1XefcENsX0YVuoubSC7CMFY6xlPe22Vuqu1Y8neEe3vEaX4rll6uVBr/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ni8BoWWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ni8BoWWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7161F000CA;
	Mon, 19 Oct 2026 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418326;
	bh=rYBZe3igbPZbFkB4NVWRoMynaA+xpZR2p3CIOhgJA8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ni8BoWWHz87j1nYFEJk8BhNBlIwGy9qRkJJC8lR3/RnOaX3G1qK40s2ooAFe8ndjL
	 VJahuIW/ygkPaz9pO1AGHfmc+6JEUlUc5lotlV4EM2yI2T6p6yjdIDvJW3yeOX7uXZ
	 2YsHQ/2A+wUH5G+OvzqkW7Ykj8RnON1Wlt+k9OdQptnaM8M46IWE5HsWGhHjUM01Fa
	 isT9UWbF/re8OocLlHDNZnItI11CzZbEYXMdEbfgXrIeLmRkg8p5QxWzYQQlyUxdYV
	 RzWOz0pOLe/dIX1nPTZfLBpuTDWgfjYximZZdjIb8ROFf1UoK1PkPhtPwwtiybIfrG
	 xuM0G08R8+f/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] regmap: maple: Workaround for another false-positive compiler warning
Date: Mon, 19 Oct 2026 09:47:39 -0400
Message-ID: <20261019135441.1420968-168-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit dffd32eb2b0e714a8ae23f98518ad7152cb06369 ]

Similar to the issue fixed in commit 542440fd7b30 ("regmap: maple: work
around gcc-14.1 false-positive warning"), I see an uninitialized warning
for upper_index and upper_last.

Happens with arc-linux-gnu-gcc (Debian 15.3.0-1) 15.3.0 on an
allmodconfig for ARCH=arc.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260626060427.2548578-2-u.kleine-koenig@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the tree version, the pre-image at v6.18.53, the lore thread, and
the call-path context. Compiling the nine-phase analysis next.

---

## Phase 1: Commit message forensics

**Step 1.1: Subject**
Record: `[regmap: maple:] [Workaround] [silence a gcc false-positive
-Wuninitialized on upper_index/upper_last]`

**Step 1.2: Tags**
Record:
- Link: https://patch.msgid.link/20260626060427.2548578-2-u.kleine-
  koenig@baylibre.com
- Signed-off-by: Uwe Kleine-König (author)
- Signed-off-by: Mark Brown (regmap maintainer)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, or Cc:
  stable (absence expected)
- Mentions prior commit 542440fd7b30

**Step 1.3: Body**
Record: [Bug] gcc 15.3.0 on ARCH=arc allmodconfig reports
-Wuninitialized for `upper_index` and `upper_last` in
`regcache_maple_drop()`. Same class as the gcc-14.1 false-positive
already worked around for `lower_index`/`lower_last`. [Symptom] compiler
warning; with `CONFIG_WERROR` it is a hard build failure
(`-Werror=uninitialized`). [Versions] gcc 15.3.0 (Debian), ARCH=arc
allmodconfig. [Root cause] compiler cannot see that those locals are
only read after they are assigned (guarded by `if (upper)`).

**Step 1.4: Hidden bug fix?**
Record: Not a hidden runtime bug. It is an explicit compiler-warning
workaround. It is a **build fix**, which the stable rules treat as an
allowed exception.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `drivers/base/regmap/regcache-maple.c` — 1 line changed
(`+1/-1`). Function: `regcache_maple_drop()`. Scope: single-file, one-
line surgical change.

**Step 2.2: Flow**
Record: Before: `unsigned long upper_index, upper_last;` uninitialized.
After: `= 0` on both. No control-flow change. `upper_index`/`upper_last`
are assigned at lines 146–147 only when `mas.last > max`, which is also
when `upper` is allocated; they are consumed only under `if (upper)`
(line 171). Initializing to 0 is a dead store on the real path.

**Step 2.3: Bug mechanism**
Record: [Category] Build / compiler false-positive (not a runtime
uninitialized use). [Mechanism] gcc 15 cannot prove initialization
through the maple-tree loop and warns; with Werror that fails the build.
Fix: same dummy init already used for `lower_index`/`lower_last`.

**Step 2.4: Fix quality**
Record: Obviously correct; matches the existing comment and the gcc-14
workaround. Zero runtime behavior change. Regression risk: negligible (0
is never consumed unless `upper` is set, and that path always assigns
first).

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: `regcache_maple_drop()` introduced in f033c26de5a57 (“regmap:
Add maple tree based register cache”, 2023-03-30, ~v6.4). `lower_index`
dummy init: 542440fd7b309 (2024-07-19, in this tree). `upper_index` was
left uninitialized until this commit.

**Step 3.2: Fixes: tag**
Record: None. Related original: 542440fd7b309, already an ancestor of
HEAD and of v6.18.53.

**Step 3.3: File history**
Record: Recent real fixes in this file (`00bb549d7d63a` cache
corruption, `eaa03486d9325` uninitialized `ret`, `f08f2d2907675` leak on
store failure) are independent. This commit is standalone, not patch X/Y
of a functional series.

**Step 3.4: Author**
Record: Uwe Kleine-König is a regular driver-core contributor, not the
regmap maintainer. Mark Brown applied it. No other related maple commits
by this author.

**Step 3.5: Dependencies**
Record: Needs the maple cache (present since v6.4) and the existing
`lower_*` init comment (present). Applies standalone. No new helpers or
struct fields.

---

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record: [Lore]
https://patch.msgid.link/20260626060427.2548578-2-u.kleine-
koenig@baylibre.com
[Revisions] v1 only (`b4 dig -a`). Thread: submission + Mark Brown
“Applied to broonie/regmap.git for-7.3”. No NAKs, no stable nomination,
no reviewer risk flags.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: To: Mark Brown. Cc: Greg Kroah-Hartman, Rafael Wysocki, Danilo
Krummrich, linux-kernel, driver-core. Maintainer received and applied
it.

**Step 4.3: Bug report**
Record: Author-reported compiler warning on arc-linux-gnu-gcc 15.3.0
allmodconfig. No syzbot/bugzilla. Severity: build warning/error, not a
runtime crash.

**Step 4.4: Series**
Record: msgid `…2548578-2` but subject is `[PATCH v1]` and Mark applied
it as `[1/1]`. Standalone.

**Step 4.5: Stable list**
Record: No lore.kernel.org/stable discussion of this specific fix found.

---

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: `regcache_maple_drop()` only.

**Step 5.2: Callers**
Record: Wired as `regcache_ops.drop`. Reached via
`regcache_drop_region()` (exported). Callers: regmap core, kunit tests,
various drivers. The *warning* triggers at compile time whenever this
file is built, independent of runtime callers.

**Step 5.3: Callees**
Record: maple-tree `mas_*`, `kmemdup_array`, `kfree`. Unchanged.

**Step 5.4: Reachability**
Record: Compile-time: `drivers/base/regmap/regcache-maple.c` is built
with `CONFIG_REGMAP` (common). Runtime drop path is not relevant to the
failure mode.

**Step 5.5: Similar patterns**
Record: Same function already initializes `lower_index`/`lower_last` for
the same reason (542440fd7b309) and `ret` for smatch (eaa03486d9325).
This completes the remaining pair.

---

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the buggy code exist?**
Record: Local tree is **6.18.53** (`git describe`:
v6.18.53-5049-g0f0bdc2b0dffb; Makefile VERSION=6 PATCHLEVEL=18
SUBLEVEL=53). At **v6.18.53**:
```
unsigned long upper_index, upper_last;
```
exists; `lower_index = 0` is already present. Upstream dffd32eb2b0e is
**not** an ancestor of v6.18.53. Maple cache has been here since ~v6.4.

**Step 6.2: Backport difficulty**
Record: Clean apply on v6.18.53. Surrounding function matches the hunk.
No refactor in the way.

**Step 6.3: Related fixes already here?**
Record: gcc-14 `lower_*` workaround is in v6.18.53. Nothing already
initializes `upper_*`.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: [Subsystem] drivers/base/regmap (maple register cache).
[Criticality] IMPORTANT — used by many hardware drivers; this change is
compile-time only.

**Step 7.2**
Record: Mature cache implementation (since v6.4), modest ongoing churn.
Not staging.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Anyone compiling this file with gcc that emits the warning.
Documented trigger: ARCH=arc, gcc 15.3.0, allmodconfig. `CONFIG_WERROR`
defaults to `COMPILE_TEST` (`init/Kconfig`); allmodconfig enables that,
so the warning becomes `-Werror=uninitialized` (same diagnostic the
gcc-14 commit showed as a hard error). Distro production configs usually
have WERROR=n, so they see a warning rather than a failed build.

**Step 8.2: Trigger**
Record: Compile of `regcache-maple.c`. Not a runtime race. Not
userspace-triggerable.

**Step 8.3: Failure mode**
Record: Build warning, or build *error* when WERROR is on. Severity:
MEDIUM for CI/allmodconfig (broken compile), LOW at runtime (no
functional bug).

**Step 8.4: Risk-benefit**
Record: Benefit: restores allmodconfig/WERROR builds on gcc 15 (and
likely similar compilers). Risk: very low — one-line initializer, proven
pattern in the same function. Ratio: favorable.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Explicit **build-fix** exception (compilation warnings/errors).
- Reproduced: gcc 15.3.0, ARCH=arc allmodconfig.
- With `CONFIG_WERROR` this is a hard build failure
  (`-Werror=uninitialized`), same class as 542440fd7b309, which is
  already in this tree.
- One line, obviously correct, no runtime change.
- Buggy (uninitialized) locals exist in v6.18.53; patch applies cleanly.
- Maintainer (Mark Brown) applied it; no NAKs.

AGAINST:
- Not a runtime crash/corruption/security bug.
- Applied to for-7.3 (merge window), not a -fixes pull, so not treated
  as urgent by the maintainer.
- Narrowest documented trigger is ARC + gcc 15 + allmodconfig.
- No Cc: stable (expected; not a negative).

UNRESOLVED:
- Whether gcc 15 also warns on x86/arm allmodconfig for 6.18 was not
  reproduced here (author only cited ARC).
- lore.kernel.org HTTP fetch returned 403; discussion recovered via `b4
  dig -m` and openwall/patchew mirrors.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — dummy init; author built ARC
   allmodconfig; maintainer applied.
2. Real bug affecting users? **PASS** as a build break under
   WERROR/allmodconfig; not a runtime bug.
3. Important (crash/security/corruption/deadlock)? **FAIL** as a runtime
   issue; **PASS** under the build-fix exception.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — v6.18.53 has the pre-image.

**Step 9.3: Exception**
Record: **Build fix** (compiler warning that becomes a compile error
with WERROR).

**Step 9.4: Decision**
This is a one-line, zero-risk workaround for a real gcc 15 false-
positive that breaks `CONFIG_WERROR` builds of a file this 6.18.y tree
already ships. It matches the gcc-14 workaround already present here. It
meets the build-fix exception and applies cleanly.

---

### What the commit solves for this tree

v6.18.53 still declares `upper_index`/`upper_last` uninitialized in
`regcache_maple_drop()`. gcc 15.3.0 (ARC allmodconfig) warns; with
WERROR that fails the kernel build. Initializing them to 0, as already
done for `lower_index`/`lower_last`, silences the diagnostic without
changing runtime behavior.

### Risk vs benefit

Benefit is restoring compiles for WERROR/allmodconfig (and silencing the
warning otherwise). Risk is a dead store of 0. No prerequisites beyond
code already in 6.18.y.

### Verification
- [Phase 1] Parsed tags: Link to msgid, SOBs from Uwe Kleine-König and
  Mark Brown; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: 1 line in `regcache_maple_drop()`; `upper_index,
  upper_last` → `= 0`
- [Phase 2] Read function: `upper_*` assigned only when `mas.last >
  max`, used only under `if (upper)`
- [Phase 3] blame: maple cache f033c26de5a57 (v6.4); lower_* init
  542440fd7b309 (in this tree)
- [Phase 3] `git merge-base --is-ancestor 542440fd7b309 HEAD` → yes;
  `dffd32eb2b0e` vs v6.18.53 → not ancestor
- [Phase 3] `git show 542440fd7b309`: same -Werror=uninitialized class
  for `lower_index`
- [Phase 4] `b4 dig -c dffd32eb2b0e`: lore msgid
  20260626060427.2548578-2; v1 only; applied for-7.3
- [Phase 4] `b4 dig -w`: Mark Brown, Greg KH, driver-core CC’d
- [Phase 4] mbox: Mark Brown applied [1/1]; no NAK, no stable Cc
- [Phase 4] WebFetch lore/msgid.link: 403; recovered via openwall +
  patchew + mbox
- [Phase 5] callers: `regcache_ops.drop` → `regcache_drop_region()`;
  warning is compile-time
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.53
- [Phase 6] `v6.18.53:drivers/base/regmap/regcache-maple.c` still has
  `unsigned long upper_index, upper_last;`
- [Phase 7] init/Kconfig: `config WERROR` default `COMPILE_TEST`;
  Makefile.extrawarn adds `-Werror`
- [Phase 8] Failure mode: compile warning/error, not runtime oops
- UNVERIFIED: whether gcc 15 warns on non-ARC 6.18 allmodconfig (author
  only reported ARC)

**YES**

 drivers/base/regmap/regcache-maple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 9cf0384ce7b95..615ecb89d5377 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -112,7 +112,7 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 	unsigned long *entry, *lower, *upper;
 	/* initialized to work around false-positive -Wuninitialized warning */
 	unsigned long lower_index = 0, lower_last = 0;
-	unsigned long upper_index, upper_last;
+	unsigned long upper_index = 0, upper_last = 0;
 	int ret = 0;
 
 	lower = NULL;
-- 
2.53.0

