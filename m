Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68250EC0D;
	Mon, 19 Oct 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418105; cv=none; b=DQlmxkexetOt8i+Bsv4llclhVoUi+tNQgqriaOo20WX5yUq5pk9Tuewvy+CFWRXTnmHHXAPE7ZUzetO1HosZFZscpO/ZtEtOF7BeCBvfa3TRYQhKa4VzpI0CJFbtgIJy/HWb6H0KlVeVuN1bKBQas3PtXnRtADlkIha+7ZaOVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418105; c=relaxed/simple;
	bh=dRKtZiqV8VSzXaZcx6dKZKMWSLuN2sC5YxHYVua8wOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5Ia3Byz0o6dskjGDzd2I0ErgzWF5Ho0+XJGLD9irulwS+a4Fe35kqZmeaNmwTXcPugdX7YZL1ueHmLeVmtFthdNgNYZX4ROzINFNJaQOQdekoS6hF1EJI69lLeKsiGXJHKm3gNnKo+Y4tYKDDy2KE4EdwnOM8wTSwJL4EJu1kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmYu8/td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmYu8/td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD571F000C4;
	Mon, 19 Oct 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418103;
	bh=7MLSX91YXWGMiDuQOVHG7eM6KF/4ZfqZKFra9uborK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmYu8/tdyWkdcrQpj/khJ7b5PDJxrClr1nJ8vxdwP5lv6vqqflev+AgE3GHsHSVUX
	 3UudM1472T2OlmQ64pgVUhgY5f2T8WfFiaQSsKJramM/06aOvlUZ2iPgaeCEq1v3a8
	 axdqzqf9tF2T+ILUCfHUEmS3l0UPQS3TAULUIFf/yPXVJaW/h2X5f+I6Z+Pc47lDZK
	 Jq7I0aBFkeUTlSVI6wPE+fU81laS2iqNpUfzsSQWZkULd+drIqC0fHC50iw58b1LXj
	 42U0JxBQxWGAgrGIbBpC0Z5fdx5ZsdBngWd77SaHPvIL/VTKZDH4a5O8jnb89JnLP6
	 ity1oV8sMmTrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	y.oudjana@protonmail.com,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-clk@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] clk: mediatek: mt6735-vencsys: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:45:05 -0400
Message-ID: <20261019135441.1420968-14-sashal@kernel.org>
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

[ Upstream commit 36cf8d279ff90835f4b002dec28eedb059554842 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
This tree is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
driver exists here; the change is a one-line `MODULE_DEVICE_TABLE(of,
...)` so the vencsys clock module can autoload from DT.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[clk/mediatek] [add] add missing MODULE_DEVICE_TABLE() for
  mt6735-vencsys`

**Step 1.2: Tags**
- Record:
  - **Fixes:** none (expected for this review)
  - **Reported-by:** none
  - **Tested-by:** none
  - **Reviewed-by:** Brian Masney `<bmasney@redhat.com>` (COMMON CLK
    FRAMEWORK maintainer)
  - **Acked-by:** none
  - **Link:** none in the commit; mailing list found via `b4 dig`
  - **Cc: stable:** none (not a negative signal)
  - **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author);
    Brian Masney `<bmasney@redhat.com>` (clk maintainer who applied it)
  - Notable: maintainer review + maintainer SOB; no user/syzbot report

**Step 1.3: Body**
- Record:
  - **Bug:** OF match table is wired to `.of_match_table` but not
    exported with `MODULE_DEVICE_TABLE()`, so `file2alias` does not emit
    `of:` aliases.
  - **Symptom:** when `CONFIG_COMMON_CLK_MT6735_VENCSYS=m`,
    udev/modprobe cannot autoload `clk-mt6735-vencsys` from
    `mediatek,mt6735-vencsys`.
  - **Version info:** none in the message. Git: driver added in
    **v6.13-rc1** (`0bd9b1211f741`); this fix first appears in
    **v7.3-rc1**.
  - **Root cause:** omitted alias publication, not a runtime logic
    error.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. It is a real functional gap (module autoload), not
  a crash/UAF. The “source-level fix / no hardware reproduction” wording
  matches the original lore submission, not pipeline decoration.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - `drivers/clk/mediatek/clk-mt6735-vencsys.c`: **+1 / -0**
  - Function/data: `of_match_mt6735_vencsys[]` (file scope)
  - Scope: single-file, one-line surgical change

**Step 2.2: Code flow**
- Record: Before, the table is only consumed by
  `platform_driver.driver.of_match_table` (bind if the module is already
  loaded or built-in). After, `MODULE_DEVICE_TABLE(of,
  of_match_mt6735_vencsys)` also creates a `__mod_device_table` alias so
  `scripts/mod/file2alias.c` `do_of_entry()` emits
  `of:N*T*Cmediatek,mt6735-vencsys`. Build-time metadata only; no probe-
  path change.

**Step 2.3: Bug mechanism**
- Record: **Hardware matching / module autoload** (same class as missing
  device IDs). Match table exists but is not published for modules.

**Step 2.4: Fix quality**
- Record: Obviously correct; matches sibling MT6735 files that shipped
  with `MODULE_DEVICE_TABLE` (`apmixedsys`, `infracfg`, `pericfg`,
  `topckgen`). No runtime lock/API/data-structure change. Regression
  risk is essentially none. `imgsys` and `mfgcfg` still lack the macro;
  this patch does not depend on those.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Match table and driver introduced by `0bd9b1211f741` (“clk:
  mediatek: Add drivers for MT6735 syscon clock and reset controllers”,
  Yassine Oudjana, 2024-11-06, applied 2024-11-14). First in
  **v6.13-rc1**. `MODULE_DEVICE_TABLE` line is this commit
  `36cf8d279ff90`.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag. The omission dates from the introducing
  commit `0bd9b1211f741`, which **is** an ancestor of this tree.

**Step 3.3: File history**
- Record: Only two commits on this file: introducer + this fix. No later
  conflicting refactor. Sibling same-day commit `096ab64a0e694` does the
  same for `clk-mt6735-vdecsys.c`. Standalone; not patch 2/N.

**Step 3.4: Author**
- Record: Pengpeng Hou is not the MT6735 clk maintainer (that is Yassine
  Oudjana). Same author also added `MODULE_DEVICE_TABLE` in `clk-
  mt6735-vdecsys.c` and two i.MX clk drivers. Applied by clk co-
  maintainer Brian Masney.

**Step 3.5: Dependencies**
- Record: None. Uses existing `MODULE_DEVICE_TABLE` / `of_device_id`.
  Applies on top of the original driver with no prerequisites.

## Phase 4: Mailing list and external research

**Step 4.1: Original discussion**
- Record: `b4 dig -c 36cf8d279ff90` →
  https://patch.msgid.link/20260704124808.19916-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-07-04). Applied version is that v1.
- Thread (mbox): author patch + Brian Masney `Reviewed-by`. No NAK, no
  stable nomination, no risk discussion.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Yassine Oudjana (MT6735 clk maintainer), Stephen Boyd, Brian
  Masney, Michael Turquette, Matthias Brugger, AngeloGioacchino Del
  Regno; `linux-clk`, `linux-mediatek`, `linux-arm-kernel`, `linux-
  kernel`. Right maintainers and lists.

**Step 4.3: Bug report**
- Record: No Reported-by, no syzbot, no bugzilla. Author states there
  was no hardware reproduction.

**Step 4.4: Series**
- Record: Independent single patches (vencsys + vdecsys), not a numbered
  series. This commit does not need the vdecsys patch.

**Step 4.5: Stable list**
- Record: **UNVERIFIED.** `curl` to lore.kernel.org/stable returned HTTP
  403. No in-tree evidence this was rejected for stable.

## Phase 5: Code semantic analysis

**Step 5.1: Functions**
- Record: No function body changed. Adds `MODULE_DEVICE_TABLE` next to
  `of_match_mt6735_vencsys[]`. Driver still uses
  `module_platform_driver` → `mtk_clk_simple_probe` /
  `mtk_clk_simple_remove`.

**Step 5.2: Callers**
- Record: Platform core binds via OF compatible. Probe is boot/device-
  instantiation, not a syscall hot path. Impact is whether the **module
  is loaded at all**.

**Step 5.3: Callees**
- Record: Unchanged. `mtk_clk_simple_probe()` in `clk-mtk.c` registers
  the vencsys gates from `vencsys_clks`.

**Step 5.4: Reachability**
- Record: Reachable when DT has `mediatek,mt6735-vencsys` and the driver
  is a module. **No in-tree `.dts`/`.dtsi` uses that compatible** (only
  `Documentation/devicetree/bindings/clock/mediatek,syscon.yaml`). Users
  need out-of-tree DT (typical for older MT6735 phones). Built-in (`=y`)
  is unaffected.

**Step 5.5: Similar patterns**
- Record: Same omission still present in `clk-mt6735-imgsys.c` and `clk-
  mt6735-mfgcfg.c`. Four other MT6735 clk files had
  `MODULE_DEVICE_TABLE` from day one (`43c04ed791892` for apmixedsys).
  Pattern is systematic but this patch is complete for vencsys.

## Phase 6: Local tree cross-reference

**Step 6.1: Buggy code in this tree?**
- Record: Yes. File exists; current tree already has the fix at line 40.
  Bug was the missing alias from v6.13 until v7.3-rc1.
  `CONFIG_COMMON_CLK_MT6735_VENCSYS` is **tristate**.

**Step 6.2: Backport difficulty**
- Record: **Clean apply.** File is essentially unchanged since
  introduction. One inserted line after the match table.

**Step 6.3: Related fixes already here**
- Record: This exact commit is already an ancestor of HEAD (`git merge-
  base --is-ancestor 36cf8d279ff90 HEAD` → yes). That is mainline
  history, not a reason to reject on merit. No alternate fix. Sibling
  vdecsys fix is also present; imgsys/mfgcfg still missing.

## Phase 7: Subsystem context

**Step 7.1: Subsystem / criticality**
- Record: `drivers/clk/mediatek/` — SoC clock driver. **PERIPHERAL**
  (MT6735 video-encoder clocks only). Not mm/fs/net core.

**Step 7.2: Activity**
- Record: Mediatek clk is actively maintained; this file is not. Two
  commits total. Mature omission, not churn.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Only MT6735 systems with `CONFIG_COMMON_CLK_MT6735_VENCSYS=m`
  and a DT node `mediatek,mt6735-vencsys`. Driver- and config-specific;
  small population (no in-tree board DTS).

**Step 8.2: Trigger**
- Record: Modular boot + OF device present. Not a race. Unprivileged
  users do not trigger it; udev autoload fails. Built-in and manual
  `modprobe` work.

**Step 8.3: Failure mode**
- Record: Module does not autoload → vencsys clocks (smi_larb3, venc,
  jpgenc, jpgdec) never register → video encode/JPEG on that SoC can
  fail. **Severity: MEDIUM** (functional miss, not
  oops/corruption/deadlock). Fits stable-rules “oh, that’s not good” and
  the device-ID-style enablement exception.

**Step 8.4: Risk-benefit**
- Record: **Benefit:** correct autoload for a supported tristate driver;
  one line. **Risk:** negligible (modinfo/depmod metadata only). Ratio
  favors applying it on trees that have this driver.

## Phase 9: Final synthesis

**Step 9.1: Evidence**

FOR:
- Real autoload bug: match table used, aliases not published
- One line, obviously correct, reviewed and applied by clk maintainer
  Brian Masney
- Driver is tristate; modular build is an intended config
- Same class as device-ID additions (publish existing OF IDs)
- Sibling MT6735 files already had the macro; this was an omission from
  `0bd9b1211f741`
- Zero runtime regression risk; applies cleanly
- Driver and bug exist in this 7.3 tree (introduced v6.13)

AGAINST:
- Not a crash, UAF, deadlock, or security issue
- No user report and no hardware reproduction
- No in-tree DT consumer for this compatible
- Niche SoC; often clocks are built-in

UNRESOLVED:
- Whether this was discussed on the stable list (lore HTTP 403)

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **PASS** — one-line, standard macro,
   maintainer Reviewed-by/SOB. No runtime test; correctness is
   mechanical.
2. Real bug that affects users? **PASS** — modular OF autoload is
   broken. User set is small but real if they use `=m`.
3. Important issue? **PASS** (low end of “oh, that’s not good” /
   hardware-enablement), not CRITICAL.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes existing match table.
6. Can apply to this tree? **PASS** — file and table exist; patch is a
   clean one-liner.

**Step 9.3: Exception category**
- Record: Closest match is **device ID / hardware matching** (OF module
  aliases), not a new driver.

**Step 9.4: Decision**

Backport this. It is a one-line, obviously correct fix for failed OF
module autoload on an existing tristate driver. That is the same kind of
enablement stable already takes for new device IDs, with no runtime
behavior change if the module is built-in or loaded by other means. This
7.3 tree has the driver (since v6.13); there are no missing
prerequisites. Limited hardware and no crash report lower urgency, not
correctness.

### What it solves for stable users
If `clk-mt6735-vencsys` is a module, userspace cannot match
`mediatek,mt6735-vencsys` and load it. Video-encoder clocks then never
appear. `MODULE_DEVICE_TABLE(of, ...)` generates the aliases
`file2alias` already knows how to emit.

### Risk vs benefit
Benefit is correct autoload on MT6735 modular configs. Risk is
negligible: no probe, locking, or ABI change.

## Verification
- [Phase 1] Parsed tags: Reviewed-by + SOB Brian Masney; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] `git show -s 36cf8d279ff90`: body matches the candidate;
  “source-level fix” is in the real commit and lore v1
- [Phase 2] Diff: +1 `MODULE_DEVICE_TABLE(of, of_match_mt6735_vencsys)`
  in `clk-mt6735-vencsys.c`
- [Phase 2] `include/linux/module.h` and `scripts/mod/file2alias.c`
  `do_of_entry()`: confirmed alias generation from that macro
- [Phase 3] `git blame`: table from `0bd9b1211f741` (v6.13-rc1); macro
  from `36cf8d279ff90`
- [Phase 3] `git describe --contains 0bd9b1211f741`: v6.13-rc1; fix
  contained in v7.3-rc1; `git merge-base --is-ancestor` vs v7.2: not in
  v7.2
- [Phase 3] File log: only introducer + this commit; sibling
  `096ab64a0e694` for vdecsys
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 lore thread; Masney Reviewed-by;
  correct clk/mediatek CCs; no NAK
- [Phase 4] WebFetch lore/msgid.link: HTTP 403; used mbox instead
- [Phase 5] Kconfig: `COMMON_CLK_MT6735_VENCSYS` tristate; Makefile
  `obj-$(CONFIG_COMMON_CLK_MT6735_VENCSYS)`
- [Phase 5] `mtk_clk_simple_probe` in `clk-mtk.c` used unchanged
- [Phase 5] Grep: no in-tree dts/dtsi `mediatek,mt6735-vencsys`; binding
  in `mediatek,syscon.yaml`
- [Phase 5] imgsys/mfgcfg still lack `MODULE_DEVICE_TABLE`
- [Phase 6] `make kernelversion` / `git describe HEAD`: 7.3.0-rc4 /
  v7.3-rc4-27-gf0100363d8c37
- [Phase 6] File currently contains the macro; `git merge-base --is-
  ancestor 36cf8d279ff90 HEAD` = yes
- [Phase 7] MAINTAINERS: MT6735 clk → Yassine Oudjana; COMMON CLK →
  Stephen Boyd, Brian Masney, Jerome Brunet
- [Phase 8] Failure mode: missing module autoload, not oops; severity
  MEDIUM
- UNVERIFIED: stable@ lore discussion (HTTP 403)

**YES**

 drivers/clk/mediatek/clk-mt6735-vencsys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt6735-vencsys.c b/drivers/clk/mediatek/clk-mt6735-vencsys.c
index 8dec7f98492ac..64ba9da9fd427 100644
--- a/drivers/clk/mediatek/clk-mt6735-vencsys.c
+++ b/drivers/clk/mediatek/clk-mt6735-vencsys.c
@@ -37,6 +37,7 @@ static const struct of_device_id of_match_mt6735_vencsys[] = {
 	{ .compatible = "mediatek,mt6735-vencsys", .data = &vencsys_clks },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, of_match_mt6735_vencsys);
 
 static struct platform_driver clk_mt6735_vencsys = {
 	.probe = mtk_clk_simple_probe,
-- 
2.53.0

