Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D524C6F12;
	Mon, 31 Aug 2026 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183542; cv=none; b=D+Q3Hz/msiPGMlSG1DvPrYd2vIFwxP8BAR3xJ9UfBkcXezYZA/Gf+1Ls5YU+a6+Avj/bLvKtLMMbmGCnER7pZCBYzTETQUsR9bhjZIblaGTYkn569bCGYqDlJ8q0fxQr7PI32k5FZPhUDq7/fTP7sjHflwWBmkGUwg9aLOnJW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183542; c=relaxed/simple;
	bh=xR89S1Mm+gl9/HBPQ/qei1iWoGU90o0dvqEhyqubgGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRteTuBv6OM9tucivYguXGIyaHLZ5kMIgzc0/+MTNx5A+2h3Rfy7rqW8Aqv32OUaMc5L+5Bc4rVU+ZW4LldJ5+Q6tY7+X3cAyvcxqtZUN4X58n0bUBaTzVVuzADtfV+Y3/5eS/mUYvC1f6JD2nvrqOXU7WN5xCCn/IKF72v2TQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0tzdx1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0tzdx1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977171F000E9;
	Mon, 31 Aug 2026 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183539;
	bh=jD+RyzpZVTssGjSqCfPu7u3PzHrNFB2E/eA6V7M3Y0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0tzdx1PfB8MB5MNHwaeKyQI+Sj50u+dkC6d/1to3oSnlrDQLGwJTpq3Apy3aJ8qf
	 sh1oxbb/PJp0lycIhgjfFhkrz9jy2kgPkjsTrGgN5F1ut+Owjbff1XRa1nKrfsnTAF
	 NqtHjV37e0VVzbKBTEJvz/2h0ZqpuOgx2uZCbnup9Xc4L1Lx7+3CJ/4R+Mpz9eYayW
	 40YjmRhtedvguZoMCPPGl4R93XbgsBMGUrxgJgR/bPMFttWjBRBY8JNg0FE1Z49uwE
	 Nmtb+zm48JgwG8qsyGpuwvvxVp05BuyygjPtm5eJ0P4J8MJgttnoebvgK4YzF1ECFK
	 1O2dQ27CS4+Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Mon, 31 Aug 2026 09:23:05 -0400
Message-ID: <20260831133314.4125787-157-sashal@kernel.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[thunderbolt]` `[keep]` — Keep an XDomain reference for the
full lifetime of a Thunderbolt service device.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** — absent
- **Acked-by:** — absent
- **Link:** — absent
- **Cc: stable@vger.kernel.org** — absent (not a negative signal)
- **Signed-off-by:** Mika Westerberg \<mika.westerberg@linux.intel.com\>
  (subsystem maintainer)

No syzbot, no multi-reporter tags. Author is the Thunderbolt maintainer.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `tb_service_release()` calls `ida_free(&xd->service_ids,
  ...)`, but `service_ids` is owned by the parent XDomain. The XDomain
  can be freed before the service’s final `release` callback runs.
- **Symptom:** Use-after-free when freeing the service ID during service
  teardown (potential crash / memory corruption).
- **Version info:** Not stated in the commit message.
- **Root cause (author):** Missing explicit XDomain reference for the
  service’s lifetime.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — this is an explicit lifetime/reference-
counting bug fix, not cleanup or optimization.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **File:** `drivers/thunderbolt/xdomain.c` (+2 lines net)
- **Functions modified:** `tb_service_release()`, `enumerate_services()`
- **Scope:** Single-file, surgical fix (2 meaningful lines)

### Step 2.2: Code Flow Change (per hunk)

**Hunk 1 — `tb_service_release()`:**
- **Before:** Frees service ID from parent XDomain’s IDA, frees service
  memory; no XDomain refcount drop.
- **After:** Same, then calls `tb_xdomain_put(xd)` to release the
  reference taken at enumeration.
- **Path:** Service device final release callback (after last
  `put_device()` on the service).

**Hunk 2 — `enumerate_services()`:**
- **Before:** `svc->dev.parent = &xd->dev` (bare pointer, no refcount).
- **After:** `svc->dev.parent = get_device(&xd->dev)` (holds XDomain
  alive).
- **Path:** XDomain service enumeration during property exchange /
  reconnect.

### Step 2.3: Bug Mechanism
**Record:** **Reference counting / use-after-free fix.**

Mechanism verified against the driver core:
1. `enumerate_services()` registers child service devices parented under
   the XDomain.
2. `tb_service_release()` accesses `xd->service_ids` via `ida_free()`.
3. `tb_xdomain_release()` destroys that IDA with
   `ida_destroy(&xd->service_ids)`.
4. On `device_unregister(service)`, `device_del()` immediately calls
   `put_device(parent)` (see `drivers/base/core.c:3983`), dropping the
   parent reference acquired in `device_add()` — even if the service
   device struct still exists because something holds an extra
   reference.
5. `tb_xdomain_remove()` unregisters all services, then unregisters the
   XDomain; the XDomain can reach refcount zero and run
   `tb_xdomain_release()` while a service device is still pending final
   release.
6. When `tb_service_release()` finally runs, `xd` and `xd->service_ids`
   may already be freed → UAF.

The fix holds an independent XDomain reference from enumeration until
`tb_service_release()`.

### Step 2.4: Fix Quality Assessment
**Record:**
- **Quality:** Obviously correct; standard `get_device()` /
  `put_device()` pairing via `tb_xdomain_put()`.
- **Scope:** Minimal; no API changes.
- **Regression risk:** Very low. Refcount is balanced: one
  `get_device()` at parent assignment, one `tb_xdomain_put()` at service
  release. `device_add()`/`device_del()` continue to manage their own
  parent reference separately.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** `git blame` attributes current `tb_service_release()` /
`enumerate_services()` code to commit `19eef1d98eeda` in this tree
(stable history is squashed; that commit message is unrelated). The
service/XDomain code is present and has the buggy pattern. Approximate
introduction: with the XDomain service enumeration infrastructure
(present in this 6.18.y tree).

### Step 3.2: Follow the Fixes: Tag
**Record:** No `Fixes:` tag present — step not applicable.

### Step 3.3: File History for Related Changes
**Record:** Recent thunderbolt commits in this tree include XDomain
security hardening (`b5daa920f44cb`, `46da5c3ea011e`, `fcbd0cdab9283`,
etc.). This fix is **standalone** (2 lines, no structural
prerequisites). Related stable series patches (debugfs unregister,
delayed-work UAF) are separate; this commit does not depend on them.

### Step 3.4: Author's Other Commits
**Record:** Mika Westerberg is the Thunderbolt subsystem maintainer. No
other commits by this author found in this tree’s `drivers/thunderbolt/`
log (history is compressed).

### Step 3.5: Prerequisite Commits
**Record:** No dependencies. `tb_xdomain_get()`/`tb_xdomain_put()`,
`tb_service_parent()`, `enumerate_services()`, and
`ida_alloc`/`ida_free` on `xd->service_ids` all exist in this tree.
Patch applies to current `xdomain.c` with only the two line changes
(candidate diff uses `kzalloc_obj`; local tree uses `kzalloc` —
unrelated context, no conflict).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig` could not be run — commit hash is not in this
checkout. lore.kernel.org returned 403 (bot protection). **Ratatoskr
stable-queue archives** show this exact patch nominated for multiple
stable trees:
- `[PATCH 5.10.y 1/3] thunderbolt: Keep XDomain reference during the
  lifetime of a service`
- `[PATCH 5.15.y 3/6] ...`
- `[PATCH 6.6.y 4/7] ...`

Part of a broader Thunderbolt XDomain stability series (`Stable-dep-of:
2c5d2d3c3f70` on related patches).

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch lore thread or run `b4 dig -w`.
Author is subsystem maintainer.

### Step 4.3: Bug Report
**Record:** No external bug report referenced. Bug identified by code
analysis / disconnect teardown path.

### Step 4.4: Related Patches / Series
**Record:** Related stable patches in the same series (debugfs
unregister, remove without holding `tb->lock`, delayed-work UAF) are
complementary but **this commit is independently correct and
applicable**. Greg’s Linux 6.18.44 announcement (2026-08-09 per
Ratatoskr) suggests the broader series is heading into 6.18.y.

### Step 4.5: Stable Mailing List History
**Record:** Stable nominations confirmed via Ratatoskr for 5.10.y,
5.15.y, 6.6.y at minimum. Direct lore stable-list search UNVERIFIED
(403).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `tb_service_release()`, `enumerate_services()`,
`tb_xdomain_remove()`, `tb_xdomain_release()`, `tb_service_parent()`.

### Step 5.2: Trace Callers
**Record:**
- `enumerate_services(xd)` — called from XDomain property update path
  (line 1497).
- `tb_service_release()` — device core release callback for
  `tb_service_type`.
- `tb_xdomain_remove()` — called on XDomain disconnect; unregisters all
  child services then the XDomain.

Callers of `tb_xdomain_remove()` include ICM and core Thunderbolt
disconnect paths — common during cable unplug / peer host disconnect.

### Step 5.3: Trace Callees
**Record:** `ida_free()`, `ida_destroy()`, `get_device()`,
`tb_xdomain_put()` (wraps `put_device()`), `device_register()`,
`device_unregister()`.

### Step 5.4: Call Chain / Reachability
**Record:**
```
Thunderbolt disconnect / XDomain removal
  → tb_xdomain_remove()
    → device_for_each_child_reverse(..., unregister_service)
      → device_unregister(service)  [parent ref dropped in device_del]
    → device_unregister(xd)
      → tb_xdomain_release()  [ida_destroy(&xd->service_ids)]
  → (later) tb_service_release()  [ida_free on possibly freed xd]  ← BUG
```
**Userspace-reachable:** Yes — triggered by Thunderbolt hot-unplug /
peer disconnect while a service device has lingering references (driver
binding, `get_device()` holders, etc.). Not theoretical.

### Step 5.5: Similar Patterns
**Record:** XDomain itself correctly uses `get_device(parent)` at
allocation (`xdomain.c:2016`). Services were the missing symmetric case.
`tb_service_get()`/`tb_service_put()` exist for service devices but did
not protect the parent XDomain.

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **YES.** Local tree is **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`).

Current buggy code verified:

```1006:1015:drivers/thunderbolt/xdomain.c
static void tb_service_release(struct device *dev)
{
        struct tb_service *svc = container_of(dev, struct tb_service,
dev);
        struct tb_xdomain *xd = tb_service_parent(svc);

        tb_service_debugfs_remove(svc);
        ida_free(&xd->service_ids, svc->id);
        kfree(svc->key);
        kfree(svc);
}
```

```1120:1124:drivers/thunderbolt/xdomain.c
                svc->id = id;
                svc->dev.bus = &tb_bus_type;
                svc->dev.type = &tb_service_type;
                svc->dev.parent = &xd->dev;
                dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev),
svc->id);
```

No `get_device(&xd->dev)` on parent assignment; no `tb_xdomain_put(xd)`
in release. Fix is **not** already present (`git log --grep` and `git
log -S "svc->dev.parent = get_device"` returned nothing).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — 2 lines in one file, matching
current code structure. No refactor conflicts in the target hunks.

### Step 6.3: Related Fixes Already Present?
**Record:** No — grep and git searches found no prior application of
this fix or equivalent `tb_xdomain_put` in `tb_service_release`.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/thunderbolt/` — **IMPORTANT** (Thunderbolt/USB4
XDomain networking and device interconnection; not core kernel, but
affects real hardware on laptops/workstations).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained in this tree — multiple recent XDomain
security/stability fixes (packet validation, bounds checking, property
parsing).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_THUNDERBOLT` and active XDomain
connections (Thunderbolt networking, cross-host services). Driver-
specific but affects a widely deployed laptop/workstation feature.

### Step 8.2: Trigger Conditions
**Record:** XDomain removal/disconnect while a service child device
still has refcount > 1 after `device_unregister()`. Realistic during
hot-unplug, peer shutdown, or driver teardown races. Unprivileged users
can trigger disconnect by unplugging cable.

### Step 8.3: Failure Mode Severity
**Record:** **Use-after-free** on `xd->service_ids` during `ida_free()`
→ kernel oops / memory corruption. **Severity: HIGH to CRITICAL.**

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** HIGH — prevents UAF crash on a real disconnect path.
- **Risk:** VERY LOW — 2-line refcount fix, maintainer-authored, already
  queued for multiple stable trees.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compiled

**FOR backport:**
- Real UAF on XDomain disconnect teardown path (verified via code +
  driver-core semantics).
- Buggy code confirmed present in 6.18.43.
- Minimal, obviously correct fix (2 lines).
- Thunderbolt maintainer authorship.
- Already nominated for stable on 5.10.y, 5.15.y, 6.6.y (Ratatoskr).
- Standalone — no prerequisite commits required.
- Part of broader XDomain stability effort heading into 6.18.y.

**AGAINST backport:**
- Config-specific (`CONFIG_THUNDERBOLT`) — affects subset of users, not
  all kernels.
- No syzbot/user crash report attached (but mechanism is clear from
  code).

**UNRESOLVED:**
- Full lore review thread (403 blocked).
- Exact upstream commit SHA (not in this checkout).

Neither unresolved item weakens the technical case.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard refcount pattern;
   maintainer-authored; stable-queue nominations imply review.
2. Fixes a real bug affecting users? **PASS** — UAF on Thunderbolt
   XDomain disconnect.
3. Important issue? **PASS** — UAF / potential crash (HIGH-CRITICAL).
4. Small and contained? **PASS** — 2 lines, one file.
5. No new features or APIs? **PASS** — refcount fix only.
6. Can apply to local tree? **PASS** — code exists; clean 2-line apply.

### Step 9.3: Exception Categories
**Record:** Not applicable (not a device ID, quirk, DT, build, or docs
fix — standard bug fix).

### Step 9.4: Decision Rationale

This commit fixes a genuine use-after-free: `tb_service_release()`
accesses the parent XDomain’s `service_ids` IDA after the XDomain may
already have been destroyed during disconnect teardown, because
`device_del()` drops the parent reference at unregister time rather than
at final service release. The fix is minimal, self-contained, and the
buggy code is present in this 6.18.43 tree. Stable maintainers have
already nominated it for multiple older stable branches.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-by/Link
  tags; author is Mika Westerberg.
- **[Phase 2]** Read full diff; confirmed 2-line refcount fix in
  `tb_service_release()` and `enumerate_services()`.
- **[Phase 3]** `git blame` on xdomain.c service code; `git log -S`
  searches; no fix already in tree.
- **[Phase 4]** lore.kernel.org: 403 Forbidden. Ratatoskr: stable
  nominations found for 5.10.y/5.15.y/6.6.y. `b4 dig`: not run (no
  commit hash in tree).
- **[Phase 5]** Traced call chain through `tb_xdomain_remove()` →
  `device_unregister()` → `tb_xdomain_release()` vs deferred
  `tb_service_release()`.
- **[Phase 5]** Verified `device_del()` calls `put_device(parent)` at
  `drivers/base/core.c:3983`.
- **[Phase 5]** Verified `tb_xdomain_release()` calls
  `ida_destroy(&xd->service_ids)` at `xdomain.c:1883`.
- **[Phase 6]** `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43.
- **[Phase 6]** Read current `xdomain.c` — buggy pattern confirmed, fix
  absent.
- **[Phase 6]** Verified `tb_xdomain_get`/`tb_xdomain_put` exist in
  `include/linux/thunderbolt.h:325-336`.
- **[Phase 7]** Thunderbolt subsystem active with recent XDomain fixes
  in this tree.
- **[Phase 8]** Assessed UAF severity as HIGH-CRITICAL on disconnect
  path.

**YES**The analysis is done for **6.18.43**.

**Verdict: YES** — backport this commit.

It fixes a real use-after-free: when an XDomain disconnects,
`tb_service_release()` can call `ida_free()` on the parent XDomain’s
`service_ids` after that XDomain has already been torn down. The fix is
small (two lines: `get_device()` on parent assignment,
`tb_xdomain_put()` in release), applies cleanly here, and the buggy code
is present in this tree.

 drivers/thunderbolt/xdomain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 5fbdd412a712f..fed0fae2a6299 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1029,6 +1029,7 @@ static void tb_service_release(struct device *dev)
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1137,7 +1138,7 @@ static void enumerate_services(struct tb_xdomain *xd)
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);
-- 
2.53.0

