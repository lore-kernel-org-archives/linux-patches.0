Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8A7546263;
	Mon, 19 Oct 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418189; cv=none; b=a6u3OSrz+V6+izeTdVPWEfTIJ1b4WuHhhmlvJ2MU6bEtk2vDEaKcZts7CUEcdKQB6Jog4Sgm0+jI4h64UaUGsKHVtr9ce5J+UEOvtmt13L2/LnzfagEmvW77WoeJWnePyrTJpeAip6nFuUMD/2pCnIPd0TzWYiEIEHVAck993EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418189; c=relaxed/simple;
	bh=Zvl3JjBQn+ODgoMXzFQMk2a6kQzDcRT01owVbLeVK7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MY+fH4+7MYO/42Tkkp35N1k5goqDTIhbx+bvoOzqGlkba+X8KrV0SccETR+KDQnLFAHC/ZotWpj+K+ppwQsUh5qyWxreolRUPcFgUsyVjMfSENdgeIDJMn6kScCfkQso3nUb2VOgmPl6KwE9gW5m07mg1S5UgmjA7ttovcTsSO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gopm6PnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gopm6PnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68CA1F000C6;
	Mon, 19 Oct 2026 13:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418187;
	bh=wpdEVcJbxQdzM6qXyyHXE1omwKBVt/Pm/yWtAX1rFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gopm6PnPOmHNabzAfToZwbZRobwMYQEkdhkF9h85EoypEEwdM9l8qln2wkD+r1HLF
	 9CF9+vM1XHuD6z12vtNpH51oJboNAlDzFha6RgIpJLU84k8k6HCBoM9wc6EGtlyasx
	 bOq+e/iw2pKQIy5zYM/tj9hdnxvAwJDm3wjFuWuKPhKDQf709W+tpb4RAsDv2hnu32
	 TRFA9RyowASpfCEXm+yJd2jeUJ10GK0Hqh06hdcN+tRmmG1p/gn0iNZNhJHL9ZwpD6
	 /JUcYS8axP1YZsaYUzCrSk1n/VGm6ezGKCBF9Q+MU55QUJZu0Oj0Tb065E17WBRepX
	 KZuDOV4fn0kDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	bhelgaas@google.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI: cadence: Add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:46:05 -0400
Message-ID: <20261019135441.1420968-74-sashal@kernel.org>
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

[ Upstream commit 93aac16f1eb9a181f9bdde620b464f6cc5fa8369 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20260704122835.14277-1-pengpeng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `PCI: cadence: Add missing
MODULE_DEVICE_TABLE()`

Local tree: **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). Verdict
is for this checkout only.

Candidate: `93aac16f1eb9a181f9bdde620b464f6cc5fa8369`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[PCI/cadence] [Add] missing MODULE_DEVICE_TABLE() so OF module
aliases are generated`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>` (PCI
  controller maintainer; applied the patch)
- `Reviewed-by: Aksh Garg <a-garg7@ti.com>`
- `Link:
  https://patch.msgid.link/20260704122835.14277-1-pengpeng@iscas.ac.cn`
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected
  for this review)
- No syzbot / KASAN / crash report

**Step 1.3 — Body**
Record:
[Bug] OF match table is wired to `.of_match_table` but not exported via
`MODULE_DEVICE_TABLE()`.
[Symptom] `depmod` / udev / `modprobe` do not get `of:N*T*Ccdns,cdns-
pcie-host` / `cdns,cdns-pcie-ep` aliases, so the module does not
autoload.
[Version info] None in the message.
[Root cause] Missing alias publication, not a runtime logic error. The
mailing-list body (mbox) states this is a source-level fix with no
hardware reproducer.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised. It is an explicit autoload/modalias fix. Same
class as `PCI: j721e: Fix module autoloading`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
[Files] `drivers/pci/controller/cadence/pcie-cadence-plat.c` (+1 / −0)
[Functions] none changed; one statement added after
`cdns_plat_pcie_of_match[]`
[Scope] single-file, one-line surgical change

**Step 2.2 — Code flow**
Record: Before: match table exists and is used for probe matching, but
`scripts/mod/file2alias.c` never sees it, so the `.ko` has no OF
aliases. After: `MODULE_DEVICE_TABLE(of, cdns_plat_pcie_of_match)`
creates the `__mod_of__cdns_plat_pcie_of_match` alias
(`include/linux/module.h`). Normal module-build path only; no
probe/runtime behavior change.

**Step 2.3 — Bug mechanism**
Record: [Category] logic/correctness for modular OF drivers (missing
userspace alias). [Mechanism] without the macro, a modular `pcie-
cadence-plat` never autoloads from DT. Sibling Cadence drivers already
export tables (`pci-j721e.c`, `pci-sky1.c`, `pcie-sg2042.c`).

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal. Regression risk is effectively
none: it only adds module metadata. Does not change locking, probe, or
APIs. Reviewer AI notes about probe `return 0` and drvdata type mismatch
are **pre-existing** and not introduced here.

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
Record: Match table introduced in `bd22885aa188f` (“PCI: cadence:
Refactor driver to use as a core library”, 2019). Driver was
`builtin_platform_driver` + `bool` Kconfig until `611627a4e5e4a` (“PCI:
cadence: Add module support for platform controller driver”,
2025-11-14). That commit is in **v6.19**. Bug (missing table export for
a loadable module) starts there.

**Step 3.2 — Fixes: tag**
Record: No `Fixes:` tag. The introducing commit is `611627a4e5e4a`
(module support). It **is** an ancestor of this tree.

**Step 3.3 — File history**
Record: Recent: HPA support, module support, then this one-liner.
Standalone; not `patch X/Y`. No later revert on this file.

**Step 3.4 — Author**
Record: Pengpeng Hou also did `e145af8c14474` `PCI: spacemit: Add
missing MODULE_DEVICE_TABLE()` the same day. Applied by Manivannan
Sadhasivam (PCI controller maintainer).

**Step 3.5 — Dependencies**
Record: Needs `module_platform_driver` + tristate Kconfig from
`611627a4e5e4a`. Both are in this 7.3 tree. Applies standalone here.

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original discussion**
Record: `b4 dig -c 93aac16f1eb9a` →
https://patch.msgid.link/20260704122835.14277-1-pengpeng@iscas.ac.cn
`b4 dig -a`: **v1 only**, 2026-07-04.
Thread (mbox): Aksh Garg Reviewed-by; Manivannan “Applied, thanks!” to
`93aac16f1eb9a`. No NAK, no stable nomination, no concern about this
line.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: PCI maintainers (Lorenzo Pieralisi, Krzysztof Wilczyński,
Manivannan Sadhasivam, Bjorn Helgaas), Rob Herring, linux-pci, linux-
kernel.

**Step 4.3 — Bug report**
Record: None. Author did not claim a hardware reproducer.

**Step 4.4 — Related series**
Record: Same-day sibling `PCI: spacemit: Add missing
MODULE_DEVICE_TABLE()`. Precedent in-tree: `9a7f144e18dc5` `PCI: j721e:
Fix module autoloading` (`Fixes:` + `Cc: stable`) — same one-line OF
table export.

**Step 4.5 — Stable list**
Record: UNVERIFIED. lore.kernel.org returned a bot-check page; WebFetch
of the msgid URL returned 403. No stable-list discussion was retrieved.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions**
Record: No function bodies changed. Data: `cdns_plat_pcie_of_match[]`.
Driver: `cdns_plat_pcie_driver` / `cdns_plat_pcie_probe`.

**Step 5.2 — Callers**
Record: Probe is the platform-driver callback. Match table used only in
this file. Triggered when DT has `cdns,cdns-pcie-host` or `cdns,cdns-
pcie-ep`.

**Step 5.3 — Callees**
Record: Unchanged. `MODULE_DEVICE_TABLE` is a compile-time alias for
`file2alias.c`.

**Step 5.4 — Reachability**
Record: Reachable on OF platforms that describe Cadence PCIe with those
compatibles and build `CONFIG_PCIE_CADENCE_PLAT=m`. No in-tree
`.dts`/`.dtsi` uses those strings (only DT binding examples). So the in-
tree user set is small; out-of-tree / FPGA / IP reference boards may
still use the generic compatible.

**Step 5.5 — Similar patterns**
Record: Same missing-table pattern already fixed for j721e, mvebu, qcom-
ep, spacemit, and the other Cadence glue drivers in this directory.

---

## PHASE 6: LOCAL TREE CROSS-CHECK

**Step 6.1 — Does the buggy code exist here?**
Record: Yes. This tree has tristate `PCIE_CADENCE_PLAT`,
`module_platform_driver`, and the OF table. Module support is in v6.19+.
Without `MODULE_DEVICE_TABLE`, modular autoload is broken. (The one-line
fix is present at line 166 of the current file; that is not used as
“already selected” circular reasoning — it confirms the surrounding code
matches the patch.)

**Step 6.2 — Backport difficulty**
Record: Clean apply on this tree: one line next to the existing table.

**Step 6.3 — Related fixes already here?**
Record: j721e/sky1/sg2042 already have `MODULE_DEVICE_TABLE`. Nothing
else replaces this plat-driver export.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
Record: `[drivers/pci/controller/cadence] [IMPORTANT for Cadence-IP
SoCs; PERIPHERAL vs core mm/net]`. PCIe host not coming up is serious
for those boards, not universal.

**Step 7.2**
Record: Active PCI controller area (HPA, module support, several glue
drivers). Plat driver itself is mature (2019) with occasional fixes.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
Record: Driver-specific / config-specific: `CONFIG_PCIE_CADENCE_PLAT=m`
plus DT compatible `cdns,cdns-pcie-*`. Built-in builds are unaffected.
No in-tree board DTS match; population is reference/FPGA/out-of-tree DT.

**Step 8.2 — Trigger**
Record: Boot (or coldplug) on matching DT with the driver as a module.
Common for modular embedded images. Unprivileged users cannot trigger a
crash; they just never get the controller unless something else loads
the module.

**Step 8.3 — Failure mode**
Record: [Failure] module not autoloaded → PCIe host/endpoint never
probes → downstream devices missing. [Severity] **MEDIUM** (functional
miss, not oops/corruption). Workaround: `modprobe` or `=y`.

**Step 8.4 — Risk vs benefit**
Record: Benefit: hardware actually binds on modular kernels. Risk: very
low (modinfo aliases only). Ratio: favorable. Same class as device-ID /
autoload fixes that stable already takes (j721e was `Cc: stable`).

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

For:
- Real autoload bug on a driver this tree can build as a module
- One line, obviously correct, maintainer-applied, reviewed
- Sibling Cadence drivers already export tables; j721e’s identical fix
  was stable-tagged
- Zero runtime regression surface
- Fits “device ID / make existing hardware work” exception more than a
  feature

Against:
- No user report, no `Fixes:`/`Cc: stable` on this patch
- Author stated no hardware reproduction
- No in-tree DTS uses these compatibles
- Not a crash, UAF, or data-corruption bug
- Stable mailing-list history UNVERIFIED

Unresolved: whether anyone on stable@ already rejected or requested this
(lore blocked).

**Step 9.2 — Stable rules (this tree)**
1. Obviously correct and tested? **PASS** — one documented macro; v1
   applied as-is after Reviewed-by.
2. Real bug that affects users? **PASS** — modular OF autoload fails;
   users who `=m` this controller do not get PCIe without a manual load.
3. Important (crash/security/corruption/deadlock)? **PASS** at “oh,
   that’s not good” / device-ID-class — PCIe does not come up. Not
   CRITICAL.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — metadata for IDs that already
   exist.
6. Can apply to this tree? **PASS** — table, `module_platform_driver`,
   and tristate Kconfig are all here.

**Step 9.3 — Exception category**
Record: Closest to **device ID / hardware enablement**: publishing
existing OF IDs for autoload, not a new driver.

**Step 9.4 — Decision**
This 7.3 tree can build the Cadence platform controller as a module.
Without `MODULE_DEVICE_TABLE(of, ...)`, userspace never sees the aliases
and the host/endpoint driver does not autoload. That is a real, user-
visible functional bug, a one-line contained fix, and the same pattern
already sent to stable for `pci-j721e`. Risk is negligible. It should be
included in this tree.

---

## What the commit solves (for stable users)

On kernels where `CONFIG_PCIE_CADENCE_PLAT=m`, udev/modprobe cannot
match DT nodes `cdns,cdns-pcie-host` / `cdns,cdns-pcie-ep` to `pcie-
cadence-plat.ko`. The controller never probes unless the module is
loaded by hand. The patch only emits the standard OF aliases. No new
ABI, no probe-path change.

Risk vs benefit: benefit is “PCIe works on modular images”; risk is
alias-only. Backport on this tree is a clean one-line apply;
prerequisite module support (`611627a4e5e4a`, v6.19) is already present.

---

## Verification

- [Phase 1] Parsed tags: author Hou, SOB+apply Manivannan Sadhasivam,
  Reviewed-by Aksh Garg, Link msgid; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of,
  cdns_plat_pcie_of_match)` in `pcie-cadence-plat.c`
- [Phase 2] Confirmed macro in `include/linux/module.h` creates
  `file2alias` alias
- [Phase 3] `git describe HEAD` / `make kernelversion`: **7.3.0-rc4**
- [Phase 3] `git blame`: table from `bd22885aa188f` (2019);
  `MODULE_DEVICE_TABLE` line from `93aac16f1eb9a`
- [Phase 3] Introducer of modular bug: `611627a4e5e4a` (bool→tristate,
  `builtin_platform_driver`→`module_platform_driver`); first tag
  **v6.19**; `git merge-base --is-ancestor 611627a4e5e4a HEAD` true
- [Phase 3] `git merge-base --is-ancestor 93aac16f1eb9a HEAD` true (used
  only to confirm context, not as “already selected”)
- [Phase 3] No revert of this commit on the file after it
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; lore msgid above; PCI
  maintainers on To; Reviewed-by + Applied; no NAK
- [Phase 4] WebFetch lore URL: 403; lore search: bot wall. Stable-list
  discussion **UNVERIFIED**
- [Phase 5] `git grep cdns_plat_pcie`: confined to plat driver + header
  + sky1 using the of_data struct
- [Phase 5] `git grep` of compatibles in `arch/`: **no** dts/dtsi users;
  only DT binding examples
- [Phase 5] Sibling `MODULE_DEVICE_TABLE` already in j721e, sky1, sg2042
- [Phase 6] Local file has match table + `module_platform_driver` +
  tristate Kconfig; patch applies as a single added line
- [Phase 6] Precedent `9a7f144e18dc5` j721e autoload fix has `Fixes:` +
  `Cc: stable`
- [Phase 8] Failure mode: no autoload → PCIe missing; severity MEDIUM,
  not oops
- UNVERIFIED: whether this was discussed on stable@ (lore blocked)

**YES**

 drivers/pci/controller/cadence/pcie-cadence-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index 0456845dabb96..0f9cf2a9f0034 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -167,6 +167,7 @@ static const struct of_device_id cdns_plat_pcie_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, cdns_plat_pcie_of_match);
 
 static struct platform_driver cdns_plat_pcie_driver = {
 	.driver = {
-- 
2.53.0

