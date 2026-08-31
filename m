Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5424B5CB0;
	Mon, 31 Aug 2026 13:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184372; cv=none; b=tZCgjGuDwsDOk9dofSrWN3kpHIqqzW7rtxqlS4qWmhPZbBQl5mnwDjAPYNtuG5kP7jLDszMso8EXnhqwzRh+R58zS7+kfQPj2dczNSAO6VmlQxWPjAdQD8qRBzPWMTjayr+DNSv4MIt+O3tJ1RaOE4Wrws4SCcLgIzTDu+vlqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184372; c=relaxed/simple;
	bh=JRAcA22qW7c8ZitNzISg41bO8q4tLt2zICy0E1KASUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZpS8R1XSEB+C0StC5/2ez1X5EwIbvFDQZFaD9BHPVrT85YebNxGnu5ouxXknejDrXI1Ldt/dcQnO2kZff2D466+toiVnehO9y19WC7fsqLZwxprgbPN5WnSCr9fz7Q5iOdunVrIWRVydmYwt/wwPk7lSMSu5TLpo4OfkuMEhfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQN+FcsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQN+FcsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1523C1F000E9;
	Mon, 31 Aug 2026 13:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184370;
	bh=EoDhVhAqFkTd/gwKHnm+ddgdp3zLKhRCGZaTUlfzPgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQN+FcsFfove5+xPNoKWqf62Meox9MkDA5PY1l8yCgvVqf4sBC4LiReB8hD3oROmw
	 tgN6Zg+kDg+/wYOycGcQvLgXr3ONhwF6wmPl6nOnuFWjEUw9NAcjU/7OpXMkRL4kgc
	 8tK0HLMoTGJRzhQAPzGQ+4/mmZqCtyJtUegTqdWHO06o6uzMicWylX6tsuCmvXANgP
	 jqgagM2S7gJa1EzDBTjqlkyIxkKUoCz0tGNkeC8bMfo/f5EOBJQNAwFwkbdSW7Dtth
	 6Xw7yl+OIuArp1l5M1BlkRfCHJmpWd3WSbVkcFVpFtaNWjdsTC75jYW9kvja53Y9yv
	 2b97iFosIhEIg==
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
Subject: [PATCH AUTOSEL 6.18-5.10] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Mon, 31 Aug 2026 09:31:21 -0400
Message-ID: <20260831133314.4125787-653-sashal@kernel.org>
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

[ Upstream commit 4c63f29872cb444b33665348bbd2f45cab06afcd ]

If tb_cfg_request() fails setting up the request (for example the
control channel is shut down already) it returns an error without
calling the callback. To avoid leaking that memory, call
tb_cfg_request_put() if tb_cfg_request() fails.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `thunderbolt: Release request if
tb_cfg_request() fails in __tb_xdomain_response()`

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel version **6.18.43**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[thunderbolt]` `[Release/fix]` — Release the allocated
`tb_cfg_request` when `tb_cfg_request()` fails in
`__tb_xdomain_response()`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Mika Westerberg `<mika.westerberg@linux.intel.com>`
  (author; ignore pipeline SOB)

No syzbot, no user reports. Author is the Thunderbolt subsystem
maintainer.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `tb_cfg_request()` can fail during setup (e.g., control
  channel already shut down with `ctl->running == false`). On failure it
  returns an error without invoking the `response_ready` callback.
- **Symptom:** Each failed `__tb_xdomain_response()` leaks one `struct
  tb_cfg_request` (~200 bytes via `kzalloc`).
- **Root cause:** Caller allocates with `tb_cfg_request_alloc()`
  (refcount 1). `tb_cfg_request()` bumps refcount and on error only
  drops its own reference, leaving the alloc reference unreleased. The
  success path relies on `response_ready` + workqueue to drop both
  references; the error path has no callback.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — explicitly a memory-leak fix on an error
path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/thunderbolt/xdomain.c` (+5 / -1 lines)
- **Function:** `__tb_xdomain_response()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `return tb_cfg_request(ctl, req, response_ready, req);` —
  on error, `req` leaked.
- **After:** Capture return value; if non-zero, call
  `tb_cfg_request_put(req)`; return `ret`.
- **Path affected:** Error path only (enqueue failure `-ENOTCONN`, TX
  failure, etc.).

### Step 2.3: Bug mechanism
**Record:** **Category:** Memory/resource leak (reference counting
imbalance).

Verified refcount flow in `tb_cfg_request()`:

```547:578:drivers/thunderbolt/ctl.c
int tb_cfg_request(struct tb_ctl *ctl, struct tb_cfg_request *req,
                   void (*callback)(void *), void *callback_data)
{
        // ...
        tb_cfg_request_get(req);
        ret = tb_cfg_request_enqueue(ctl, req);
        if (ret)
                goto err_put;
        // ...
err_put:
        tb_cfg_request_put(req);
        return ret;
}
```

- Alloc: ref = 1
- `tb_cfg_request_get()`: ref = 2
- Error `tb_cfg_request_put()`: ref = 1 (callback never runs)
- Without caller `put`: **leak**

Success path (no `req->response`): workqueue runs `response_ready` (put)
then `tb_cfg_request_put` in work — balanced.

### Step 2.4: Fix quality
**Record:** Obviously correct. Matches the pattern in
`__tb_xdomain_request()` (always calls `tb_cfg_request_put` after sync)
and `icm.c` (always puts after `tb_cfg_request`). Minimal regression
risk — only runs on already-failing paths.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** `__tb_xdomain_response()` leaky pattern is present at HEAD
in this tree. Upstream fix: `4c63f29872cb` (May 5, 2026). Prepared
stable backport object `5430d7b1b6346` exists in repo but is **NOT** an
ancestor of HEAD.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug is a longstanding omission in the
async ownership model of `__tb_xdomain_response`, not a regression from
a specific commit.

### Step 3.3: Related file history
**Record:** Recent thunderbolt fixes in this tree include other leak
fixes (`da405838` debugfs margining buffer leak). XDomain hardening
commits (`fcbd0cd`, `46da5c3`, `b5daa920`) are separate security/size
fixes.

### Step 3.4: Author context
**Record:** Mika Westerberg is Thunderbolt maintainer. Fix is in a 7.2
pull series but is standalone (patch 5/12, no structural dependencies).

### Step 3.5: Prerequisites
**Record:** No dependencies. `tb_cfg_request_put`, `response_ready`, and
`__tb_xdomain_response` all exist in this tree. Applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c 4c63f29872cb` and `b4 dig -c 5430d7b1b6346` — no
lore match. `b4 am` subject lookup — not found. lore.kernel.org blocked
by Anubis bot protection. Web search found patch in **[GIT PULL] USB /
Thunderbolt driver changes for 7.2-1** as patch 5/12.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not retrieve recipient list from lore/b4.

### Step 4.3: Bug report
**Record:** No external bug report. Issue identified by maintainer via
code inspection.

### Step 4.4: Series context
**Record:** Part of 12-patch Thunderbolt series for 7.2. This patch is
self-contained; other series patches are unrelated features/refactors.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable archive inaccessible. Similar
thunderbolt leak fix (`da405838`) already backported to this 6.18.y
tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__tb_xdomain_response()`, `response_ready()`,
`tb_cfg_request()`, `tb_cfg_request_alloc()`, `tb_cfg_request_put()`.

### Step 5.2: Callers of `__tb_xdomain_response()`
**Record:** Six internal call sites in `xdomain.c`:
- `tb_xdp_uuid_response()`
- `tb_xdp_error_response()`
- `tb_xdp_properties_response()`
- `tb_xdp_properties_changed_response()`
- `tb_xdp_link_state_status_response()`
- (one more via grep at line 609)

Also exported wrapper `tb_xdomain_response()` for module drivers.

### Step 5.3: Callees
**Record:** `tb_cfg_request_alloc()`, `tb_cfg_request()`,
`tb_cfg_request_put()` (after fix). `tb_cfg_request_enqueue()` returns
`-ENOTCONN` when `!ctl->running`.

### Step 5.4: Reachability
**Record:** Triggered during XDomain protocol handling — device hotplug,
property exchange, link state changes. Error path fires when control
channel is stopped (`tb_ctl_stop()` during `tb_domain_remove()` / probe
error paths). Realistic during Thunderbolt cable unplug or driver
unload.

### Step 5.5: Similar patterns
**Record:** `__tb_xdomain_request()` always calls
`tb_cfg_request_put(req)` after `tb_cfg_request_sync()`. `icm.c:2282`
always puts after async `tb_cfg_request()`. `__tb_xdomain_response()`
was the outlier missing error-path cleanup.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** At HEAD, `drivers/thunderbolt/xdomain.c:153` still
has `return tb_cfg_request(ctl, req, response_ready, req);` without
error-path `put`. Fix commit `5430d7b1b6346` is **NOT_IN_HEAD**.

### Step 6.2: Backport complications
**Record:** Clean apply expected — upstream diff is 5 lines, no context
conflicts with recent XDomain security patches in this tree.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix present. Other thunderbolt leak fixes
exist (debugfs) but not this one.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/thunderbolt/` — **IMPORTANT** (USB4/Thunderbolt
driver, `CONFIG_USB4`). Affects systems with TB/USB4 hardware.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple recent fixes in this 6.18.y
tree (XDomain validation, debugfs leak, property parsing bounds).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with USB4/Thunderbolt (`CONFIG_USB4`) during XDomain
communication, especially teardown/unplug scenarios.

### Step 8.2: Trigger conditions
**Record:** `tb_cfg_request()` fails because control channel is not
running (`-ENOTCONN` from `tb_cfg_request_enqueue`) or TX fails. Most
likely during domain stop/removal while XDomain responses are still
attempted. Not userspace-triggerable directly, but common on hot-unplug.

### Step 8.3: Failure mode severity
**Record:** Memory leak — one `struct tb_cfg_request` per failed
response. Not a crash or security issue, but accumulates on repeated
teardown races. **Severity: MEDIUM** (resource leak on realistic error
path).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — prevents kernel memory leak during TB
  disconnect/teardown
- **Risk:** VERY LOW — 5-line error-path fix, maintainer-authored,
  mirrors existing patterns
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Verified memory leak on `tb_cfg_request()` error path
- Buggy code confirmed present in 6.18.43 tree; fix not yet applied
- Small, surgical, obviously correct fix
- Thunderbolt maintainer authorship
- Realistic trigger during control channel shutdown
- Precedent: other thunderbolt leak fixes backported to this tree
- No dependencies or API changes

**AGAINST backport:**
- Leak is small per occurrence (not crash/corruption)
- Only affects `CONFIG_USB4` systems
- No fuzzer or user reports

**UNRESOLVED:**
- Full lore review thread unavailable (b4/lore blocked)
- Exact frequency of leak in production unquantified

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — refcount logic verified; no
   Tested-by but pattern matches sibling code
2. Fixes a real bug? **PASS** — confirmed memory leak
3. Important issue? **PASS (MEDIUM)** — resource leak on driver teardown
   path
4. Small and contained? **PASS** — 5 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision rationale

This commit fixes a real, verifiable memory leak in the Thunderbolt
XDomain response path. When the control channel is already stopped
(typical during domain teardown or hot-unplug), `tb_cfg_request()`
returns an error without invoking the `response_ready` callback, leaving
the allocation from `tb_cfg_request_alloc()` unreleased. The fix adds
the missing `tb_cfg_request_put()` on the error path only, matching
established patterns elsewhere in the same driver.

For the **6.18.43** tree checked out locally, the buggy code is present
and the fix is absent. The patch is minimal, maintainer-authored, and
carries very low regression risk. While not a crash-level issue, stable
trees routinely accept driver memory-leak fixes on realistic error paths
— and this tree already backports a similar thunderbolt debugfs leak
fix.

---

## Verification

- [Phase 1] Parsed subject, tags (only SOB from Mika Westerberg), body —
  memory leak on `tb_cfg_request()` failure
- [Phase 2] Diff: +5/-1 in `__tb_xdomain_response()`, error-path
  `tb_cfg_request_put()`
- [Phase 2] Read `tb_cfg_request()` at `ctl.c:547-578` — confirmed error
  path drops only internal ref, callback not called
- [Phase 2] Read `response_ready()` at `xdomain.c:133-136` — success-
  path cleanup via callback
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 3] `git show 4c63f29872cb` — upstream fix commit exists (May 5,
  2026)
- [Phase 3] `git merge-base --is-ancestor 5430d7b1b6346 HEAD` →
  NOT_IN_HEAD; buggy code at `xdomain.c:153`
- [Phase 3] Compared `__tb_xdomain_request()` at `xdomain.c:198` —
  always puts after request
- [Phase 3] Compared `icm.c:2278-2282` — always puts after async
  `tb_cfg_request()`
- [Phase 4] `b4 dig -c 4c63f29872cb` — no lore match
- [Phase 4] Web search — found in 7.2 GIT PULL series (patch 5/12)
- [Phase 4] lore.kernel.org — blocked by Anubis (UNVERIFIED for thread
  review)
- [Phase 5] Grep: 6 call sites for `__tb_xdomain_response()` in
  `xdomain.c`
- [Phase 5] Read `tb_cfg_request_enqueue()` at `ctl.c:140-142` — returns
  `-ENOTCONN` when `!ctl->running`
- [Phase 5] Read `tb_ctl_stop()` at `ctl.c:751-754` — sets `ctl->running
  = false`
- [Phase 5] Read `tb_domain_remove()` at `domain.c:506` — calls
  `tb_ctl_stop()`
- [Phase 6] Confirmed buggy code at HEAD `xdomain.c:138-154`
- [Phase 6] Confirmed fix not in HEAD; upstream diff applies to same
  function structure
- [Phase 7] Driver built under `CONFIG_USB4` per
  `drivers/thunderbolt/Makefile`
- [Phase 8] Prior thunderbolt leak fix `da405838` present in this tree
- [Phase 8] Leak size: one `kzalloc(sizeof(struct tb_cfg_request))` per
  failure

**YES**The background `git branch -a --contains` check hung (likely
because scanning all branches is slow in this repo), so I didn’t wait on
it.

The same question was already answered with a direct check: `git merge-
base --is-ancestor 5430d7b1b6346 HEAD` → **NOT_IN_HEAD**. The leak fix
is not in your current **6.18.43** tree; the buggy code is still at
`drivers/thunderbolt/xdomain.c:153`.

**Verdict from the analysis: YES** — this is a small, correct memory-
leak fix on the `tb_cfg_request()` error path and is appropriate for
stable backport to this tree.

 drivers/thunderbolt/xdomain.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index b27ef872edeac..5fbdd412a712f 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -139,6 +139,7 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 				 size_t size, enum tb_cfg_pkg_type type)
 {
 	struct tb_cfg_request *req;
+	int ret;
 
 	req = tb_cfg_request_alloc();
 	if (!req)
@@ -150,7 +151,11 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 	req->request_size = size;
 	req->request_type = type;
 
-	return tb_cfg_request(ctl, req, response_ready, req);
+	ret = tb_cfg_request(ctl, req, response_ready, req);
+	if (ret)
+		tb_cfg_request_put(req);
+
+	return ret;
 }
 
 /**
-- 
2.53.0

