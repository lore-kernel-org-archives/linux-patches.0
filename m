Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619E753BBBB;
	Mon, 19 Oct 2026 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418709; cv=none; b=Ioj/8HgxvcRTCDQ54uyJzRvx+fRH9bMKZDLlIpGUuc4pZvuI9YB2vPnQrmX8UfjKu2CTckvGBHRfsYJbMsCe92fJnadBR6K/JK3n6Jocmpo1ONxxY/tL5Es+YveL129qv0pTm2939pJen6VayvEsYVGK2Re6AWUX7yx8JC9oiV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418709; c=relaxed/simple;
	bh=w2HX/Fw+5HgIO5XZQ10RGAnFoCq/jW40U+9SRlYu8Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=naW6n/8nw/H9oq7xnUAhyZkbw/0QRNW5tq8BVbfkXUqTfl8jZj7UhtqO8r7W6gJaUJlZfuZCY1bB7AcRxoBD2ZBPK2uBfVsqCXb3ZtlDxICxcYzDGRxU0+0qIE2yEEGuQJ48Se7XGW23J6XGGR+vjqqJ/orbGNm3m5TjgBJHLMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtxGgvC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtxGgvC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ADB1F000C4;
	Mon, 19 Oct 2026 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418707;
	bh=Us7JsWYJ7Arw0VBDkGQy6sNQDtX+hznFYmkOxZjm1/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DtxGgvC86n2S722n7FB1ivnxoAnJqGUionse9sRVgxqwXAFJYCYZETRop3cd/29Kb
	 OM6FUrqmjvzf0Vefi/Cq3gB2v021xzObXZIUShqg1sZny6f07X0LpZpo88jSTB1vSY
	 tSUupsRS6E4drmJHkNO3bYMyOmtE4/aQMb9twfw3sJAX008E6PCFGi55xPv24Adg0R
	 9vXiOjLhG43F4Y2xdhaCdvDyK2THEOoGKYWbBTaAOSsj4a9QKNRdoa0ucFHqvyNjHF
	 lndYlY8JcPpB+gxwklII+d5wlUT99UQ6FLoCajOQnh1Lc87G2GJ3O6oaa3WPpLLbbN
	 xj+5trplxTz7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kaloz@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:52:10 -0400
Message-ID: <20261019135441.1420968-439-sashal@kernel.org>
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

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[soc: ixp4xx: qmgr]` `[add]` add missing
`MODULE_DEVICE_TABLE()` so OF module aliases are generated.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>`
- `Signed-off-by: Linus Walleij <linusw@kernel.org>` (IXP4xx/SoC
  maintainer; applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Cc: stable`, or `Link:` tags (absence of Fixes/Cc-stable is
  expected for this review)

**Step 1.3 — Body**
Record:
- **Bug:** `ixp4xx_qmgr_of_match[]` is wired to `.of_match_table` but
  not exported via `MODULE_DEVICE_TABLE(of, ...)`.
- **Symptom:** `depmod`/modinfo aliases are not generated, so userspace
  cannot autoload the module from the DT compatible `intel,ixp4xx-ahb-
  queue-manager`.
- **Failure mode:** modular `CONFIG_IXP4XX_QMGR=m` does not bind on DT
  boot unless someone `modprobe`s by hand. Built-in (`=y`) is
  unaffected.
- **Version info:** none in the message. Introduced with DT probe in
  v5.2-rc1.
- **Root cause (author):** source-level omission; no hardware
  reproduction claimed.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised. It is an explicit autoload fix. The “source-level
/ no reproduction” wording is honesty, not cleanup-as-fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/soc/ixp4xx/ixp4xx-qmgr.c` (`+1 / -0`)
- Function/data: `ixp4xx_qmgr_of_match[]` (table, not a function)
- Scope: single-file, one-line surgical change

**Step 2.2 — Code flow**
Record:
- **Before:** OF table exists and is used for in-kernel matching when
  the driver is already loaded/built-in. No `alias=of:N*T*Cintel,ixp4xx-
  ahb-queue-manager` in module metadata.
- **After:** `MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match)` creates the
  `file2alias` alias so kmod/udev can load `ixp4xx-qmgr` from DT.
- Path affected: module-build metadata only; probe/remove/IRQ paths
  unchanged.

**Step 2.3 — Bug mechanism**
Record: **Hardware enablement / missing device-table publication**
(module autoload). Not UAF, leak, race, or crash. Mechanism: missing
`MODULE_DEVICE_TABLE` so OF IDs never reach userspace.

**Step 2.4 — Fix quality**
Record: Obviously correct; this is the standard kernel idiom next to
every OF match table. Minimal, no API change, no locking, no runtime
behavior change for built-in. Regression risk is effectively zero
(`MODULE_DEVICE_TABLE` is a build-time alias attribute).

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- OF table added in `9e01a00958405` (“soc: ixp4xx: qmgr: Add DT probe
  code”, Linus Walleij, 2019) — first in **v5.2-rc1**.
- `.of_match_table = of_match_ptr(...)` until `526f3f3b102f0`
  (v5.19-rc1) dropped `of_match_ptr()`.
- `MODULE_DEVICE_TABLE` never added until this commit `01479280fa5d4`
  (Pengpeng Hou, 2026-07-04; applied 2026-07-24).
- Buggy omission has been in tree for ~7 years.

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag. Implicit parent is `9e01a00958405` (DT probe).
That commit **is** an ancestor of this checkout (`git merge-base --is-
ancestor` succeeded).

**Step 3.3 — File history**
Record: Recent related work is the sibling `f0b93c158aa92` (“soc:
ixp4xx: npe: add missing MODULE_DEVICE_TABLE()”) from the same
author/date. Other nearby commits are `dev_err` cleanup and `remove()`
signature changes — not prerequisites for this one-liner.

**Step 3.4 — Author**
Record: Pengpeng Hou is not the subsystem maintainer; this is one of a
batch of `MODULE_DEVICE_TABLE` additions (ixp4xx npe, aspeed, mediatek,
rtc, vdpa, watchdog, hwmon, fbdev). Maintainer Linus Walleij applied it
(“Patch applied.”).

**Step 3.5 — Dependencies**
Record: Standalone. Requires only the existing `ixp4xx_qmgr_of_match`
table and `<linux/module.h>` (already included). No series dependency
beyond the optional sibling npe patch.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 01479280fa5d4` →
  https://patch.msgid.link/20260704121851.63805-1-pengpeng@iscas.ac.cn
- Thread: patch + maintainer reply only. Linus Walleij: “Patch applied.”
  No NAK, no stable nomination, no requested revisions.
- `b4 dig -a` also matched an earlier same-diff series: Liao Chen,
  2024-08-14, `[PATCH -next] soc: ixp4xx/qmgr: fix module autoloading`
  (`20240814031004.3876441-1-liaochen4@huawei.com`). Same patch-id; that
  2024 posting did not land; Hou’s 2026 resend did.
- Lore HTTP fetch returned 403; thread recovered via `b4 dig -m`.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: To Linus Walleij, Imre Kaloz (historical OpenWrt IXP4xx); Cc
`linux-arm-kernel`, `linux-kernel`. Right maintainer was on To: and
merged it.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla/`Reported-by`. Author states there is no
dynamic hardware reproduction.

**Step 4.4 — Series**
Record: Not numbered `X/Y`. Parallel sibling `f0b93c158aa92` for
`ixp4xx-npe.c` is independent (same one-line pattern). This qmgr patch
is self-contained.

**Step 4.5 — Stable list**
Record: Unverified. `lore.kernel.org/stable/` fetch returned 403. No
stable discussion found via `b4` or local git.

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: No function body changed. Data: `ixp4xx_qmgr_of_match[]`. Driver
still registered with `module_platform_driver(ixp4xx_qmgr_driver)`.

**Step 5.2 — Callers / impact surface**
Record:
- Probe via platform/OF: DT node `qmgr: queue-manager@60000000` in
  `arch/arm/boot/dts/intel/ixp/intel-ixp4xx.dtsi` (`compatible =
  "intel,ixp4xx-ahb-queue-manager"`), used by all IXP4xx SoC DTs that
  include that dtsi.
- Consumers of exported qmgr APIs:
  `drivers/net/ethernet/xscale/ixp4xx_eth.c`,
  `drivers/net/wan/ixp4xx_hss.c`,
  `drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c`. Those Kconfigs `depends
  on IXP4XX_QMGR`.
- Reachable on IXP4xx boot when the DT node is present. Not a syscall-
  hot path; device probe / module load.

**Step 5.3 — Callees**
Record: Unchanged. `MODULE_DEVICE_TABLE` expands to a used alias
attribute for `file2alias.c` (see `include/linux/module.h`).

**Step 5.4 — Reachability**
Record: Userspace-reachable only as module autoload (kmod). If
`CONFIG_IXP4XX_QMGR=m`, missing aliases mean the queue manager (and thus
Ethernet/HSS/crypto that need it) will not come up automatically. If
`=y`, this commit is a no-op at runtime.
`arch/arm/configs/ixp4xx_defconfig` has `CONFIG_IXP4XX_QMGR=y` and
`CONFIG_IXP4XX_ETH=y`. Kconfig is still **tristate**, so modular builds
are a supported config.

**Step 5.5 — Similar patterns**
Record: Same omission/fix in `drivers/soc/ixp4xx/ixp4xx-npe.c`
(`f0b93c158aa92`). Same author also added `MODULE_DEVICE_TABLE` in other
SoC drivers the same week.

## Phase 6: Local tree

**Step 6.1 — Does the buggy code exist here?**
Record: Local tree is **v7.3-rc4** (`7.3.0-rc4`, `git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`). This is mainline, not an LTS branch. The
OF match table and platform driver exist. `git merge-base --is-ancestor
01479280fa5d4 HEAD` is true — the candidate is already in this checkout.
The pre-fix omission existed from v5.2 until this commit.

**Step 6.2 — Backport difficulty**
Record: Clean apply. One line next to a table that has been stable since
2019. No structural conflict with later `remove()` or `dev_err` changes.

**Step 6.3 — Related fixes already here**
Record: This exact line is already present (`MODULE_DEVICE_TABLE(of,
ixp4xx_qmgr_of_match)` at line 451). Sibling npe fix is also present. No
alternate autoload fix.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/soc/ixp4xx` — Intel IXP4xx (XScale ARMv5) SoC queue
manager. **PERIPHERAL** for the kernel as a whole; **IMPORTANT** on the
boards that still use this SoC (Ethernet/WAN/crypto sit on it).

**Step 7.2**
Record: Low-churn, mature platform. Occasional one-line hygiene/fixes.
Bug is old, not a new-subsystem issue.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Platform-specific / config-specific: `ARCH_IXP4XX` (or
`COMPILE_TEST`) with `CONFIG_IXP4XX_QMGR=m`. Official defconfig builds
it in, so default distro-style `ixp4xx_defconfig` users never hit this.
Modular custom/OpenWrt-style builds can.

**Step 8.2 — Trigger**
Record: Boot with DT + driver as a module. Not a race. Unprivileged
users cannot trigger a crash; they just don’t get the device until a
manual load. Commonness: low (legacy SoC; defconfig is built-in).

**Step 8.3 — Failure mode**
Record: Module does not autoload → queue manager never probes →
Ethernet/HSS/crypto that depend on it fail to operate. **Severity:
MEDIUM** (device non-function when modular; not
oops/corruption/deadlock). Built-in: none.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Medium for modular IXP4xx users (hardware actually
  binds); low for defconfig/`=y` users.
- **Risk:** Very low (one line, build-time metadata only).
- **Ratio:** Favorable. This is the device-ID class of change: tiny,
  enables existing hardware, no runtime regression surface.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real, well-understood autoload bug: OF table used by the driver but
  not published to userspace.
- One line, idiomatically correct, zero runtime risk.
- DT node is in the SoC dtsi; Ethernet/WAN/crypto depend on this driver.
- Kconfig is tristate; modular builds are supported.
- Bug present since v5.2; applies cleanly; no prerequisites.
- Maintainer applied it; same fix on the sibling NPE driver.
- Official stable rules explicitly allow “just add a device ID”; this is
  the OF equivalent (publish existing IDs for autoload).
- Matches the documented exception for trivial ID/enablement additions.

Against:
- Not a crash, security issue, deadlock, or data-corruption bug.
- Author documents no hardware reproduction.
- No user `Reported-by`.
- `ixp4xx_defconfig` uses `CONFIG_IXP4XX_QMGR=y`, so the official config
  never needs aliases.
- IXP4xx is a legacy, small user population.
- No reviewer `Cc: stable`.

Unresolved:
- Could not read lore.kernel.org over HTTP (403); discussion recovered
  via `b4 dig -m`.
- Could not search the stable mailing list (same 403).

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — one-line standard idiom;
   maintainer applied it. “Tested” is source-level, which is sufficient
   for this class of change.
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   is broken; users can still `modprobe` manually, but autoload is the
   supported path.
3. Important issue? **PASS** under the device-ID exception (hardware
   does not bind when built as a module). Not CRITICAL severity.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — metadata only.
6. Can apply to this tree? **PASS** — driver and table exist here; patch
   is already an ancestor of HEAD and would apply to any tree that still
   has the OF table.

**Step 9.3 — Exception category**
Record: **Device ID / module alias publication** for an existing driver
(OF equivalent of adding/exporting a PCI/USB ID). Not a new driver, not
a new API.

**Step 9.4 — Decision**
The local checkout is mainline **v7.3-rc4**. The driver, OF table, and
DT node are all here; the fix is a one-line alias publication with no
runtime risk. That is exactly the class of change stable trees take so
existing hardware keeps working when the driver is modular. Niche
platform and built-in defconfig lower the blast radius; they do not make
the fix incorrect or risky.

---

### What the commit solves for stable users
Without `MODULE_DEVICE_TABLE(of, ...)`, a `CONFIG_IXP4XX_QMGR=m` kernel
never generates `of:N*T*Cintel,ixp4xx-ahb-queue-manager` aliases. On DT
boot the queue manager stays unloaded, so IXP4xx Ethernet/HSS/crypto
that depend on it do not come up. The patch only emits those aliases.

### Rules / risk
Obviously correct, +1 line, no new API, applies cleanly. Benefit is
hardware enablement for modular builds; risk is negligible because
nothing in probe, IRQ, or locking changes.

### Concerns
No hardware reproduction and a tiny user base. Those are not blockers
for this exception class. Sibling NPE change is independent and not
required.

### Verification
- **[Phase 1]** Parsed tags: author Pengpeng Hou; SOB Linus Walleij;
  Message-ID present; no Fixes/Reported-by/Cc-stable.
- **[Phase 2]** Diff: +1 line `MODULE_DEVICE_TABLE(of,
  ixp4xx_qmgr_of_match)` in `drivers/soc/ixp4xx/ixp4xx-qmgr.c`.
- **[Phase 3]** `git blame`: table from `9e01a00958405` (v5.2-rc1); this
  line from `01479280fa5d4`.
- **[Phase 3]** `git merge-base --is-ancestor 9e01a00958405 HEAD` and
  `01479280fa5d4 HEAD`: both true.
- **[Phase 3]** Sibling `f0b93c158aa92` on `ixp4xx-npe.c` same day; not
  a prerequisite.
- **[Phase 4]** `b4 dig -c 01479280fa5d4`: lore URL `https://patch.msgid
  .link/20260704121851.63805-1-pengpeng@iscas.ac.cn`.
- **[Phase 4]** `b4 dig -a`: also matched 2024 Liao Chen posting with
  the same patch-id; Hou 2026 version is what landed.
- **[Phase 4]** `b4 dig -w`: To Linus Walleij and Imre Kaloz; Cc linux-
  arm-kernel, linux-kernel.
- **[Phase 4]** `b4 dig -m`: Walleij reply is “Patch applied.”; no NAK,
  no stable tag.
- **[Phase 4]** WebFetch lore/stable: 403. UNVERIFIED: stable-list
  discussion.
- **[Phase 5]** Callers of qmgr APIs: `ixp4xx_eth.c`, `ixp4xx_hss.c`,
  `ixp4xx_crypto.c`. DT node in `intel-ixp4xx.dtsi`.
- **[Phase 5]** `MODULE_DEVICE_TABLE` in `include/linux/module.h` is an
  alias attribute for `file2alias.c`.
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = `7.3.0-rc4`. File already contains the line.
- **[Phase 6]** Kconfig `IXP4XX_QMGR` is tristate; `ixp4xx_defconfig`
  sets `CONFIG_IXP4XX_QMGR=y`.
- **[Phase 8]** Failure mode: module autoload miss → device never
  probes; severity MEDIUM, not oops.

**YES**

 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 475e229039e30..e3ad0e0237a77 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -454,6 +454,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0

