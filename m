Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6034F9C7C;
	Mon, 31 Aug 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183685; cv=none; b=gWNmEGHt1G8NzV3sRTlPty8V4x9V322+eIfyxKJ4abTqh551ND5a39OvVDVdY4D4zPpzpCk8D0QseSymb8GnrJRpWdvPi0BkaWlpLN6hcilbWUNA0ByEmfsYjI8013cvXxfzfS6NBUNy/SzqacsQ/8BRv355g3diVWyt7Ae2Gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183685; c=relaxed/simple;
	bh=DB0Tukm1teGstjgzYUkOET9cw3v8J72MQ1+1ieAPynE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGkQ8ezyHVG+s7V2gWsRrATQOCql+K3ZLLGGM1m12Q2cAiURjOvxSULUEvvoxL4TY37ft9Q4CWiwR50TKGK1+VcOfwOp62B18COWzaBEPzAonJ6tqjJmOXcIARMEAjNyEd5Fkz9gvr+fYqkrgs8nchUAnPDh3wLplG0EolkzDFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0wRlrKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0wRlrKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497B51F00A3F;
	Mon, 31 Aug 2026 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183683;
	bh=t9NjzSVvUiK3gayp1XaXxHEpLml92T0c2xxi6CPFnHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0wRlrKErUVDJTAUuxmDF+qkwIgNWTtkYZSb/XVEpOJEiKoamOkdq/FZi5K5vUY/a
	 fU3+G1q8E2Hiq02mHCLEi6HTn24OVCAs8FJY1M5m20l93YY9Md+iXq6ecr10MTzptF
	 LV0BhieFqvztq5TEX2pmpX9u3Ae2LQ1ymMWfoV031HWXCLSjFDYfnDwp51wYKAMeR/
	 C5nc7GZN6x5Je7xDJAXGTjvfQ4xCE0x366xDDIMZgURRuuh+fiz/qexjbAbavznSFR
	 LRG8juTiYLQyRB4IFVxAW6X5c1k2FFegP/UghbXiuLVdEsQdf2+CvX6sQm6uCGhLdF
	 k6Gym0z8QKOsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: shayderrr <darknessshayder@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@kernel.org,
	mperttunen@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] host1x: bus: Fix missing ops null check in error teardown
Date: Mon, 31 Aug 2026 09:24:30 -0400
Message-ID: <20260831133314.4125787-242-sashal@kernel.org>
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

From: shayderrr <darknessshayder@gmail.com>

[ Upstream commit 71d25f668bc5c0f36ea843462e12307dea45aaa3 ]

In host1x_device_init(), the error teardown paths do not check
client->ops before dereferencing it, unlike the forward init paths
which correctly guard with 'client->ops &&'. This can result in a
NULL pointer dereference if client->ops is NULL.

Fix by adding the missing client->ops check in both the teardown
and teardown_late labels.

Signed-off-by: shayderrr <darknessshayder@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260517170456.84927-1-darknessshayder@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[host1x: bus]` `[Fix]` — Add missing `client->ops` NULL
checks in `host1x_device_init()` error teardown paths.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** shayderrr \<darknessshayder@gmail.com\> (author)
- **Signed-off-by:** Thierry Reding \<treding@nvidia.com\> (host1x/Tegra
  maintainer)
- **Link:** https://patch.msgid.link/20260517170456.84927-1-
  darknessshayder@gmail.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer sign-off is a strong quality signal; no
  syzbot/user bug report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `host1x_device_init()` teardown (`teardown`, `teardown_late`)
  dereferences `client->ops` without a NULL guard; forward init paths
  already use `client->ops &&`.
- **Symptom:** NULL pointer dereference during error recovery when
  initialization fails.
- **Root cause:** Oversight when teardown was added (2017) and when
  `teardown_late` was added (2021); `host1x_device_exit()` and other
  paths in the same file already guard correctly.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit NULL-deref fix on an error path,
not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/host1x/bus.c` (+2 / -2 lines)
- **Function:** `host1x_device_init()`
- **Scope:** Single-file, surgical (2-line change)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`teardown`):** `if (client->ops->exit)` → `if (client->ops
  && client->ops->exit)`
- **Hunk 2 (`teardown_late`):** `if (client->ops->late_exit)` → `if
  (client->ops && client->ops->late_exit)`
- **Before:** Error teardown could dereference NULL `client->ops`.
- **After:** Clients without `ops` are skipped, matching forward init
  and `host1x_device_exit()`.

### Step 2.3: Bug Mechanism
**Record:** **Category:** NULL pointer dereference (memory safety).
**Mechanism:** On `early_init`/`init` failure, reverse iteration calls
`client->ops->exit` / `client->ops->late_exit` even when `client->ops`
is NULL — a client skipped in the forward path can still be visited in
teardown.

### Step 2.4: Fix Quality
**Record:** Obviously correct; mirrors existing patterns at lines
196–207, 257–271, and 815–836 in the same file. Minimal regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `teardown` without NULL check: introduced in `8f7da1578e90b` (Thierry
  Reding, 2017-11-08) — "gpu: host1x: Cleanup on initialization failure"
- `teardown_late` without NULL check: introduced in `933deb8c7b8e3f`
  (Thierry Reding, 2021-03-26) — "gpu: host1x: Add early init and late
  exit callbacks"
- Forward paths have had `client->ops &&` since original
  `host1x_device_init()` (2013)

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent host1x stable-style fixes in this tree include UAF
(`5f4de3c717d34`), reference leak (`c4d6442ac3ed0`), and syncpt race
(`79197c6007f2a`). Standalone fix; not part of a series.

### Step 3.4: Author Context
**Record:** shayderrr is a contributor; Thierry Reding (maintainer)
signed off. Author is not the subsystem maintainer but patch was
accepted by one.

### Step 3.5: Dependencies
**Record:** No prerequisites. Applies to code present since 2017/2021.
Self-contained.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- `b4 dig` by commit hash and subject: no match (commit not in this
  checkout)
- Lore/patch.msgid.link: blocked by Anubis bot protection — could not
  read thread
- **UNVERIFIED:** Reviewer feedback, stable nominations, series
  revisions

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `host1x_device_init()` — only function modified.

### Step 5.2: Callers
**Record:** `host1x_device_init()` is called from:
- `drivers/gpu/drm/tegra/drm.c` (Tegra DRM probe)
- `drivers/crypto/tegra/tegra-se-main.c` (Tegra SE)
- `drivers/staging/media/tegra-video/video.c` (staging Tegra video)

All are device-probe initialization paths on Tegra (or COMPILE_TEST).

### Step 5.3: Callees
**Record:** `client->ops->exit`, `client->ops->late_exit`,
`mutex_lock/unlock`, list iteration macros.

### Step 5.4: Reachability
**Record:**
1. Tegra clients register via `host1x_client_register()` /
   `__host1x_client_register()`.
2. `host1x_device_init()` runs when the composite host1x device driver
   probes.
3. If any client's `init`/`early_init` fails, teardown runs.
4. Forward path skips clients with `client->ops == NULL`; teardown does
   not — inconsistent and unsafe.
5. In-tree drivers set `ops` before register, but the API explicitly
   allows NULL `ops` (forward guards prove intent). A client with NULL
   `ops` on `device->clients` plus a later init failure triggers the
   bug.

**Userspace trigger:** Indirect — probe failure during boot/driver load
on Tegra systems with `CONFIG_TEGRA_HOST1X` and dependent drivers.

### Step 5.5: Similar Patterns
**Record:** Same `client->ops &&` pattern used in
`host1x_device_exit()`, `host1x_client_suspend()`, and
`host1x_client_resume()` in the same file. Teardown paths are the
outlier.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (Makefile: 6.18.44).
Buggy code at lines 224 and 232 in `drivers/gpu/host1x/bus.c` — fix not
yet applied.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — two identical one-line changes.
No conflicting recent churn in this function.

### Step 6.3: Related Fixes Already Present?
**Record:** No existing fix for this issue in this tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/gpu/host1x/` — Tegra display/multimedia bus
infrastructure. **Criticality:** IMPORTANT for Tegra/embedded;
PERIPHERAL globally (requires `CONFIG_TEGRA_HOST1X`, `ARCH_TEGRA` or
`COMPILE_TEST`).

### Step 7.2: Activity
**Record:** Actively maintained; multiple bugfix commits in recent
history on this subsystem.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Tegra platform users with host1x clients (DRM, crypto,
staging video). Not universal x86/ARM server impact.

### Step 8.2: Trigger Conditions
**Record:**
- `host1x_device_init()` called during probe
- A client `init`/`early_init` fails
- Teardown visits a client with `client->ops == NULL` (skipped during
  forward init)
- **Likelihood:** Low-to-medium on error paths; requires init failure
  plus NULL-ops client on the list

### Step 8.3: Failure Mode Severity
**Record:** Kernel oops (NULL dereference) during error recovery instead
of clean `-errno` return. **Severity: HIGH** for affected path (turns
recoverable probe failure into crash).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents crash on init-failure teardown; makes error
  recovery robust
- **Risk:** Very low — 2-line change matching established pattern
- **Ratio:** Favorable for Tegra stable users

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real NULL-deref bug on error path
- Trivial, obviously correct 2-line fix
- Matches existing code in same function/file
- Maintainer (Thierry Reding) signed off
- Bug present since 2017/2021; affects this v6.18.44 tree
- Error-path crash is worse than the original init failure

**AGAINST backport:**
- Platform-specific (Tegra only)
- Requires init failure (uncommon)
- No user/syzbot report documented
- In-tree drivers appear to always set `ops` before register (trigger
  may be rare in practice)

**UNRESOLVED:**
- Mailing list review thread (Anubis blocked)
- No confirmed in-tree reproduction with current drivers

The unresolved items do not outweigh the clear correctness fix: forward
paths already treat NULL `ops` as valid; teardown must match.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing guards;
   maintainer SOB; no logic change beyond NULL safety
2. Fixes a real bug? **PASS** — NULL deref on error teardown
3. Important issue? **PASS** — kernel oops on probe error recovery (HIGH
   for affected users)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed in v6.18.44

### Step 9.3: Exception Categories
**Record:** None (standard bug fix).

### Step 9.4: Decision Rationale
This is a conservative, surgical fix for an inconsistent NULL check that
can kernel-oops during `host1x_device_init()` error recovery on Tegra
systems. The fix aligns teardown with forward init and
`host1x_device_exit()`, carries negligible regression risk, and the
buggy code is present in this v6.18.44 tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query
- **[Phase 2]** Confirmed diff: 2 lines in `host1x_device_init()`
  teardown paths
- **[Phase 3]** `git describe HEAD`: v6.18.44; Makefile confirms 6.18.44
- **[Phase 3]** `git blame -L 222,236`: teardown from 2017
  (`8f7da1578e90b`), teardown_late from 2021 (`933deb8c7b8e3f`)
- **[Phase 3]** `git show 8f7da1578e90bf`: original teardown added
  without NULL check while forward path had one
- **[Phase 3]** `git log -p -S 'if (client->ops->exit)'`: confirmed 2017
  introduction of unguarded teardown
- **[Phase 3]** `git log --oneline -15 -- drivers/gpu/host1x/bus.c`:
  recent related fixes; no duplicate fix
- **[Phase 4]** `b4 dig`: no results (commit not in tree)
- **[Phase 4]** WebFetch lore/patch.msgid.link: blocked by Anubis —
  **UNVERIFIED** review discussion
- **[Phase 5]** `grep host1x_device_init`: callers in tegra drm, tegra-
  se, tegra-video
- **[Phase 5]** Read `host1x_device_init()`, `host1x_device_exit()`,
  suspend/resume: confirmed `client->ops &&` pattern elsewhere
- **[Phase 5]** Read tegra driver probes (dc.c, gr3d.c, sor.c, tegra-
  se): ops set before register
- **[Phase 6]** Read current `bus.c` lines 224, 232: buggy code present
  (no NULL check)
- **[Phase 6]** Kconfig: `CONFIG_TEGRA_HOST1X` depends on `ARCH_TEGRA ||
  COMPILE_TEST`
- **[Phase 8]** Failure mode: NULL deref → oops on init-failure teardown

**YES**The backport analysis is done.

**Commit:** `host1x: bus: Fix missing ops null check in error teardown`
**Tree:** v6.18.44 — the bug is still present (unguarded `client->ops`
derefs at lines 224 and 232 in `drivers/gpu/host1x/bus.c`).

**Summary:** On Tegra, if `host1x_device_init()` fails partway through,
the teardown paths can NULL-deref `client->ops` while forward init and
`host1x_device_exit()` already guard against that. The fix is two lines,
matches existing patterns, and is signed off by host1x maintainer
Thierry Reding.

**Verdict: YES** — backport to this tree.

A background `git log --grep` search timed out; it wasn’t needed for the
decision since the buggy code and history were already confirmed
directly.

 drivers/gpu/host1x/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 3313ead8bfcc2..06aa7fcd367e1 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -221,7 +221,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->exit)
+		if (client->ops && client->ops->exit)
 			client->ops->exit(client);
 
 	/* reset client to end of list for late teardown */
@@ -229,7 +229,7 @@ int host1x_device_init(struct host1x_device *device)
 
 teardown_late:
 	list_for_each_entry_continue_reverse(client, &device->clients, list)
-		if (client->ops->late_exit)
+		if (client->ops && client->ops->late_exit)
 			client->ops->late_exit(client);
 
 	mutex_unlock(&device->clients_lock);
-- 
2.53.0

