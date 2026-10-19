Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2922A5008DB;
	Mon, 19 Oct 2026 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418297; cv=none; b=SUqcN1U8zfM60KGlPsY5OpjbfbEIGUcO7UvgDyNF7kHoFyq0viGvPRT/BR00X1o8ijCJ8UBqQGGt8iuM46lAASM7iJ6ixOrbYbyLHQy67918tpCGSTNO/Zu+f5/9AK4cl5OO22UlJ43yBQODnRyiSGjnznsNNKP3eCLTor7ILJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418297; c=relaxed/simple;
	bh=+gizcpBKphcm9LNReXGI0Mt+7+kT1LWOBGOEziwPLvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVjOrrzKsvtYYFJgJyc+/yaVxa1jCqe3M2glLcvhrKWjunIe2EaTZ6/PGDov5Hi2ZrWKUHIoVAujLE0sdYr4/qnAQ/ANZPE/Z4+HbsaKtdhr0eOuJuXpG9YfIRegXJlBnxekjjiPvITDYH39q5Ip8oMKsNpC2eyuVgiQqaDFa+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kULE8PDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kULE8PDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2978E1F000C8;
	Mon, 19 Oct 2026 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418295;
	bh=85qfeiOa1NVqqULnFXLwgWZiYeXT6dY9AfFlRUE5iw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kULE8PDikPIzShVcGLPn5Nh0DfRKBhqDeqjIL3t5PS3CQjM+tDEMJwW7juq1o25qp
	 yzBdPpFOTIeYSrnMogcj0aWBbUfPtJv72TJTWwDloMznErHMmmevGQHDOQPqx2hqU8
	 uDboGUE2CCyDRYaJS5v2H9DvcRJZly11JP73kwfj894Ql75cl8DLaSm2wYcCwjzoUR
	 ZL+k3fzsU39WNuXMRL7y73YSg/JiNyQOV156Kn8O32eI0oR6923MGbL+c+26dbeTKo
	 NMGsnRfiSd3wbbZ8/hKmiuGzqvgvqy2dD5sV+sTGjGjQJbHyttMlTw+RSrSeIqNJla
	 3Ah/u1FVyk6Uw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] soc: mediatek: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:47:17 -0400
Message-ID: <20261019135441.1420968-146-sashal@kernel.org>
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

[ Upstream commit ec762057868d70d474a9816e9c293c2ef801c3c9 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **7.3-rc4**. The DVFSRC driver is modular, had an
OF match table, and did not publish aliases, so autoload is broken for
`CONFIG_MTK_DVFSRC=m`. That is a real, one-line hardware-enablement bug.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[soc: mediatek] [add] [missing MODULE_DEVICE_TABLE() for OF
module autoload]**
- Subsystem: `soc: mediatek`
- Verb: **add** (missing export; the body is a fix, not a feature)
- Intent: publish the existing OF match table as module aliases

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Verified from `git show ec762057868d70`:
- Signed-off-by: Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- Signed-off-by: AngeloGioacchino Del Regno
  \<angelogioacchino.delregno@collabora.com\> (MediaTek SoC maintainer;
  applied the patch)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable
- Absence of Fixes:/Cc: stable is expected for this review and is not a
  negative

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** OF match table is wired to `.of_match_table` but not exported
  via `MODULE_DEVICE_TABLE(of, ...)`
- **Symptom:** `depmod`/`file2alias` never emit
  `of:N*T*Cmediatek,mtXXXX-dvfsrc` aliases, so udev/kmod will not
  autoload `mtk-dvfsrc.ko`
- **Version info:** none in the message. Driver landed in v6.13; this
  fix is in v7.3-rc4
- **Root cause:** forgotten alias publication on a tristate
  `module_platform_driver`

The extra “source-level fix / no dynamic hardware reproduction”
paragraph is in the original lore submission as well (not a stable-
pipeline marker).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** It is an explicit autoload/modalias bug fix
disguised only by the verb “add”. Same class as a missing device-ID
table export.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/soc/mediatek/mtk-dvfsrc.c` (**+1 / −0**)
- One line after `mtk_dvfsrc_of_match[]`
- Scope: **single-file surgical fix**

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** match table exists and is used for platform binding, but
  no `__mod_of__mtk_dvfsrc_of_match` alias is generated
- **After:** `MODULE_DEVICE_TABLE(of, mtk_dvfsrc_of_match)` creates that
  alias for `scripts/mod/file2alias.c`
- Affected path: **module build / autoload**, not probe logic. Built-in
  (`=y`) is unchanged at runtime

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** hardware enablement / missing module alias (OF
  equivalent of a missing device ID table)
- **Mechanism:** without `MODULE_DEVICE_TABLE`, kmod cannot map DT
  `compatible` to `mtk-dvfsrc.ko`. Probe never runs unless the module is
  loaded by hand
- Not UAF, leak, race, or locking

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct:** one standard macro next to the table, same
  pattern as `mtk-mmsys.c`, `mtk-svs.c`, `mtk-mutex.c` in this tree
- **Regression risk: negligible.** No runtime code, locking, or API
  change; only `.modinfo` aliases when built as a module

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Match table introduced in **192514ae05687** (“Add MediaTek DVFS
  Resource Collector (DVFSRC) driver”, AngeloGioacchino Del Regno, 2024)
- Present in **v6.13-rc1**; **not** in v6.12 or v6.6
- Original file already had `.of_match_table` and
  `module_platform_driver` and **never** had `MODULE_DEVICE_TABLE` (`git
  show 192514ae05687a:drivers/soc/mediatek/mtk-dvfsrc.c`)
- The one-line fix is **ec762057868d70** (Pengpeng Hou, 2026-07-04;
  applied 2026-07-30)

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Bug is the original omission in
192514ae05687, which **is** an ancestor of this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: later DVFSRC work (MT6893, MT8196, bandwidth rework) only grew
the match table. No prerequisite refactor is required for this one line.
**Standalone.**

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Pengpeng Hou has a series of the same “add missing
MODULE_DEVICE_TABLE()” fixes (rtc, vdpa, watchdog, hwmon, aspeed,
ixp4xx). This is a systematic audit, not a one-off. The applying
maintainer is the MediaTek SoC co-maintainer.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Needs only `mtk_dvfsrc_of_match` and `module.h`, both
present since the driver was added. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c ec762057868d70` →
  https://patch.msgid.link/20260704124308.6241-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread (saved via `b4 dig -m`): maintainer reply “Applied to
  v7.2-next/soc, thanks!” (commit 0ef07f74aff2 while in the MTK tree)
- No NAKs, no requested changes, no Cc: stable in review

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included both MediaTek SoC maintainers
(Matthias Brugger, AngeloGioacchino Del Regno) and linux-mediatek /
linux-arm-kernel / linux-kernel. Applied by the subsystem maintainer.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by / bugzilla / syzbot.** Evidence is the source
mismatch (match table vs missing export), which is deterministic for
`=m` builds.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: not a numbered series. Sibling same-cycle fixes exist (`soc:
aspeed`, `soc: ixp4xx: npe/qmgr`). Each is self-contained. Historical
MediaTek analogs: `6f42f5e73bb43` (mtk-svs), `10687632307c0` (mtk-
mmsys).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED.** lore.kernel.org returned HTTP 403 for WebFetch
and curl. No local evidence of a stable NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **No function body changed.** The new line is
`MODULE_DEVICE_TABLE(of, mtk_dvfsrc_of_match)` beside the existing
table. Related runtime entry is `mtk_dvfsrc_probe`.

Step 5.2: TRACE CALLERS
Record:
- `module_platform_driver(mtk_dvfsrc_driver)` → OF platform probe
- Exported `mtk_dvfsrc_send_request` / `mtk_dvfsrc_query_info` used by:
  - `drivers/interconnect/mediatek/icc-emi.c`
    (`INTERCONNECT_MTK_DVFSRC_EMI` depends on `MTK_DVFSRC`)
  - `drivers/regulator/mtk-dvfsrc-regulator.c` (`REGULATOR_MTK_DVFSRC`
    depends on `MTK_DVFSRC`)
- Probe also `devm_of_platform_populate()`, so child
  interconnect/regulator nodes never appear if this module never loads

Step 5.3: TRACE CALLEES
Record: probe does SMC init/start of the DVFSRC IP, clock enable, child
populate. Autoload failure means that entire stack never starts.

Step 5.4: FOLLOW THE CALL CHAIN
Record: **Userspace-reachable via normal boot on MediaTek DT platforms**
(kmod/udev matching `compatible`). Unprivileged users do not need a
special syscall; they just boot. Trigger requires `CONFIG_MTK_DVFSRC=m`
and a matching DT node.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: other `drivers/soc/mediatek/` drivers already have
`MODULE_DEVICE_TABLE(of, ...)`. This was the omission.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` → **7.3.0-rc4**
- File and match table exist. Before ec762057868d70 there was **no**
  `MODULE_DEVICE_TABLE` (`git show ec762057868d70^:...`)
- Bug introduced with the driver in **v6.13** (192514ae05687)
- `git merge-base --is-ancestor ec762057868d70 HEAD` → yes (this
  checkout already contains the fix as mainline, which does not change
  whether the bug class is real)

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **clean apply.** One line after the sentinel entry. Compatible
strings may differ on older stables, but the macro is independent of
table contents.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: this is the fix. No earlier equivalent. Sibling SoC drivers
already had the macro.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** `drivers/soc/mediatek` (MediaTek SoC DVFS resource
  collector)
- **Criticality: IMPORTANT** on ARCH_MEDIATEK (Chromebooks/boards with
  MT8183/MT8195/MT8196/MT6893), **PERIPHERAL** globally
- Kconfig: `config MTK_DVFSRC` **tristate**, `depends on ARCH_MEDIATEK`

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: actively maintained (MT8196/DVFSRCv4, bandwidth rework,
mmsys/cmdq work). DVFSRC itself is a few years old (6.13), not brand-new
staging code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **platform-specific / config-specific** — `ARCH_MEDIATEK` +
`CONFIG_MTK_DVFSRC=m` + DT `compatible` in the match table. Built-in
configs are unaffected.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: boot (or DT overlay) with the module not already loaded
- Common on distro-style `=m` kernels; Chromebook/embedded images often
  use `=y` (then a no-op)
- Not a race; **100%** for modular builds
- Unprivileged user is not required beyond using the machine

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure:** DVFSRC module does not autoload → probe skipped → child
  devices not populated → interconnect EMI bandwidth votes and DVFSRC
  regulators return failure/`-ENODEV`
- Not an oops/UAF/corruption
- **Severity: MEDIUM** (device/stack does not come up; power/bandwidth
  management broken on those SoCs). For users who ship this as a module,
  it is a real “hardware doesn’t work” bug, in the same bucket as
  missing device IDs

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for modular MediaTek kernels; zero elsewhere
- **Risk:** very low (1 line, `.modinfo` only)
- **Ratio:** strongly favors including it

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real, deterministic autoload bug on a **tristate** driver that already
  has an OF table
- DVFSRC is the parent of interconnect and regulator children; missing
  autoload takes down that DVFS/bandwidth stack
- 1-line, standard `MODULE_DEVICE_TABLE(of, ...)` pattern already used
  by sibling MediaTek SoC drivers
- Applied by the MediaTek SoC maintainer; v1 accepted unchanged
- Same class as device-ID additions (explicit stable exception):
  existing driver, existing hardware, missing match publication
- Driver has been in this lineage since v6.13; the omission is old, not
  a just-landed feature

AGAINST:
- No user/syzbot report; author describes it as source-level
- Not a crash, deadlock, or data-corruption fix
- `=y` builds are unaffected; no in-tree defconfig sets
  `CONFIG_MTK_DVFSRC`
- No Cc: stable (expected here; not used as a negative)

UNRESOLVED:
- lore.kernel.org stable-list search (HTTP 403)
- Whether a given distro actually builds this as `=m` (unverified)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one established macro;
   maintainer applied v1
2. Fixes a real bug that affects users? **PASS** — module will not
   autoload for OF devices (`stable-kernel-rules.rst`: “real bug that
   bothers people **or** just add a device ID”)
3. Important issue? **PASS** as hardware-does-not-bind / missing ID-
   table export, not as a panic. Severity MEDIUM but in the device-ID
   exception class
4. Small and contained? **PASS** — +1 line, one file
5. No new features or APIs? **PASS** — only publishes an existing table
6. Can apply to the local tree? **PASS** — file and table exist; the
   line is already the correct form here

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Device ID / match-table publication for an existing driver.**
Closest documented exception: “just add a device ID.”

Step 9.4: MAKE YOUR DECISION
This is a one-line, obviously correct fix for a real modular-boot
failure on MediaTek SoCs that already have this driver. Risk is
negligible. It belongs in this tree’s stable lineage.

### What it solves for stable users
If `mtk-dvfsrc` is built as a module, kmod never gets `of:` aliases for
`mediatek,mt8183-dvfsrc` and the other compatibles. The driver never
probes, so DVFSRC children (EMI interconnect, DVFSRC regulators) never
appear. Adding `MODULE_DEVICE_TABLE` is the supported way to generate
those aliases (`include/linux/module.h` + `scripts/mod/file2alias.c`).

### Risk vs benefit
Benefit is restoring autoload for a SoC DVFS block; risk is a `.modinfo`
addition with no runtime logic change.

### Concerns
Needs no extra commits. Older stables without `mtk-dvfsrc.c` (pre-6.13)
would not apply; **this** checkout has the driver. Lore stable
discussion could not be fetched (403).

Verification:
- [Phase 1] `git show ec762057868d70`: subject/tags/body as above; no
  Fixes/Cc stable/Reported-by
- [Phase 2] Diff is exactly `+MODULE_DEVICE_TABLE(of,
  mtk_dvfsrc_of_match);` in `mtk-dvfsrc.c`
- [Phase 3] Blame: table from 192514ae05687; MODULE_DEVICE_TABLE line
  from ec762057868d70
- [Phase 3] `git show 192514ae05687a:drivers/soc/mediatek/mtk-dvfsrc.c`:
  of_match_table + module_platform_driver, no MODULE_DEVICE_TABLE
- [Phase 3] `git merge-base --is-ancestor 192514ae05687 v6.13-rc1` yes;
  not in v6.12
- [Phase 3] `git merge-base --is-ancestor ec762057868d70 HEAD` yes
- [Phase 4] `b4 dig -c/-a/-w/-m`: lore msgid
  20260704124308.6241-1-pengpeng@iscas.ac.cn; v1 only; maintainers CC’d;
  Angelo applied to v7.2-next/soc
- [Phase 4] lore.kernel.org HTTP 403 — stable-list discussion UNVERIFIED
- [Phase 5] Callers: `icc-emi.c`, `mtk-dvfsrc-regulator.c`; Kconfig
  `depends on MTK_DVFSRC`; probe uses `devm_of_platform_populate`
- [Phase 5] `CONFIG_MTK_DVFSRC` is tristate in
  `drivers/soc/mediatek/Kconfig`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] Pre-commit file has match table and no MODULE_DEVICE_TABLE
- [Phase 7] MAINTAINERS: ARM/Mediatek SoC support → AngeloGioacchino Del
  Regno (applier)
- [Phase 8] Failure mode: module not autoloaded → DVFSRC/DVFS stack
  down; not an oops
- UNVERIFIED: distro `=m` vs `=y` defaults; stable@ lore thread

**YES**

 drivers/soc/mediatek/mtk-dvfsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-dvfsrc.c b/drivers/soc/mediatek/mtk-dvfsrc.c
index 41add5636b03c..af35d71615baf 100644
--- a/drivers/soc/mediatek/mtk-dvfsrc.c
+++ b/drivers/soc/mediatek/mtk-dvfsrc.c
@@ -562,6 +562,7 @@ static const struct of_device_id mtk_dvfsrc_of_match[] = {
 	{ .compatible = "mediatek,mt8195-dvfsrc", .data = &mt8195_data },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, mtk_dvfsrc_of_match);
 
 static struct platform_driver mtk_dvfsrc_driver = {
 	.probe	= mtk_dvfsrc_probe,
-- 
2.53.0

