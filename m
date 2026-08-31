Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6DD4854E0;
	Mon, 31 Aug 2026 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183485; cv=none; b=IyNIvSETWLZ7SjPoCrAHP45xYddb0P1tewJQUoPF2YcklfDZttFuUKz7mgT3GweaCtgWP4WqDnVbqKPvgFHbz2ZYCcmLWyMhO9R5WANncYS+rX0ycGg4oH5EkFRZCUXn9Va9vkeHEnZdUyIiSAQ8uiTUU6s162FT9jtRQO9/vzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183485; c=relaxed/simple;
	bh=+ecQkqPnHhC7zpnkxluGGxDHFr5O+3ddzAR2gy/ERPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSjZjZ5QJc184Am6O0AvLAipqhTDmvf/7jkAdiVw2wnfjDQu0nms/0e2+HkDBvDwUiJi6wv6YWoWmm84Z63RI8wJk003o/VfdNAbe7Rv2fw4sfTUlxYYv/sGyIZZe2qem9EzbVx2mZRDyfb9NIkAOC8XE1cNQW/m2dw8mMMeCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGywkr2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGywkr2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80F31F00ACA;
	Mon, 31 Aug 2026 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183482;
	bh=frt4K/qoWbuXnTGa/aHOppJsqvconQ6FFWA3kUUUeMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGywkr2f/CNBUQKifrpCaYp2PE2BLckfR1aux31NsuWGYCzozGAGoyKMJ27bxh8kH
	 xcCfI7nStZZGbbRiwrvwClRXVqElKsjnUVeYz7GsCfuyMwm4uK4RS4ygx9suLCG1pO
	 iJ4B4f4kPfdDfX0zJeSeWAn5WR5PmiMbxqseaR3xDENRjaxHw9VLrDGYES4Ky61Vll
	 E8aexjy2CPxL5gmM8tGOaDBpJlBg+aMOIfLIljB7YwH1TVdhMOE5uTt4rpxYbIU9nw
	 lrl8x8kgl1CPp7iSvDek3J+hsnlPF0L3QqwZ0qLNoSmnNOVaMJsbz0YzPMMinPG/jz
	 IaLRv+D8K831w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: pcie: add two LNL PCI IDs
Date: Mon, 31 Aug 2026 09:22:31 -0400
Message-ID: <20260831133314.4125787-123-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f88b045d959f8a51757e0fde29d5d204da1176f ]

Add two PCI IDs for two WiFi-7 BE1735x Killer devices (these
are CRFs) so they work when put into the LNL platform.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260515150751.d2e3c380227a.I791eef3dedc11a8b246ce3130a34018886e63d3f@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[wifi: iwlwifi: pcie] [add] two LNL PCI IDs for WiFi-7
  BE1735x Killer CRF devices on Lunar Lake platform`

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (author,
    iwlwifi maintainer)
  - `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
    (series submitter; pipeline SOB ignored per instructions)
  - `Link: https://patch.msgid.link/20260515150751.d2e3c380227a...`
    (patch message link; fetch blocked by bot protection)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
    stable@vger.kernel.org`
  - Notable: no syzbot/fuzzer involvement; this is hardware-enablement,
    not a sanitizer bug

**Step 1.3 — Body analysis**
- Record:
  - **Bug/problem:** Two PCI IDs (`0xA840:0x1735`, `0xA840:0x1736`) for
    WiFi-7 BE1735x Killer CRF modules are missing from the iwlwifi PCI
    ID table.
  - **Symptom:** Devices on LNL (Lunar Lake) platform are not bound by
    iwlwifi; WiFi is non-functional.
  - **Root cause:** PCI subsystem cannot match unknown device IDs to the
    existing `iwl_bz_mac_cfg` driver configuration.
  - **Version info:** None in commit message.

**Step 1.4 — Hidden bug fix?**
- Record: Not a crash/leak/race fix. This is explicit **hardware
  enablement** via PCI ID table entries — a recognized stable exception
  category (new device IDs on an existing driver).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - Files: `drivers/net/wireless/intel/iwlwifi/pcie/drv.c` (+2 lines, 0
    removed)
  - Functions: none modified; only `iwl_hw_card_ids[]` PCI ID table
    extended
  - Scope: single-file, surgical (2 lines)

**Step 2.2 — Code flow per hunk**
- Record:
  - **Before:** PCI IDs `0xA840:0x1735` and `0xA840:0x1736` absent from
    `iwl_hw_card_ids[]`; `pci_register_driver()` cannot match these
    devices.
  - **After:** Both IDs map to existing `iwl_bz_mac_cfg`, same as
    adjacent Killer entries `0x1775`/`0x1776`.
  - **Path affected:** PCI device enumeration / driver probe at boot or
    hotplug.

**Step 2.3 — Bug mechanism**
- Record:
  - Category: **Hardware enablement** (missing PCI ID entries)
  - Mechanism: Without table entries, `iwl_pci_probe()` is never called
    for these devices; iwlwifi does not load firmware or bring up WiFi.

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: uses same `iwl_bz_mac_cfg` as sibling Bz/Killer
    devices already in-tree.
  - Minimal, no unrelated changes.
  - Regression risk: very low — only extends an existing ID table; no
    logic/locking/API changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: Local tree is a shallow checkout (`git rev-parse --is-shallow-
  repository` → `true`); full per-line history unavailable. Insertion
  point is adjacent to existing `0x1775`/`0x1776` Killer entries (lines
  538–539), which use the same `iwl_bz_mac_cfg`. The missing-ID problem
  is present in this tree because `0x1735`/`0x1736` are absent.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag.

**Step 3.3 — File history**
- Record: Shallow history limits `git log` on `drv.c` (only one commit
  visible). Patch is **patch 13/15** of `wifi: iwlwifi: updates -
  2026-05-14` series, but this specific change is **standalone** — no
  dependency on other series patches.

**Step 3.4 — Author context**
- Record: Johannes Berg is iwlwifi maintainer. Author also has 6 other
  patches in the same series (UHR/NAN/debugfs work unrelated to this
  2-line ID addition).

**Step 3.5 — Dependencies**
- Record: No prerequisites. `iwl_bz_mac_cfg` and the Bz PCI ID block
  (`#if IS_ENABLED(CONFIG_IWLMVM) || IS_ENABLED(CONFIG_IWLMLD)`) already
  exist in this tree. Patch applies cleanly (`git apply --check`
  succeeded).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: Found in local mbox `v2_20260515_miriam_rachel_korenblit_wifi_
  iwlwifi_updates_2026_05_14.mbx` as `[PATCH v2 13/15]`. Lore URL from
  `Link:` tag could not be fetched (Anubis bot protection). `b4 dig -c`
  could not be run (no commit hash in shallow tree for this patch).

**Step 4.2 — Reviewers**
- Record: This individual patch has only author SOBs. Other patches in
  the series carry `Reviewed-by: Emmanuel Grumbach` and `Reviewed-by:
  Johannes Berg`. No explicit stable nomination found in mbox grep.

**Step 4.3 — Bug report**
- Record: N/A — no `Reported-by:` or bugzilla/syzbot links. Problem is
  hardware not working without driver binding.

**Step 4.4 — Series context**
- Record: Part of 15-patch iwlwifi update series; this patch only
  touches `drv.c` (+2 PCI IDs). Self-contained for backport purposes.

**Step 4.5 — Stable list**
- Record: No stable-list discussion found (mbox grep for "stable" on
  this patch returned no hits). Absence is not a negative signal per
  instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `iwl_hw_card_ids[]` (modified), `iwl_pci_probe()`
  (beneficiary), `iwl_pci_register_driver()` (registers ID table)

**Step 5.2 — Callers**
- Record:
  - `iwl_pci_register_driver()` called from `iwl_drv_init()` in `iwl-
    drv.c` at module init
  - PCI core matches devices against `iwl_hw_card_ids[]` during
    enumeration
  - Common boot/hotplug path for any iwlwifi PCI hardware

**Step 5.3 — Callees**
- Record: On match, `iwl_pci_probe()` → `iwl_pci_gen1_2_probe()` with
  `mac_cfg` from `ent->driver_data` (`iwl_bz_mac_cfg`).
  `iwl_pci_find_dev_info()` provides optional friendly names but is not
  required for probe.

**Step 5.4 — Reachability**
- Record: Any system with `0xA840:0x1735` or `0xA840:0x1736` hardware
  (Killer BE1735x on LNL) hits this path at PCI probe. Without the IDs,
  the driver never loads — WiFi is completely unavailable.

**Step 5.5 — Similar patterns**
- Record: Adjacent entries `0x1775`/`0x1776` (Killer BE1775) already
  present with `iwl_bz_mac_cfg` and matching `IWL_DEV_INFO` name
  entries. New IDs follow the identical pattern; only PCI table entries
  are added (no new `IWL_DEV_INFO` for BE1735 — cosmetic naming only,
  not functional).

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **YES.** Local tree is `v6.18.44` (`VERSION=6`,
  `PATCHLEVEL=18`, `SUBLEVEL=44`). `0x1735`/`0x1736` are absent;
  `0x1775`/`0x1776` and full `iwl_bz_mac_cfg` infrastructure exist.

**Step 6.2 — Backport complications**
- Record: **Clean apply expected.** Verified with `git apply --check`
  against current `drv.c`. Insertion context matches exactly (after
  `0x1776`, before `0x7740`).

**Step 6.3 — Related fixes already present?**
- Record: No existing commit adding `0x1735`/`0x1736` found (`git log
  --grep="1735"` returned empty). Fix not yet in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `drivers/net/wireless/intel/iwlwifi` — network wireless
  driver. Criticality: **IMPORTANT** (common laptop WiFi hardware, not
  core kernel, but affects connectivity for affected users).

**Step 7.2 — Activity**
- Record: iwlwifi actively maintained; Bz/MLD support (`CONFIG_IWLMLD`)
  present in this tree with `mld/` subsystem, `cfg/bz.c`, and extensive
  `0xA840` PCI ID table.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users with Killer WiFi-7 BE1735x CRF modules on Lunar Lake
  (LNL) platforms running iwlwifi with `CONFIG_IWLMLD`/`CONFIG_IWLMVM`.
  Driver-specific, but WiFi is essential for those machines.

**Step 8.2 — Trigger conditions**
- Record: Boot or PCI hotplug with `0xA840:0x1735` or `0xA840:0x1736`.
  Deterministic — every such device is affected. Unprivileged users
  cannot trigger the fix, but all users on this hardware are impacted
  without it.

**Step 8.3 — Failure mode severity**
- Record: **HIGH** for affected users — WiFi hardware completely non-
  functional (no driver binding). Not a kernel crash, but a total loss
  of wireless connectivity on shipping hardware.

**Step 8.4 — Risk vs benefit**
- Record:
  - **Benefit:** HIGH for LNL + BE1735x Killer users — enables WiFi on
    hardware that otherwise has none.
  - **Risk:** VERY LOW — 2-line PCI ID addition using existing, proven
    `iwl_bz_mac_cfg`.
  - **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Textbook PCI device ID addition (stable exception) | Not a
crash/security/data-corruption fix |
| Fixes real user-visible problem (no WiFi) | Hardware may be niche (LNL
+ specific Killer SKUs) |
| 2 lines, 1 file, applies cleanly | No `IWL_DEV_INFO` name entries
(cosmetic only) |
| Uses existing `iwl_bz_mac_cfg` | Part of larger series (but this patch
is standalone) |
| Author is iwlwifi maintainer | No explicit stable nomination in
available sources |
| Adjacent Killer IDs already in 6.18.44 | |

Unresolved: Lore thread content unavailable (bot protection); no commit
hash for `b4 dig -c`.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — trivial ID table extension;
   maintainer-authored; series reviewed by Intel iwlwifi team.
2. Fixes real bug affecting users? **PASS** — WiFi non-functional
   without driver binding on affected hardware.
3. Important issue? **PASS** — complete loss of wireless on shipping
   hardware (HIGH for affected users).
4. Small and contained? **PASS** — 2 lines, 1 file.
5. No new features/APIs? **PASS** — only PCI IDs; exception category
   explicitly allows this.
6. Can apply to local tree? **PASS** — verified clean apply to 6.18.44.

**Step 9.3 — Exception category**
- Record: **NEW DEVICE IDs** — adding PCI IDs to existing iwlwifi driver
  with existing `iwl_bz_mac_cfg`. Driver and firmware support already
  present.

**Step 9.4 — Decision rationale**
This commit adds two PCI IDs so Killer WiFi-7 BE1735x CRF modules on
Lunar Lake platforms bind to the existing iwlwifi Bz driver. Without it,
affected laptops have no WiFi at all. The change is minimal, uses an
already-supported MAC configuration identical to neighboring Killer
entries, applies cleanly to Linux 6.18.44, and falls squarely within the
stable exception for new device IDs on existing drivers.

---

## Verification

- [Phase 1] Parsed subject, body, tags from provided commit message and
  mbox
- [Phase 2] Diff analysis: +2 lines in `iwl_hw_card_ids[]`,
  `iwl_bz_mac_cfg` assignments
- [Phase 3] `git describe HEAD` → `v6.18.44`; shallow repo confirmed
- [Phase 3] `git log --grep="1735"` → no existing fix in tree
- [Phase 3] `git apply --check` with patch diff → applies cleanly
- [Phase 4] Mbox `v2_20260515_miriam_rachel_korenblit_wifi_iwlwifi_updat
  es_2026_05_14.mbx` → patch 13/15 confirmed
- [Phase 4] WebFetch lore link → blocked (Anubis); no stable nomination
  retrieved
- [Phase 4] `b4 dig -c` → not possible without commit hash
- [Phase 5] `grep iwl_pci_register_driver` → called from
  `iwl_drv_init()` in `iwl-drv.c`
- [Phase 5] Read `iwl_pci_probe()` → uses `ent->driver_data` as
  `mac_cfg`; no dependency on `iwl_pci_find_dev_info()` for binding
- [Phase 6] `grep 0x1735/0x1736` in `drv.c` → absent (bug present)
- [Phase 6] `grep 0x1775/0x1776` in `drv.c` → present with
  `iwl_bz_mac_cfg`
- [Phase 6] `iwl_bz_mac_cfg` confirmed in `cfg/bz.c`
- [Phase 6] `CONFIG_IWLMLD` build integration confirmed in `Makefile`
  and `drv.c`
- [Phase 8] Failure mode: no driver binding → WiFi non-functional on
  affected hardware

**YES**

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 706dc7bb9a18d..cd0c416e927a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -537,6 +537,8 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA840, 0x4314, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1775, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0xA840, 0x1776, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1735, iwl_bz_mac_cfg)},
+	{IWL_PCI_DEVICE(0xA840, 0x1736, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x7740, PCI_ANY_ID, iwl_bz_mac_cfg)},
 	{IWL_PCI_DEVICE(0x4D40, PCI_ANY_ID, iwl_bz_mac_cfg)},
 
-- 
2.53.0

