Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B052DC25;
	Mon, 19 Oct 2026 14:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418620; cv=none; b=uxXlsyhg54tStIlDjC6kVOmgU/dVq8ZI6gSKrXtQgESowoHO1Ci19iZsVnWK2eY6tMvKPptwr9qU+dMkoEXJ0eseGIcwTZtoUKBGSuIPYBa0KQ3fZPaM3ykde4ZIXh3mHsijJOcZcdXn+JVq1RIWxY4ntyxWJGZ/vzCbZ+DeUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418620; c=relaxed/simple;
	bh=hbihBp5BQ0Hal5bIJHFx6paCi1amFxZU4D0vsGDNb2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i1bonwChetLiKqw8wVYj/vJli/kA92anrRGgqjM6Rpf3CuS4NpI0Qy+ZvU61Lw25hwlMEoT9XJ/aP5yq9DLDKueW/C7k6nXXwsIQqcyy2DUsEaci7wnrU5XV10RzZZXFS3xM9K79isrk5XiYrjk9wuDmCDIObwJ4jKaXlOETCwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVCg/1v5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVCg/1v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757D1F000C6;
	Mon, 19 Oct 2026 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418618;
	bh=qhU3U1QJmWxoNYdP8CLkLSqK+hpB1Gql0BZw7G8xNQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVCg/1v51KNZFp+JxqZDNaQZMjdttHcNuHzXGq2d057lcnH4+yZzqoTtUF0qbo2eW
	 v3cg2Q6xg4aelExbPbX86JGnXrX+uFeRkp4hbwkg9NLHk/DL8rGvce+1pWl4l5lMwu
	 7LtLl/nxdWetlhy+VahkBewhK9KFTWnNoErGmypsDdRyuDpm+CjsliOqlDp0eOyWge
	 Pqh06faGXwnMaHu2sBOUW3IFt/3pnJw/A/etK4xUWjkeKp4ru4bC4uytTKzcHDY1q5
	 Ye2EIrx9ZHle3hJxFkGmws26ceCYZEBYK9VphaCZi+0D2Ak4uzm1HzDVeYeqUh07kX
	 /fmXABby5g7Bw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Mon, 19 Oct 2026 09:51:08 -0400
Message-ID: <20261019135441.1420968-377-sashal@kernel.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 13856e22217fbf7c1200633716ff87ccb50fd89a ]

When irq_domain_trim_hierarchy() fails in irq_domain_alloc_irqs_locked(),
the error handling path fails to undo the hierarchy allocations.

Add the missing cleanup.

[ tglx: Massage change log ]

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260623075134.4432-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This 6.18.53 tree has the buggy irqdomain error path. The 4-line
rollback is a real hierarchy-resource leak fix and should be backported.

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[irqdomain] [Plug] leak in
irq_domain_alloc_irqs_locked() error path`

**Step 1.2:** Record:
- No `Fixes:` on the committed message (v2 later added `Fixes:
  55567976629e5`)
- No `Reported-by` / `Tested-by` / `Reviewed-by` / `Acked-by` / `Cc:
  stable`
- `Signed-off-by: Kemeng Shi`, `Signed-off-by: Thomas Gleixner`
- `Link: https://patch.msgid.link/20260623075134.4432-2-
  shikemeng@huaweicloud.com`
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

**Step 1.3:** Record:
- Bug: after `irq_domain_alloc_irqs_hierarchy()` succeeds, a
  `irq_domain_trim_hierarchy()` failure skips `domain->ops->free`
- Symptom: parent-domain IRQ / irqchip resources stay allocated while
  virq descriptors are freed
- Root cause: error goto used `out_free_irq_data` instead of hierarchy
  free
- Original v1 text: “unlikely to fail, but there is no harm to add extra
  protection”
- tglx retitled it to a leak plug

**Step 1.4:** Record: Not disguised. It is an error-path resource-leak
fix. The series cover called it a “minor” learning cleanup; the code
change is still a real rollback hole.

## Phase 2: Diff analysis

**Step 2.1:** Record: `kernel/irq/irqdomain.c` only; +3/−1. Function:
`irq_domain_alloc_irqs_locked()`. Surgical single-file change.

**Step 2.2:** Record: On trim failure the old path jumped to
`out_free_irq_data` (`irq_domain_free_irq_data` + `irq_free_descs`).
After: jump to new `out_free_irqs`, which calls
`irq_domain_free_irqs_hierarchy()` then falls through. Success path
unchanged.

**Step 2.3:** Record: Error-path resource leak. Hierarchy `ops->alloc`
already ran; missing `ops->free`. `irq_domain_free_irq_data()` only
`kfree`s irq_data nodes and does not undo irqchip/parent mappings.

**Step 2.4:** Record: Obviously correct. Same order as
`irq_domain_free_irqs()` (hierarchy free, then irq_data, then descs),
minus `irq_domain_remove_irq()` because insert has not run. Only the
trim-failure path. Low regression risk:
`irq_domain_free_irqs_hierarchy()` already skips IRQs with no irq_data
and no-ops if `ops->free` is NULL.

## Phase 3: Git history

**Step 3.1:** Record: Trim loop added in `55567976629e58` (“Allow
partial trimming of irq_data hierarchy”), first in **v5.10-rc1**.
Hierarchy alloc itself dates to `f8264e34965aaf` (v3.19). The broken
goto is as old as the trim call.

**Step 3.2:** Record: Committed message has no Fixes tag. Author v2
added `Fixes: 55567976629e5`. That commit is an ancestor of this 6.18
tree (`git describe --contains` → `v5.10-rc1~...`).

**Step 3.3:** Record: Recent file history is irqdomain refactors plus
this series. No extra prerequisite refactor needed.
`irq_domain_free_irqs_hierarchy()` already exists here.

**Step 3.4:** Record: Kemeng Shi is not the irq maintainer; tglx applied
it. Same series also has the helper-use and NULL-check cleanups (not
required for this leak).

**Step 3.5:** Record: Standalone. Other series patches are cleanups. No
new helpers.

## Phase 4: Mailing list

**Step 4.1:** Record: lore.kernel.org returned 403 (Anubis). Recovered
via `b4` + gnuweeb/ratatoskr/lkml.iu.edu.
- Cover: `[PATCH 0/3] Minor fix and cleanups to genirq`
- Patch 1/3 is this leak fix
- tglx merged v1 on 2026-06-29 as
  `13856e22217fbf7c1200633716ff87ccb50fd89a`
- v2 (2026-07-02) only added Fixes + changelog; same diff; tglx had
  already taken v1
- No NAKs in the 7-message thread

**Step 4.2:** Record: To tglx, Cc linux-kernel. tip-bot also Cc’d maz
and x86. Maintainer applied it.

**Step 4.3:** Record: No bugzilla/syzbot/user report. Code inspection
while learning irq.

**Step 4.4:** Record: Series is 3 patches; only 1/3 is the leak fix.
Independent.

**Step 4.5:** Record: No stable-list discussion found (commit is new
relative to 6.18.53).

## Phase 5: Semantic analysis

**Step 5.1:** Record: `irq_domain_alloc_irqs_locked()` (hierarchy
version under `CONFIG_IRQ_DOMAIN_HIERARCHY`).

**Step 5.2:** Record: Callers: `__irq_domain_alloc_irqs()` (public,
`irq_domain_alloc_irqs()` wrapper) and OF/hierarchy mapping around
`kernel/irq/irqdomain.c:945`. Used from MSI (`kernel/irq/msi.c`), IPI,
x86 IOAPIC, GIC, gpiolib, many irqchips.

**Step 5.3:** Record: `irq_domain_alloc_irqs_hierarchy` →
`domain->ops->alloc`; trim; insert. Locked with `domain->root->mutex`.

**Step 5.4:** Record: Reachable from device probe /
`irq_create_fwspec_mapping` / MSI alloc. Unprivileged users do not call
it directly; drivers do at probe. Trim failure is `-EINVAL` for invalid
chip chain (NULL/ERR outermost chip, empty chip before a trim marker,
chip after a trim marker, non-`-ENOTCONN` marker). Disconnect users:
tegra PMC, qcom PDC/MPM.

**Step 5.5:** Record: Success-path `irq_domain_free_irqs()` already does
hierarchy free. The alloc-failure path still skips `ops->free` because
failed `ops->alloc` is expected to roll itself back. Trim failure is
after a **successful** alloc, so it uniquely needs `ops->free`.

## Phase 6: Local tree (6.18.53)

**Step 6.1:** Record: `git describe HEAD` =
`v6.18.53-5049-g0f0bdc2b0dffb`, `make kernelversion` = `6.18.53`. At
`v6.18.53` the trim-failure path still `goto out_free_irq_data`. Bug
exists here. Introduced v5.10.

**Step 6.2:** Record: Clean apply. Context matches 6.18.53 exactly.

**Step 6.3:** Record: No earlier equivalent fix in this tree.
`irq_domain_push_irq` leak fix (`0f394daef89b3`) is a different bug.

## Phase 7: Subsystem

**Step 7.1:** Record: `kernel/irq/` irqdomain. **CORE** for any
hierarchical irqdomain (x86 selects `IRQ_DOMAIN_HIERARCHY`
unconditionally; ARM GIC/MSI too).

**Step 7.2:** Record: Mature core code; trim path ~5.5 years old. Not a
new subsystem.

## Phase 8: Impact and risk

**Step 8.1:** Record: Hierarchical irqdomain users (typical x86/ARM/MSI
systems). Config-specific in theory; practically common.

**Step 8.2:** Record: Trigger is failed hierarchy validation after a
successful `ops->alloc`. Uncommon on correct irqchip drivers. Author:
“unlikely to fail.” Not a hot path; probe/mapping time.

**Step 8.3:** Record: Failure mode = leak of parent IRQ / irqchip
resources (not just kmalloc). Can exhaust parent IRQs and make later
devices fail to allocate interrupts. Severity: **MEDIUM** (rare),
**HIGH** if it hits because the resource is finite hardware state. Not a
panic by itself.

**Step 8.4:** Record: Benefit medium (correct unwind of core IRQ alloc).
Risk very low (4 lines, error path only, existing helper). Ratio favors
backport.

## Phase 9: Synthesis

**For:**
- Confirmed missing rollback after successful hierarchy alloc
- Leaks irqchip/parent mappings, not only heap objects
- 4-line, obviously correct, matches `irq_domain_free_irqs()`
- Present since v5.10; present on 6.18.53; applies cleanly
- tglx accepted it; v2 named `55567976629e5` as the introducing commit
- No new API, no series dependency

**Against:**
- Author called it unlikely extra protection
- No user/syzbot reports
- Not a crash/UAF/deadlock
- Trigger is a malformed hierarchy, i.e. a driver/firmware mistake

**Unresolved:** Full lore HTML was 403; mirrors showed no review
comments beyond tglx applying v1.

**Stable checklist:**
1. Obviously correct and tested? **PASS** (tglx applied; logic matches
   existing free path)
2. Real bug affecting users? **PASS** (leak of allocated hierarchy IRQs)
3. Important? **PASS** (finite irqchip resources; core alloc unwind;
   small enough that the bar is met)
4. Small and contained? **PASS** (+3/−1, one function)
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** (clean on 6.18.53)

**Exception category:** none; ordinary error-path leak fix.

The path is rare, but the hole is real and the patch is the same cleanup
`irq_domain_free_irqs()` already does. For this 6.18.y tree it is a
safe, self-contained correctness fix.

Verification:
- [Phase 1] Tags: SOB Kemeng Shi + tglx; Link msgid 4432-2; no Fixes on
  committed text
- [Phase 1] v1 body: “unlikely to fail… extra protection”; tglx massaged
  to “Plug leak”
- [Phase 2] Diff: goto `out_free_irqs` +
  `irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs)`
- [Phase 2] Confirmed `irq_domain_free_irq_data()` only kfree’s parent
  irq_data; does not call `ops->free`
- [Phase 3] blame: trim loop from `55567976629e58` (v5.10-rc1)
- [Phase 3] `v6.18.53:kernel/irq/irqdomain.c` still `goto
  out_free_irq_data` on trim failure
- [Phase 4] b4 dig → tip-bot merge
  `13856e22217fbf7c1200633716ff87ccb50fd89a`; cover “Minor fix and
  cleanups”
- [Phase 4] lore 403; gnuweeb/ratatoskr recovered v1 and v2; v2 Adds
  Fixes: 55567976629e5; no NAK
- [Phase 5] Callers: `__irq_domain_alloc_irqs`, OF map path, MSI,
  IOAPIC, GIC
- [Phase 5] Disconnect users: tegra PMC, qcom PDC/MPM
- [Phase 6] `git describe HEAD` = v6.18.53-5049; `make kernelversion` =
  6.18.53
- [Phase 6] Clean apply vs v6.18.53; `irq_domain_free_irqs_hierarchy`
  already present
- [Phase 7] x86 `select IRQ_DOMAIN_HIERARCHY`
- [Phase 8] Severity: resource leak on rare `-EINVAL` trim; risk of
  later IRQ alloc failure
- UNVERIFIED: Could not load lore.kernel.org HTML due to 403; used b4 +
  mirrors instead

**YES**

 kernel/irq/irqdomain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index dc473faadcc81..cca2f01115aa0 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1621,7 +1621,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1629,6 +1629,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0

