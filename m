Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD13D63DB5C;
	Mon, 19 Oct 2026 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418780; cv=none; b=dGO97a490W0hLQqSSQljlSwt1XyZpLug0Fvt71r3yEWB/hJN1AoyHROPCC9/CdsYE+3k2TaPE7TDGK5z+xdcEaQ9SgJkMh9gz4Du1c9vGZG4eEcvXTQCSb/N7g54I5ohJMj0l/SxXjQB0HxSoqBfQNb9IBbfzg6PwQ3x+pbycQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418780; c=relaxed/simple;
	bh=OdyJJ1TcH/KZ4hEhPE5KC/X/gh+QKeYAIqXRnwqShK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iHfnXxcfsMS4pZViGtPc/Jsdpru8DaRayFuFh57QIKxIUfF/Hg5nDO/UvOVCpjrv78Lly1yoZSgO5tlDwLY1I34+gTIMZjnmU6yjeQ8nwYRBb/nw/cbmYc+SaEjEV+HbuNtT0toAGH0X8RdV6xO3V+6PfT6kiwdqN9DSOBO7OoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Srvi2mhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Srvi2mhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA28C1F000C5;
	Mon, 19 Oct 2026 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418777;
	bh=hwkb0P5SDw7wfm5aToOfwjRzuJMunmkgoeXbZNqeC08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Srvi2mhUIm6m9XCLAMlQ7hegr2sDlxkLrin06uiCJKi9D8Itp9qBdqkx1G+3IYpkQ
	 uc2/72Abd2z8kcsbmLM5RtyOMyQq/VSvyOX/rElbWU6PTlmqzrIp7B9YrTr2zZfRya
	 TO+qboFzcNPYfW/qHqJDO7Cvndl6xSGD1bUUOAALjdLPhsI2+jNiKT1O4H67YvrP7y
	 ihUF1tfwGIKyxSkMWmu2/zouaZL0fIbw5oHMmpy3+RifVqDYUfpAi8XbULJTCo0I/9
	 Cwc35nEJywbsbN9KyeTqmvvJxi7/so1Us66UuhgmLc3+3gdx1K4mWAt3ChKq8ziypA
	 KkCY2oJYfPcgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	sre@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:53:00 -0400
Message-ID: <20261019135441.1420968-489-sashal@kernel.org>
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

[ Upstream commit ffefc5d9a052f67bc87b57d1107fd7cc1fa1a3d4 ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152336.51384-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The driver
has been present since v4.10; the change is a one-line
`MODULE_DEVICE_TABLE()` addition so the existing PCI ID can autoload the
module.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[power/reset: piix4-poweroff] [add] [export the existing PCI
match table via MODULE_DEVICE_TABLE() so the module can autoload]**

**Step 1.2: Tags**
Record:
- **Fixes:** none (expected for this review path)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260704152336.51384-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou (author); Sebastian Reichel (power-
  supply maintainer)
- No syzbot, no CVE, no kernel test robot

**Step 1.3: Body**
Record:
- **Bug:** `piix4_poweroff_ids[]` is wired into `pci_driver.id_table`
  but not published with `MODULE_DEVICE_TABLE()`, so modpost does not
  emit PCI aliases.
- **Symptom:** when `CONFIG_POWER_RESET_PIIX4_POWEROFF=m`, userspace
  (udev/modprobe) cannot match PCI `8086:7113` to the module, so the
  driver is not autoloaded and `pm_power_off` is never installed.
- **Version info:** none in the message. Driver added in 2016
  (`29676833df1d9`, first in v4.10-rc1).
- **Root cause:** missing module-alias publication, not a runtime logic
  error. Author states this is a **source-level** finding, not a
  hardware repro.

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** The message names the autoload failure directly.
It is a real functional bug even without a crash report.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- **File:** `drivers/power/reset/piix4-poweroff.c` — **+1 / −0**
- **Function:** none; one statement after `piix4_poweroff_ids[]`
- **Scope:** single-file, surgical

**Step 2.2: Code flow**
Record:
- **Before:** PCI ID table exists and is used for matching **after** the
  module is loaded (`id_table = piix4_poweroff_ids`). No
  `MODULE_DEVICE_TABLE`, so no `modules.alias` entry.
- **After:** `MODULE_DEVICE_TABLE(pci, piix4_poweroff_ids)` creates the
  alias symbol that `scripts/mod/file2alias.c` (`do_pci_entry`) turns
  into `MODULE_ALIAS("pci:v00008086d00007113...")`.
- **Path affected:** module metadata / autoload only. Probe, remove, and
  `piix4_poweroff()` are unchanged.

**Step 2.3: Bug mechanism**
Record: **[Hardware enablement / missing module alias]** — match table
present, alias not exported. Same class as adding a PCI ID for autoload.
Not UAF, leak, race, or crash.

**Step 2.4: Fix quality**
Record: **Obviously correct.** Canonical one-macro fix used across
`drivers/power/reset/`. No API, locking, or control-flow change.
**Regression risk: negligible** (build-time alias only).

## Phase 3: Git history

**Step 3.1: Blame**
Record: ID table introduced in **`29676833df1d9`** (“power: reset: Add
Intel PIIX4 poweroff driver”, Paul Burton, 2016-09-28). **`git describe
--contains`:** `v4.10-rc1~120^2~15`. The table never had
`MODULE_DEVICE_TABLE` until this commit. Bug is old, not recent churn.

**Step 3.2: Fixes: tag**
Record: **No Fixes: tag.** Buggy pattern is the original driver, not a
later regression. Introducing commit is an ancestor of this tree.

**Step 3.3: File history**
Record: Only a handful of commits on this file (`29676833df1d9` add,
SPDX, email, `MODULE_DESCRIPTION`, then this). **Standalone**, not patch
2/N. Sibling same-day commit `9da4152d376ca` (cw2015) is a parallel
autoload fix, not a prerequisite.

**Step 3.4: Author**
Record: Pengpeng Hou is not the subsystem maintainer; they have a series
of missing-`MODULE_DEVICE_TABLE` fixes (rtc, vdpa, watchdog, hwmon,
fbdev, this driver). Applied by **Sebastian Reichel**, power-
supply/reset maintainer.

**Step 3.5: Dependencies**
Record: **None.** Only needs `piix4_poweroff_ids` and
`MODULE_DEVICE_TABLE()`, both present here for years. Applies
standalone.

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- **Lore/msgid:**
  `https://patch.msgid.link/20260704152336.51384-1-pengpeng@iscas.ac.cn`
- **`b4 dig -a`:** **v1 only** (2026-07-04). No v2/v3.
- Maintainer reply 2026-07-21: **“Applied, thanks!”** (no requested
  changes).
- **No NAK, no stable nomination, no flagged risk.**
- lore.kernel.org HTTP fetch returned **403**; thread recovered via
  **`b4 dig -m`**.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: To Sebastian Reichel (`sre@kernel.org`); Cc `linux-
pm@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Right maintainer
and list.

**Step 4.3: Bug report**
Record: **No user/syzbot/bugzilla report.** Evidence is the source
mismatch (table used, not exported).

**Step 4.4: Series**
Record: Standalone 1/1. Parallel same-author autoload patches in other
drivers; this patch does not depend on them.

**Step 4.5: Stable list**
Record: **`site:lore.kernel.org/stable` search returned no hits.**
WebFetch to lore/stable also 403. **No evidence this was rejected for
stable.**

## Phase 5: Semantic / call-chain analysis

**Step 5.1: Functions**
Record: **No function body changed.** New use of `MODULE_DEVICE_TABLE`
next to `piix4_poweroff_ids`. Related runtime functions:
`piix4_poweroff_probe`, `piix4_poweroff_remove`, `piix4_poweroff`.

**Step 5.2: Callers**
Record: `piix4_poweroff_probe` / `remove` only via `module_pci_driver`.
`piix4_poweroff` assigned to `pm_power_off` in probe. No other in-tree
callers (`git grep`).

**Step 5.3: Callees**
Record: Probe uses `pci_request_region`, `pci_resource_start`. Poweroff
path uses PIO and `pci_bus_write_config_dword`. Unchanged by this patch.

**Step 5.4: Reachability**
Record: Userspace-reachable: PCI enumerate → autoload → probe →
`pm_power_off`. `reboot(LINUX_REBOOT_CMD_POWER_OFF)` then runs the
handler. **Without aliases, the module never loads**, so power-off via
this southbridge never registers. Config: `POWER_RESET_PIIX4_POWEROFF`
is **tristate**, `depends on PCI && HAS_IOPORT && (MIPS ||
COMPILE_TEST)` — mainly **MIPS Malta / QEMU Malta**.

**Step 5.5: Similar patterns**
Record: Same one-line fix already used in this directory (`gpio-
poweroff`, `keystone-reset`, `regulator-poweroff`, `at91-poweroff`, `zx-
reboot`, etc.). Established, not novel.

## Phase 6: This checkout

**Step 6.1: Buggy code in this tree?**
Record: **Yes.** File exists; pre-image at `ffefc5d9a052f^` has the ID
table and **no** `MODULE_DEVICE_TABLE`. Bug since **v4.10**. Current
tree already contains the fix (`git merge-base --is-ancestor
ffefc5d9a052f HEAD` succeeded). That is expected for a mainline checkout
of the originating commit, not a reason to treat the bug as absent from
this lineage.

**Step 6.2: Backport difficulty**
Record: **Clean apply** onto any tree that still has the original ID-
table block (verbatim in this file since 2016 aside from nearby module
macros). No refactor of this driver.

**Step 6.3: Related fixes already here?**
Record: **No earlier autoload fix** on this file. `b498ddb6f283c` only
added `MODULE_DESCRIPTION()`.

## Phase 7: Subsystem context

**Step 7.1:**
Record: **[drivers/power/reset] [PERIPHERAL]** — platform power-off, not
mm/VFS/net core. Still the whole purpose of this driver.

**Step 7.2:**
Record: Subsystem is active overall; **this file is mature and almost
untouched**. Long-standing omission, not a new-code fix.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: **Config- and platform-specific:**
`CONFIG_POWER_RESET_PIIX4_POWEROFF=m` on MIPS (Malta/QEMU) with Intel
PIIX4 PM **8086:7113**. Built-in (`=y`) already works without aliases.
Distros that ship this as a module are the users who benefit.

**Step 8.2: Trigger**
Record: Boot with the PCI device present and the driver as a module,
without a manual `modprobe`. Common for modular distro kernels; **not**
a race. Unprivileged users do not need to trigger it for it to matter —
missing autoload means **power-off never gets hooked**.

**Step 8.3: Failure mode**
Record: **[Module never loads → `pm_power_off` not set by this driver →
`poweroff` does not cut board/QEMU power]**
**Severity: MEDIUM** (functional, not oops/corruption). For this driver
that *is* the user-visible bug.

**Step 8.4: Risk vs benefit**
Record:
- **Benefit:** medium for the small MIPS Malta/QEMU population (driver
  actually loads).
- **Risk:** very low (one metadata macro).
- **Ratio:** favorable. Same bar as PCI ID additions, which stable
  explicitly allows.

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For:**
- Real autoload bug: ID table used, not exported.
- One line, canonical, maintainer-applied v1.
- Driver in this tree since v4.10; no extra commits required.
- Device-ID / hardware-enablement exception: userspace cannot bind the
  existing PCI ID.
- Zero runtime behavior change once the module is loaded.
- Same fix already used throughout `drivers/power/reset/`.

**Against:**
- Not a crash, UAF, deadlock, or security hole.
- Niche (`MIPS || COMPILE_TEST`), old PIIX4/Malta.
- No hardware repro, no `Reported-by`.
- Only matters for `=m`, not `=y`.

**Unresolved:** lore.kernel.org HTTP 403 (thread still obtained via `b4
dig`); no stable-list thread found.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — one well-known macro;
   maintainer applied v1.
2. Real bug affecting users? **PASS** — modular autoload/power-off fails
   on matching PCI.
3. Important (crash/security/corruption/deadlock)? **PASS via device-ID
   exception** — enables existing hardware; failure mode is “power-off
   driver never attaches,” which is this driver’s job. Not a panic.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS** — publishes an ID table that already
   exists.
6. Can apply to this tree? **PASS** — file and table match the pre-
   image; no missing helpers.

**Step 9.3: Exception category**
Record: **Device ID / module autoload (hardware enablement).** Closest
documented exception: new device IDs on an existing driver. Here the ID
is already in the driver; only the userspace alias was missing.

**Step 9.4: Decision**
The local 7.3-rc4 tree has this driver and the long-standing omission.
The patch is a zero-risk, one-line autoload fix that makes the existing
PCI match actually load the module. That is appropriate to take into
this tree’s stable-style line.

### What it solves for users of this tree
With `CONFIG_POWER_RESET_PIIX4_POWEROFF=m`, udev cannot load
`piix4-poweroff` for Intel 82371AB PM (`8086:7113`). Probe never runs,
`pm_power_off` is not set, and Malta/QEMU-style power-off does not work
unless the module is loaded by hand. `MODULE_DEVICE_TABLE(pci,
piix4_poweroff_ids)` is the required alias export.

### Risk vs benefit
Benefit is restoring the driver’s purpose on modular MIPS configs. Risk
is essentially none: no runtime path, lock, or ABI change.

---

**Verification:**
- **[Phase 1]** Parsed message/tags: no Fixes/Reported-by/Cc:stable;
  Link msgid; SOBs Hou + Reichel
- **[Phase 2]** Diff: +1 line `MODULE_DEVICE_TABLE(pci,
  piix4_poweroff_ids)` in `piix4-poweroff.c`
- **[Phase 2]** Confirmed `MODULE_DEVICE_TABLE` in
  `include/linux/module.h` creates the alias symbol;
  `scripts/mod/file2alias.c` `do_pci_entry` emits `pci:v...d...` aliases
- **[Phase 3]** `git blame`: ID table from `29676833df1d9` (Paul Burton,
  2016); MDT line from `ffefc5d9a052f`
- **[Phase 3]** `git describe --contains 29676833df1d9` →
  `v4.10-rc1~120^2~15`
- **[Phase 3]** `git log --oneline --
  drivers/power/reset/piix4-poweroff.c`: no other autoload fix
- **[Phase 3]** `git merge-base --is-ancestor ffefc5d9a052f HEAD` → yes
  (commit is in this tree)
- **[Phase 3]** Pre-image `git show ffefc5d9a052f^:...` matches the
  patch context exactly
- **[Phase 4]** `b4 dig -c ffefc5d9a052f`: msgid
  `20260704152336.51384-1-pengpeng@iscas.ac.cn`
- **[Phase 4]** `b4 dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: To Sebastian Reichel; Cc linux-pm, linux-
  kernel
- **[Phase 4]** `b4 dig -m /tmp/piix4-mdt.mbox`: maintainer “Applied,
  thanks!”; no NAK/stable discussion
- **[Phase 4]** lore HTTP 403; stable web search: no hits —
  **UNVERIFIED: full lore HTML; verified via mbox**
- **[Phase 5]** `git grep piix4_poweroff`: only this file; probe sets
  `pm_power_off`
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`
- **[Phase 6]** Kconfig: tristate, `depends on PCI && HAS_IOPORT &&
  (MIPS || COMPILE_TEST)`
- **[Phase 6]** `PCI_DEVICE_ID_INTEL_82371AB_3` = `0x7113` in
  `include/linux/pci_ids.h`
- **[Phase 8]** Failure mode: missing autoload → power-off handler never
  registered; MEDIUM, not oops

**UNVERIFIED:** Direct lore.kernel.org page content (403). Does not
change the verdict; mbox has the full v1 + apply mail.

**YES**

 drivers/power/reset/piix4-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/piix4-poweroff.c b/drivers/power/reset/piix4-poweroff.c
index e6822c0210000..1a6f3d22d2974 100644
--- a/drivers/power/reset/piix4-poweroff.c
+++ b/drivers/power/reset/piix4-poweroff.c
@@ -96,6 +96,7 @@ static const struct pci_device_id piix4_poweroff_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(pci, piix4_poweroff_ids);
 
 static struct pci_driver piix4_poweroff_driver = {
 	.name		= "piix4-poweroff",
-- 
2.53.0

