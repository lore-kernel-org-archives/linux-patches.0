Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B545B79A5;
	Mon, 19 Oct 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418446; cv=none; b=MW3zXAK4j2948xJi1wHUY1SXyPllM+Nq3IugtEcepQj6G9gTjECvcIrNlVX++bbsfp4IQ7uzCN7e8t1asF4C/ybweCn0ThASQS3DwxNrlIh/D+l5uhTROLemf1hmODYWX1UszAfK38D45N4vi3ZYpvPxYU/OoTfh+8e2GSWYmRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418446; c=relaxed/simple;
	bh=ZUHMONK+uqOvaTNGBGkHS4RNvg6YiKVzJZK+BpVJy14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edDpTU+ye/ifzkL8dakxUFOhhzx2YjdLl3xoJlqW7CktPNuDqLaWN3fIHtfdG9/6BSlCEpnDEjw/pQMuCOiRtHaIROMiBZSjUO6zqgQu9GZ7UGmgUB0nV1MDhJCrDfH/JqtoDnu9O+g0J8OR/mublBXrXDansTwxWDsV3i/u4Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1joZ6bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1joZ6bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E911F000C9;
	Mon, 19 Oct 2026 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418444;
	bh=woDQFJcQQTqvpSJjN0218Yk/zCb6MZjy1tq5Gy92XUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1joZ6bxi0uo4YHfc1m4bLFR2bZZf/Hs6W3J3sogV9OWXzbYCibD5P04Y4CREyJvr
	 GNX0irBjDKd0ITF0E06PeMoyQ58h4Eld1J8r2oVmTf+tyMe9U6VfGonnB7Q+tTwWb8
	 yDlxWU1MbTW0ojoxK9M/5KOayBK3ExwuazYiTixohlgb22bDstPQ9gSfIPg6Oi5OdN
	 dYwJ3Mcdj77pQvDD6ZFAxSB/JXaUB8wP/m0aXKBhWFcPAwb04JOB6yyJHevXnbt66C
	 AQXeF+BkaGSJv+00nNgIr6HOMx/Dk+NraZ8nFtX2R/QBe9o0yzuJEUWEP+7YcBog8T
	 tmxytSV9L7FpQ==
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
Subject: [PATCH AUTOSEL 6.18-6.1] vdpa: alibaba: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:49:04 -0400
Message-ID: <20261019135441.1420968-253-sashal@kernel.org>
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

[ Upstream commit 7eeda5e2487276ed87960655fdae1c97d9779a0e ]

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
Message-ID: <20260704152732.55338-1-pengpeng@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[vdpa: alibaba:] [add] [missing MODULE_DEVICE_TABLE() so PCI
aliases are generated for autoload]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

From upstream commit `7eeda5e2487276ed87960655fdae1c97d9779a0e`
(verified with `git show`):

- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Michael S. Tsirkin <mst@redhat.com>` (virtio/vDPA
  maintainer)
- `Message-ID: <20260704152732.55338-1-pengpeng@iscas.ac.cn>`

No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`, no
`Acked-by:`, no `Cc: stable`, no `Link:` (besides Message-ID). Absence
of `Fixes:`/`Cc: stable` is expected for this review pipeline.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:

- Bug: `eni_pci_ids[]` is wired into `eni_vdpa_driver.id_table` but
  never exported via `MODULE_DEVICE_TABLE()`.
- Symptom: `modpost`/`file2alias` never emits `pci:v...d...` aliases, so
  depmod/udev will not autoload `alibaba-eni-vdpa` when the PCI device
  appears.
- Version info: none in the message. Driver itself dates to v5.16-rc1.
- Root cause: missing alias publication, not a runtime logic error.
  Author explicitly calls it a source-level fix (build-time module
  metadata).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an autoload/hardware-enablement
bug: the match table exists and is used for probe matching, but is not
published for module loading. Same pattern as device-ID publication.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:

- File: `drivers/vdpa/alibaba/eni_vdpa.c` (`+1` / `-0`)
- Function: none. Insert after `eni_pci_ids[]`, before
  `eni_vdpa_driver`.
- Scope: single-file, one-line surgical change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Before, `eni_pci_ids` is only referenced by `.id_table` (in-
kernel PCI matching after the module is already loaded). After,
`MODULE_DEVICE_TABLE(pci, eni_pci_ids)` also creates
`__mod_pci__eni_pci_ids_device_table`, which `scripts/mod/file2alias.c`
(`do_pci_entry`) turns into PCI aliases. No probe/remove/runtime path
changes. Built-in (`!MODULE`) the macro is a no-op
(`include/linux/module.h`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: Category **(h) hardware enablement / missing device-ID
publication**. Mechanism: without `MODULE_DEVICE_TABLE`, udev never
loads the module on device discovery. Sibling PCI vDPA drivers (`ifcvf`,
`snet`) already export their tables.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct; matches the established PCI-driver pattern.
Minimal. Regression risk is negligible: no locks, no APIs, no data-
structure changes, no runtime control-flow change. `linux/module.h` is
already included (line 12).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: `git blame -L 540,560` shows the ID table and `pci_driver` come
entirely from `e85087beedcae` (“eni_vdpa: add vDPA driver for Alibaba
ENI”, Wu Zongyong, 2021-10-29). Contained in `v5.16-rc1`. Present and
unchanged in this tree. Bug has existed for the entire life of the
driver.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commit is `e85087beedcae`. `git
merge-base --is-ancestor e85087beedcae HEAD` succeeded. No later commit
in this tree added `MODULE_DEVICE_TABLE` for this driver.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent history is `e85087beedcae` → probe simplify → vDPA API
updates → probe error-path fix → `get_vq_size`. None of those touch the
PCI ID table. Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou is not the vDPA maintainer. Same day they sent an
identical `MODULE_DEVICE_TABLE` fix for `can: ctucanfd`, which **is
already in this 6.12 tree** as `877e99535dfb9` (`Cc: stable@kernel.org`,
`Fixes:`, Greg KH). Maintainer of this driver is Michael S. Tsirkin, who
applied the vDPA patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No new helpers or structs. `MODULE_DEVICE_TABLE` has existed for
decades. Applies standalone. `git show
7eeda5e2487276ed87960655fdae1c97d9779a0e | git apply --check` succeeded
(exit 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:

- `b4 dig -c 7eeda5e2487276ed87960655fdae1c97d9779a0e` →
  https://patch.msgid.link/20260704152732.55338-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: single revision (v1 only).
- Thread (saved mbox): MST replied the same day asking what the “source-
  level fix” boilerplate paragraph meant. No NAK, no requested code
  change. He later SOB’d and applied it (CommitDate 2026-08-19). No
  reviewer asked for `Cc: stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc were Michael S. Tsirkin, Jason Wang, Xuan
Zhuo, Eugenio Pérez, `virtualization@lists.linux.dev`, `linux-
kernel@vger.kernel.org`. Right maintainers. Only MST replied.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No `Reported-by`, no bugzilla/syzbot. Author found it by
inspecting the driver-owned match table vs missing alias export. No
evidence of a live user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Same-day batch of missing-`MODULE_DEVICE_TABLE` patches
(ctucanfd, octeon_ep vDPA, cadence PCI, this one). ctucanfd already
landed in this stable tree. octeon_ep in *this* checkout also still
lacks `MODULE_DEVICE_TABLE` (`octep_pci_vdpa_map` at
`drivers/vdpa/octeon_ep/octep_vdpa_main.c`); that is a separate
candidate and is not a dependency of this patch.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable searches returned 403; web search found
no stable-list discussion of this specific Alibaba patch. The related
ctucanfd patch *was* sent to stable and is in this tree. UNVERIFIED: no
positive evidence this exact SHA was discussed on stable@; no evidence
it was rejected either.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: No functions modified. Added `MODULE_DEVICE_TABLE(pci,
eni_pci_ids)` next to `eni_pci_ids[]` / `eni_vdpa_driver`.

**Step 5.2: TRACE CALLERS**

Record: `eni_pci_ids` is used as `.id_table` of `eni_vdpa_driver`,
registered via `module_pci_driver()`. PCI core matches on
enumeration/hotplug. The new alias is consumed at module-install time by
depmod, then at runtime by udev/systemd-udevd. Not an interrupt or
syscall path.

**Step 5.3: TRACE CALLEES**

Record: Macro only. Expands to an alias symbol for `file2alias.c`. No
allocations, locks, or I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable when `CONFIG_ALIBABA_ENI_VDPA=m` and a matching PCI
device appears (Red Hat Qumranet vendor `0x1af4`, transitional virtio-
net `VIRTIO_TRANS_ID_NET`, subsystem virtio-net). Userspace does not
need a special syscall; PCI discovery is enough. Built-in builds are
unaffected (macro is empty).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: In-tree vDPA PCI drivers `ifcvf` and `snet` already have
`MODULE_DEVICE_TABLE(pci, ...)`. `eni_vdpa` and `octeon_ep` do not.
Systematic omission, not unique to Alibaba.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. Local tree is **6.12.111** (`git describe HEAD` →
`p-6.12-3-gc504cf0baa3d8`; `VERSION=6 PATCHLEVEL=12 SUBLEVEL=111`).
Current `eni_vdpa.c` has `eni_pci_ids` and `.id_table = eni_pci_ids`
with **no** `MODULE_DEVICE_TABLE`. `git merge-base --is-ancestor
7eeda5e2487276ed87960655fdae1c97d9779a0e HEAD` failed (fix not in this
tree). Bug introduced in `e85087beedcae` (v5.16-rc1), well before 6.12.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Surrounding lines match the upstream hunk exactly. `git apply
--check` clean. Expected difficulty: **clean apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep='alibaba: add missing MODULE_DEVICE_TABLE'` on
this file is empty. No alternate autoload fix. ctucanfd’s analogous fix
is already here, which shows this class is accepted on 6.12.y.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/vdpa/alibaba/` — vDPA PCI driver for Alibaba ENI.
**PERIPHERAL** (cloud-specific, `depends on PCI_MSI && X86`). Not core
mm/net, but a real distro-shipped driver.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: vDPA is actively maintained (recent ifcvf/mlx5/octeon_ep/vduse
fixes). The Alibaba file itself is mature; last functional commits are
API follow-ups plus a probe error-path fix. This is a long-standing
omission, not churn from new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Config- and driver-specific: `CONFIG_ALIBABA_ENI_VDPA=m` on x86
with Alibaba ENI (legacy virtio 0.9.5 transitional net PCI IDs). Built-
in (`=y`) already probes via the in-kernel `id_table`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Trigger is ordinary PCI enumeration with the module not
preloaded. Common for distro modular kernels. Unprivileged users cannot
exploit it; the failure is “device never binds until someone
`modprobe`s”.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Failure mode: driver never autoloads → vDPA/ENI NIC does not
come up. Not a panic, UAF, or corruption. Severity **MEDIUM** for
affected hardware (device non-functional until manual load). Matches the
device-ID/quirk exception, not a crash-class bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:

- Benefit: restores autoload for a driver that already exists in 6.12;
  hardware that distros already ship a module for actually binds.
- Risk: **very low** (one line, build-time metadata only).
- Ratio: strongly favorable. Same class already taken into this tree
  (`877e99535dfb9`).

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:

- Real functional bug: PCI match table present, aliases unpublished.
- One-line, obviously correct, applies cleanly to this 6.12 tree.
- Buggy code has been here since the driver was added (v5.16); the
  upstream fix is not an ancestor of HEAD.
- Device-ID / autoload publication is an established stable exception.
- Identical pattern from the same author already backported here
  (ctucanfd).
- Sibling vDPA PCI drivers already export `MODULE_DEVICE_TABLE`.
- Applied by the vDPA maintainer (MST) after seeing the patch.
- Zero runtime regression surface.

AGAINST:

- Not a crash, UAF, deadlock, or security issue.
- Niche (Alibaba ENI, x86, modular builds only).
- No user `Reported-by`.
- Author did not `Cc: stable` (expected for this review set; not a
  negative).
- MST questioned the boilerplate wording, not the code.

UNRESOLVED:

- Could not fetch lore.kernel.org/stable HTML (403). No evidence of
  rejection.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one-line standard pattern;
   maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — modular autoload
   fails for matching PCI devices.
3. Important issue? **PASS** under the device-ID / hardware-enablement
   exception (severity MEDIUM, not crash-class).
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes IDs the driver already
   matches on.
6. Can apply to the local tree? **PASS** — buggy code present; `git
   apply --check` clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Device ID / module alias publication for an existing driver.**
Equivalent to adding PCI IDs so hardware actually binds when built as a
module.

**Step 9.4: DECISION**

This should be backported to this 6.12 tree. The driver is already here,
the omission is real, the fix is trivial and has no runtime risk, and
this tree already accepted the same class of fix.

---

### What the commit solves and why it matters here

Without `MODULE_DEVICE_TABLE(pci, eni_pci_ids)`, `file2alias` never
emits PCI aliases for `alibaba-eni-vdpa`. On 6.12 systems that build
`CONFIG_ALIBABA_ENI_VDPA=m`, udev will not load the module when the ENI
virtio-net PCI device appears, so the vDPA device never probes unless
something else loads the module. The in-kernel `id_table` still works
after a manual `modprobe`; autoload is what is broken.

### Stable rules and risk

The change is one line, matches the PCI driver idiom used by
`ifcvf`/`snet`, and does not alter probe/remove. Risk is essentially
zero. Benefit is limited to Alibaba ENI modular users, but that is the
same justification used for PCI ID additions and for the ctucanfd
autoload fix already on this branch.

### Concerns

None material for this tree. No prerequisites. No backport rewrite
needed. octeon_ep has the same omission locally; that is independent.

---

Verification:
- [Phase 1] Parsed tags from `git show
  7eeda5e2487276ed87960655fdae1c97d9779a0e`: SOB Hou, SOB Tsirkin,
  Message-ID; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(pci, eni_pci_ids)` in
  `eni_vdpa.c`; no function body change
- [Phase 2] Confirmed `MODULE_DEVICE_TABLE` expansion in
  `include/linux/module.h` (alias for modules, empty if built-in)
- [Phase 2] Confirmed `do_pci_entry()` in `scripts/mod/file2alias.c`
  generates `pci:` aliases from exported tables
- [Phase 3] `git blame -L 540,560`: ID table from `e85087beedcae`
  (v5.16-rc1)
- [Phase 3] `git merge-base --is-ancestor e85087beedcae HEAD`: yes (bug
  present)
- [Phase 3] `git merge-base --is-ancestor
  7eeda5e2487276ed87960655fdae1c97d9779a0e HEAD`: no (fix absent)
- [Phase 3] Same-author ctucanfd fix `877e99535dfb9` already in this
  tree
- [Phase 4] `b4 dig -c 7eeda5e…`:
  https://patch.msgid.link/20260704152732.55338-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: MST, Jason Wang, Xuan Zhuo, Eugenio Pérez,
  virtualization@, lkml
- [Phase 4] mbox: MST asked about boilerplate wording; no NAK; later
  applied
- [Phase 4] lore.kernel.org HTML fetches returned 403; used b4 mbox +
  openwall copy instead
- [Phase 5] Callers: `module_pci_driver` → PCI probe; aliases consumed
  by depmod/udev
- [Phase 5] Sibling drivers `ifcvf`/`snet` already have
  `MODULE_DEVICE_TABLE`; `octeon_ep` still missing (independent)
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111
  (`p-6.12-3-gc504cf0baa3d8`)
- [Phase 6] Current `eni_vdpa.c` lines 540–559: table present,
  `MODULE_DEVICE_TABLE` absent
- [Phase 6] `git apply --check` of the commit: success
- [Phase 7] Kconfig: `ALIBABA_ENI_VDPA` tristate, `depends on PCI_MSI &&
  X86`
- [Phase 8] Failure mode: module autoload skip → device does not bind;
  severity MEDIUM; risk very low
- UNVERIFIED: no stable@ thread found (lore/stable HTTP 403); did not
  drive the decision

The fix is small, surgical, present as a real autoload bug in this 6.12
tree, and meets the device-ID/hardware-enablement exception.

**YES**

 drivers/vdpa/alibaba/eni_vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
index e476504db0c82..fd6fdba460945 100644
--- a/drivers/vdpa/alibaba/eni_vdpa.c
+++ b/drivers/vdpa/alibaba/eni_vdpa.c
@@ -545,6 +545,7 @@ static struct pci_device_id eni_pci_ids[] = {
 			 VIRTIO_ID_NET) },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(pci, eni_pci_ids);
 
 static struct pci_driver eni_vdpa_driver = {
 	.name		= "alibaba-eni-vdpa",
-- 
2.53.0

