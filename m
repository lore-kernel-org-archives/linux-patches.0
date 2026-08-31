Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEB241D4D0;
	Mon, 31 Aug 2026 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183256; cv=none; b=b4zfjrBXnTSjFxsuouzdTapek7SNu3g94L/QjTx0Ozq+rhRzipEYBNRpS3A8yDYdx8POwqCMCEMYJ6r5isRr75y1JcgzATpTUSZxgOj8Ut0CNpZVrJAvmNp5b4I0uzCR25EShMrM/8g7JJgyT3RUYLVpgLey7lj3Mf5I3LLehzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183256; c=relaxed/simple;
	bh=8PUSKcI0rCh181oAz0uBvOIUW1gHW67lG31yI5EYr2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcuOw30vK6oBD20Hu8JbxkU/p2CuWbQybqWG9p+jNj7Ef1++yBPm9CWjfMtMtYT6DJF7Z6eVFKMmu9htFRmEjBrCxk13NtxU1+LmmdpMhgEorZ1/5OZ4MhiDXct+2NAXx5NZTrvqftSM+yf3+XUZh0TDKhMzKrq4myPjaKd1UrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooD4djly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooD4djly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EFD1F00ACA;
	Mon, 31 Aug 2026 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183254;
	bh=/Q79X5Xn+tg1UZxAIgYhgAna65OpGpoajZyd4LCaADw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooD4djlyqAt3nWkmqMgPM8/He6nbwvRxTQU0Kg1273mJ2IFfO26pa4h74ESML1v+I
	 OtpBVb1leIQHgGlcbFJMpQdzyT0MmfLvpnXN05Zk8X9vCfb41eDmp4rI4XieyHvh3C
	 F29fVMEPNqJGL4FRBXFYrsCGDLtz7KUxS72wnVN5HTHwqlL8V1roSDDpvHXcybYlvi
	 F5HJexi8RDTBBbENo/DmRrcIYmxeHnQuQlFUxOgfADtzcwW+Khf0nB0DtTKksypwzl
	 6vIojdr2zIlcJ+xJCHLum/+ED34l+SBznclQSWcjV7O/edPCSE/DjZ246T+6oi+CoE
	 aRU+vkDFVSzig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw
Date: Mon, 31 Aug 2026 09:21:06 -0400
Message-ID: <20260831133314.4125787-38-sashal@kernel.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit d1f9f5839bd785a3a06335a01d53282e80f8e5fa ]

Change psp_copy_fw from void to int: return -ENODEV when drm_dev_enter
fails, and -EINVAL when the image size is zero or larger than the
1 MiB PSP private buffer.

Replace open-coded memset/memcpy into fw_pri_buf with psp_copy_fw.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu: validate and share PSP
fw_pri_buf copies via psp_copy_fw`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`)
**Upstream commit:** `d1f9f5839bd78` (not yet in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/amdgpu]` `[validate]` — Add size validation and error
propagation to `psp_copy_fw`, consolidating open-coded `fw_pri_buf`
copies.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Candice Li <candice.li@amd.com>` (author)
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`

Notable: AMD maintainer review and merge; no fuzzer or user bug report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `psp_copy_fw()` silently returns on `drm_dev_enter()`
  failure; `memcpy()` into `fw_pri_buf` has no bounds check against the
  1 MiB (`PSP_1_MEG`) buffer.
- **Symptom:** Callers proceed as if the copy succeeded — PSP commands
  may run with stale/empty buffer data, or a heap buffer overflow occurs
  if `bin_size > PSP_1_MEG`.
- **Root cause:** `psp_copy_fw` was `void` with no size validation;
  several PSP version files duplicated `memset`/`memcpy` without checks.
- **Fix:** Return `-ENODEV` / `-EINVAL`; propagate errors to all
  callers; route all copies through `psp_copy_fw`.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite "validate and share" wording, this is a real
memory-safety and error-handling bug fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- 8 files: `amdgpu_psp.c` (+32/-7 net), `amdgpu_psp.h` (+1/-1),
  `psp_v3_1.c`, `psp_v11_0.c`, `psp_v12_0.c`, `psp_v13_0.c`,
  `psp_v13_0_4.c`, `psp_v14_0.c`
- Total: +62 / -38 lines
- Functions: `psp_copy_fw`, `psp_load_toc`, `psp_rl_load`,
  `psp_ta_load`, plus bootloader load helpers in PSP version files
- **Scope:** Multi-file but mechanical; single-subsystem surgical fix

### Step 2.2: Code Flow Changes
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| `psp_copy_fw` | `void`; silent return on `drm_dev_enter` fail;
unchecked `memcpy` | `int`; returns `-ENODEV`/`-EINVAL`; validates `0 <
bin_size <= PSP_1_MEG` |
| `psp_load_toc`, `psp_rl_load`, `psp_ta_load` | Ignored `psp_copy_fw`
result | Check return; release cmd buf and abort on error |
| `psp_v11_0`–`psp_v14_0` bootloader paths | Open-coded
`memset`/`memcpy` or ignored `psp_copy_fw` return | Use `psp_copy_fw`
with error propagation |

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Memory safety (buffer overflow) + logic bug (ignored
  error path)
- **Mechanism:** `fw_pri_buf` is allocated at exactly `PSP_1_MEG`
  (verified at `amdgpu_psp.c:508`). `is_psp_fw_valid()` only checks
  `size_bytes != 0` (`amdgpu_psp.c:4179-4181`). `memcpy(psp->fw_pri_buf,
  start_addr, bin_size)` with `bin_size > PSP_1_MEG` overflows the 1 MiB
  kernel buffer. On `drm_dev_enter` failure, callers previously
  submitted PSP commands believing the copy succeeded.

### Step 2.4: Fix Quality
**Record:** Obviously correct. Mirrors existing TA validation
(`ta_bin_len > PSP_1_MEG` in `amdgpu_psp_ta.c:169`). Minimal regression
risk; error paths properly release acquired resources.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `psp_copy_fw` introduced in `f89f8c6bafd06` (May 2021,
"Guard against write accesses after device removal"). `drm_dev_enter`
guard added then; silent `return` on failure is the latent bug. Code
present in 6.18.44.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Related prior fix `c99769bceab4e` ("Validate TA binary
size", 2023) is already in 6.18.44 — validates userspace TA loads
against `PSP_1_MEG`. This commit extends the same constraint to kernel
firmware copy paths. Standalone; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Candice Li is an active AMD amdgpu contributor. Alex Deucher
(maintainer) committed the merge.

### Step 3.5: Dependencies
**Record:** No prerequisites. All touched files and `psp_copy_fw` exist
in 6.18.44. Cherry-pick test: applies cleanly (exit 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch Discussion
**Record:** `b4 dig -c d1f9f5839bd78` — no lore match found. Patch
likely merged via GitLab/Freedesktop rather than public lore thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not run (no lore match). Commit message confirms
`Reviewed-by: Tao Zhou` and `Signed-off-by: Alex Deucher`.

### Step 4.3: Bug Report
**Record:** N/A — no `Reported-by:` or `Link:` tags. No syzbot report.

### Step 4.4: Related Patches
**Record:** `c99769bceab4e` (TA size validation) is the directly related
prior fix, already in this tree.

### Step 4.5: Stable List History
**Record:** lore.kernel.org search blocked (Anubis bot protection). No
stable-list discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `psp_copy_fw`, `psp_load_toc`, `psp_rl_load`, `psp_ta_load`,
`psp_v*_bootloader_load_*`

### Step 5.2: Callers
**Record:** `psp_copy_fw` called from PSP init/bootloader paths
(`psp_v3_1`, `psp_v11_0`, `psp_v12_0`, `psp_v13_0`, `psp_v13_0_4`,
`psp_v14_0`) and from `psp_load_toc`, `psp_ta_load` during GPU
probe/initialization. All AMD GPU users with PSP enabled hit these paths
at driver load.

### Step 5.3: Callees
**Record:** `drm_dev_enter/exit`, `memset`, `memcpy`, `dev_err` —
operates on `psp->fw_pri_buf` (1 MiB BO-mapped buffer).

### Step 5.4: Reachability
**Record:** Triggered during GPU probe/init (every boot with amdgpu).
Not a direct syscall path, but universal for amdgpu hardware. Overflow
requires `size_bytes > PSP_1_MEG` from firmware header parsing;
`drm_dev_enter` failure occurs during device teardown concurrent with
PSP operations.

### Step 5.5: Similar Patterns
**Record:** Userspace TA path already validates `ta_bin_len > PSP_1_MEG`
(`amdgpu_psp_ta.c:169`). Kernel paths in `psp_v13_0.c`, `psp_v14_0.c`,
`psp_v13_0_4.c`, and `psp_rl_load` still use unchecked `memcpy` —
exactly what this fix addresses.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** Yes. In 6.18.44, `psp_copy_fw` is still `void` with
unchecked `memcpy` (`amdgpu_psp.c:4157-4168`). Open-coded unchecked
copies exist in `psp_v13_0.c:268-271`, `psp_v14_0.c:143-146`,
`psp_v13_0_4.c`, and `psp_rl_load` (`amdgpu_psp.c:1162-1163`). Bug
present since 2021.

### Step 6.2: Backport Complications
**Record:** Clean apply confirmed via test cherry-pick. No conflicts
expected.

### Step 6.3: Related Fixes Already Present?
**Record:** TA userspace validation (`c99769bceab4e`) is in tree. The
kernel-path validation this commit adds is not.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/gpu/drm/amd/amdgpu` — GPU driver (IMPORTANT).
Affects all AMD GPU users with PSP firmware loading.

### Step 7.2: Activity
**Record:** Actively maintained; PSP v13/v14 support added in recent
6.18 development.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** All amdgpu users during GPU initialization (driver-specific,
but broad within AMD GPU deployments).

### Step 8.2: Trigger Conditions
**Record:**
- **Overflow:** Corrupt/malformed firmware header with `size_bytes >
  0x100000`, or internal bug setting oversized `size_bytes`.
  Unprivileged users cannot directly trigger kernel firmware path;
  requires bad firmware on disk.
- **drm_dev_enter failure:** Device removal/teardown racing with PSP
  firmware load (uncommon but realistic).

### Step 8.3: Failure Mode Severity
**Record:**
- Buffer overflow → heap corruption, kernel oops/panic — **CRITICAL**
- Silent copy failure → PSP commands with stale data, init failure or
  hardware hang — **HIGH**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes a real overflow window; consistent with
  existing TA validation; proper error propagation
- **Risk:** LOW — small, mechanical, reviewed by AMD maintainer, applies
  cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR:**
- Fixes potential heap buffer overflow (memory safety)
- Fixes silent error on `drm_dev_enter` failure
- Extends validation already applied to userspace TA path
  (`c99769bceab4e`, in tree)
- Small (+62/-38), obviously correct, AMD-reviewed
- Applies cleanly to 6.18.44
- All affected code exists in this tree

**AGAINST:**
- No user report, syzbot, or CVE
- Normal AMD firmware sizes are well under 1 MiB; overflow requires
  corrupt firmware or parsing bug
- Primarily defense-in-depth on init path

**UNRESOLVED:**
- No public lore discussion found
- No production crash report documented

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — simple bounds check; AMD
   internal review
2. Fixes a real bug? **PASS** — unchecked `memcpy` into fixed 1 MiB
   buffer
3. Important issue? **PASS** — buffer overflow (CRITICAL class)
4. Small and contained? **PASS** — 8 files, ~100 lines, single subsystem
5. No new features/APIs? **PASS** — validation and error propagation
   only
6. Can apply to local tree? **PASS** — clean cherry-pick confirmed

### Step 9.3: Exception Category
**Record:** None of the automatic exception categories apply; this is a
standard memory-safety bug fix.

### Step 9.4: Decision Rationale

This commit closes a genuine memory-safety hole: `fw_pri_buf` is exactly
1 MiB, but multiple kernel firmware copy paths perform unchecked
`memcpy` based on `size_bytes` from firmware headers, with
`is_psp_fw_valid()` only rejecting zero size. The driver already
validates the same 1 MiB limit for userspace-loaded TA binaries — this
brings kernel paths to the same standard. The `drm_dev_enter` error
propagation fix prevents PSP command submission after a failed copy
during device teardown.

While no crash has been reported, buffer overflow fixes are explicitly
stable-worthy, the change is small and low-risk, and it applies cleanly
to 6.18.44.

---

## Verification

- [Phase 1] Parsed commit `d1f9f5839bd78` message and tags from `git
  show`
- [Phase 2] Analyzed full diff; confirmed `PSP_1_MEG = 0x100000` in
  `amdgpu_psp.h:37`
- [Phase 2] Verified `fw_pri_buf` allocated at `PSP_1_MEG`
  (`amdgpu_psp.c:508-513`)
- [Phase 2] Verified `is_psp_fw_valid()` only checks non-zero
  (`amdgpu_psp.c:4179-4181`)
- [Phase 2] Found unchecked `memcpy` in `psp_v13_0.c:271`,
  `psp_v14_0.c:146`, `psp_rl_load` (`amdgpu_psp.c:1162-1163`)
- [Phase 3] `git blame`: `psp_copy_fw` from `f89f8c6bafd06` (May 2021)
- [Phase 3] Related fix `c99769bceab4e` confirmed in tree via `git
  merge-base --is-ancestor`
- [Phase 3] Cherry-pick test: `git cherry-pick --no-commit
  d1f9f5839bd78` — clean apply (exit 0)
- [Phase 4] `b4 dig -c d1f9f5839bd78` — no lore match
- [Phase 4] lore.kernel.org fetch — blocked by Anubis
- [Phase 5] `grep psp_copy_fw`: 14 call sites across 7 files in tree
- [Phase 5] TA validation at `amdgpu_psp_ta.c:169` confirmed
- [Phase 6] `git describe HEAD` → `v6.18.44`
- [Phase 6] Buggy `void psp_copy_fw` confirmed present at
  `amdgpu_psp.c:4157`
- [Phase 6] Commit not in tree: present on `origin/master`, absent from
  `stable/linux-6.18.y`
- [Phase 8] Failure modes assessed from code flow analysis

**YES**The background `git log` search for `psp_copy_fw` and "validate
and share PSP fw_pri_buf" finished with no matches in this tree —
expected, since `d1f9f5839bd78` is on mainline but not in `v6.18.44`
yet.

That lines up with the earlier analysis: the unchecked `memcpy` paths
are still present here, and the fix applies cleanly. Verdict remains
**YES** for backport.

 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  | 32 ++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h  |  2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c   |  8 ++++--
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c   |  8 ++++--
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c   | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c   | 14 +++++------
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c    |  8 ++++--
 8 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 5f7aa840b2151..9f3581ce492f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -832,7 +832,11 @@ static int psp_load_toc(struct psp_context *psp,
 	struct psp_gfx_cmd_resp *cmd = acquire_psp_cmd_buf(psp);
 
 	/* Copy toc to psp firmware private buffer */
-	psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	ret = psp_copy_fw(psp, psp->toc.start_addr, psp->toc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	psp_prep_load_toc_cmd_buf(cmd, psp->fw_pri_mc_addr, psp->toc.size_bytes);
 
@@ -1159,8 +1163,11 @@ static int psp_rl_load(struct amdgpu_device *adev)
 
 	cmd = acquire_psp_cmd_buf(psp);
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-	memcpy(psp->fw_pri_buf, psp->rl.start_addr, psp->rl.size_bytes);
+	ret = psp_copy_fw(psp, psp->rl.start_addr, psp->rl.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	cmd->cmd_id = GFX_CMD_ID_LOAD_IP_FW;
 	cmd->cmd.cmd_load_ip_fw.fw_phy_addr_lo = lower_32_bits(psp->fw_pri_mc_addr);
@@ -1383,8 +1390,12 @@ int psp_ta_load(struct psp_context *psp, struct ta_context *context)
 
 	cmd = acquire_psp_cmd_buf(psp);
 
-	psp_copy_fw(psp, context->bin_desc.start_addr,
-		    context->bin_desc.size_bytes);
+	ret = psp_copy_fw(psp, context->bin_desc.start_addr,
+			  context->bin_desc.size_bytes);
+	if (ret) {
+		release_psp_cmd_buf(psp);
+		return ret;
+	}
 
 	if (amdgpu_virt_xgmi_migrate_enabled(psp->adev) &&
 		context->mem_context.shared_bo)
@@ -4154,17 +4165,24 @@ static ssize_t psp_usbc_pd_fw_sysfs_write(struct device *dev,
 	return count;
 }
 
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size)
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size)
 {
 	int idx;
 
 	if (!drm_dev_enter(adev_to_drm(psp->adev), &idx))
-		return;
+		return -ENODEV;
+
+	if (!bin_size || bin_size > PSP_1_MEG) {
+		dev_err(psp->adev->dev, "PSP firmware is invalid\n");
+		drm_dev_exit(idx);
+		return -EINVAL;
+	}
 
 	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
 	memcpy(psp->fw_pri_buf, start_addr, bin_size);
 
 	drm_dev_exit(idx);
+	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index 237b624aa51ca..c3a5940e311aa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -605,7 +605,7 @@ int psp_get_fw_attestation_records_addr(struct psp_context *psp,
 int psp_update_fw_reservation(struct psp_context *psp);
 int psp_load_fw_list(struct psp_context *psp,
 		     struct amdgpu_firmware_info **ucode_list, int ucode_count);
-void psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
+int psp_copy_fw(struct psp_context *psp, uint8_t *start_addr, uint32_t bin_size);
 
 int psp_spatial_partition(struct psp_context *psp, int mode);
 int psp_memory_partition(struct psp_context *psp, int mode);
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
index 27d883fda5fa9..6f131f4b81134 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -217,7 +217,9 @@ static int psp_v11_0_bootloader_load_component(struct psp_context  	*psp,
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -263,7 +265,9 @@ static int psp_v11_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
index 4c6450d62299a..80ba57cce3916 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -87,7 +87,9 @@ static int psp_v12_0_bootloader_load_sysdrv(struct psp_context *psp)
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	ret = psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -123,7 +125,9 @@ static int psp_v12_0_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index af4a7d7c4abd8..8100930e47eb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -265,10 +265,9 @@ static int psp_v13_0_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
@@ -347,10 +346,9 @@ static int psp_v13_0_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
index 5f39a2edcc956..3d5e26b3fa00a 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
@@ -105,10 +105,9 @@ static int psp_v13_0_4_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
@@ -168,10 +167,9 @@ static int psp_v13_0_4_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
index 38dfc5c19f2a7..040a61aefa866 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -140,10 +140,9 @@ static int psp_v14_0_bootloader_load_component(struct psp_context  	*psp,
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy PSP KDB binary to memory */
-	memcpy(psp->fw_pri_buf, bin_desc->start_addr, bin_desc->size_bytes);
+	ret = psp_copy_fw(psp, bin_desc->start_addr, bin_desc->size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP KDB to bootloader */
 	WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_36,
@@ -214,10 +213,9 @@ static int psp_v14_0_bootloader_load_sos(struct psp_context *psp)
 	if (ret)
 		return ret;
 
-	memset(psp->fw_pri_buf, 0, PSP_1_MEG);
-
-	/* Copy Secure OS binary to PSP memory */
-	memcpy(psp->fw_pri_buf, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_36,
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
index 833830bc3e2e3..409f097f4c524 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v3_1.c
@@ -96,7 +96,9 @@ static int psp_v3_1_bootloader_load_sysdrv(struct psp_context *psp)
 		return ret;
 
 	/* Copy PSP System Driver binary to memory */
-	psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	ret = psp_copy_fw(psp, psp->sys.start_addr, psp->sys.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the sys driver to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
@@ -135,7 +137,9 @@ static int psp_v3_1_bootloader_load_sos(struct psp_context *psp)
 		return ret;
 
 	/* Copy Secure OS binary to PSP memory */
-	psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	ret = psp_copy_fw(psp, psp->sos.start_addr, psp->sos.size_bytes);
+	if (ret)
+		return ret;
 
 	/* Provide the PSP secure OS to bootloader */
 	WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_36,
-- 
2.53.0

