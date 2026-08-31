Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D0430CE2;
	Mon, 31 Aug 2026 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183228; cv=none; b=U8MkxdHMhW19W4DnDPs7+PN86weW/HYhZHeBYhuKVmFaGLnTHXuZzSh/2tMtIWAR6APGK6riWulfKDgh6HfkhqlgowL6tiSN2xqaW/B+mj49QKpha6+q7mjvqlTghLZftC80Hmv0Bwc6Bgr5HXmte5RgBrFGLN6t291TcDh2Ksg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183228; c=relaxed/simple;
	bh=quJOMTBW9ktBoQlH5FST6viD+tspK9PxgqKvdSjcdTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKpsgH2NkgH3xhYJfX+HN2JeTEZxsiVvdKIPeQAu6avNSzPzECLFAxWMlYNBlFPLmyBSFbJmXbOMFd+jQQ/fn9We0tm3+WaOrMp45P57uvgAPdGxNG+jjANCIcruGEltPM5MXPvGgr90u0RnTuGHPxaFEIpOw2SgKvs0Rdx2oWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTCgVfMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTCgVfMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCBD1F00A3F;
	Mon, 31 Aug 2026 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183225;
	bh=7XE0qIhiBUqZOs40ocefX7K8S4wpxgfYOn/qG3B+V3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTCgVfMMWMQVEzk2RJsBs9JGWVMXooB0G3KSqgSKHHx5QoY/9Dp8TANv+xUyZrvFD
	 fq63sUQY+j/bV/+Cq96CqtXNsNV14ydcOnBenj+T7XxjGV0vq2R6wqpTWNItubeuH6
	 +PlUIspAqojv0jWsl5R4Ba8BHP58/B518E80nlKbVCBLhZXbE/Vmc0QBotak7VvtiL
	 asZHWSsjMA/RaJk5kJZzxwldQ9vTfW8XzK/DFwD8jRyk5vXOBr++BtLYAGiMGKN2Fw
	 p6mOGGicLvPDFuWL6N6j4bobSP4UwyDBzO+icqVuoptawTqwaGHWgqYiwpS7tkOQIK
	 AQQDRAkszLOKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vamsi Attunuru <vattunuru@marvell.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] vdpa/octeon_ep: Use 4 bytes for mailbox signature
Date: Mon, 31 Aug 2026 09:20:48 -0400
Message-ID: <20260831133314.4125787-20-sashal@kernel.org>
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

From: Vamsi Attunuru <vattunuru@marvell.com>

[ Upstream commit d42eadf7969e2217fceb84317d3fd28a7bdbd96e ]

The upper 4 bytes are reserved by the firmware for
storing meta data. Use only lower 4 bytes to update
the signature details.

Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260224095226.1001151-3-schalla@marvell.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `vdpa/octeon_ep: Use 4 bytes for mailbox
signature`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, `git describe
HEAD` → `v6.18.44`)
**Upstream commit:** `d42eadf7969e2217fceb84317d3fd28a7bdbd96e` (not yet
in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[vdpa/octeon_ep]` `[Use]` — driver correctness fix for
mailbox signature access width.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>`
- `Signed-off-by: Michael S. Tsirkin <mst@redhat.com>` (vhost/vDPA
  maintainer)
- `Message-ID: <20260224095226.1001151-3-schalla@marvell.com>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Cc: stable@vger.kernel.org`, or `Link:` tags.

Notable: maintainer sign-off from Michael S. Tsirkin; part of a 4-patch
series (`[PATCH 2/4]`).

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Driver uses 64-bit `readq`/`writeq` on a mailbox signature
  register; firmware reserves the upper 4 bytes for metadata.
- **Symptom:** Incorrect signature read/write corrupts firmware metadata
  or prevents signature match.
- **Root cause:** Access width mismatch with hardware/firmware register
  layout.
- **Version info:** None in commit message.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — despite no "fix" in the subject, this is a hardware-
interface bug fix disguised as a register-width correction. Not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/vdpa/octeon_ep/octep_vdpa_main.c` (+3/−3 lines, 6
  lines touched)
- **Functions:** `get_device_ready_status()`, `octep_sriov_enable()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Changes

**Hunk 1 — `get_device_ready_status()` (VF path):**
- **Before:** `readq()` reads 64 bits; compares to
  `OCTEP_DEV_READY_SIGNATURE` (0xBABABABA); clears with `writeq(0)`.
- **After:** `readl()` reads lower 32 bits only; clears with
  `writel(0)`.
- **Path:** VF BAR-init polling loop in `octep_vdpa_setup_task()`.

**Hunk 2 — `octep_sriov_enable()` (PF path):**
- **Before:** `writeq(OCTEP_DEV_READY_SIGNATURE, ...)` writes 64 bits
  per VF.
- **After:** `writel(OCTEP_DEV_READY_SIGNATURE, ...)` writes lower 32
  bits only.
- **Path:** SR-IOV enable when all VFs are assigned bar space.

### Step 2.3: Bug Mechanism
**Record:** **Hardware interface / logic correctness bug**
- `OCTEP_DEV_READY_SIGNATURE` is `0xBABABABA` (32-bit, in
  `octep_vdpa.h`).
- If firmware places metadata in upper 32 bits:
  - `readq()` returns a value ≠ `0xBABABABA` → ready check never
    succeeds.
  - `writeq()` overwrites/clears upper 32 bits → firmware metadata
    corruption.
- Rest of mailbox code in `octep_vdpa_hw.c` already uses 32-bit
  `ioread32`/`iowrite32`.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct and minimal.
- Matches existing 32-bit mailbox access patterns in the same driver.
- **Regression risk:** Very low — only narrows access to the documented
  32-bit signature field.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy `readq`/`writeq` in `get_device_ready_status()` introduced in
  `8b6c724cdab85` (Jun 14, 2024) — initial driver commit.
- Buggy `writeq` in `octep_sriov_enable()` same commit; address
  calculation around it fixed later in `54556d5394382`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by `8b6c724cdab85`
("virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices"), which is
present in this tree.

### Step 3.3: Related File History
**Record:** Recent `drivers/vdpa/octeon_ep/` history in 6.18.y:
1. `54556d5394382` — Fix PF->VF mailbox data address calculation (series
   patch 1/4, already backported)
2. `3ef0cfa77a3d5` — fix IRQ-to-ring mapping (series patch 4/4, already
   backported)
3. `8716a841d1da4` — refcount leak fix

Patches 2/4 (this commit) and 3/4 (event handling) are **not** in 6.18.y
yet.

### Step 3.4: Author Context
**Record:** Vamsi Attunuru (Marvell). Michael S. Tsirkin committed.
Srujana Challa submitted the series. Active contributors to this driver.

### Step 3.5: Dependencies
**Record:**
- Part of 4-patch series, but **this patch is standalone** — only
  changes access width.
- Prerequisite patch 1 (`54556d5394382`, mailbox address calc) is
  already in 6.18.y.
- Does **not** require patch 3/4 (event handling — separate feature).
- `git apply --check` against current tree: **applies cleanly**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c d42eadf7969e2`:
  https://patch.msgid.link/20260224095226.1001151-3-schalla@marvell.com
- Series: v1, 4 patches from Srujana Challa, Feb 24, 2026.
- No reviewer replies or stable nominations found in saved mbox for this
  specific patch.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd: `virtualization@lists.linux.dev`,
`mst@redhat.com`, `jasowang@redhat.com`, Marvell developers. No explicit
`Reviewed-by` in thread.

### Step 4.3: Bug Reports
**Record:** N/A — no external bug report links. Bug inferred from
firmware register layout and code analysis.

### Step 4.4: Related Patches
**Record:** 4-patch series:
1. Fix PF->VF mailbox address — **in 6.18.y**
2. Use 4 bytes for mailbox signature — **this commit**
3. Add vDPA device event handling — not in 6.18.y (new functionality)
4. fix IRQ-to-ring mapping — **in 6.18.y**

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch. Two
other patches from the same series were already backported to 6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `get_device_ready_status()`, `octep_sriov_enable()`

### Step 5.2: Callers
**Record:**
- `get_device_ready_status()` ← `octep_vdpa_setup_task()` (work item,
  polls up to 5s during VF init)
- `octep_sriov_enable()` ← `octep_vdpa_sriov_configure()` ← sysfs SR-IOV
  interface (`echo N > sriov_numvfs`)

### Step 5.3: Callees
**Record:** `readl`/`writel`/`readq` (unchanged for `OCTEP_EPF_RINFO`),
PCI SR-IOV helpers.

### Step 5.4: Reachability
**Record:**
- VF init path: triggered when Octeon DPU VF probes with
  `CONFIG_OCTEONEP_VDPA=m`.
- PF SR-IOV path: triggered by admin enabling VFs.
- Requires Marvell Octeon DPU hardware/emulation; not universal, but
  reachable on deployed systems using this driver.

### Step 5.5: Similar Patterns
**Record:** `octep_vdpa_hw.c` mailbox protocol consistently uses 32-bit
`ioread32`/`iowrite32`. Only the signature handshake incorrectly used
64-bit access.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current tree at
`drivers/vdpa/octeon_ep/octep_vdpa_main.c`:
- Line 585: `u64 signature = readq(...)`
- Line 588: `writeq(0, ...)`
- Line 760: `writeq(OCTEP_DEV_READY_SIGNATURE, ...)`

Driver present since `8b6c724cdab85` (Jul 2024). Bug present since
driver introduction.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** Series patches 1 and 4 already backported. This specific fix
is **not** present. No alternate fix for the access-width bug.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/vdpa/octeon_ep/` — vDPA driver for Marvell Octeon
DPU. **Criticality: PERIPHERAL** (hardware-specific, module-only:
`CONFIG_OCTEONEP_VDPA`).

### Step 7.2: Activity
**Record:** Actively maintained; multiple fixes backported to 6.18.y in
2026 from the same patch series.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Marvell Octeon DPU devices with the `octep_vdpa`
module (enterprise DPU / SmartNIC deployments). Config-specific, not
universal.

### Step 8.2: Trigger Conditions
**Record:**
- Every VF probe runs the signature poll loop.
- Every SR-IOV enable writes the ready signature.
- Trigger is deterministic when firmware uses upper 32 bits for metadata
  (as documented in commit message).
- Requires root/admin for SR-IOV; VF init happens automatically on
  probe.

### Step 8.3: Failure Mode
**Record:**
- **VF init failure:** 5-second timeout, `"BAR initialization is timed
  out"` — vDPA device never comes up. **Severity: HIGH** for affected
  hardware.
- **Firmware metadata corruption:** `writeq` clobbers upper 32 bits.
  **Severity: HIGH** (undefined firmware behavior).
- Not a generic kernel crash, but complete functional breakage on
  affected hardware.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for Octeon DPU users — restores working VF init and
  correct firmware handshake.
- **Risk:** VERY LOW — 6-line change, obviously correct, matches driver
  conventions.
- **Ratio:** Strong benefit for affected users, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware-interface bug present since driver introduction
- Causes VF initialization failure and potential firmware metadata
  corruption
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.y
- Prerequisite from same series already backported
- Other fixes from same series already in 6.18.y
- Consistent with existing 32-bit mailbox access in the driver
- vDPA maintainer sign-off

**AGAINST backport:**
- Hardware-specific; affects niche Marvell Octeon DPU deployments only
- No syzbot report or user bug report attached
- Patch 3/4 (event handling) not backported — but this patch does not
  depend on it

**Unresolved:** No runtime test evidence or user bug reports in mailing
list thread.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logically correct;
   maintainer SOB; no Tested-by but change is trivial.
2. Fixes a real bug? **PASS** — 64-bit access violates firmware register
   layout.
3. Important issue? **PASS** — device init failure on affected hardware
   (HIGH for those users).
4. Small and contained? **PASS** — 6 lines, 1 file.
5. No new features or APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — clean apply verified; buggy code
   confirmed present.

### Step 9.3: Exception Categories
**Record:** Hardware workaround / driver correctness fix for existing
hardware — qualifies under stable exception for hardware-specific fixes.

### Step 9.4: Decision Rationale

This commit fixes a genuine firmware handshake bug in the Marvell Octeon
vDPA driver that has been present since the driver landed in 6.18.y.
Using 64-bit accesses on a register where only the lower 32 bits hold
the signature can prevent VF ready detection (leading to init timeout)
and corrupt firmware metadata in the upper 32 bits. The fix is minimal,
matches the driver's existing 32-bit mailbox conventions, applies
cleanly, and two other patches from the same series are already in
6.18.y — indicating this driver is actively maintained in stable. For
Octeon DPU users on 6.18.y, this is an important functional fix with
negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed commit `d42eadf7969e2` message and tags from `git
  show`
- **[Phase 2]** Diff analysis: 3 `readq`/`writeq` → `readl`/`writel`
  changes in 2 functions
- **[Phase 3]** `git blame`: buggy code from `8b6c724cdab85`
  (2024-06-14)
- **[Phase 3]** `git log stable/linux-6.18.y --
  drivers/vdpa/octeon_ep/`: patches 1 and 4 of series already present;
  this fix absent
- **[Phase 3]** `git merge-base --is-ancestor`: driver and prerequisite
  patch 1 confirmed in tree
- **[Phase 3]** `git apply --check`: patch applies cleanly
- **[Phase 4]** `b4 dig -c d42eadf7969e2`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 series, 4 patches identified
- **[Phase 4]** `b4 dig -w`: maintainers CC'd (mst, jasowang)
- **[Phase 4]** mbox saved to `/tmp/octeon_mbox_thread.mbox`: no stable
  nomination or NAKs found
- **[Phase 5]** `grep` call chain: `get_device_ready_status` ←
  `octep_vdpa_setup_task`; `octep_sriov_enable` ←
  `octep_vdpa_sriov_configure`
- **[Phase 5]** `octep_vdpa_hw.c`: confirmed 32-bit mailbox access
  pattern elsewhere
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read current `octep_vdpa_main.c` lines 583-593, 758-761:
  buggy `readq`/`writeq` confirmed present
- **[Phase 6]** `git log master`: commit exists on master, not on stable
  branch
- **[Phase 7]** Kconfig: `CONFIG_OCTEONEP_VDPA` module for Marvell
  Octeon DPU
- **[Phase 8]** Read timeout path at line 631-633: failure produces
  `"BAR initialization is timed out"`

**YES**

 drivers/vdpa/octeon_ep/octep_vdpa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_main.c b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
index df8af6c1454cc..9aac6dbdaf3aa 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -582,10 +582,10 @@ static const struct vdpa_mgmtdev_ops octep_vdpa_mgmt_dev_ops = {
 
 static bool get_device_ready_status(u8 __iomem *addr)
 {
-	u64 signature = readq(addr + OCTEP_VF_MBOX_DATA(0));
+	u32 signature = readl(addr + OCTEP_VF_MBOX_DATA(0));
 
 	if (signature == OCTEP_DEV_READY_SIGNATURE) {
-		writeq(0, addr + OCTEP_VF_MBOX_DATA(0));
+		writel(0, addr + OCTEP_VF_MBOX_DATA(0));
 		return true;
 	}
 
@@ -757,7 +757,7 @@ static int octep_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	rpvf = FIELD_GET(GENMASK_ULL(35, 32), val);
 	if (done) {
 		for (i = 0; i < pf->enabled_vfs; i++)
-			writeq(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
+			writel(OCTEP_DEV_READY_SIGNATURE, addr + OCTEP_PF_MBOX_DATA(i * rpvf));
 	}
 
 	return num_vfs;
-- 
2.53.0

