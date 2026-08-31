Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AEB4A92DA;
	Mon, 31 Aug 2026 13:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183964; cv=none; b=kY19Cs7lmajL/5MBk7yT4BD9NCty+p1gH8geiXnXbVhUXzwvHicmJzMTb3XLaY6CAzr0WVVZB1D2K3D8xq2wyDo/i5JwxJROwbJcszeKbQh9Sp3SvbZKJ9Rwa0fLMaKViEnOtqBQKpVcA2e89eQ1GFECWo0/Phe/e9BGp5EMI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183964; c=relaxed/simple;
	bh=HaJFFpH5FN2gIUzxOBjDXRqxZgumWInTi8IRVMPSh6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVTQApX5ILNZiXmYi+ZFBzJa5YJDMNckukelLukSiKi3c3LKCJwUpxA+fLfugn4jWB+d57Md6/HECjaqkbKH4rzwFpxuHwTVMQnsyw93TfXKMyVHOz2dSYzhs7PtpqJnbUP3SFvAGybtKOv6niUqdHjoUN2QrL/jWWQkvRO2tLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QunXjefW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QunXjefW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3981F000E9;
	Mon, 31 Aug 2026 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183961;
	bh=Fa8X07+qikM4Fuldd4aQRMXOt6yXY73ZZD6iOkGAo5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QunXjefW/IXf2Lb/hDyQ/8WNJSbqPH2ojCQl+xn8sBfumobCwFRD+tZmdoCkVs5cH
	 Bakr7zaXEgKvk3M13mtoxeGFbIS9/DKmI1XOlbZ2QQ1oMM9UA76TxJmBchGMOq4hnQ
	 qnSNr2uOG9keUpp24Zi+hc7PhEQTE/fV21YvCu0+QKuocJabZ3V+2f7lsa3W8D0Bsh
	 nB3JjhzUl3rRT2NYXcdd/ggVI77mwMYrb0bYS3ZRZmdXDtyiOakhd/y3M7+npo0Ut3
	 afQ598oXOWK11h3LkACXeSKlSed41M1BTe0SXHurwG0PsvpIvOkHpmNl0lpqJ8yZw3
	 +UZyfk7D4t9Yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shiwu Zhang <shiwu.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdgpu: fix buffer overflow during vBIOS update
Date: Mon, 31 Aug 2026 09:27:14 -0400
Message-ID: <20260831133314.4125787-406-sashal@kernel.org>
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

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 6229898d46c0cbc238a6fe9f11c1ea12cf8bb9c5 ]

Clamp the buffer postion to write by setting the bin attribute
to the maximum buffer size so that VFS layer will block the
out-of-bounds accessing.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drm/amdgpu]` `[fix]` — buffer overflow during vBIOS (IFWI)
update via `psp_vbflash` sysfs interface.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Shiwu Zhang `<shiwu.zhang@amd.com>` (author)
- **Reviewed-by:** Alex Deucher `<alexander.deucher@amd.com>` (amdgpu
  maintainer)
- **Signed-off-by:** Alex Deucher (maintainer ack)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, or `Tested-by:`
  tags
- Notable: maintainer review is a strong quality signal; no
  syzbot/fuzzer report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `psp_vbflash` `bin_attribute` has `.size = 0`, so the
  sysfs/VFS layer does not enforce write bounds;
  `amdgpu_psp_vbflash_write()` can `memcpy()` past the 16 MiB
  `kvmalloc()` buffer.
- **Symptom:** heap buffer overflow on write to
  `/sys/class/drm/card*/device/psp_vbflash` with out-of-bounds
  offset/length.
- **Fix:** set `.size = AMD_VBIOS_FILE_MAX_SIZE_B` (16 MiB) so
  `sysfs_kf_bin_write()` clamps writes.
- **Root cause:** missing sysfs size limit; driver-side check only
  tracks cumulative `vbflash_image_size`, not `pos + count`.

### Step 1.4: Hidden Bug Fix?
**Record:** No — explicitly labeled as a buffer overflow fix.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c` (+1/-1)
- **Function/struct:** `psp_vbflash_bin_attr`
- **Scope:** single-line surgical fix in one file

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `.size = 0` → inode `i_size = 0` → `sysfs_kf_bin_write()`
  skips bounds check (`if (size)` is false).
- **After:** `.size = AMD_VBIOS_FILE_MAX_SIZE_B` → sysfs rejects `pos >=
  size` with `-EFBIG` and clamps `count` to `size - pos`.
- **Path:** sysfs write to `psp_vbflash` on IFWI-capable AMDGPU
  (Navi3x+).

### Step 2.3: Bug Mechanism
**Record:** **Buffer overflow / out-of-bounds write (memory safety).**

Vulnerable write path in this tree:

```4210:4212:drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
        mutex_lock(&adev->psp.mutex);
        memcpy(adev->psp.vbflash_tmp_buf + pos, buffer, count);
        adev->psp.vbflash_image_size += count;
```

Sysfs enforcement when `size == 0`:

```157:161:fs/sysfs/file.c
        if (size) {
                if (size <= pos)
                        return -EFBIG;
                count = min_t(ssize_t, count, size - pos);
        }
```

With `.size = 0`, a user in the device group can seek past 16 MiB and
overflow the kmalloc'd buffer.

### Step 2.4: Fix Quality
**Record:** Obviously correct — `.size` matches the allocation size
(`AMD_VBIOS_FILE_MAX_SIZE_B`). Minimal, no API change. Very low
regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `.size = 0` introduced in `521289d2a279b2` / `8424f2ccb3c0d`
  (2022–2023).
- `psp_vbflash` interface present since `8424f2ccb3c0d` (May 2022).
- IFWI visibility gated by `sup_ifwi_up` since `e7347f1c73cd2` (Jul
  2023); expanded in `b3dd2903b09c6`, `c09910b511de0` (2025).

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related Changes
**Record:**
- Part of a 3-patch series (May 2026): (1) ww_mutex/GEM leaks, **(2)
  this overflow fix**, (3) concurrent allocation mutex.
- Patch 2/3 is standalone; patch 3/3 addresses a separate race.
- Fix **not merged** in this tree (`.size = 0` still at line 4275).

### Step 3.4: Author Context
**Record:** Shiwu Zhang is an AMD amdgpu contributor; Alex Deucher
reviewed.

### Step 3.5: Dependencies
**Record:** None. One-line change; `AMD_VBIOS_FILE_MAX_SIZE_B` already
defined at line 47.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144957.html
- **Series:** PATCH 2/3, May 20, 2026
- No stable nomination found in the thread snippet; no NAKs observed
- `b4 dig -c <hash>` not run — commit not in this checkout (no local
  commitish)

### Step 4.2: Reviewers
**Record:** Alex Deucher reviewed (maintainer). Full recipient list via
`b4 dig -w` unavailable without commit hash.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link; vulnerability
identified by driver author during review.

### Step 4.4: Related Patches
**Record:** Patches 1/3 and 3/3 are separate issues (leaks, concurrent
alloc). Not prerequisites for this fix.

### Step 4.5: Stable List
**Record:** Not searched separately; prior related commit
`fe56c6ee04570` was nominated with `Cc: stable@vger.kernel.org`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `amdgpu_psp_vbflash_write()`, `psp_vbflash_bin_attr`,
`amdgpu_bin_flash_attr_is_visible()`

### Step 5.2: Callers
**Record:** sysfs write path → `sysfs_kf_bin_write()` →
`amdgpu_psp_vbflash_write()`. Triggered by userspace writes to
`psp_vbflash`.

### Step 5.3: Callees
**Record:** `kvmalloc(AMD_VBIOS_FILE_MAX_SIZE_B)`, `memcpy()`,
`mutex_lock/unlock`

### Step 5.4: Reachability
**Record:**
- Exposed when `adev->psp.sup_ifwi_up` is true (PSP 13.0.0/7/10/12,
  14.0.2/3 per `psp_early_init()`).
- Mode `0660` — root and device group (typically `render`/`video`).
- Reachable from userspace by privileged/group members on supported
  dGPUs (Navi3x+ IFWI flashing per
  `Documentation/gpu/amdgpu/flashing.rst`).

### Step 5.5: Similar Patterns
**Record:** Related bounds-checking work by Lijo Lazar on VBIOS parsing
(`atom.c`, Jun 2026) is a separate code path.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `git describe HEAD` → `v6.18.44`. `.size = 0` at
line 4275; vulnerable `memcpy()` at line 4211. `vbflash` ancestor commit
`8424f2ccb3c0d` is in this tree.

### Step 6.2: Backport Complications
**Record:** Clean one-line apply expected. No structural conflicts
observed.

### Step 6.3: Fix Already Present?
**Record:** **No.** `git log --grep="buffer overflow"` on `amdgpu_psp.c`
returns nothing; `.size = 0` still present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (GPU driver,
kernel memory safety on reachable sysfs path).

### Step 7.2: Activity
**Record:** Actively maintained; recent IFWI support commits in 2025.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of AMDGPU with IFWI update support (Navi3x+ dGPUs with
supported PSP versions). Not universal, but real production hardware.

### Step 8.2: Trigger Conditions
**Record:** Write to `psp_vbflash` with `pos + count > 16 MiB` (e.g.,
`lseek` + `write`). Requires membership in device group or root — not
fully unprivileged, but still a kernel memory corruption primitive for
local attackers with GPU access.

### Step 8.3: Failure Mode
**Record:** Heap buffer overflow in kernel context → potential crash,
memory corruption, or local privilege escalation. **Severity: HIGH**
(security-relevant memory safety bug).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes exploitable overflow on documented flashing
  interface
- **Risk:** VERY LOW — one-line, matches existing allocation bound,
  reviewed by maintainer
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Real, verifiable buffer overflow (sysfs bypass + unbounded `memcpy`)
- Security-relevant memory safety fix
- One-line, maintainer-reviewed, obviously correct
- Buggy code present and unfixed in v6.18.44
- Feature is exposed on supported production hardware

**AGAINST:**
- Requires device-group membership (not arbitrary unprivileged user)
- Part of a 3-patch series (but this patch is self-contained)
- No fuzzer report or CVE (yet)

**Unresolved:** Whether patch 3/3 (concurrent alloc race) should also be
backported — separate issue.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mechanism verified in
   `fs/sysfs/file.c`; maintainer reviewed
2. Fixes a real bug? **PASS** — heap overflow on sysfs write
3. Important issue? **PASS** — buffer overflow / potential local
   escalation
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — bounds enforcement only
6. Can apply to local tree? **PASS** — buggy code present, clean apply

### Step 9.3: Exception Category
**Record:** Security/memory-safety fix (not device ID, quirk, or docs).

### Step 9.4: Decision Rationale
For **Linux 6.18.44**, the `psp_vbflash` sysfs interface allocates a 16
MiB buffer but advertises unlimited size to the VFS layer. A group-
privileged user can trigger a kernel heap overflow with an out-of-bounds
write. The fix correctly delegates bounds enforcement to sysfs by
setting `.size` to the allocation limit. It is minimal, maintainer-
reviewed, and the vulnerable code is present and unfixed in this tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no syzbot/Fixes tags
- **[Phase 2]** Read diff and `amdgpu_psp_vbflash_write()` /
  `psp_vbflash_bin_attr` in tree
- **[Phase 2]** Verified `sysfs_kf_bin_write()` skips bounds when `size
  == 0` (`fs/sysfs/file.c:157-161`)
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; Makefile confirms
  6.18.44
- **[Phase 3]** `git blame` on line 4275 → `.size = 0` since 2023
- **[Phase 3]** `git log -S "psp_vbflash_bin_attr"` → introduced
  `8424f2ccb3c0d` (2022)
- **[Phase 3]** `git merge-base --is-ancestor 8424f2ccb3c0d HEAD` →
  ancestor confirmed
- **[Phase 3]** `git log --grep="buffer overflow"` on `amdgpu_psp.c` →
  no fix merged
- **[Phase 4]** WebFetch lore thread:
  https://lists.freedesktop.org/archives/amd-gfx/2026-May/144957.html —
  PATCH 2/3 confirmed
- **[Phase 4]** UNVERIFIED: `b4 dig -c` — commit not in local tree, no
  commitish available
- **[Phase 4]** UNVERIFIED: `b4 dig -w` / `-a` — same reason
- **[Phase 5]** Read `amdgpu_bin_flash_attr_is_visible()` — `0660` when
  `sup_ifwi_up`
- **[Phase 5]** Read `psp_early_init()` — `sup_ifwi_up` set for PSP
  13.0.0/7/10/12, 14.0.2/3
- **[Phase 5]** Read `Documentation/gpu/amdgpu/flashing.rst` — documents
  `psp_vbflash` userspace interface
- **[Phase 6]** Confirmed `.size = 0` at line 4275 (fix not applied)
- **[Phase 6]** Confirmed `AMD_VBIOS_FILE_MAX_SIZE_B` defined at line 47
- **[Phase 8]** Assessed severity as HIGH based on verified overflow
  mechanism

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 9f3581ce492f3..346e9c9cde40c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -4290,7 +4290,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
  */
 static const struct bin_attribute psp_vbflash_bin_attr = {
 	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
+	.size = AMD_VBIOS_FILE_MAX_SIZE_B,
 	.write = amdgpu_psp_vbflash_write,
 	.read = amdgpu_psp_vbflash_read,
 };
-- 
2.53.0

