Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E376C3C0623;
	Mon, 20 Apr 2026 13:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691045; cv=none; b=qdfKBjPgNhQH3dI3cW4GuCy1LUGMazegQM/TefFJd/dFdmsZzw47KVpRvqOShDR66Oh1F+/yX/PwlJpiozWuJASf/XnulLiDlfoMxDK9J7IV01r3iHuOQwJAz4AxqrSGqmIxafSY95zjtNg6oKOj2soU3/Iu3W8+n1GUkAiwoLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691045; c=relaxed/simple;
	bh=ThxMyVbcwAzW0tqsHpizXd80AqabTKh2lu5uYmqS6bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JT4FvTz08yzcfi1+y788bm1zZQ80c/Ytzw8tpwI73QT0B8FDgIlGsBZRcIJyzwDuTaZWh48hoqa5AMAgNyp0LljkixTRQGTunxkpGAt0ELrdyspIBB9qdrRep5YUM/Qs+CK8qpAwRxO16uUuayTDrlVt2b7FuiRWKvQdC9C9Ou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cw4J6MzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cw4J6MzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA21C19425;
	Mon, 20 Apr 2026 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691044;
	bh=ThxMyVbcwAzW0tqsHpizXd80AqabTKh2lu5uYmqS6bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw4J6MzCcaRN+URlTbXsevMjj9pk2ib47xRaneBLUa9vfhHt7FmD/TKleUsgZpYAq
	 Hn0s2RppOKrTLPpKvkSwOI/Qwpnt4zHcTiUzG+pnYwH/QZr9LsVqulnrKF1OHYH7c3
	 eeoOyPHCBizoG1JqiOGomOXAOEZlv6PDIgu+lGZ3diMBsnYKsu5RI0xLjhXdkP8ZaF
	 FoK0UzmA3wZyRKyC3C+8ssvtOjWbi4CI0HKbxtquOx9QmvrYiFvrlwrNw98AbPiVx7
	 Zc830HUT4AL9QkWwVK1LeYZt6mHmysU1Fb1uSwk1u2Z/bv7xDxD+UduTHLGw+jIgmr
	 +/PHfR1ugANbg==
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
Subject: [PATCH AUTOSEL 7.0-5.10] ALSA: aoa/onyx: Fix OF node leak on probe failure
Date: Mon, 20 Apr 2026 09:08:47 -0400
Message-ID: <20260420131539.986432-61-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

[ Upstream commit e5d5aef802a5f41283084f7d443ef4fd4b65d86d ]

Add missing of_node_put() in the error path.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260403014736.33014-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
- **Subsystem**: ALSA: aoa/onyx (Apple Onboard Audio, onyx codec)
- **Action verb**: "Fix" — direct bug fix
- **Summary**: Fixes an OF (Open Firmware) device tree node reference
  leak when the probe function fails

### Step 1.2: Parse All Commit Message Tags
- **Signed-off-by**: wangdicheng <wangdicheng@kylinos.cn> (author)
- **Link**:
  https://patch.msgid.link/20260403014736.33014-1-wangdich9700@163.com
  (patch discussion)
- **Signed-off-by**: Takashi Iwai <tiwai@suse.de> (ALSA subsystem
  maintainer; this means it was reviewed/applied by the maintainer)
- No Fixes: tag (expected — that's why we're reviewing)
- No Cc: stable (expected — that's why we're reviewing)
- No Reported-by (static analysis / code review finding)

### Step 1.3: Analyze the Commit Body Text
The commit body is concise: "Add missing of_node_put() in the error
path." This describes a classic OF node reference leak fix. When
`of_node_get()` acquires a reference but the error path doesn't call
`of_node_put()`, the node's reference count is leaked.

### Step 1.4: Detect Hidden Bug Fixes
This is an explicit bug fix, not disguised. The subject says "Fix" and
the body confirms a missing cleanup call.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: Inventory the Changes
- **File**: `sound/aoa/codecs/onyx.c`
- **Lines**: +3, -1 (net +2 lines)
- **Function**: `onyx_i2c_probe()`
- **Scope**: Single-file surgical fix to one error path

### Step 2.2: Understand the Code Flow Change
The key flow in `onyx_i2c_probe()`:

```978:990:sound/aoa/codecs/onyx.c
        onyx->codec.init = onyx_init_codec;
        onyx->codec.exit = onyx_exit_codec;
        onyx->codec.node = of_node_get(node);  // acquires OF node
reference

        if (aoa_codec_register(&onyx->codec)) {
                goto fail;  // BEFORE: leaks OF node reference
        }
        ...
 fail:
        kfree(onyx);  // frees memory but doesn't release OF node ref
        return -ENODEV;
```

**After the fix**: `goto fail` becomes `goto fail_put`, which first
calls `of_node_put(onyx->codec.node)` then falls through to `fail`.

### Step 2.3: Identify the Bug Mechanism
Category: **Reference counting fix / resource leak**. `of_node_get()`
increments the device tree node refcount. If `aoa_codec_register()`
fails, the refcount is never decremented, leaking the OF node.

### Step 2.4: Assess the Fix Quality
- **Obviously correct**: Yes — `of_node_get()` at line 980 must be
  balanced by `of_node_put()` on error. The remove path at line 997
  already correctly calls `of_node_put()`.
- **Minimal/surgical**: Yes — only 3 lines added, 1 changed.
- **Regression risk**: Essentially zero. The new label only executes on
  error paths and merely balances a reference count.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
The buggy code was introduced by commit `f3d9478b2ce468` ("[ALSA] snd-
aoa: add snd-aoa") by Johannes Berg, dated **2006-06-21**. This is the
original addition of the entire AOA subsystem. The bug has been present
for ~20 years, meaning it exists in **every supported stable tree**.

### Step 3.2: Follow the Fixes Tag
No Fixes: tag present, but the implicit fix target is `f3d9478b2ce468`
(2006). The same commit was referenced by the related fix
`222bce5eb88d1` ("ALSA: snd-aoa: add of_node_put() in error path") which
fixed a *similar* OF node leak in `sound/aoa/core/gpio-feature.c` but
did NOT touch `onyx.c`.

### Step 3.3: Related Changes
- `222bce5eb88d1` — Fixed same bug class in `gpio-feature.c` (2018),
  never touched onyx.c
- The sibling codec `tas.c` has the **exact same bug** at lines 864-875
  (acquires `of_node_get(node)` but `goto fail` doesn't release it)

### Step 3.4: Author's Other Commits
wangdicheng appears to be contributing fixes across multiple subsystems
(KylinOS developer). Takashi Iwai, who applied the patch, is the ALSA
subsystem maintainer — adding significant confidence.

### Step 3.5: Dependent/Prerequisite Commits
None. The fix is fully standalone. The code structure (`fail` label,
`kfree(onyx)`) has been unchanged since 2006.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5: Patch Discussion
Lore.kernel.org is behind a proof-of-work challenge, and b4 dig couldn't
match this commit by patch-id. However, the patch was applied by ALSA
maintainer Takashi Iwai directly, which confirms it passed maintainer
review. The Link tag provides the message-id for the submission.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `onyx_i2c_probe()` — the I2C driver probe function, called when the
  device is matched

### Step 5.2: Callers
`onyx_i2c_probe()` is the `.probe` callback in `onyx_driver` (i2c_driver
struct at line 1012). It is called by the I2C core during device
enumeration/binding. This is a standard device probe path.

### Step 5.3-5.4: Reachability
The probe function is called whenever the kernel attempts to bind the
onyx I2C codec to its driver. On Apple Mac hardware with this audio
codec, this happens during boot. If `aoa_codec_register()` fails (which
can happen — e.g. if the fabric isn't registered yet), this leak
triggers.

### Step 5.5: Similar Patterns
As verified, `sound/aoa/codecs/tas.c` has the **identical bug** (lines
864-875): `of_node_get(node)` followed by `goto fail` that doesn't call
`of_node_put()`.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Buggy Code Existence in Stable Trees
The buggy code exists in **all** stable trees. It was introduced in 2006
(`f3d9478b2ce468`) and has never been fixed.

### Step 6.2: Backport Complications
The file has had minor changes (guard() conversions, alloc_obj macros)
but the probe function structure around the error path is essentially
unchanged since 2006. The patch should apply **cleanly** to all stable
trees, possibly with trivial context adjustments (e.g. `kzalloc_obj` vs
`kzalloc`).

### Step 6.3: Related Fixes Already in Stable
No. The related `222bce5eb88d1` fix was for `gpio-feature.c`, not
`onyx.c`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: ALSA / AOA (Apple Onboard Audio) — driver-specific
- **Criticality**: PERIPHERAL — affects Apple PowerPC/Mac hardware with
  onyx codecs
- **Maintainer review**: Applied by Takashi Iwai (ALSA maintainer)
  directly

### Step 7.2: Subsystem Activity
Low activity (last substantive change was treewide refactoring). This is
a mature, stable driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users of Apple Mac hardware with the pcm3052 (onyx) audio codec. This is
primarily older PowerPC-based Macs.

### Step 8.2: Trigger Conditions
The leak triggers when `aoa_codec_register()` fails during probe. This
can happen if the AOA fabric isn't registered, or if
`attach_codec_to_fabric()` returns an error. While not extremely common,
repeated probe failures (e.g. during deferred probing or error
injection) would accumulate leaked OF nodes.

### Step 8.3: Failure Mode Severity
- **Failure mode**: OF node reference count leak (resource leak)
- **Severity**: LOW-MEDIUM — repeated leaks consume memory, and the
  leaked OF node can never be freed, but this is a one-time probe path,
  not a hot path

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Fixes a real resource leak that has existed for 20 years.
  Trivial to understand and verify.
- **Risk**: Essentially zero — 3 lines added to an error path, one
  `goto` target changed
- **Ratio**: Very favorable — minimal risk for a correct bug fix

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compiled

**FOR backporting:**
- Fixes a real bug: missing `of_node_put()` causing OF node reference
  leak
- Extremely small and surgical fix (3 lines added, 1 changed)
- Obviously correct — verified by reading the code and comparing with
  the remove path
- Applied by ALSA subsystem maintainer (Takashi Iwai)
- Bug exists in all stable trees (introduced in 2006)
- Zero regression risk
- Consistent with similar fixes applied to the same subsystem
  (222bce5eb88d1)

**AGAINST backporting:**
- Low-severity bug (resource leak, not crash/security/corruption)
- Affects niche hardware (Apple PowerPC Macs)
- Only triggers on probe failure (not common under normal conditions)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivial fix, applied by
   maintainer
2. Fixes a real bug? **YES** — OF node reference leak
3. Important issue? **MEDIUM** — resource leak, not critical
4. Small and contained? **YES** — 3 lines, single file, single function
5. No new features or APIs? **YES** — pure fix
6. Can apply to stable trees? **YES** — code unchanged since 2006

### Step 9.3: Exception Categories
None applicable, but this is a standard reference counting bug fix — a
very common category for stable backports.

### Step 9.4: Decision
This is a small, obvious, correct fix for a real reference counting bug.
While the severity is low (resource leak on error path in niche
hardware), the fix carries essentially zero regression risk and meets
all stable kernel criteria.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by author + Takashi Iwai
  (maintainer), Link tag present
- [Phase 2] Diff analysis: 3 lines added to error path in
  `onyx_i2c_probe()`, adds missing `of_node_put()` after `of_node_get()`
  at line 980
- [Phase 3] git blame: buggy code introduced in `f3d9478b2ce468`
  (2006-06-21), present in all stable trees
- [Phase 3] Related fix `222bce5eb88d1`: same bug class fixed in `gpio-
  feature.c` but NOT in `onyx.c`
- [Phase 3] Confirmed `tas.c` has identical unfixed bug at lines 864-875
- [Phase 4] Lore blocked by anti-scraping; b4 dig failed to match. Patch
  applied by ALSA maintainer confirms review
- [Phase 5] `onyx_i2c_probe()` is standard I2C probe callback, called
  during device binding
- [Phase 5] `aoa_codec_register()` at `sound/aoa/core/core.c:57`
  confirmed: can return error from `attach_codec_to_fabric()`
- [Phase 6] Code structure unchanged since 2006; patch should apply
  cleanly to all stable trees
- [Phase 6] No related fix already in stable for this specific file
- [Phase 8] Failure mode: OF node reference leak, severity LOW-MEDIUM;
  risk of fix: essentially zero

**YES**

 sound/aoa/codecs/onyx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index 04961c456d2c5..da0eebf5dfbc2 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -980,10 +980,12 @@ static int onyx_i2c_probe(struct i2c_client *client)
 	onyx->codec.node = of_node_get(node);
 
 	if (aoa_codec_register(&onyx->codec)) {
-		goto fail;
+		goto fail_put;
 	}
 	printk(KERN_DEBUG PFX "created and attached onyx instance\n");
 	return 0;
+ fail_put:
+	of_node_put(onyx->codec.node);
  fail:
 	kfree(onyx);
 	return -ENODEV;
-- 
2.53.0

