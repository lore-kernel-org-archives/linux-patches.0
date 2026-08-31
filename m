Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EB3582B8D;
	Mon, 31 Aug 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184199; cv=none; b=osaDZRKiyA2x2fbUTlQ/4fC30uHIEqHQLwFQIbQhtQzE3JKYHJfJ2LeNu6c0xi/SLqBDpoUd8oXt0rk12h8eLwwKSUuScCKbQ+lYrL+7kkaertCw5uvUDVCeSCF1ueDuXEILU7Dtoz7isvllS2Q70FWivxNDpPeIBJHJiBDpqQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184199; c=relaxed/simple;
	bh=8SYMDksE1DxQY8JuTiY2RejCiTm9Ev2iN/cZEe5mBc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzZmVGSo+mTMxPQs5ULLUSSmxyJMimI+zF1xgKpN6rw6F3fvOISjfy0GYNZkufy0xVwh3zoflKa9yZ3kc91C0PAcBwtek+2Wx9oI1qrfMMIj59du9L5MvMqGQ+J/mJgZspvCv1hgVViXxZ8Wdwz6bfRFQ0uh/5s3DQ79YnpZSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jN/woYYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jN/woYYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E734F1F00ACA;
	Mon, 31 Aug 2026 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184197;
	bh=YsiWhBDT+GunKvfhsAsf8vWwVOjjNgw+gRuWWzNkjSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN/woYYOEDj5+i2chnkFB854H8aGsyIcV3B08Z7Ds4kvYap8NWYPdZyL00dCaUDus
	 pdWYqgvIkUZLk0Qxmq2zOslMiIRxBDYcV7GIZA6M4G0xqFWnl9Z/pfhW+VwQsJhAIB
	 6GwV9Jcw+EQtUIsoIwNvDGCdGBG19b7eE2oNKeUHDY9sMZaTg+E7xUPKWmNDppGFKr
	 cR0s8VLAp327TgzsRRtuCkuenZLMSANWdrC7w3FnV8O0rCl4VL3bWKuMzx2YB/Fzey
	 VocAyb0+Lt5NXJfInW6YuRfGXssSp5BA41iTr3mNP3kq3mITY3C46av8HGOLughf1Q
	 tIWCloXlKyMJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mengyuanlou@net-swift.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: txgbe: fix phylink leak on AML init failure
Date: Mon, 31 Aug 2026 09:29:37 -0400
Message-ID: <20260831133314.4125787-549-sashal@kernel.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 9c89f975e66922f346d92d60c9d51d07274a7f3b ]

Destroy the phylink instance when fixed-link setup fails.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260528013258.129146-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: txgbe: fix phylink leak on AML init
failure`

## Local Tree Context

- **Tree:** `v6.18.44` / `6.18.44`
- **Fix commit in repo:** `9c89f975e669` exists but is **not** in HEAD
- **Buggy code:** Present in `txgbe_phylink_init_aml()` at lines 381–384
- **Introducing commit:** `6f8b4c01a8cd9` ("Implement PHYLINK for AML
  25G/10G devices") is an ancestor of HEAD

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net: txgbe]` `[fix]` — destroy phylink on AML init failure
when fixed-link setup fails.

### Step 1.2: Tags
**Record:**
- **Fixes:** `6f8b4c01a8cd` (in original patch submission; absent from
  committed version in repo object)
- **Reviewed-by:** Maxime Chevallier, Jiawen Wu
- **Link:** https://patch.msgid.link/20260528013258.129146-1-
  zhaochenguang@kylinos.cn
- **Signed-off-by:** Chenguang Zhao, Jakub Kicinski
- No Reported-by, Tested-by, Cc: stable, or syzbot tags

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `phylink_create()` succeeds, but `phylink_set_fixed_link()`
  failure returns without `phylink_destroy()`.
- **Symptom:** Memory leak (~`sizeof(struct phylink)` + workqueue) on
  probe failure.
- **Root cause:** Missing cleanup on error path introduced with AML
  phylink support.

### Step 1.4: Hidden Bug Fix?
**Record:** No — explicitly labeled as a leak fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c` (+1 line)
- **Function:** `txgbe_phylink_init_aml()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** On `phylink_set_fixed_link()` error → log and return;
  local `phylink` leaked.
- **After:** Same path calls `phylink_destroy(phylink)` before return.
- **Path:** Probe-time initialization error path only.

### Step 2.3: Bug Mechanism
**Record:** **Resource leak on error path.** Category: memory/resource
leak (probe failure).

Probe flow when init fails:

```892:894:drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
        err = txgbe_init_phy(txgbe);
        if (err)
                goto err_release_hw;
```

`err_release_hw` does **not** call `txgbe_remove_phy()`. Since
`wx->phylink` is only assigned after successful init:

```381:387:drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
        err = phylink_set_fixed_link(phylink, &state);
        if (err) {
                wx_err(wx, "Failed to set fixed link\n");
                return err;
        }

        wx->phylink = phylink;
```

…the leaked `phylink` has no other cleanup path.

### Step 2.4: Fix Quality
**Record:** Obviously correct. Mirrors the existing pattern in
`txgbe_phylink_init()`:

```300:303:drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
                ret = phylink_connect_phy(phylink, wx->phydev);
                if (ret) {
                        phylink_destroy(phylink);
                        return ret;
```

**Regression risk:** Very low — one line on a failure-only path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy error path introduced in `6f8b4c01a8cd9` (May 2025) by
Jiawen Wu. Present in this 6.18.y tree.

### Step 3.2: Fixes: Tag
**Record:** Original patch had `Fixes: 6f8b4c01a8cd9`. Verified that
commit is in this tree and introduced `txgbe_phylink_init_aml()` without
error-path cleanup.

### Step 3.3: Related Changes
**Record:** Recent txgbe history includes AML phylink work (`6f8b4c01`,
`7649ba2b`, `9157060f`). Standalone one-line fix; no series dependency.
Similar leak fix already backported: `2d34421bfa261` ("fix FDIR filter
leak on remove") by same author, committed by Greg K-H to this tree.

### Step 3.4: Author Context
**Record:** Chenguang Zhao is an active txgbe contributor. Reviewed by
driver reviewers (Chevallier, Wu).

### Step 3.5: Dependencies
**Record:** None. Applies cleanly to this tree's simpler `txgbe_aml.c`
(391 lines vs. mainline ~530 at fix time).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Fetched from lore.kernel.org. Patch v3 applied to net-next
as `9c89f975e669` by Jakub Kicinski (Jun 1, 2026). Went through v1→v3
review. No stable nomination found in thread.

### Step 4.2: Reviewers
**Record:** CC'd netdev maintainers (Kicinski, Abeni, Miller, etc.) plus
Wangxun driver developers. Two Reviewed-by tags from subsystem
reviewers.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug identified by
code inspection / review.

### Step 4.4: Series Context
**Record:** Standalone fix, not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `txgbe_phylink_init_aml()`, `phylink_create()`,
`phylink_set_fixed_link()`, `phylink_destroy()`

### Step 5.2: Callers
**Record:** `txgbe_phylink_init_aml()` ← `txgbe_init_phy()` (for
`wx_mac_aml`) ← `txgbe_probe()` in `txgbe_main.c`

### Step 5.3: Callees
**Record:** `phylink_create()` allocates via `kzalloc()`;
`phylink_destroy()` frees via `kfree()` after `cancel_work_sync()`.

### Step 5.4: Reachability
**Record:** Reachable during PCI probe of AML Wangxun NICs
(`wx_mac_aml`). `phylink_set_fixed_link()` can return `-EINVAL` on
validation failure (wrong mode, speed/duplex not in supported caps).
With current hardcoded `SPEED_25000` + `MAC_25000FD`, failure is
**unlikely in normal operation** but the error path is real and
exercised if validation fails.

### Step 5.5: Similar Patterns
**Record:** `txgbe_phylink_init()` already destroys phylink on connect
failure. AML path was missing the equivalent cleanup.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Lines 381–384 lack `phylink_destroy()` on error.
Bug present since `6f8b4c01a8cd9` landed in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Local file differs from mainline
(no 40G/XLGMII branch in this tree), but the fix hunk applies
identically to the error path.

### Step 6.3: Fix Already Present?
**Record:** **NO.** `9c89f975e669` is in the object database but not in
HEAD (`6.18.44`).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/ethernet/wangxun/txgbe` — network driver
(IMPORTANT, driver-specific).

### Step 7.2: Activity
**Record:** Actively maintained; AML support added in 2025; multiple
stable backports already in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Wangxun txgbe AML 25G/10G NICs (`CONFIG_TXGBE`,
`wx_mac_aml`). Not universal, but real hardware.

### Step 8.2: Trigger Conditions
**Record:** `phylink_set_fixed_link()` returns error during probe.
Uncommon with current hardcoded parameters, but possible on
misconfiguration or future code changes. Each failed probe leaks one
phylink allocation. Module reload / reprobe could accumulate leaks.

### Step 8.3: Failure Mode Severity
**Record:** Memory leak on probe error path. **Severity: MEDIUM** — no
crash or corruption, but resource leak with no recovery on the probe
failure path.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct error-path resource management; aligns AML path
  with non-AML phylink init; precedent exists (FDIR leak fix backported
  to this same tree).
- **Risk:** Very low (1 line, error path only).
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory leak on probe error path
- Obviously correct, 1-line fix matching existing driver pattern
- Bug introduced by commit present in this tree
- Reviewed by driver maintainers
- Same driver already had a leak fix backported to 6.18.y
  (`2d34421bfa261`)
- Fix not yet in HEAD; applies cleanly

**AGAINST backport:**
- Affects niche hardware only
- `phylink_set_fixed_link()` failure unlikely with current hardcoded
  config
- No user reports or fuzzer findings
- Leak is per failed probe, not a hot-path leak

**Unresolved:** No runtime crash reports; trigger frequency in
production is unverified.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing pattern;
   two Reviewed-by
2. Fixes a real bug? **PASS** — probe error-path memory leak
3. Important issue? **PASS (MEDIUM)** — resource leak, not
   crash/security
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, fix not
   applied

### Step 9.3: Exception Categories
**Record:** None (not a quirk, device ID, DT, build, or docs fix).
Standard error-path resource leak fix.

### Step 9.4: Decision Rationale

This is a textbook probe error-path resource leak: `phylink_create()`
allocates memory, failure returns without cleanup, and the probe error
path (`err_release_hw`) never calls `txgbe_remove_phy()` because
`wx->phylink` was never assigned. The fix is minimal, matches existing
code in the same driver, and the same author's leak fix was already
accepted into this 6.18.y tree. While the trigger is uncommon and
hardware-specific, stable trees routinely take such surgical leak fixes.

---

## Verification

- **[Phase 1]** `git show 9c89f975e669`: parsed subject, tags, body
- **[Phase 1]** Lore mbox fetch: confirmed v3 patch, Fixes tag,
  reviewers
- **[Phase 2]** Read `txgbe_aml.c:355-390`: confirmed missing
  `phylink_destroy` on error
- **[Phase 2]** Read `txgbe_phy.c:268-310`: confirmed sibling pattern
  with `phylink_destroy`
- **[Phase 2]** Read `txgbe_main.c:892-894,920-921`: probe goes to
  `err_release_hw`, not `err_remove_phy`
- **[Phase 2]** Read `phylink.c:1787-1800,1925-1941`:
  `phylink_set_fixed_link` failure modes; `phylink_destroy` frees
  allocation
- **[Phase 3]** `git blame -L 381,385 txgbe_aml.c`: bug from
  `6f8b4c01a8cd9`
- **[Phase 3]** `git merge-base --is-ancestor 6f8b4c01a8cd9 HEAD`:
  introducing commit in tree
- **[Phase 3]** `git show 2d34421bfa261`: similar txgbe leak fix already
  in 6.18.y
- **[Phase 3]** `git log --oneline -20 -- txgbe_aml.c`: recent AML
  driver history
- **[Phase 4]** `curl lore.kernel.org/.../t.mbox.gz`: patch thread,
  v1-v3, applied notification
- **[Phase 4]** Lore stable search: no stable nomination found
- **[Phase 5]** `grep txgbe_phylink_init_aml`: caller chain to
  `txgbe_probe`
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: tree is
  6.18.44
- **[Phase 6]** `git cat-file -e 9c89f975e669` + merge-base check: fix
  exists in repo, not in HEAD
- **[Phase 6]** Read current `txgbe_aml.c`: buggy code confirmed at
  lines 381-384

**YES**The analysis is done for **v6.18.44**.

**Commit:** `net: txgbe: fix phylink leak on AML init failure`

**Finding:** On AML probe failure in `txgbe_phylink_init_aml()`, if
`phylink_set_fixed_link()` fails, the phylink object is leaked because
`wx->phylink` is never set and the probe path goes to `err_release_hw`
without calling `txgbe_remove_phy()`. The fix adds a single
`phylink_destroy(phylink)` on that error path, matching the pattern
already used in `txgbe_phylink_init()`.

**Local tree status:** The bug is present in this checkout; fix commit
`9c89f975e669` exists in the repo but is not in HEAD. A similar txgbe
leak fix (`2d34421bfa261`) was already backported to this tree.

**Verdict:** **YES** — small, obviously correct probe error-path leak
fix, low risk, applies cleanly.

 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 07ae491e3bc9b..a919962b71605 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -381,6 +381,7 @@ int txgbe_phylink_init_aml(struct txgbe *txgbe)
 	err = phylink_set_fixed_link(phylink, &state);
 	if (err) {
 		wx_err(wx, "Failed to set fixed link\n");
+		phylink_destroy(phylink);
 		return err;
 	}
 
-- 
2.53.0

