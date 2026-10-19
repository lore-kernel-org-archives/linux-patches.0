Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3CF628617;
	Mon, 19 Oct 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418703; cv=none; b=IgstNaxQhsc1dBckxA3ZMF9pDN0Do0hFnUtZOoU2IKR6YiCtPpkS44NtHRBrl6ymDh+RfNbEBtiDS8Du3rIfRnkXCKJ3BdU8jksg2InmpXaB0qxoLSqGkV8oMfu3f5W9cYT4Ol5W2p4dZdHbaF9+PINTH87tvVqyVqmKQjT7D7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418703; c=relaxed/simple;
	bh=fsNJEv92VqApu4MDiXNnLuv16Emx+3YEMvYHfZNcigI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAsksoN2qF4IfZIAaKS9ZUCz4YVahv49mc45FTH6H2zrRkW+ZuOMl7qMqKmCakPKcLT4JdynbGmmWfhNKWXoqezH5jHePbRncc1Y6RhJ2KjJ+pSt+XVOy1gVMGOSf/q4rv1XsBJiDWyUc0a58P+C/M725Pl34TbGUNHAvC0WBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOdz1It6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOdz1It6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F80B1F000C7;
	Mon, 19 Oct 2026 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418700;
	bh=uAAs1xRU044mRxttfqo0JbA6ZXpm2L7A9MFCtgdteys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOdz1It6o+LOIsKL/OAu0yUA+iKE7u/051aWZrFRUGoxAYLmAqlaeR3p8+9hvVdgh
	 OzPnH0V2Okq1hZKV/SskmBG2af6H6f7jZUb0LPBJyEh0Takr03G2Ic0XL8BshXjbbr
	 4kkEogjv774YIYhAPWEUGC5SAcRnBXnVOdQ8SZ30Po/uLTLSlX9XO5/GUTZPbROrwh
	 qEj2bIM5WbaWsEpqU0iwo/3gbZy/u2oprWpLC/KokONuYDhpi5HmysuyYZuvx7U8Xx
	 e6Zzge87snJmV7J8kWU5+hEB3mfwJhV0WGeRN3JHyH0w6rFwt/CLXjHTQMs7sOY5i5
	 IUlc0vBRuktiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	abelvesa@kernel.org,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-clk@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:52:05 -0400
Message-ID: <20261019135441.1420968-434-sashal@kernel.org>
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

[ Upstream commit e89485455ac49925565061733c0d73d568333fc0 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260704150344.59563-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **v7.3-rc4-27-gf0100363d8c37** (`VERSION=7 PATCHLEVEL=3
SUBLEVEL=0 EXTRAVERSION=-rc4`). The candidate is `e89485455ac49` (`clk:
imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()`). The file and
match table exist here; the one-line fix applies as written.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
- Record: `[clk: imx: imx8qxp-lpcg] [add] [export OF match table via
  MODULE_DEVICE_TABLE so module aliases are generated]`

**Step 1.2 — Tags**
- Record:
  - `Reviewed-by: Frank Li <Frank.Li@nxp.com>` (i.MX)
  - `Reviewed-by: Brian Masney <bmasney@redhat.com>` (Red Hat / clk)
  - `Reviewed-by: Peng Fan <peng.fan@nxp.com>` (i.MX clk)
  - `Link: https://patch.msgid.link/20260704150344.59563-1-
    pengpeng@iscas.ac.cn`
  - `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
  - `Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>` (clk-imx
    maintainer, applied it)
  - No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence expected)
  - Ignore any Sasha Levin SOB if present (none on the real commit)

**Step 1.3 — Body**
- Record: The OF match table is wired into `platform_driver` but not
  published with `MODULE_DEVICE_TABLE()`. Without that, modpost does not
  emit `of:` aliases, so kmod/udev cannot autoload the module from DT
  compatible strings.
- Symptom: `CONFIG_CLK_IMX8QXP=m` → LPCG clock module does not load from
  DT; consumers never get those clocks unless the module is loaded by
  hand.
- Version info: none in the message.
- Root cause: missing alias publication, not a runtime logic bug. Author
  states it is a source-level finding, not a live hardware repro.

**Step 1.4 — Hidden bug fix?**
- Record: Not disguised. It is a real autoload/modalias bug stated
  plainly. The “source-level” wording means it was found by inspection,
  not that it is theoretical: the table is used and not exported.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Record: `drivers/clk/imx/clk-imx8qxp-lpcg.c` — **+1 / −0**. One line
  after `imx8qxp_lpcg_match[]`. Surgical, single-file.

**Step 2.2 — Flow**
- Record: Before: `imx8qxp_lpcg_match` is only `of_match_table` (used
  after the module is already loaded). After: same table is also a
  `MODULE_DEVICE_TABLE(of, …)` so file2alias/modpost emits aliases at
  build time. No probe/runtime path change.

**Step 2.3 — Bug mechanism**
- Record: **Hardware/module autoload (OF alias publication)**. Match
  table exists (`fsl,imx8qxp-lpcg-adma/conn/lsio` and `fsl,imx8qxp-
  lpcg`) but is not exported. Same class as adding device IDs: userspace
  cannot match hardware to the module.

**Step 2.4 — Fix quality**
- Record: Obviously correct; matches every other i.MX clk driver that
  already has `MODULE_DEVICE_TABLE(of, …)` (`clk-imx8qxp.c`, `clk-
  imx8mm.c`, etc.). No API, locking, or structural change. Regression
  risk is negligible: `=y` ignores aliases; `=m` only adds autoload.

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
- Record: Match table from `1e3121bfe51a3` (“clk: imx: add imx8qxp lpcg
  driver”, 2018, in **v5.0-rc1**). Module metadata from `e0d0d4d86c766`
  (“Support building i.MX8QXP clock driver as module”, **v5.10-rc1**).
  `builtin_platform_driver` → `module_platform_driver` in
  `eee377b8f44e7` (2021, Fixes: that module-support commit). The hole
  has been there for the whole modular lifetime of the driver.

**Step 3.2 — Fixes: tag**
- Record: None. Buggy omission is the module-support work
  (`e0d0d4d86c766` / `eee377b8f44e7`). Both are in this tree.

**Step 3.3 — File history**
- Record: Recent file commits are unrelated (pm_runtime, ioremap).
  Sibling `cd21fdcbef3fb` does the same for `clk-imx8qxp.c`. Standalone;
  not “patch X/Y”.

**Step 3.4 — Author**
- Record: Pengpeng Hou also added the same fix for `clk-imx8qxp.c` and
  MediaTek mt6735 clocks. Not the clk-imx maintainer; Abel Vesa applied
  it with three subsystem/vendor reviews.

**Step 3.5 — Dependencies**
- Record: Needs `imx8qxp_lpcg_match`, `module_platform_driver`, and
  `<linux/module.h>`. All present here. Applies as a single line.

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original thread**
- Record: `b4 dig -c e89485455ac49` →
  https://patch.msgid.link/20260704150344.59563-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only**, 2026-07-04.
- Review: Peng Fan, Brian Masney, Frank Li: Reviewed-by only. Abel Vesa:
  “Applied, thanks!” No NAK, no stable tag, no risk discussion.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Abel Vesa, Peng Fan, Michael Turquette, Stephen Boyd, Frank
  Li, Sascha Hauer, Fabio Estevam; `linux-clk`, `imx@lists.linux.dev`,
  `linux-arm-kernel`, `linux-kernel`. Right maintainers and lists.

**Step 4.3 — Bug report**
- Record: No Reported-by / bugzilla / syzbot. Inspection-only, as the
  commit says.

**Step 4.4 — Series**
- Record: Standalone 1/1. Related but independent sibling on `clk-
  imx8qxp.c`.

**Step 4.5 — Stable list**
- Record: Thread has no stable nomination. Direct lore.kernel.org
  fetches returned **403**; no separate stable-list discussion verified.

---

## PHASE 5: CODE SEMANTICS

**Step 5.1 — Functions**
- Record: No C function changed. Macro `MODULE_DEVICE_TABLE(of,
  imx8qxp_lpcg_match)` next to the existing `of_device_id` table. Driver
  still uses `module_platform_driver(imx8qxp_lpcg_clk_driver)`.

**Step 5.2 — “Callers”**
- Record: Build-time: `scripts/mod/file2alias.c` looks up
  `__mod_device_table__` and emits `of:` aliases. Runtime: kmod/udev on
  DT `compatible`. Probe path unchanged. Makefile: `clk-imx-lpcg-
  scu-$(CONFIG_CLK_IMX8QXP)` → aliases belong to `clk-imx-lpcg-scu.ko`.

**Step 5.3 — Callees**
- Record: None at runtime. Macro only creates an aliased copy of the
  table for modpost.

**Step 5.4 — Reachability**
- Record: Yes, from userspace/DT: i.MX8QXP/8QM DTS uses `fsl,imx8qxp-
  lpcg` (e.g. `arch/arm64/boot/dts/freescale/imx8qm-ss-*.dtsi`). With
  `=m`, udev should load the module from that compatible. `arm64
  defconfig` has `CONFIG_CLK_IMX8QXP=y`, so the default distro/defconfig
  path is unaffected; custom/distro `=m` is the affected path.

**Step 5.5 — Similar patterns**
- Record: Same missing-table pattern fixed in `clk-imx8qxp.c` and
  several other `drivers/clk/imx/*` files already have
  `MODULE_DEVICE_TABLE`. This was the LPCG outlier.

---

## PHASE 6: THIS TREE

**Step 6.1 — Buggy code here?**
- Record: Yes. Pre-commit parent still has the table without
  `MODULE_DEVICE_TABLE`. Module support is in this tree. Bug dates to
  v5.10 module support (autoload hole after v5.16
  `module_platform_driver`).

**Step 6.2 — Backport difficulty**
- Record: **Clean apply**. Context around the match table matches the
  hunk.

**Step 6.3 — Already fixed another way?**
- Record: No other autoload fix on this file. This commit *is* the fix
  (already upstream in 7.3-rc). No substitute.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
- Record: `[drivers/clk/imx — i.MX8QXP LPCG] [IMPORTANT for
  i.MX8QXP/8QM; PERIPHERAL vs core kernel]`. Clock provider: if the
  module never loads, LPCG-gated peripherals fail probe.

**Step 7.2**
- Record: clk-imx is active (7.3 pulls). This driver itself is mature
  (2018).

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who**
- Record: Config- and platform-specific: `CONFIG_CLK_IMX8QXP=m` on
  i.MX8QXP/8QM/8DXL SCU clocks. Not universal. Defconfig `=y` does not
  need aliases.

**Step 8.2 — Trigger**
- Record: Boot/enumeration with LPCG DT nodes and the driver as a
  module. Unprivileged users cannot trigger it; it is bring-up/udev.
  Common on modular distro kernels, uncommon on typical vendor `=y`
  images.

**Step 8.3 — Failure mode**
- Record: Module not autoloaded → LPCG clocks missing → dependent
  devices fail probe (UART/DMA/etc. depending on board). Not an
  oops/UAF. Severity **MEDIUM** (functional miss for `=m`), **HIGH** on
  those boards if clocks are modular.

**Step 8.4 — Risk vs benefit**
- Record: Benefit: modular i.MX8QXP clocks actually bind. Risk: **very
  low** (one line of metadata). Ratio favors taking it; same rationale
  as the “add a device ID” stable exception.

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

For:
- Real autoload bug: match table used, aliases not published.
- One line, obviously correct, reviewed by NXP i.MX and Red Hat.
- DT hardware uses these compatibles.
- Driver is tristate (`CLK_IMX8QXP`); `module_platform_driver` is
  intentional.
- Same pattern as device-ID publication, which stable explicitly allows.
- Applies cleanly; no new API; no runtime behavior change for `=y`.

Against:
- No user/syzbot report; source-level only.
- Not crash/corruption/security.
- `arm64 defconfig` is `=y`.
- No `Cc: stable` (not a negative by itself).

Unresolved:
- Could not search lore.kernel.org/stable (HTTP 403). Original thread
  had no stable discussion.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — one-line, three reviews,
   maintainer applied.
2. Real bug that affects users? **PASS** — `=m` does not autoload; DTS
   uses the IDs.
3. Important? **PASS** (as device-ID/autoload class; not a panic).
   Missing clocks on modular i.MX8 is user-visible, not trivia.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS** — metadata only.
6. Can apply to this tree? **PASS** —
   file/table/`module_platform_driver` all present.

**Step 9.3 — Exceptions**
- Record: Device-ID / module-alias publication for an existing driver
  (stable exception #1 in spirit).

**Step 9.4 — Decision**
This is a one-line, reviewed autoload fix for a long-standing modular
i.MX8QXP LPCG driver. It matches what stable already takes for device
IDs: hardware described in DT can bind without a manual `modprobe`. Risk
is negligible on this tree.

---

## What the commit solves for this tree

Without `MODULE_DEVICE_TABLE()`, `clk-imx-lpcg-scu.ko` has no
`of:N*T*Cfsl,imx8qxp-lpcg*` aliases. kmod will not load it from DT. LPCG
is a clock provider, so that shows up as missing clocks and failed
consumer probe, not as a crash. The fix only publishes the table the
driver already uses.

It meets the stable bar: obviously correct, tiny, no new API, real
modular-load bug, applies here.

Risk vs benefit: benefit is correct autoload for `CONFIG_CLK_IMX8QXP=m`;
risk is essentially zero.

Concerns: no live repro, default `=y`. That does not outweigh a one-line
alias export that other i.MX clk drivers already have.

---

## Verification
- [Phase 1] `git log -1 e89485455ac49`: tags as above; no
  Fixes/Reported-by/Cc:stable.
- [Phase 2] `git show e89485455ac49`: +1 `MODULE_DEVICE_TABLE(of,
  imx8qxp_lpcg_match)`.
- [Phase 2] Read `clk-imx8qxp-lpcg.c`: table used as `.of_match_table`;
  `module_platform_driver`.
- [Phase 2] `include/linux/module.h`: macro creates `__mod_device_table`
  alias for modpost.
- [Phase 3] `git blame` 350–370: table `1e3121bfe51a3` (v5.0); line
  `e89485455ac49`.
- [Phase 3] `e0d0d4d86c766` in v5.10-rc1 (tristate); `eee377b8f44e7`
  switches to `module_platform_driver`.
- [Phase 3] `git merge-base --is-ancestor e89485455ac49 HEAD` succeeded.
- [Phase 3] Parent file confirmed missing `MODULE_DEVICE_TABLE`.
- [Phase 4] `b4 dig -c/-a/-w` and `b4 dig -m`: v1 thread, three R-b,
  Abel applied; To/Cc = clk + i.MX lists.
- [Phase 4] lore HTTP 403; stable-list search **UNVERIFIED**.
- [Phase 5] `Kconfig`: `CLK_IMX8QXP` tristate; Makefile builds `clk-imx-
  lpcg-scu`.
- [Phase 5] DTS: `fsl,imx8qxp-lpcg` in imx8qm-ss-*.dtsi.
- [Phase 5] defconfig: `CONFIG_CLK_IMX8QXP=y`.
- [Phase 6] `git describe HEAD` / `make kernelversion`: 7.3.0-rc4; buggy
  table present; clean apply.
- [Phase 6] Sibling `cd21fdcbef3fb` is a different file; not required
  for this hunk.
- [Phase 8] Failure mode: no autoload when `=m` — verified from code and
  MODULE_DEVICE_TABLE semantics, not from a hardware log.
- UNVERIFIED: live `=m` boot on i.MX8QXP; lore.kernel.org/stable
  contents.

**YES**

 drivers/clk/imx/clk-imx8qxp-lpcg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index 1dae3410ee99a..f0cf6cf918992 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -354,6 +354,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0

