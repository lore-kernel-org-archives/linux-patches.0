Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D1855CE65;
	Mon, 19 Oct 2026 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418239; cv=none; b=iVnr0YLUa18G7L+nI3E8oixOqcqSBQ1O+c4oTjZ3dMi+f5Im784IGjxQEDNqdJMFpZQXuWMCYZ1IM1MmIZcZOKaKANkAFLlOxhg5rP6jYTKM5DQS7bgqOd7O063HePHWZJWEotEtWxTwcjYRO02BZ5sfzYzzkM564j3gUDV7HGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418239; c=relaxed/simple;
	bh=eEZiX1kHsRCT+ZMCcaG/awfVjPRit5YiPKa40MxD0bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFmMZwb2l4+izEp9DAKI+8Yk3HXoC5SnZx2eB8F5k0dIQSaWL7gSt8hkHxSY/qkO3aR7d5QgGAPPwMv4l5CHAruyfaUcFvBYStyFkb3WJJcL3AEmGyk2YH0xaV+vSIW7/sceAAgNqkHCsLp2ipdcfO7fEexn45y+pHstDE8Xx7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UC+LHyxF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UC+LHyxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3B31F000C9;
	Mon, 19 Oct 2026 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418235;
	bh=dOvMacpT1LRqwPBvTegGIPt8B7R4hOUlH3vIgd1XAac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UC+LHyxFJPxWrgXn+V0QhNVDwXk4t/0bSac0SJHfput4FH1hPEgFcgwIK6Ri5djN3
	 vt/kTK/B4YZAv2gtT05W0dlRVWq9ZswWWT7cPofVn850bp7zJIbodmi7dgPz4Thq6m
	 gGJqcy73tbcBCiCsJMGoN3bTiSslGD2zczPNMM0NG13u5/LlOMcOhfGBkL+1gXUFcv
	 iyIfXjkuO9qEpnE3jH8RMsaqHIH7q+ItDwLon4Za2QVqBrZ09nIu7DoR8cdnqChBIC
	 PdUXTF1+FOB5L8ByCBXZout9DBam6q6BAcQDb13evlJKwK6kyPWq5/HNCgbaFq7ylR
	 aOpIPm3F0QJiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:46:39 -0400
Message-ID: <20261019135441.1420968-108-sashal@kernel.org>
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

[ Upstream commit a432f68c51fc6761658445e80a798b8425fdb3dc ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **v7.3-rc4** (mainline). The change is a one-line
`MODULE_DEVICE_TABLE()` so PCI aliases are generated; that is a real
autoload bug with no runtime risk.

## Phase 1: Commit message forensics

**Step 1.1: Subject**
Record: **[uio/sercos3] [add] [export the existing PCI ID table with
MODULE_DEVICE_TABLE()]**

**Step 1.2: Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Link:
  https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (UIO/char-misc maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)

**Step 1.3: Body**
Record:
- **Bug:** `sercos3_pci_ids` is wired into `sercos3_pci_driver.id_table`
  but not published with `MODULE_DEVICE_TABLE()`.
- **Symptom:** depmod/modpost emit no PCI aliases, so udev/kmod will not
  autoload `uio_sercos3` when a matching card appears.
- **Version info:** none in the message. The ID table has been in the
  driver since 2008.
- **Root cause:** missing module-alias publication, not a wrong match
  table.

**Step 1.4: Hidden bug fix?**
Record: **No disguise.** It is an explicit metadata-export fix. The
“source-level / no hardware reproduction” sentence is honesty about
evidence, not a cleanup-only change. Without the macro, modular autoload
is broken.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/uio/uio_sercos3.c` — **+1 / −0**
- Function/data: `sercos3_pci_ids` (static PCI ID table), immediately
  before `sercos3_pci_driver`
- Scope: **single-file surgical fix**

**Step 2.2: Code flow**
Record:
- **Before:** table exists and is used at runtime by PCI core *after*
  the module is already loaded (or if built-in).
- **After:** same runtime matching, plus `MODULE_DEVICE_TABLE(pci,
  sercos3_pci_ids)` so modpost/`file2alias.c` emits
  `pci:v...d...sv...sd...` aliases into the module.
- Path affected: **build-time module metadata / userspace autoload**,
  not probe/remove/IRQ.

**Step 2.3: Bug mechanism**
Record: **Hardware enablement / missing device-table export** (same
family as adding PCI IDs).
- Mechanism: `scripts/mod/file2alias.c` `do_pci_entry()` only walks
  tables found via `MODULE_DEVICE_TABLE()`. No macro → no aliases → no
  autoload.
- Runtime `id_table` is unchanged, so probe matching is not altered.

**Step 2.4: Fix quality**
Record: **Obviously correct, one line, no unrelated edits.** Regression
risk is **very low**: aliases match the same
vendor/device/subvendor/subdevice entries the driver already uses. No
locking, no API, no data-structure change.

## Phase 3: Git history

**Step 3.1: Blame**
Record: ID table and `pci_driver` come from **`a6030fcc608bd`** (“UIO:
add automata sercos3 pci card support”, John Ogness, 2008-09-18). That
commit never added `MODULE_DEVICE_TABLE()`. The table was later made
`const` in `511d7a35a438d` (2025). The missing export has been present
for the entire life of the driver.

**Step 3.2: Fixes: tag**
Record: **None.** Introduced by `a6030fcc608bd` (verified: parent of
this fix has no `MODULE_DEVICE_TABLE` in this file). `git grep` on
`a432f68c51fc6^ -- drivers/uio/uio_sercos3.c` returned no match.

**Step 3.3: File history**
Record: Recent commits on this file are constify, devm allocs, SPDX,
`module_pci_driver`. **No prerequisite series.** Standalone one-liner.

Same class of UIO fix already exists historically: **`912335c43bb10`**
(“UIO: fix specific device driver missing statement for depmod”, 2009)
added `MODULE_DEVICE_TABLE` to `uio_cif.c` for the same depmod/alias
reason.

**Step 3.4: Author**
Record: Pengpeng Hou is not the UIO maintainer. Same author has a batch
of “add missing MODULE_DEVICE_TABLE()” patches (rtc, vdpa, watchdog,
fbdev, soc, can, clk, power). Pattern is systematic and consistent.
Maintainer of record is Greg Kroah-Hartman, who applied it.

**Step 3.5: Dependencies**
Record: **None.** Uses the long-standing `MODULE_DEVICE_TABLE()` macro
in `include/linux/module.h`. Can apply standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c a432f68c51fc6` →
  https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn
- Openwall copy: https://lists.openwall.net/linux-kernel/2026/07/04/476
- `b4 dig -a`: **v1 only**, 2026-07-04. Applied version is that v1.
- No reviewer comments, NAKs, or `Cc: stable` suggestions found in the
  retrieved thread.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Pengpeng Hou, **Greg Kroah-Hartman**, `linux-
kernel@vger.kernel.org`. Correct maintainer was To:’d.

**Step 4.3: Bug report**
Record: **No user/syzbot/bugzilla report.** Author states source-level
evidence only.

**Step 4.4: Series**
Record: **Standalone**, not `N/M`.

**Step 4.5: Stable list**
Record: **UNVERIFIED.** `lore.kernel.org/stable` and git.kernel.org
fetches returned 403 (Anubis). Openwall search found the lkml submission
only, not a stable-thread discussion.

## Phase 5: Semantic / impact

**Step 5.1: Functions**
Record: No function body changed. Data: `sercos3_pci_ids`; consumer:
`sercos3_pci_driver`.

**Step 5.2: Callers**
Record:
- Runtime: PCI core uses `.id_table` from
  `module_pci_driver(sercos3_pci_driver)` → `sercos3_pci_probe` on
  match.
- Autoload: udev/kmod uses aliases generated from `MODULE_DEVICE_TABLE`.
- Not IRQ/hot path; module-load / device-enumeration path.

**Step 5.3: Callees**
Record: The new line expands to an alias symbol for modpost. No new
runtime calls.

**Step 5.4: Reachability**
Record: **Yes, from userspace + hardware.** Trigger is a matching PLX
9030 + Sercos subsystem ID (0x1971 / 0x3530, 0x3535, 0x3780) with
`CONFIG_UIO_SERCOS3=m`. Built-in (`=y`) never needed aliases.

**Step 5.5: Similar patterns**
Record: Sibling UIO PCI drivers already export tables: `uio_cif.c`,
`uio_netx.c`, `uio_mf624.c`, `uio_aec.c`. `uio_sercos3` was the outlier.
OF/vmbus/dfl UIO drivers also use `MODULE_DEVICE_TABLE`.

## Phase 6: This checkout

**Step 6.1: Does the buggy code exist here?**
Record:
- Tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`, origin `torvalds/linux.git`.
- File and PCI ID table exist (`drivers/uio/uio_sercos3.c`).
- At **HEAD**, `MODULE_DEVICE_TABLE(pci, sercos3_pci_ids)` is already at
  line 215 (`git merge-base --is-ancestor a432f68c51fc6 HEAD`
  succeeded). That is expected: this checkout is mainline after 7.3-rc1,
  i.e. the **source** of stable candidates, not a missing-driver stable
  branch.
- Bug introduced: **2008** (`a6030fcc608bd`). Not a post-branch feature.

**Step 6.2: Backport difficulty**
Record: **Clean apply.** Surrounding table/`pci_driver` layout matches
the hunk. No refactor blocking a one-line insert.

**Step 6.3: Related fixes already here**
Record: This is the fix. No alternate alias-export for this driver.
Historical analogue is `uio_cif`’s 2009 `MODULE_DEVICE_TABLE` addition.

## Phase 7: Subsystem

**Step 7.1:**
Record: **UIO PCI driver** (`drivers/uio/`). Criticality: **PERIPHERAL**
— Automata Sercos III industrial card, `CONFIG_UIO_SERCOS3` tristate,
default n, `depends on PCI`.

**Step 7.2:**
Record: **Mature / low churn.** Driver added 2008; later commits are
cleanup (`module_pci_driver`, SPDX, devm, constify). Not a new
subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: **Driver-specific / config-specific:** `CONFIG_UIO_SERCOS3=m`
and a matching PCI card. Built-in and systems without the card are
unaffected.

**Step 8.2: Trigger**
Record: PCI enumeration + udev module lookup. Common on modular distro
kernels **if the hardware is present**. Unprivileged users cannot
trigger it without the card. Not a race.

**Step 8.3: Failure mode**
Record: Module not autoloaded; card stays unbound until `modprobe
uio_sercos3`. **Severity: MEDIUM** (real functional break, not
oops/corruption/security). Workaround exists but is not how PCI drivers
are supposed to load.

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** restores autoload for existing IDs (same user-visible
  outcome as a device-ID addition).
- **Risk:** very low (one metadata line, no runtime change).
- **Ratio:** favorable.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real autoload bug: ID table registered, aliases never published.
- Same class as the stable “add a device ID” exception; IDs already
  exist, they were just invisible to kmod.
- One line, obviously correct, no API/feature.
- Sibling UIO PCI drivers already do this; `uio_cif` got the same depmod
  fix in 2009.
- Greg Kroah-Hartman applied v1 unchanged.
- Driver present since 2008; no missing prerequisites on this tree.

Against:
- Niche hardware; no `Reported-by` in ~18 years.
- Not a crash, deadlock, or security issue.
- Author did not reproduce on hardware (stated).
- Manual `modprobe` still works.

Unresolved:
- Stable mailing-list discussion (lore 403).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — one-line, standard macro;
   Greg applied it. Hardware repro not required for alias generation.
2. Real bug affecting users? **PASS** — modular autoload fails for
   matching PCI devices.
3. Important? **PASS** (device-ID / hardware-enablement class) — not a
   panic, but it is the userspace half of PCI ID support; stable rules
   explicitly allow device-ID additions.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS** — publishes existing IDs.
6. Can apply to this tree? **PASS** — driver and table are here; hunk
   matches.

**Step 9.3: Exception**
Record: **Device ID / hardware-enablement.** Closest documented
exception: “just add a device ID.” This exports IDs the driver already
matches.

**Step 9.4: Decision**
This tree has the driver and the ID table; the omission is a real
modular-load bug, the patch is a one-line metadata export with no
runtime risk, and it matches how other UIO PCI drivers (and stable’s
device-ID exception) already work. It should be selected for stable.

---

**What it solves for stable users:** With `CONFIG_UIO_SERCOS3=m`, a
Sercos III PLX 9030 card will not cause udev to load `uio_sercos3`
because `modules.alias` has no PCI entries. The line adds those aliases.
Distro/LTS kernels typically ship such drivers as modules.

**Rules:** Small, correct, no new API; equivalent to enabling existing
device IDs for autoload.

**Risk vs benefit:** Benefit is autoload on real hardware; risk is
essentially zero.

**Concerns:** Niche card and no crash report, but that does not outweigh
a zero-risk hardware-enablement one-liner that applies cleanly.

Verification:
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, lore msgid Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 `MODULE_DEVICE_TABLE(pci, sercos3_pci_ids)` after
  `sercos3_pci_ids[]` in `drivers/uio/uio_sercos3.c`
- [Phase 2] Confirmed `sercos3_pci_driver.id_table = sercos3_pci_ids`
  and `module_pci_driver(sercos3_pci_driver)`
- [Phase 3] `git blame`: table from `a6030fcc608bd` (2008); this line
  from `a432f68c51fc6`
- [Phase 3] `git grep` on parent: no `MODULE_DEVICE_TABLE` in this file;
  HEAD has it at line 215
- [Phase 3] Historical analogue: `912335c43bb10` added the same macro to
  `uio_cif.c` for depmod
- [Phase 4] `b4 dig -c a432f68c51fc6`: lore/msgid match; `-a`: v1 only;
  `-w`: Greg KH + lkml
- [Phase 4] Openwall thread matches committed patch; no NAK found
- [Phase 4] lore.kernel.org WebFetch: 403 — stable-list discussion
  UNVERIFIED
- [Phase 5] `MODULE_DEVICE_TABLE` in `include/linux/module.h`;
  `do_pci_entry()` in `scripts/mod/file2alias.c`
- [Phase 5] Sibling UIO PCI drivers already have `MODULE_DEVICE_TABLE`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor a432f68c51fc6 HEAD` exit 0
  (commit is in this mainline checkout)
- [Phase 6] Commit not in `v7.2`; is in `v7.3-rc1`
- [Phase 7] `CONFIG_UIO_SERCOS3` tristate, depends on PCI, module name
  `uio_sercos3`
- [Phase 8] Failure mode: no PCI aliases → no autoload; severity MEDIUM;
  risk very low
- UNVERIFIED: whether this hash was already applied on some older stable
  branch (not this checkout; not used for the verdict)

**YES**

 drivers/uio/uio_sercos3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 12afc2fa1a0bb..80087897f9b86 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -212,6 +212,7 @@ static const struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0

