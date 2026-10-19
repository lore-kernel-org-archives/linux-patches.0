Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF57753FA0F;
	Mon, 19 Oct 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418180; cv=none; b=OunoI/v5GIes9fbwZy7O7iceJ+Mkv9rJ+BB8FIJBjoe494oIWMW67Ufx7v8SCsl7gynm9uTtPVpm2q9rqG563boQUeVR3Z4aCc9DZVO4+sIih4L/oNJ9KT2Wc7+7Xcxru91hWNVk5R+9lDuO+dlPxkw9/QPPslnpt9g2YMgYd6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418180; c=relaxed/simple;
	bh=onDSn61GDLoGxSb7sKSAlbs+7Pnrh3ibXMOsIh4a9os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHYt2ODAF149keWM/FZmhtAKTcELlr1AyEYTQUYoMzcLkd4llNPhdd7vBinfTbn7JpbilVpaqMZlYzPuUI+tkHBHUqMga45S+Cm2bEeuBUxJjsGYWqdyttwAqH0X1czo7z6ZeCMjr2dWt9SskzeCqkc+0+DBrvNQbIM/ZWhb218=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6aDCSwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6aDCSwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F901F000C7;
	Mon, 19 Oct 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418177;
	bh=vsecmG44xRD3F94Ps60bP4dIf2XmQbo2tFrtNujGeDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6aDCSwb0pGBDXGnGIfc5N5paP945bKxQajy0ot0Lgni5ZIuew1Uoe9vUIX2Pa4m/
	 m1i0GzrqmkfrTg+V66iPrzhXhIuUzoWotGV7ttANWapQIXZMrD2lf1Dta8pi8KbdEV
	 7tM9Aye6FL/OBbp+Y6A843jl4wMAV2TZMmlgjE2GWt9zLsi2t3HXDmqYvn1bD1eEC+
	 PXHs9Fmx06lhzInIlpIZkJmP8DLvh7MJpHOZaYHefpn5PmJpd1Zrcm2lalUuXSw+r4
	 K8HCRbJS9rtQVUugc3SaF+yDbx7JRxXkSDxNEMLwrUfnlU6A4bAmcZkWzHJqJFg53l
	 JzOKp1xGQFriQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cassel@kernel.org,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ata: ata_generic: Don't store pci_device_id
Date: Mon, 19 Oct 2026 09:45:58 -0400
Message-ID: <20261019135441.1420968-67-sashal@kernel.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 4f3075f629077a8cb3d3455c794a1f4a8fc8b43e ]

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the history, the series context, and the UAF path. Next I’ll
write the full nine-phase verdict for this 7.3-rc4 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[ata / ata_generic] [Don't store] [Stop keeping a pointer to
struct pci_device_id in host private_data; keep only driver_data]`

Subsystem prefix is `ata: ata_generic:`. Action is “Don’t store” —
defensive lifetime fix, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none on this commit
- **Tested-by:** none
- **Reviewed-by:** Danilo Krummrich `<dakr@kernel.org>` (PCI/driver-
  core)
- **Acked-by:** Damien Le Moal `<dlemoal@kernel.org>` (libata
  maintainer)
- **Link:** `https://patch.msgid.link/20260723-pci_id_fix-v4-1-
  3580726844e1@garyguo.net` (v4 patch 1/9)
- **Cc: stable:** none (not a negative signal)
- **Signed-off-by:** Gary Guo (author); Bjorn Helgaas (PCI maintainer,
  committer)
- Ignore any Sasha Levin SOB if present — none on the actual git commit
  `4f3075f629077`

Notable: ATA maintainer Ack plus PCI maintainer commit. Series name
`pci_id_fix-v4` — this is patch 1 of 9.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `pci_device_id` is not guaranteed to outlive `probe` because
  PCI dynamic IDs (`new_id` / `remove_id`) can free that object.
- **Symptom/failure mode:** later dereference of
  `ap->host->private_data` as `const struct pci_device_id *` is a use-
  after-free.
- **Version info:** none in the message.
- **Root cause:** `ata_generic_init_one()` stored the `id` pointer via
  `ata_pci_bmdma_init_one(..., (void *)id, ...)`. `generic_set_mode()`
  later reads `id->driver_data`. Only `driver_data` is needed;
  vendor/device can come from `pci_dev`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The subject is lifetime hygiene, but
the mechanism is a real UAF if a dynamic ID is freed while the ATA host
still holds the pointer. Cover letter for the series calls storing
`pci_device_id` from probe a “bad pattern” and names a genuine dynamic-
ID UAF (Sashiko report, used for the PCI-core patch). This driver change
is both a standalone dangling-pointer fix and a prerequisite so PCI core
can shrink dyn-ID lifetime.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/ata/ata_generic.c` — 3 insertions, 3 deletions (net 0,
  6 lines touched)
- Functions: `generic_set_mode()`, `ata_generic_init_one()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Hunk 1 (`generic_set_mode`):
- Before: `const struct pci_device_id *id = ap->host->private_data;`
  then `id->driver_data & ATA_GEN_FORCE_DMA`
- After: `unsigned long driver_data = (unsigned
  long)ap->host->private_data;` then `driver_data & ATA_GEN_FORCE_DMA`
- Path: ATA mode programming, including libata error handling
  (`ata_eh_set_mode()` → `ap->ops->set_mode`), not probe-only

Hunk 2 (`ata_generic_init_one`):
- Before: `ata_pci_bmdma_init_one(..., (void *)id, 0)` stores the full
  `pci_device_id *`
- After: `ata_pci_bmdma_init_one(..., (void *)id->driver_data, 0)`
  stores the integer flags only
- Path: PCI probe / host registration

`ATA_GEN_CLASS_MATCH` and `ATA_GEN_INTEL_IDER` remain consumed from the
live `id` argument during probe only — they are not read from
`private_data`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** memory safety / use-after-free (stale pointer)
- **Mechanism:** PCI `remove_id_store()` does `list_del` +
  `kfree(dynid)` under `dynids.lock` without unbinding devices. If the
  host was bound via that dyn ID, `host->private_data` still pointed at
  `dynid->id`. `generic_set_mode()` later loads `id->driver_data`.
- After the later PCI-core change in this same series (`3ffc4c9690c33`),
  dyn-ID matches return a **stack copy** valid only during probe
  (`include/linux/pci.h`: “The pci_device_id parameter is only valid
  during probe.”). Storing that pointer past probe would then be a stack
  UAF even without `remove_id`. This driver patch must land first (and
  it did: v4-1 before v4-9).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: the only post-probe use was `id->driver_data`; copy
  that integer instead of the object.
- Minimal; no unrelated edits; no API change.
- Regression risk: very low. `driver_data` values are small flags
  (`1<<0`..`1<<2`). Same `void *` ↔ `unsigned long` trick already used
  elsewhere (e.g. `pata_amd.c`).
- This tree already contains the after-state (`4f3075f629077` is an
  ancestor of HEAD).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Storing the `pci_device_id *` in `host->private_data` was introduced
  in `1529c69adce1e` (“ata_generic: implement ATA_GEN_* flags and force
  enable DMA on MBP 7,1”), 2010-07-01, contained in `v2.6.35-rc4`.
- That commit is an ancestor of this tree. The pattern is ~16 years old,
  not new 7.3 code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag on this commit. The buggy pattern is
`1529c69adce1e`, verified present. Related PCI-core UAF has `Fixes:
0994375e9614` (“PCI: add remove_id sysfs entry”) on `3ffc4c9690c33` —
different patch, same series.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (last commits on `drivers/ata/ata_generic.c`):
- `4f3075f629077` this fix
- `9986ce65bebb9` constify `pci_device_id` (unrelated)
- No other recent functional churn at these lines

Standalone vs series: **patch 1/9** of `pci_id_fix`. Sibling driver
patches (`nsp32`, `tpci200`, `mlxsw`, agp). PCI core is patches 7–9.
**This patch applies standalone**; it does not call new PCI helpers.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Gary Guo is not the ATA maintainer; he is the series author
(Rust/PCI ID work). Nearby same-author commits: `3c28376273e8f` nsp32,
`9a1b9aa5cedf3` tpci200, `1ae2920768f79` mlxsw, plus PCI TOCTOU/UAF.
Damien Le Moal Acked this ATA patch. Bjorn Helgaas committed it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No prerequisites. `ata_pci_bmdma_init_one(..., void *host_priv,
...)` has taken an opaque `host_priv` for a long time (`libata-sff.c`).
This is a caller-side change only. Later PCI patches depend on *this*
class of driver fix, not the reverse.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 4f3075f629077` matched patch-id; lore URL: `https://patch.m
  sgid.link/20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net`
- `b4 dig -a` revisions:
  - v1 2026-06-26: PCI match refactor only (this driver fix not yet
    present)
  - v2 2026-06-30: `[PATCH v2 1/7] ata: don't keep pci_device_id` —
    driver stores added
  - v3 2026-07-06: `[PATCH v3 1/9] ata: don't store pci_device_id`
  - v4 2026-07-23: applied version; cover: “PCI: Fix UAF and TOCTOU
    related to dynamic ID”
- v2 changelog: “Fix users which store pci_device_id.” v4: style fixes
  from Bjorn. Applied version is latest.
- No NAK on this patch. Sashiko bot: “found no issues.”
- Cover letter: Sashiko reported a genuine dynamic-ID UAF; storing
  `pci_device_id` from probe is called out as a bad pattern.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): linux-ide, linux-pci, driver-core, linux-scsi,
netdev, dri-devel; Damien Le Moal, Niklas Cassel, Bjorn Helgaas, Danilo
Krummrich, Greg KH. Right maintainers were on CC. Reviewed-by Krummrich,
Acked-by Le Moal, committed by Helgaas.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: This specific ATA patch has no `Reported-by`. The series UAF
report is on patch 9: `Reported-by: Sashiko <sashiko-bot@kernel.org>` /
lore `20260619170503.518F61F00A3A@smtp.kernel.org`. Direct WebFetch of
lore returned HTTP 403; thread was recovered via `b4 dig -m`. No user
crash log for `ata_generic` itself.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 9-patch series. Patches 1–6 fix drivers that stash or pointer-
arithmetic the ID. Patches 7–9 change PCI matching, dyn-ID TOCTOU, and
concurrent probe vs `remove_id` UAF. This commit is self-contained; it
does not require 7–9 to be correct. If 9 were backported without 1, dyn-
ID probe would hand a stack copy to `ata_generic`, which would then
store it — a worse UAF. Evaluating **this** commit alone: it is
independently correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `curl`/`WebFetch` to `lore.kernel.org/stable/` returned 403. The
saved v4 thread contains **no** `Cc: stable` discussion. **UNVERIFIED:**
whether anyone asked for this on the stable list.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `generic_set_mode()`, `ata_generic_init_one()`. (semcode MCP not
available; used hunks + grep.)

**Step 5.2: TRACE CALLERS**

Record:
- `ata_generic_init_one` — PCI `.probe` of `ata_generic_pci_driver`
  (device bind).
- `generic_set_mode` — `generic_port_ops.set_mode`. Called from
  `ata_eh_set_mode()` in `drivers/ata/libata-eh.c` when
  `ap->ops->set_mode` is set. That runs from `ata_eh_recover()` when
  `ATA_EHI_SETMODE` is set (initial config, reset, revalidate). **After
  probe**, disk errors / resume / EH can invoke it.

**Step 5.3: TRACE CALLEES**

Record: `ata_pci_bmdma_init_one()` stores `host_priv` on the `ata_host`.
`generic_set_mode` reads BMDMA status and libata xfer-mask helpers. No
new allocations or locks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Common path: PCI probe of a device in the static `ata_generic[]` table
  → `id` points at module `.rodata` for the module’s lifetime → **no
  UAF** on static IDs.
- Buggy path: `echo ... > /sys/bus/pci/drivers/ata_generic/new_id`
  (typically CAP_SYS_ADMIN) → bind via heap `pci_dynid` → store pointer
  → `remove_id` kfree’s dynid while host still bound → later EH
  `generic_set_mode` → UAF.
- Reachable from userspace: yes, via PCI sysfs + later ATA EH. Not a
  normal unprivileged syscall path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same-series fixes in `nsp32`, `tpci200`, `mlxsw`, agp. Other ATA
drivers store their own `hpriv`, not `pci_device_id *`. Pattern was
systematic across PCI drivers, not unique to ATA.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4` (Linus mainline, detached HEAD).
- Commit `4f3075f629077` **is already an ancestor of HEAD** (`git merge-
  base --is-ancestor` succeeded; first appeared in `v7.3-rc1`).
- Current `drivers/ata/ata_generic.c` already stores `id->driver_data`
  and reads it as `unsigned long`.
- The **pre-fix** code existed on this lineage from `1529c69adce1e`
  (v2.6.35) until that commit. This is not a “bug introduced after this
  tree branched” case.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Against the pre-fix file (`4f3075f629077^`), the diff is a clean
6-line replace. No refactor of `ata_generic.c` in between. Expected
apply on a tree that still has the old pointer store: **clean**. On
*this* checkout the after-state is already present, so re-applying the
patch would be a no-op/conflict with itself — that is git ancestry, not
a missing-code problem.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This exact fix is in HEAD. PCI-core companion `3ffc4c9690c33` is
also an ancestor. No alternate/earlier ata_generic dyn-ID fix found
(`git log --grep=pci_device_id -- drivers/ata/ata_generic.c` only this
commit and an unrelated constify).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/ata/` — libata generic PCI IDE driver
(`CONFIG_ATA_GENERIC`). **IMPORTANT** for machines that still use BIOS-
configured PATA/IDE (Cenatek FORCE_DMA, Intel IDE-R, various legacy
chips). Not mm/net core, but storage.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: libata is actively maintained (recent EH/LPM/AHCI fixes).
`ata_generic.c` itself is mature; little churn besides this lifetime
fix.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific (`CONFIG_ATA_GENERIC`), and the UAF only if the
host was bound via a **dynamic** PCI ID. Static-table devices (the usual
case) keep `id` in module memory. Affected population: admins using
`new_id` on `ata_generic`, then `remove_id` or (after PCI stack-copy)
any post-probe `set_mode`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: privileged sysfs `new_id`/`remove_id`, then ATA EH
  `set_mode`.
- Likelihood on production LTS: **low** (dyn IDs are uncommon for this
  driver).
- Unprivileged trigger: **no** (driver `new_id`/`remove_id` are root-
  owned sysfs). Still a real kernel UAF, not theoretical pointer math.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Use-after-free of `pci_dynid` / dangling ID pointer → KASAN/oops
or worse. **Severity: HIGH** when triggered; **likelihood: LOW**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Prevents a real UAF in a long-lived storage driver;
  3-line change; maintainer-acked. Also keeps the driver correct if the
  PCI dyn-ID lifetime fix is applied.
- **Risk:** Very low (tiny, local, no locking/API).
- **Ratio:** favorable. Conservative “rare trigger” concern does not
  outweigh UAF + trivial patch.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real UAF: `host->private_data` held `pci_device_id *` beyond probe;
  `remove_id` can free dyn IDs; `generic_set_mode` runs from libata EH
  after probe.
- Bug present since v2.6.35 (`1529c69adce1e`); code exists on this
  lineage.
- 6-line, obviously correct; only `driver_data` was used post-probe.
- Reviewed/Acked by PCI and ATA maintainers; PCI maintainer committed
  it.
- No new APIs/features.
- Self-contained; no missing helpers in this tree.

AGAINST:
- Common static-ID path was not buggy; trigger needs dyn-ID sysfs
  (root).
- No user crash report / syzbot on this exact driver file.
- Part of a 9-patch series whose headline UAF is PCI-core patch 9; this
  was added in v2 as “fix users which store pci_device_id.”
- No `Cc: stable` in the thread (absence is expected).

UNRESOLVED:
- lore.kernel.org HTTP 403 for live pages; used `b4 dig` mbox instead.
- Stable-list discussion UNVERIFIED (403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — logic is local and reviewed;
   Sashiko found no issues on v4-1.
2. Fixes a real bug that affects users? **PASS** — dangling
   `pci_device_id` after dyn-ID removal / after probe lifetime; users of
   `ata_generic` + `new_id` can hit it.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   UAF → oops/KASAN (HIGH, rare trigger).
4. Small and contained? **PASS** — 6 lines, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** for trees still on the old
   pointer store. This 7.3-rc4 checkout already contains the commit;
   that does not make the fix unsuitable — it confirms the code and
   helpers exist here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID / quirk / DT / build / docs exception).
Qualifies as a normal small UAF fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **Linux 7.3-rc4** (mainline). `ata_generic` is present; the
buggy store-the-`id`-pointer pattern lived here from 2010 until
`4f3075f629077`. The patch is a 3-line lifetime fix for a real UAF, not
a feature or refactor, and it applies in isolation.

Rare privileged trigger is not enough to reject a tiny, maintainer-acked
UAF fix in a storage driver. It meets stable-kernel-rules.

### What the commit solves (for stable users)

`ata_generic` used to keep a pointer to the `pci_device_id` passed into
probe. For IDs added through sysfs `new_id`, that object can be freed by
`remove_id` while the ATA host is still live. `generic_set_mode()` —
including from error handling — then dereferences freed memory. The fix
copies `driver_data` (the only field used later) and drops the pointer.

### Risk vs benefit

Benefit is avoiding a UAF/oops on a long-standing driver. Risk is
negligible. No prerequisites missing in this tree.

---

Verification:
- [Phase 1] Parsed tags on `4f3075f629077`: Reviewed-by Danilo
  Krummrich, Acked-by Damien Le Moal, Link to v4-1; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Subject/body: don’t store `pci_device_id`; dyn-ID lifetime
- [Phase 2] Diff: 3+ / 3- in `drivers/ata/ata_generic.c`;
  `generic_set_mode` + `ata_generic_init_one`
- [Phase 2] Pre-fix file via `git show
  4f3075f629077^:drivers/ata/ata_generic.c`: stored `(void *)id`, later
  `id->driver_data & ATA_GEN_FORCE_DMA`
- [Phase 3] `git blame` / `git log -S private_data --
  drivers/ata/ata_generic.c`: introduced `1529c69adce1e` (2010,
  `v2.6.35-rc4`)
- [Phase 3] `git merge-base --is-ancestor 1529c69adce1e HEAD` — yes;
  `4f3075f629077` — yes
- [Phase 3] Series: `3c28376273e8f`, `9a1b9aa5cedf3`, `1ae2920768f79`,
  `c967b365d7b51`, `04fde70f782b6`, `3ffc4c9690c33`
- [Phase 4] `b4 dig -c 4f3075f629077`: patch.msgid.link v4-1; `-a`:
  v1–v4; `-w`: linux-ide/linux-pci + Le Moal/Helgaas
- [Phase 4] `b4 dig -m`: cover letter genuine dyn-ID UAF; this patch
  added in v2; no NAK; Sashiko OK
- [Phase 4] WebFetch lore/patch.msgid.link: HTTP 403; used b4 mbox
  instead
- [Phase 4] Stable list: UNVERIFIED (403)
- [Phase 5] Callers: PCI probe; `ata_eh_set_mode()` in `libata-eh.c`
  lines 3480–3482 and 3962–3963
- [Phase 5] `remove_id_store()` in `drivers/pci/pci-driver.c` kfree’s
  dynid without unbind
- [Phase 5] `include/linux/pci.h` ~989: id only valid during probe
  (after series)
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] Current file already has the fix (commit in 7.3-rc1)
- [Phase 7] `CONFIG_ATA_GENERIC` in `drivers/ata/Kconfig` — generic BIOS
  ATA, PCI+BMDMA
- [Phase 8] Failure mode: UAF in EH `set_mode`; severity HIGH; trigger
  privileged dyn-ID; risk of the patch itself very low
- UNVERIFIED: stable@ lore discussion (HTTP 403)

The patch is small, fixes a real use-after-free, and meets stable
criteria for this tree’s `ata_generic` code.

**YES**

 drivers/ata/ata_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index e70b6c089cf17..18ea740ca5829 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -51,11 +51,11 @@ enum {
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
-	const struct pci_device_id *id = ap->host->private_data;
+	unsigned long driver_data = (unsigned long)ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 
-	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+	if (driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
 	} else if (ap->ioaddr.bmdma_addr) {
 		/* Bits 5 and 6 indicate if DMA is active on master/slave */
@@ -206,7 +206,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id->driver_data, 0);
 }
 
 static const struct pci_device_id ata_generic[] = {
-- 
2.53.0

