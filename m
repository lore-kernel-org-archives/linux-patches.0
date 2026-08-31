Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E55A1797;
	Mon, 31 Aug 2026 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184324; cv=none; b=XZ29XtMWgqt4aUy912fG8qUYUccPKaQ2QaForHZsi0QRecdFMWs5eWE/6nXih4ixv9dV8uYi+jtdoLN20Fi9IUEfcDjqvBDJBwVsLM0abFx2tIR+ICrBNArKDneOjmrpxjdtosmrcBhAYhuh5N8eiZp+qALA1O5jbwOodZod1XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184324; c=relaxed/simple;
	bh=rWomLVEiEZKOUaXEyYX7CewewlPuDfik83UKJ3dHq28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0a9Vm+lNB6gVcI2qbGuHj+pcjKuwvhMITB/wUK2cLnhfwI//RYqK0GTQBq4MO5x6OL000AKik7u0r050sfyPWrDXJebRLNZ7jCtjgj7+Eqo6Ds3/pAPrFZyuvKErW3Vqi5b/9iX+M95sEkWrWtJ2FbVE1/Qtvm3lwPFwFRL47U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4ussLRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4ussLRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D81E1F00ACF;
	Mon, 31 Aug 2026 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184322;
	bh=1zdy6bI3JwOxCFZNpWXii6waiEn2715vzPIx/kZPEDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4ussLRvao5JpmV0d5YKsm0pBqPcA7v4l+YGrgxhBuunr34uWDKdBJg1GfkWhcFKa
	 QhVJh6hLJhAVzXDaf3BI+OsyjAmGMXCivDzxBHvhV6y6qomgKok2tPLXFpgloyOYNo
	 F+XGENTf1sMWLSGpjppfqhy0GeoFoesWO5ZjmNP0UG1g6Sdtxk0pZdSCwDtrpipKfD
	 RGv7aodlfxdRVnJYJshZaNIze8TZl8irhu4A7RyMj6qTfyX5akjLlGASseglhP9tBQ
	 gSQcq9tEAu5zrsqxK4p34HugJHfhRokjvT67oiFyeyfMkzvc88yHlNOUzV8b/Pf+7E
	 fH3+awveXC5yg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Mon, 31 Aug 2026 09:30:52 -0400
Message-ID: <20260831133314.4125787-624-sashal@kernel.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `md/raid5: let stripe batch bm_seq
comparison wrap-safe`

**Local tree:** `v6.18.44` (6.18.y) — `git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`

**Commit analyzed:** `00e93faf4cea9` (mainline) / `13cb77aa61c3d`
(stable-queue variant)
**Status in this tree:** Buggy code is present; fix is **not** merged
(`git merge-base --is-ancestor 13cb77aa61c3d HEAD` → exit 1).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[md/raid5]` `[let/fix]` — make stripe-batch `bm_seq`
comparison wrap-safe when merging bitmap sequence numbers during
batching.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Chen Cheng `<chencheng@fnnas.com>` (author)
- **Signed-off-by:** Yu Kuai `<yukuai@fygo.io>` (md maintainer,
  committer upstream)
- **Link:**
  https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc:
  stable@vger.kernel.org
- Notable: maintainer ack via commit + "Applied to md-7.2" on list; no
  user/syzbot reports

### Step 1.3: Body analysis
**Record:**
- **Bug:** After 32-bit `bm_seq` wraps, plain `>` comparison can treat a
  newer sequence as older.
- **Symptom:** Batch head may retain a stale (older) `bm_seq` instead of
  the latest required bitmap batch.
- **Root cause:** `sh->batch_head->bm_seq > seq` is not wrap-safe;
  should use subtraction idiom.
- **Versions:** No explicit version range; bug dates to 2015
  introduction of this comparison.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as wrap-safety, but it is a real correctness
bug in RAID5 bitmap batch sequencing, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/md/raid5.c` (+1/-1)
- **Function:** `stripe_add_to_batch_list()`
- **Scope:** Single-line, single-function, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** When merging `STRIPE_BIT_DELAY` state into `batch_head`,
  take `batch_head->bm_seq` only if `batch_head->bm_seq > seq`.
- **After:** Use `batch_head->bm_seq - seq > 0` (wrap-safe “is a newer
  than b?”).
- **Path:** Normal write/batching path when stripes with pending bitmap
  updates are merged into a batch.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — signed sequence-number comparison
  across wrap boundary.
- **Mechanism:** After `bm_seq` (signed 32-bit `int`) wraps past
  `INT_MAX`, a post-wrap value can be numerically less than a pre-wrap
  value. The `>` check then fails to propagate the newer sequence to
  `batch_head->bm_seq`, so the batch may proceed before all required
  bitmap flushes complete.

### Step 2.4: Fix quality
**Record:**
- Obviously correct; mirrors existing raid5 idiom at line 259:
  `sh->bm_seq - conf->seq_write > 0` (present since 2006).
- Minimal risk; no API/struct changes.
- Sashiko review noted theoretical UBSAN on signed subtraction — same
  pattern already used in this file for 20 years; author and maintainer
  accepted it.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy comparison introduced in `2b6b24574256c` (Neil Brown,
2015-05-21): "md/raid5: ensure whole batch is delayed for all required
bitmap updates." Present in this 6.18.y tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Related context: `ae3c20ccf84c8` (2006)
introduced wrap-safe `sh->bm_seq - conf->seq_write > 0` in
`do_release_stripe()` path, but the 2015 batch-merge site was never
updated.

### Step 3.3: Related file history
**Record:** Recent raid5.c changes are unrelated (batch race fixes, IO
hangs, llbitmap). Standalone one-patch fix; not part of a series.

### Step 3.4: Author context
**Record:** Chen Cheng has recent md contributions (raid5 batch race
fixes). Yu Kuai is md maintainer and applied this to md-7.2.

### Step 3.5: Dependencies
**Record:** No prerequisites. Applies cleanly to current
`drivers/md/raid5.c` at lines 996–1002.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
- **Revisions:** v1 only
- **Feedback:** Sashiko AI flagged UBSAN concern and pre-existing
  lockless `bm_seq` RMW race; author replied that `a - b > 0` is the
  long-standing raid5 template (citing `do_release_stripe()`);
  maintainer applied without requesting changes
- **Stable nomination:** None explicit in thread

### Step 4.2: Reviewers
**Record:** CC'd `linux-raid@vger.kernel.org`, `yukuai@fygo.io`. Yu Kuai
committed upstream and applied to md-7.2.

### Step 4.3: Bug reports
**Record:** No syzbot, bugzilla, or user crash reports.
Theoretical/latent correctness bug.

### Step 4.4: Related patches
**Record:** None in series.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `stripe_add_to_batch_list()` modified.

### Step 5.2: Callers
**Record:** Called from raid5 write path at line 6030
(`stripe_can_batch(sh)` branch) during `add_stripe_bio` processing —
common RAID5 write path with batching enabled.

### Step 5.3: Callees / context
**Record:** Manages `STRIPE_BIT_DELAY` and `bm_seq` on batch head; ties
into bitmap unplug sequencing (`conf->seq_flush`, `conf->seq_write`,
`activate_bit_delay()`).

### Step 5.4: Reachability
**Record:** Reachable on RAID5 arrays with writeback + bitmap enabled +
stripe batching. Enterprise NAS/server workloads on stable kernels are
in scope.

### Step 5.5: Similar patterns
**Record:** Same wrap-safe idiom at line 259; `dm-pcache` uses
`(s8)(seq1 - seq2) > 0`. The 2015 batch-merge site was the outlier still
using plain `>`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** Yes — at lines 998–999:

```996:1002:drivers/md/raid5.c
        if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
                int seq = sh->bm_seq;
                if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state)
&&
                    sh->batch_head->bm_seq > seq)
                        seq = sh->batch_head->bm_seq;
                set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
                sh->batch_head->bm_seq = seq;
```

Bug introduced 2015; predates 6.18 branch.

### Step 6.2: Backport complications
**Record:** Clean one-line apply expected; no structural conflicts
observed.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree (`git log --grep="stripe
batch bm_seq"` on HEAD → empty).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/md/raid5.c` — **IMPORTANT** (RAID5 + bitmap is
widely used in enterprise/storage on LTS kernels).

### Step 7.2: Activity
**Record:** md/raid5 actively maintained; recent stable-worthy fixes (IO
hangs, batch races) landed in 6.18.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of RAID5 with external/internal bitmap and stripe
write batching — config-specific but common on production md arrays.

### Step 8.2: Trigger conditions
**Record:**
- Requires `bm_seq`/`seq_flush` to wrap (~2³¹ bitmap batch increments).
- Bug manifests when comparing sequences on opposite sides of the wrap
  boundary during batch merge.
- **Likelihood:** Low frequency, but realistic on long-uptime, write-
  heavy arrays (exactly the stable/LTS profile).

### Step 8.3: Failure mode severity
**Record:** Stale `bm_seq` on batch head → stripe may write before
required bitmap batch is flushed → per raid5's own BITMAP UNPLUGGING
comments, missed dirty bits can cause **incorrect recovery after power
loss** (data integrity). Severity when triggered: **CRITICAL**; overall
exposure: **LOW** due to rare trigger.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents latent bitmap sequencing corruption on long-
  running RAID5 arrays.
- **Risk:** Very low — one line, established idiom, maintainer-accepted.
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real correctness bug in bitmap sequencing (potential recovery/data
  integrity issue)
- Bug present since 2015 in this tree
- One-line, obviously correct fix matching 20-year-old raid5 pattern
- Md maintainer committed and applied to md-7.2
- Small, contained, no new APIs/features
- Applies cleanly to v6.18.44

**AGAINST backport:**
- No user reports or fuzzer findings
- Trigger requires ~2³¹ bitmap batch increments (very rare)
- Not an immediate crash/hang; latent correctness issue
- Sashiko UBSAN note (mitigated: same pattern already in file since
  2006)

**Unresolved:** No production incident reports confirming the wrap was
hit in the wild.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — matches existing raid5 wrap-
   safe idiom; maintainer applied.
2. Fixes a real bug? **PASS** — incorrect seq comparison after wrap.
3. Important issue? **PASS** — bitmap sequencing error can cause
   recovery integrity failure (critical when triggered).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code confirmed present; fix
   not yet applied.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
correctness bug fix.

### Step 9.4: Decision rationale

For **this** 6.18.y tree, the buggy comparison exists and has existed
for a decade. The fix is minimal, maintainer-vetted, and aligns with
established raid5 bitmap sequencing practice. While the trigger is rare,
stable kernels target long-lived, write-heavy storage systems where
counter wrap is a realistic eventual concern, and the failure mode
(bitmap bit not recorded before write) is exactly the class of issue
stable backports exist to prevent.

---

## Verification

- **[Phase 1]** `git show 00e93faf4cea9` / `13cb77aa61c3d`: parsed
  message, tags, body
- **[Phase 1]** Ignored pipeline-only markers per instructions
- **[Phase 2]** Diff: 1-line change in `stripe_add_to_batch_list()`
- **[Phase 2]** Read `drivers/md/raid5.c` lines 13–30 (BITMAP UNPLUGGING
  comment), 258–260, 996–1003, 6802–6811
- **[Phase 2]** `drivers/md/raid5.h` line 214: `bm_seq` is `int`; line
  636: `seq_flush, seq_write`
- **[Phase 3]** `git blame -L 996,1003`: introduced `2b6b24574256c`
  (2015)
- **[Phase 3]** `git show 2b6b24574256c`, `d0852df543e5a`,
  `ae3c20ccf84c8`: history context
- **[Phase 3]** `git log --oneline -20 -- drivers/md/raid5.c`: recent
  unrelated changes
- **[Phase 3]** `git merge-base --is-ancestor 2b6b24574256c HEAD`: buggy
  code commit in tree
- **[Phase 3]** `git merge-base --is-ancestor 13cb77aa61c3d HEAD` → exit
  1: fix NOT in tree
- **[Phase 4]** `b4 dig -c 13cb77aa61c3d`: found lore thread
- **[Phase 4]** `b4 dig -c 13cb77aa61c3d -w`: CC'd linux-raid,
  yukuai@fygo.io
- **[Phase 4]** `b4 dig -c 13cb77aa61c3d -a`: single v1 revision
- **[Phase 4]** `b4 dig -m /tmp/bm_seq_thread.mbox`: read thread; Yu
  Kuai "Applied to md-7.2"; Sashiko review + author reply
- **[Phase 5]** `grep stripe_add_to_batch_list`: caller at line 6030
- **[Phase 5]** `grep bm_seq` in raid5.c: wrap-safe pattern at line 259
  since 2006
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Confirmed buggy `>` comparison at line 999 in working
  tree
- **[Phase 6]** `git log --grep="stripe batch bm_seq" HEAD`: no fix
  present
- **[Phase 8]** Assessed trigger rarity (~2³¹ `seq_flush` increments)
  and failure mode via bitmap sequencing comments

**YES**

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c81dbac7eab5..f3951e162762c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -996,7 +996,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0

