Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE5E5BD60A;
	Mon, 19 Oct 2026 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418465; cv=none; b=f1s2onl0EhUYQ3vNjWAYrzQsg5UvIgLpcSu2oz35RE3OMAi+NHGkCUyNoaJ5U49N6zLlSq062Khe7fOd8rxCZYhUSCmVZ8KAhNt9l60QYeb0cVmBDyptTrCNpyF/k9/bSVbSa1R4a7zQwcldrSahUQRcD6k/oo2COCxZefmE4EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418465; c=relaxed/simple;
	bh=hRSGPTkLw54cTZJsbX+sj2cXA0YyEva62KGimZnJL9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9vYO9jMkp/59oQhgQ2QXOM14kkUYLJO5TuxMAqSAN7tYX7F/9VBn3KueWoq2NsyG9FEPLllt8xZq1fQDB7gK8WrkBHXvZStdVSjGU34ySjAtiJyd3YmOr/Rg5ODW8v6h2BQ87kjWWJq4pJLPXKtTjeiXMJTZxKgFUiDJIvKe40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mV0F92pW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mV0F92pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D261F000C7;
	Mon, 19 Oct 2026 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418463;
	bh=e+MnSU7zP3D5FT+usb4x8OWXQd7SGnkkQ975jMjPpas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mV0F92pWj4cUMVp8xam3I6mPV1gcq7RxtKWH9EaVYTrmYqZtWi5MSTa8fwJtAO7WT
	 T2TfSpuT7pgO0TgWyCl1ZvCk5RrjjNlNRm09WNB8cxUrq9WpOGe1YZZJk+LnskJtbY
	 g22HonKC5rtM0uGyyQOhj6/wp3vATBnrm3ubmWHjtICJAoEa1KFdJ+Qq13VBLM2IVt
	 D/RrZVTiIPhmYe+TiszPcybCo0H3NQsdP5M8LDHn34cHH0fTIs4dKwhrs9aAKWuv+B
	 bnf1MoEjfmHRaa2F3Udo8KZdTtAzYPSgtHFzpZgcKCbt9jTjtJmejxbQ+aiQ1p95qN
	 L3enKTirOZKsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	abelvesa@kernel.org,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	Frank.Li@nxp.com,
	linux-clk@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:49:17 -0400
Message-ID: <20261019135441.1420968-266-sashal@kernel.org>
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

[ Upstream commit cd21fdcbef3fb32136f72075ab668b075423b3f6 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[clk/imx]** **[add]** missing `MODULE_DEVICE_TABLE()` so the
i.MX8QXP SCU clock driver’s OF match table is exported as module
aliases.

**Step 1.2 — Tags**
Record:
- `Reviewed-by: Brian Masney <bmasney@redhat.com>`
- `Link:
  https://patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>` (clk/imx
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Acked-by:`, or `Cc:
  stable` (absence of the last two is expected for this review)

**Step 1.3 — Body**
Record: The driver already has `imx8qxp_match[]` wired as
`of_match_table`, but it never called `MODULE_DEVICE_TABLE(of, …)`.
Without that, modpost/`file2alias` does not emit `of:N*T*C…` aliases, so
udev/`modprobe`/initramfs tools cannot autoload `clk-imx-scu` from DT
compatible strings. Failure mode: modular `CONFIG_CLK_IMX8QXP=m` does
not bind on `fsl,scu-clk` / `fsl,imx8qxp-clk` / `fsl,imx8qm-clk` /
`fsl,imx8dxl-clk`. The author presents this as a source-level
correctness fix, not a live hardware repro. No version range is given.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised. It is an explicit completeness fix for module
alias publication. That is a real functional bug for `=m` builds, not
style cleanup.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: One file, `drivers/clk/imx/clk-imx8qxp.c`, **+1 / -0**. One
insertion after `imx8qxp_match[]`. Surgical single-file change.

**Step 2.2 — Code flow**
Record: **Before:** `imx8qxp_match[]` is only referenced by
`imx8qxp_clk_driver.driver.of_match_table` (bind-time matching if the
module is already loaded). **After:** the same table is also aliased for
modpost (`__mod_device_table__kmod_*__of__imx8qxp_match`), which
produces OF module aliases. No probe, init, or error-path logic changes.

**Step 2.3 — Bug mechanism**
Record: **Hardware/module-autoload omission** (same class as missing
device IDs). The OF table existed; aliases were not published.
`MODULE_DEVICE_TABLE` is the required export so
`scripts/mod/file2alias.c` `do_of_entry()` can emit aliases.

**Step 2.4 — Fix quality**
Record: Obviously correct: same pattern as `clk-imx8mm.c`
(`MODULE_DEVICE_TABLE(of, imx8mm_clk_of_match)`) and the sibling LPCG
driver. Minimal, no API/data-structure change. Regression risk is
essentially none: for `=y` the extra alias symbol is unused at runtime;
for `=m` it only adds `modules.alias` entries.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Match table introduced in `c2cccb6d0b33b` (2018, original
driver). Modular build introduced in `e0d0d4d86c766` (“Support building
i.MX8QXP clock driver as module”, 2020-08-22, first in **v5.9**). That
is when `MODULE_DEVICE_TABLE` became necessary and was omitted. Bug is
long-standing, not recent.

**Step 3.2 — Fixes: tag**
Record: None. The introducing commit is `e0d0d4d86c766`; it is an
ancestor of this HEAD.

**Step 3.3 — File history**
Record: Immediate neighbor `e89485455ac49` (`clk: imx: imx8qxp-lpcg: add
missing MODULE_DEVICE_TABLE()`) is the same author/pattern on the LPCG
sibling. Independent 1-line fix; this patch does not depend on it. Other
recent file history (`aadb7d1f2ca0f` softdep on `scu_pd`) is unrelated.

**Step 3.4 — Author**
Record: Pengpeng Hou submitted a cluster of clk `MODULE_DEVICE_TABLE`
additions (imx8qxp, imx8qxp-lpcg, mediatek mt6735). Not the clk/imx
maintainer. Maintainer Abel Vesa applied it; Brian Masney reviewed.

**Step 3.5 — Dependencies**
Record: None. Needs only `imx8qxp_match[]` and `MODULE_DEVICE_TABLE`
from `<linux/module.h>`, both present. Standalone.

---

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record: `b4 dig -c cd21fdcbef3fb` →
https://patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn
`b4 dig -a`: single **v1**, no later revisions.
Thread (gnuweeb mirror; lore.kernel.org returned 403): Brian Masney
`Reviewed-by`; Abel Vesa “Applied, thanks!” as `cd21fdcbef3fb`. No NAK,
no stable nomination, no risk flags.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Abel Vesa, Peng Fan, Stephen Boyd, Michael Turquette, Frank Li,
Sascha Hauer, Fabio Estevam, linux-clk, imx@lists.linux.dev, linux-arm-
kernel. Correct maintainers and lists.

**Step 4.3 — Bug report**
Record: No `Reported-by` / syzbot / bugzilla. Evidence is the match
table vs missing export. Pull text for clk-imx 7.3 lists “Add missing
MODULE_DEVICE_TABLE() declarations for i.MX8QXP clock drivers.”

**Step 4.4 — Series**
Record: Standalone `[PATCH]`, not `N/M`. Sibling LPCG patch is parallel
and not a prerequisite.

**Step 4.5 — Stable list**
Record: gnuweeb `/stable/?q=imx8qxp+MODULE_DEVICE_TABLE` did not show a
dedicated discussion of this patch (hits were unrelated imx8 noise).
lore.kernel.org/stable returned 403.

---

## Phase 5: Code semantics

**Step 5.1 — Functions**
Record: No function body changed. Data: `imx8qxp_match[]`. Related:
`imx8qxp_clk_driver`, `imx8qxp_clk_init()`, `imx8qxp_clk_probe()`.

**Step 5.2 — Callers**
Record: `imx8qxp_clk_init()` (`module_init`) →
`platform_driver_register(&imx8qxp_clk_driver)`. Probe runs when OF
compatible matches. Autoload is what was broken: without aliases the
module may never load, so probe never runs.

**Step 5.3 — Callees**
Record: Probe calls `imx_clk_scu_init()`, many
`imx_clk_scu`/`imx_clk_scu2`, `of_clk_add_hw_provider()`. Unchanged.

**Step 5.4 — Reachability**
Record: Userspace-reachable only in the sense that missing aliases
prevent the module from being requested. Affects i.MX8QXP/QM/DXL boards
with `CONFIG_CLK_IMX8QXP=m`. DT compatibles: `fsl,scu-clk`,
`fsl,imx8dxl-clk`, `fsl,imx8qxp-clk`, `fsl,imx8qm-clk`.

**Step 5.5 — Similar patterns**
Record: Other imx clk files already had `MODULE_DEVICE_TABLE(of, …)`
(`clk-imx8mm.c`, `clk-imx8mn.c`, `clk-imx8mp.c`, `clk-imx8mq.c`, `clk-
imx8-acm.c`, etc.). This file was the omission.

---

## Phase 6: Local tree

**Step 6.1 — Does the buggy code exist here?**
Record: Local tree is **v7.3-rc4** (`git describe` =
`v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`). `CLK_IMX8QXP` is **tristate**. File has
`imx8qxp_match[]`, `module_init`/`module_exit`, and (after this commit)
`MODULE_DEVICE_TABLE`. The omission existed from v5.9 until this 7.3-era
commit. `git merge-base --is-ancestor cd21fdcbef3fb HEAD` is true — the
fix is already in this checkout; the underlying driver and match table
are present.

**Step 6.2 — Backport difficulty**
Record: Clean apply: one line after the sentinel of `imx8qxp_match[]`.
No refactor of that region.

**Step 6.3 — Related fixes already here?**
Record: Sibling LPCG table already has `MODULE_DEVICE_TABLE`. No earlier
equivalent for `clk-imx8qxp.c`. No competing fix.

---

## Phase 7: Subsystem / maintainer

**Step 7.1**
Record: **clk / i.MX SoC clocks**. **IMPORTANT** for i.MX8QXP/QM/DXL
(clock provider for the SoC), not core mm/vfs. Peripheral relative to
the whole kernel, critical on those boards.

**Step 7.2**
Record: Actively maintained (`clk-imx-7.3` pull by Abel Vesa). The
missing alias is old; the rest of the file is mature.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: **Platform/config-specific**: NXP i.MX8QXP/QM/DXL with
`CONFIG_CLK_IMX8QXP=m`. Built-in (`=y`) is unchanged.

**Step 8.2 — Trigger**
Record: Modular kernel + DT node with those compatibles + autoload via
aliases (udev, `request_module`, dracut/mkinitramfs). Common for distro
`=m` configs. Unprivileged users do not trigger it; boot/device-probe
does.

**Step 8.3 — Failure mode**
Record: Module never autoloads → SCU clocks never register → consumers
fail to probe (UART, net, display, etc.). **MEDIUM–HIGH** on affected
boards; not a panic/UAF. For `=y`, **no effect**.

**Step 8.4 — Risk vs benefit**
Record: **Benefit:** restores documented autoload for a supported
tristate clock driver. **Risk:** very low (1 line, no runtime path).
Ratio is strongly favorable.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real bug: OF match table not exported; aliases missing for a
  `tristate` driver with `module_init`.
- Same pattern already used throughout `drivers/clk/imx/`.
- 1-line, obviously correct; maintainer applied; Reviewed-by Brian
  Masney.
- Zero runtime change when built-in.
- Analogous to device-ID additions (exception category: make existing
  hardware/driver work).
- Bug present since v5.9 modular support (`e0d0d4d86c766`).
- Applies cleanly to this tree’s `imx8qxp_match[]`.

AGAINST:
- No crash/syzbot/user report; source-level only.
- Impact limited to `CLK_IMX8QXP=m` (many images use `=y`).
- Not a security/UAF/deadlock class bug.

UNRESOLVED:
- Could not fetch lore.kernel.org (403); used b4 + gnuweeb/LKML mirrors
  instead.
- No dedicated stable-list thread found.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — 1-line standard macro;
   reviewed and applied by clk/imx.
2. Real bug affecting users? **PASS** — `=m` autoload/initramfs alias
   generation is broken without it.
3. Important? **PASS** — SoC clock provider failing to load breaks the
   platform; severity is functional, not panic, but that is enough for
   this class of fix.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS** — publishes existing table.
6. Can apply to this tree? **PASS** — match table, `linux/module.h`, and
   modular Kconfig are all here.

**Step 9.3 — Exception category**
Record: Closest match is **device-ID / module-alias enablement** for an
existing driver (not a new driver).

**Step 9.4 — Decision**
This tree is mainline **7.3-rc4**. The driver, OF table, and tristate
module support are here; the fix is a one-line alias export with no
runtime risk. That meets stable criteria for this checkout.

---

### Problem and why it matters
`clk-imx8qxp.c` can be `=m` since v5.9 and already matches DT via
`imx8qxp_match[]`, but never published that table with
`MODULE_DEVICE_TABLE()`. Users with modular i.MX8QXP/QM/DXL kernels do
not get `of:` aliases, so the clock module may not autoload and
consumers never get clocks.

### Stable rules
Small, obviously correct, no new API, real autoload bug, applies to this
tree.

### Risk vs benefit
Benefit is correct module loading on a supported config; risk is
negligible.

### Concerns
No hardware repro and no `Fixes:` tag; neither blocks this pattern.
Sibling LPCG patch is independent.

---

Verification:
- [Phase 1] Parsed tags: Reviewed-by Brian Masney; Link
  patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn; SOBs Hou
  and Abel Vesa; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of, imx8qxp_match)` in
  `drivers/clk/imx/clk-imx8qxp.c`; no function body change
- [Phase 3] `git blame`: table from `c2cccb6d0b33b` (2018); modular
  support `e0d0d4d86c766` (v5.9) introduced the need for aliases
- [Phase 3] `git merge-base --is-ancestor e0d0d4d86c766 HEAD`: yes; `git
  merge-base --is-ancestor cd21fdcbef3fb HEAD`: yes
- [Phase 3] Neighbor `e89485455ac49` is independent LPCG
  MODULE_DEVICE_TABLE add
- [Phase 4] `b4 dig -c cd21fdcbef3fb`: matched v1 at that msgid; `-a`
  only v1; `-w` listed clk/imx and linux-clk recipients
- [Phase 4] gnuweeb thread: Masney Reviewed-by; Vesa Applied as
  cd21fdcbef3fb; no NAK
- [Phase 4] lore.kernel.org fetch: 403; used mirrors
- [Phase 5] `CLK_IMX8QXP` is tristate in `drivers/clk/imx/Kconfig`;
  built as `clk-imx-scu` via Makefile; `module_init(imx8qxp_clk_init)`
  registers the platform driver
- [Phase 5] `scripts/mod/file2alias.c` `do_of_entry()` emits
  `of:N*T*C<compatible>` from MODULE_DEVICE_TABLE
- [Phase 5] Sibling `clk-imx8mm.c` already uses the same macro
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4; file currently contains the added line
- [Phase 6] Apply difficulty: one line after existing `imx8qxp_match[]`
- [Phase 8] Failure mode: modular clock provider not autoloaded;
  severity MEDIUM–HIGH on those SoCs, none if `=y`
- UNVERIFIED: live udev/initramfs failure on hardware (author did not
  claim a runtime repro); stable-list discussion beyond the gnuweeb
  search

**YES**

 drivers/clk/imx/clk-imx8qxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 3ae162625bb1a..15b08fc02f920 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -337,6 +337,7 @@ static const struct of_device_id imx8qxp_match[] = {
 	{ .compatible = "fsl,imx8qm-clk", &imx_clk_scu_rsrc_imx8qm, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_match);
 
 static struct platform_driver imx8qxp_clk_driver = {
 	.driver = {
-- 
2.53.0

