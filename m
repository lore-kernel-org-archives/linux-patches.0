Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3245BD5E4;
	Mon, 19 Oct 2026 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418463; cv=none; b=A0DqZI3AKuHVav4idiHuTJCe4rG8CWgTEvDI3tv+gOiNdi3rlQ/5HHq+VvQ9Q1E8+7Im72t20t9TQ7HIsTdytpFBF8Zh6qSicBbtPhUiihUV7Ez2E4bacJKWJJZ5LbmrWiZQiRDFiC4iHCgkwmfhGN1pIBMMbgSnn58UbrChsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418463; c=relaxed/simple;
	bh=deT57D3GLwt4S+n6hCnJBg4KXACI1DwTDzdzSA4/KdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLEqxgKo1bZh9Qc+VBKfhNUa9H5IALVms65VsCWur+P00tsQ+yhyTUFVyYHCuG5kWDCVYHoy4g1cv+toHuahHpfjzgM9XyuI8s4qWHmmKSWLG3XcCSAaquTAfSeMh2vslrGt7ou6ekv+35ihZ9aPLIcbswRvtU0xyuEXqHyFeMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idp/LB3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idp/LB3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7B61F000C8;
	Mon, 19 Oct 2026 14:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418461;
	bh=MynhFGxmAm7DOXMHr+uwe12ATUwwoeN4u/MR/YhK6W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idp/LB3pj6ERZ5j5oOLxDB8YLosRv4EJj9EHScHyuDU7FEk4y7KZMkzeFZLVyevv8
	 8iPOCUH400QKJKGZThFElawbYU5D+dA6nDu9YeB+yG2XJn0Vg7NhPUkK6AERF6zHkW
	 2tpDQTxGXW8HCUxYd39vzpMNr312QHQUB+Fk2ICCNYzyfzonykrBan8LR6FhSHjVX8
	 b5MWmx6ZouOFPbuOd1tGKlJVPOpKAyvAfpvGXL1LfgTmueqcu5w+HnTekBvt4d6H8R
	 3JjToP69lIVELY2mBjyS+GAAxnKWMsE+JQQFXnlgKbB173ancuwVly5SypXRVKcpFH
	 4nMNUPX5hfZ1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] vdpa: octeon_ep: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:49:16 -0400
Message-ID: <20261019135441.1420968-265-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 346da62d9f9ccca81cf279c361137d1fe2fe0c7f ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260705002546.85004-1-pengpeng@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The one-line
`MODULE_DEVICE_TABLE()` addition belongs here: the Octeon vDPA PCI IDs
already exist, but they are not published for autoload.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[vdpa/octeon_ep] [add] [export the existing PCI match table
via MODULE_DEVICE_TABLE so userspace can autoload the module]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Verified from mainline `346da62d9f9cc` (`git log -1 --format=fuller`):

- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Michael S. Tsirkin <mst@redhat.com>` (virtio/vDPA
  maintainer; applied the patch)
- `Message-ID: <20260705002546.85004-1-pengpeng@iscas.ac.cn>`

No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Link:`, or `Cc: stable`. Absence of `Fixes:` / `Cc: stable` is expected
for this review and is not a negative.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `octep_pci_vdpa_map[]` is wired to `octep_pci_vdpa.id_table`,
  but is not exported with `MODULE_DEVICE_TABLE()`.
- **Symptom:** `depmod`/`modpost` do not emit `pci:v0000177Dd0000...`
  aliases, so udev/kmod will not autoload `octep_vdpa` when the
  Cavium/Marvell DPU appears.
- **Version info:** none in the message. Driver introduced in this tree
  by `8b6c724cdab85` (in v6.11; present in v6.12).
- **Root cause:** missing module-alias publication, not a runtime logic
  error.

The “source-level fix / no dynamic hardware reproduction” paragraph is
in the original lore submission (not a stable-prep marker). MST asked
what it meant, then applied the patch unchanged.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** It is an explicit autoload/hardware-binding
fix, same class as adding PCI IDs.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/vdpa/octeon_ep/octep_vdpa_main.c` (**+1 / -0**)
- Function/object: `octep_pci_vdpa_map[]` (table definition; no function
  body change)
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** PCI IDs exist and are used for bind **if the module is
  already loaded**. No `MODULE_DEVICE_TABLE`, so no `modules.alias`
  entries.
- **After:** Same IDs plus `MODULE_DEVICE_TABLE(pci,
  octep_pci_vdpa_map)`, which creates the
  `__mod_pci__octep_pci_vdpa_map_device_table` alias consumed by
  `scripts/mod/file2alias.c` (`do_pci_entry()`).
- Path: **module build / autoload**, not probe/error/init runtime logic.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware enablement / missing device-ID publication]**
Mechanism: `MODULE_DEVICE_TABLE` is empty when `!MODULE`
(`include/linux/module.h`). This driver is **module-only** (`depends on
m`), so the missing export is always the live path. Sibling vDPA PCI
drivers already have it (`ifcvf_main.c`, `snet_main.c`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct, one standard line, no API/locking/refcount
change.** Regression risk is **very low**. MST applied it to mainline.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Table and `pci_driver` come from **`8b6c724cdab85`** (`virtio:
vdpa: vDPA driver for Marvell OCTEON DPU devices`, Srujana Challa,
2024-06-14; committed 2024-07-09). **Never had `MODULE_DEVICE_TABLE`.**
Present since v6.11.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** Buggy omission is the original driver
commit above. `git merge-base --is-ancestor 8b6c724cdab85 HEAD` →
**yes**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (this tree, `-- drivers/vdpa/octeon_ep/octep_vdpa_main.c`):
- `b3175ec5209b8` mailbox signature
- `6e950ebc7da41` PF→VF mailbox address
- `f655550322469` SR-IOV refcount leak
- `8b6c724cdab85` driver introduction

No later commit in this tree adds `MODULE_DEVICE_TABLE`. Standalone; not
patch X/Y.

**Step 3.4: CHECK THE AUTHOR’S OTHER COMMITS**
Record: Pengpeng Hou submitted a July 2026 batch of the same one-line
fix. Same pattern already **in this 6.12 tree**: `877e99535dfb9` `can:
ctucanfd: add missing MODULE_DEVICE_TABLE()` (upstream `d937bdb244a75`,
with `Cc: stable`). Mainline also has `7eeda5e248727` `vdpa: alibaba:
add missing MODULE_DEVICE_TABLE()`. Author is not the vDPA maintainer;
MST took the octeon_ep patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses existing table name and `MODULE_DEVICE_TABLE()`.
`git show 346da62d9f9cc | git apply --check` → **CLEAN APPLY**. Later
mainline commits (`3e4cddec63db5`, `6519ca235131c`) do not touch this
site.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 346da62d9f9cc` →
  https://patch.msgid.link/20260705002546.85004-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-07-05)
- Thread: author patch + MST reply (“what does this paragraph mean?”
  about the source-level boilerplate). **No NAK, no stable request, no
  risk flags.** Applied 2026-08-19.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Marvell reviewers
`schalla@marvell.com`, `vattunuru@marvell.com`; MST; Jason Wang; Xuan
Zhuo; Eugenio Pérez; `virtualization@lists.linux.dev`. **Subsystem
maintainer applied it.**

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot/bugzilla report.** Evidence is the match table
vs missing export. Same class as PCI ID additions.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-day one-line series (cadence PCI, tegra CEC, ixp4xx,
most_usb, imx8qxp, ctucanfd, alibaba vdpa, this driver). Each is self-
contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No octeon_ep-specific stable-list hit for this subject. Lore
HTTP fetch returned 403; search did not show a prior reject. Related
ctucanfd patch **did** go to this 6.12 tree with `Cc: stable`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body change. Objects: `octep_pci_vdpa_map`,
`octep_pci_vdpa`, `octep_vdpa_probe`.

**Step 5.2: TRACE CALLERS**
Record: `octep_vdpa_probe` is only the PCI `.probe` callback
(`module_pci_driver`). Invoked by PCI core on match **after** the module
is loaded. Callers of the *new* macro are `modpost`/`file2alias.c` at
build time.

**Step 5.3: TRACE CALLEES**
Record: Probe dispatches to `octep_vdpa_probe_vf` /
`octep_vdpa_probe_pf`. Unchanged.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: PCI enumeration of Cavium IDs
0xb900/0xb903/0xba00/0xba03/0xbd00/0xbd03 (`PCI_VENDOR_ID_CAVIUM`
0x177d). Userspace-visible via hotplug/boot. Autoload is the intended
udev path. Manual `modprobe octep_vdpa` still works without the patch.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: In-tree vDPA PCI drivers already export tables (`ifcvf`,
`snet`). This driver was the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/vdpa/octeon_ep/octep_vdpa_main.c:841-857` has
the table and `.id_table` and **no** `MODULE_DEVICE_TABLE`. Introduced
**v6.11**, present in this **6.12.111** checkout. `git merge-base --is-
ancestor 346da62d9f9cc HEAD` → **not in HEAD**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding lines match. No refactor of the
table.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: **No.** `git log --grep=MODULE_DEVICE_TABLE -- drivers/vdpa/` is
empty. Same-class ctucanfd fix is already in this tree, which shows the
pattern is accepted here.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drivers/vdpa/octeon_ep — Marvell Octeon DPU vDPA] [PERIPHERAL
/ IMPORTANT for that hardware]**
Not core mm/VFS. Real PCI devices; Kconfig is supported (MAINTAINERS:
MARVELL OCTEON ENDPOINT VIRTIO DATA PATH ACCELERATOR).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Driver is young (2024) but present for the life of 6.12. Modest
churn; mailbox/SR-IOV fixes already in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-/hardware-specific** — hosts with Marvell/Cavium CN10x
DPU vDPA (`CONFIG_OCTEONEP_VDPA=m`). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Trigger is **every boot/hotplug** of those PCI devices if the
module is not preloaded. Unprivileged users do not trigger a crash; they
just get a **non-bound device**. Kconfig `depends on m` means there is
**no built-in fallback**.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure mode: module does not autoload; vDPA offload does not
come up until manual modprobe.** **Severity: MEDIUM** (hardware non-
function, not oops/corruption). Same user-visible class as missing PCI
IDs.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for Octeon DPU users (driver actually attaches on
  device appearance).
- **Risk:** very low (one `MODULE_DEVICE_TABLE` line, no runtime
  change).
- **Ratio:** **favorable.** Official rule: *“It must either fix a real
  bug that bothers people or just add a device ID.”*

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real autoload bug: IDs exist, aliases are not generated.
- Module-only driver (`depends on m`) — autoload is the normal load
  path.
- +1 line, standard macro, clean apply on 6.12.111.
- Same omission since driver introduction (in this tree).
- Sibling vDPA PCI drivers already export tables.
- Virtio maintainer applied it upstream.
- Same-class patch already in this 6.12 tree (`can: ctucanfd`).
- Matches the documented device-ID exception.

**AGAINST:**
- Not a crash/UAF/security issue.
- Niche DPU hardware; no distro bug report.
- Manual `modprobe` is a workaround.
- Kconfig notes firmware/emulation must be running first (PCI presence
  still implies the device is enumerable).

**UNRESOLVED:** Direct lore.kernel.org HTTP was 403; thread recovered
via `b4 dig` mbox. No stable-list discussion found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one-line, maintainer-
   applied.
2. Fixes a real bug that affects users? **PASS** — broken autoload for
   existing PCI IDs.
3. Important issue? **PASS** under the **device-ID / hardware-
   enablement** exception (not a crash).
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes IDs the driver already
   matches.
6. Can apply to the local tree? **PASS** — buggy code present; `git
   apply --check` clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Device ID / module-alias publication for an existing driver**
(stable-rules “or just add a device ID”).

**Step 9.4: MAKE YOUR DECISION**
Backport. The local 6.12 tree has the driver without aliases; the fix is
the documented, low-risk hardware-enablement class.

---

### What the commit solves for this tree

On 6.12, `octep_vdpa` can bind only if something already loaded it. The
PCI table is complete; `MODULE_DEVICE_TABLE` is missing, so udev never
loads `octep_vdpa` for CN103K/CN105K/CN106K PF/VF IDs. Adding the macro
generates aliases at module build time and does not change probe logic.

### Risk vs benefit

Benefit is that those DPUs attach on boot/hotplug. Risk is negligible.
This is the same pattern already taken for `ctucanfd` in this tree.

### Concerns

None that block backport: no prerequisites, no conflicts, no new API. No
`Fixes:`/`Cc: stable` on the original, which is why it needs this
review.

---

### Verification
- **[Phase 1]** `git log -1 --format=fuller 346da62d9f9cc`: SOB Pengpeng
  Hou + MST; Message-ID as given; no Fixes/Cc stable/Reported-by.
- **[Phase 1]** `git describe HEAD` / `make kernelversion` / Makefile:
  **pending-6.12, 6.12.111**.
- **[Phase 2]** Diff is +1 `MODULE_DEVICE_TABLE(pci,
  octep_pci_vdpa_map)` after the ID table.
- **[Phase 2]** `include/linux/module.h:251-256`: macro emits the alias
  only for `MODULE`.
- **[Phase 2]** `scripts/mod/file2alias.c:441-459`: `do_pci_entry()`
  builds `pci:vNdN...` aliases.
- **[Phase 2]** `drivers/vdpa/Kconfig:133-142`: `OCTEONEP_VDPA` is
  `tristate` **`depends on m`**.
- **[Phase 3]** `git blame -L 841,863`: table from `8b6c724cdab85`;
  never had MODULE_DEVICE_TABLE.
- **[Phase 3]** `git merge-base --is-ancestor 8b6c724cdab85 HEAD` → yes;
  vs v6.11 and v6.12 → in both.
- **[Phase 3]** `git merge-base --is-ancestor 346da62d9f9cc HEAD` →
  **not in this tree**.
- **[Phase 3]** `git log --oneline -20 --
  drivers/vdpa/octeon_ep/octep_vdpa_main.c`: four commits; none add the
  macro.
- **[Phase 3]** `git show 346da62d9f9cc | git apply --check` → **CLEAN
  APPLY**.
- **[Phase 3]** `877e99535dfb9` in this tree: same-author
  MODULE_DEVICE_TABLE pattern already backported.
- **[Phase 4]** `b4 dig -c 346da62d9f9cc`: lore URL; v1 only; recipients
  include MST and Marvell; MST question only, then apply.
- **[Phase 4]** `/tmp/octep_mdt.mbox`: 2 messages; no NAK.
- **[Phase 4]** lore.kernel.org/stable search: no octeon_ep discussion
  found (lore HTTP 403 on direct fetch).
- **[Phase 5]** `grep octep_vdpa_probe`: only PCI `.probe` in this file.
- **[Phase 5]** `ifcvf`/`snet` already have `MODULE_DEVICE_TABLE(pci,
  ...)`.
- **[Phase 6]** Current file lines 841–863: table + driver, **no**
  MODULE_DEVICE_TABLE.
- **[Phase 6]** Later origin/master commits do not touch this hunk.
- **[Phase 7]** MAINTAINERS: `drivers/vdpa/octeon_ep/` listed; reviewers
  schalla/vattunuru.
- **[Phase 8]** IDs in `octep_vdpa.h`:
  0xb900/0xb903/0xba00/0xba03/0xbd00/0xbd03; vendor
  `PCI_VENDOR_ID_CAVIUM` 0x177d.
- **[Phase 9]** `Documentation/process/stable-kernel-rules.rst:15`: “fix
  a real bug … **or just add a device ID**”.
- **UNVERIFIED:** Live udev/hardware reproduction (author did not claim
  it; source-level evidence is sufficient). Direct lore.kernel.org page
  fetch (403); thread recovered via b4.

**YES**

 drivers/vdpa/octeon_ep/octep_vdpa_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/octeon_ep/octep_vdpa_main.c b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
index 9aac6dbdaf3aa..e5dbabff5e81b 100644
--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -898,6 +898,7 @@ static struct pci_device_id octep_pci_vdpa_map[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_VDPA_DEVID_CN103K_VF) },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(pci, octep_pci_vdpa_map);
 
 static struct pci_driver octep_pci_vdpa = {
 	.name     = OCTEP_VDPA_DRIVER_NAME,
-- 
2.53.0

