Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243F84A4C37;
	Mon, 31 Aug 2026 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183835; cv=none; b=FMbB6EWeryxkIHhSsFrbIp/YWv4hCjrx1+pkBdUEGRZEGx5/dadBuwxA2gno1cbofq8Mmicf+2MOUi/qmby7BG+OyE4sjj0729qfbV26HibN2ujpCQsSUcDIo9FCedrPlBZyXmEwvWmHybwCzoVgSH5zXX5FEEY4OVqln5Bb1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183835; c=relaxed/simple;
	bh=guxvnReWjgaXVgEWIc//dRH3ZdumFVJN5IaHcZLXP48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ncc2kNXC/NTcGBdMXF558zCdaeN8YS3LmRwqxnhPy33Jma/aTZprY32upqd3N9rftK548VZaELlZGKcVeiw9BxWUrYrb0wLikh8PaLDI4NuFdnMhfLZfaUuO9BxVW/hlhetrVJQdMvJC4O955XYeI/3+RTE2sjQJ39QvHUoVy6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MBxwbZ6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MBxwbZ6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7798F1F00A3E;
	Mon, 31 Aug 2026 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183833;
	bh=nqh6IQJMFyy0N8GbWvGTs8cWSqQT38lz1Wzeep5i/SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBxwbZ6fZN26/SFl2FlA9nDDLKRScjJX35Mgp1BKs5rrb4Zs9WG0b94hdTKLbAy2T
	 +r4MrdO0N27Bsgrw3ubibcYkojKObze2D7DYjfiqKxkOK0htthhNR+MGu0ymYCkJz1
	 0uqIJlDWRSqUOMk1Hz2B0BqyRLXrN1oO7QoVxwqkvUfmhKl9rExhp9nVmiIJn6kFCt
	 HUfXntTkhg1/McqnnHNFDV+orNlV7CDXdLWRQk9tSEq4eAlt67ZCvCclbJryN3KHXo
	 32bNnY/Uae1lxbEK5hEBROuITVBKmuimwuPMKEgs5Zg2JAuYHXPdyaB9YgOtFsLrs6
	 rRvp0Ar5v3gTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Javier Tia <floss@jetm.me>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mt76: mt7925: add 320MHz bandwidth to bss_rlm_tlv
Date: Mon, 31 Aug 2026 09:25:59 -0400
Message-ID: <20260831133314.4125787-331-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Javier Tia <floss@jetm.me>

[ Upstream commit efc9a10d1de1763baecd2031c1c6dfe6aac9ac38 ]

bss_rlm_tlv() in mt7925_mcu_bss_rlm_tlv() has no case for
NL80211_CHAN_WIDTH_320. When associated to a 320MHz BSS, the switch
falls through to default and sends bw=0 (CMD_CBW_20MHZ) to firmware
via BSS_RLM TLV. Firmware then configures the RX radio for 20MHz
and cannot decode the AP's 320MHz frames, resulting in complete data
path failure at 320MHz.

Add the missing NL80211_CHAN_WIDTH_320 case with CMD_CBW_320MHZ and
center_chan2.

Tested on ASUS RT-BE92U: 320MHz throughput goes from 0 Mbps to
841 Mbps (iperf3 -t30 -P8), PHY 4803 Mbps EHT-MCS11.

Reported-by: 张旭涵 <Loong.0x00@gmail.com>
Closes: https://github.com/openwrt/mt76/issues/927
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: mt76: mt7925]` `[add]` — add missing 320MHz bandwidth
handling in `bss_rlm_tlv()`.

**Step 1.2 — Tags**

Record:
- **Reported-by:** 张旭涵 \<Loong.0x00@gmail.com\>
- **Tested-by:** 8 testers (reporter plus Marcin FM, Cristian-Florin
  Radoi, George Salukvadze, Evgeny Kapusta, Samu Toljamo, Ariel
  Rosenfeld, Chapuis Dario, Thibaut François)
- **Reviewed-by:** Sean Wang \<sean.wang@mediatek.com\> (MediaTek
  maintainer)
- **Closes:** https://github.com/openwrt/mt76/issues/927
- **Link:**
  https://patch.msgid.link/20260425195011.790265-3-sean.wang@kernel.org
- **Signed-off-by:** Javier Tia, Felix Fietkau
- No `Fixes:`, no `Cc: stable@vger.kernel.org` (expected for candidate
  review)
- Ignore pipeline `Signed-off-by: Sasha Levin` if present in prepared
  form

Notable: broad real-world testing, maintainer review, public bug tracker
reference.

**Step 1.3 — Body analysis**

Record:
- **Bug:** `mt7925_mcu_bss_rlm_tlv()` has no `NL80211_CHAN_WIDTH_320`
  case; falls through to `default` and sends `bw=0` (`CMD_CBW_20MHZ`) to
  firmware via `BSS_RLM` TLV.
- **Symptom:** firmware configures RX for 20MHz, cannot decode AP 320MHz
  frames → complete data-path failure (0 Mbps).
- **Fix:** add `NL80211_CHAN_WIDTH_320` case with `CMD_CBW_320MHZ` and
  `center_chan2`.
- **Evidence:** ASUS RT-BE92U test: 0 Mbps → 841 Mbps iperf3 (`-t30
  -P8`), PHY 4803 Mbps EHT-MCS11.
- **Root cause:** missing switch case when programming firmware RLM TLV.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Subject says “add,” but this is a functional bug fix:
wrong bandwidth programmed to firmware causes total connectivity loss at
320MHz. Not a style/cleanup change.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **Files:** `drivers/net/wireless/mediatek/mt76/mt7925/mcu.c` (+4
  lines)
- **Function:** `mt7925_mcu_bss_rlm_tlv()`
- **Scope:** single-file, surgical fix

**Step 2.2 — Code flow**

Record:
- **Before:** `chandef->width == NL80211_CHAN_WIDTH_320` hits `default`
  → `req->bw = CMD_CBW_20MHZ`.
- **After:** explicit case sets `req->bw = CMD_CBW_320MHZ` and
  `req->center_chan2` from `freq2` (same pattern as
  `NL80211_CHAN_WIDTH_80P80`).
- **Paths affected:** BSS association/channel-context updates via
  `mt7925_mcu_set_chctx()` and BSS enable path in
  `__mt7925_mcu_bss_req()`.

**Step 2.3 — Bug mechanism**

Record: **Logic/correctness bug** — incomplete switch on channel width.
Category: driver/firmware configuration mismatch causing total RX
failure. Not a crash/UAF, but complete loss of throughput at 320MHz.

**Step 2.4 — Fix quality**

Record: **Obviously correct.** Mirrors existing `80P80` handling; uses
`CMD_CBW_320MHZ` already defined in `mt76_connac.h`. Minimal regression
risk; only affects 320MHz width path.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `mt7925_mcu_bss_rlm_tlv()` introduced in `ca64503a8f06ec` (2024-06-12,
  merged 2024-07-09): “add mt7925_mcu_bss_rlm_tlv to constitue the RLM
  TLV”
- Bandwidth switch written without `NL80211_CHAN_WIDTH_320` from the
  start
- `c948b5da6bbec` (2023-09-18) introduced mt7925 driver with
  `[NL80211_CHAN_WIDTH_320] = 6` elsewhere in `mcu.c`

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag. Bug introduced by omission in
`ca64503a8f06ec`, which is present in this tree.

**Step 3.3 — Related file history**

Record:
- `mt7925_mcu_bss_rlm_tlv` added `ca64503a8f06ec`, refined in
  `22d66ef6653bb`
- No prior fix for this specific issue in tree
- Message-ID `-3` suggests patch 3 of a series, but this hunk is self-
  contained (no new symbols/structs)

**Step 3.4 — Author context**

Record: Patch authored by Javier Tia; reviewed by Sean Wang (MediaTek).
Felix Fietkau (mt76 maintainer) committed. Consistent with normal mt76
review path.

**Step 3.5 — Dependencies**

Record: **Standalone.** `CMD_CBW_320MHZ`, `freq2`, and
`NL80211_CHAN_WIDTH_320` already exist in this tree. No prerequisite
commits required for this hunk to compile or function.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig` requires `-c COMMITISH`; commit hash not in this tree,
so direct `b4 dig -c` failed. Lore fetch blocked by bot protection. Link
points to linux-wireless thread
`20260425195011.790265-3-sean.wang@kernel.org` (patch 3).

**Step 4.2 — Reviewers**

Record: UNVERIFIED via `b4 dig -w` (no commit hash). Commit message
itself documents **Reviewed-by: Sean Wang** and **Signed-off-by: Felix
Fietkau**.

**Step 4.3 — Bug report**

Record: GitHub issue #927 (MT7927/mt76 support) documents 320MHz
failure. Contributor analysis (jetm, ~line 2620) identifies this exact
missing `NL80211_CHAN_WIDTH_320` case as root cause: firmware told
20MHz, negotiates down, 0 throughput. Matches commit message.

**Step 4.4 — Related patches**

Record: Issue thread mentions additional 320MHz work (EHT MCS maps,
wiphy caps). **This commit is independently valuable** for the RLM TLV
path; does not depend on those other changes to be correct.

**Step 4.5 — Stable list history**

Record: UNVERIFIED — lore stable search blocked. No in-tree evidence of
prior stable nomination.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `mt7925_mcu_bss_rlm_tlv()` (modified).

**Step 5.2 — Callers**

Record:
- `mt7925_mcu_set_chctx()` — channel context changes during STA
  operation
- `__mt7925_mcu_bss_req()` — BSS enable during association/setup

Both are normal runtime WiFi paths, not init-only.

**Step 5.3 — Callees**

Record: `mt76_connac_mcu_add_tlv()`, `ieee80211_frequency_to_channel()`,
standard TLV population. Uses existing `CMD_CBW_*` constants.

**Step 5.4 — Reachability**

Record: Triggered when `chandef->width == NL80211_CHAN_WIDTH_320` during
association or channel update. Reachable for hardware/firmware paths
operating at 320MHz (e.g. MT6639/7927-class devices using mt7925 driver,
tested setups on 6.18.x per GitHub thread). In vanilla tree,
`mt7925_init_eht_caps()` currently advertises only 80/160 MHz MCS maps,
so 320MHz association is less common without additional caps work — but
the buggy code path still exists and is incorrect whenever 320MHz width
is presented.

**Step 5.5 — Similar patterns**

Record: `mt76_connac_chan_bw()` in `mt76_connac.h` already maps
`NL80211_CHAN_WIDTH_320 → CMD_CBW_320MHZ`. `mt7996` uses that helper for
RLM TLV. mt7925’s manual switch was simply incomplete — clear oversight.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **v6.18.44** (`make kernelversion` =
6.18.44). Current `mt7925_mcu_bss_rlm_tlv()` at lines 2325–2350 lacks
`NL80211_CHAN_WIDTH_320` case. Fix not yet applied (`git log -S "case
NL80211_CHAN_WIDTH_320" -- mt7925/mcu.c` returns nothing).

**Step 6.2 — Backport difficulty**

Record: **Clean apply expected** — 4-line insertion between
`NL80211_CHAN_WIDTH_160` and `NL80211_CHAN_WIDTH_5` cases. No
surrounding churn in that hunk.

**Step 6.3 — Related fixes already present?**

Record: **No** equivalent fix in this tree. Other 320MHz references
exist (`ch_width[]` at line 2151, `CMD_CBW_320MHZ` in `mt76_connac.h`)
but not in `bss_rlm_tlv()`.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: **IMPORTANT** — `drivers/net/wireless/mediatek/mt76/mt7925` WiFi
driver. Affects users of MT7925-class hardware (PCI `0x7925`, `0x0717`;
USB `0x7925`). Not core-kernel, but connectivity failure is user-visible
and severe for affected hardware.

**Step 7.2 — Subsystem activity**

Record: Actively maintained in 6.18.y — recent stable commits include
NULL-deref fix, crash fix, MLO fixes, TLV length fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: **Driver-specific** — users of mt7925/mt7925e/mt7925u (and
related 0x0717 devices) connecting to 320MHz BSS. Growing install base
on WiFi 7 platforms (motherboards, routers as STA).

**Step 8.2 — Trigger conditions**

Record: Association or channel update at 320MHz width. Requires 320MHz-
capable hardware and 320MHz AP/network. Not universal, but reproducible
and documented with concrete iperf numbers. Unprivileged user can
trigger by connecting to a 320MHz AP.

**Step 8.3 — Failure severity**

Record: **HIGH** — not a kernel oops, but complete data-path failure (0
Mbps, cannot decode frames). Effectively renders WiFi unusable at
320MHz.

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** HIGH for affected 320MHz users (restores full throughput;
  0 → 841 Mbps demonstrated)
- **Risk:** VERY LOW — 4 lines, no API change, only corrects firmware
  TLV for one width enum
- **Ratio:** Strongly favorable

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Real, reproducible bug with 0 Mbps failure mode
- Severe functional impact on 320MHz operation
- Minimal, obviously correct fix (matches `80P80` pattern and
  `mt76_connac_chan_bw()`)
- Extensively tested (8 Tested-by)
- Reviewed by MediaTek maintainer
- Buggy code present in v6.18.44 tree since `ca64503a8f06ec`
- Standalone, no dependencies
- Driver already has partial 320MHz support elsewhere — this completes a
  missing piece

**AGAINST:**
- In-tree `mt7925_init_eht_caps()` does not yet advertise 320MHz MCS
  maps, so vanilla users may not negotiate 320MHz today without
  additional upstream work
- Could be viewed as part of broader 320MHz enablement for MT7927-class
  hardware
- Full lore/stable discussion not accessible

**UNRESOLVED:**
- Exact upstream commit SHA (not in this tree)
- Whether reviewers explicitly nominated for stable on lore

The unresolved items do not outweigh the clear technical bug and fix
quality.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — 4-line switch case; 8
   Tested-by; maintainer reviewed
2. Fixes real bug affecting users? **PASS** — documented 0 Mbps at
   320MHz
3. Important issue? **PASS** — complete connectivity failure at
   supported width enum
4. Small and contained? **PASS** — 4 lines, one function
5. No new features/APIs? **PASS** — fixes firmware configuration for
   existing enum value
6. Can apply to local tree? **PASS** — buggy code confirmed present in
   v6.18.44

**Step 9.3 — Exception categories**

Record: Best classified as **hardware/driver quirk completion** —
completes missing bandwidth handling for hardware/firmware that already
uses `CMD_CBW_320MHZ` elsewhere in the same driver.

**Step 9.4 — Decision rationale**

For **v6.18.44**, the mt7925 driver is present, the incomplete switch
has been wrong since `bss_rlm_tlv()` was added, and users connecting at
320MHz get a completely broken data path. The fix is tiny, safe, well-
tested, and restores real-world functionality. This meets stable-kernel
criteria for an important driver bug fix.

---

## Verification

- [Phase 1] Parsed commit message, tags, and body from user-provided
  candidate
- [Phase 1] Identified 8 Tested-by, 1 Reported-by, Reviewed-by Sean
  Wang, Closes GitHub #927
- [Phase 2] Diff: +4 lines in `mt7925_mcu_bss_rlm_tlv()` adding
  `NL80211_CHAN_WIDTH_320` case
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 3] `git blame` on lines 2325–2357: switch introduced
  `ca64503a8f06ec` without 320MHz case
- [Phase 3] `git show ca64503a8f06ec`: function added June 2024 without
  320MHz handling
- [Phase 3] `git show c948b5da6bbec`: mt7925 driver in tree since Sept
  2023
- [Phase 3] `git merge-base --is-ancestor c948b5da6bbec HEAD` → driver
  present
- [Phase 3] `git merge-base --is-ancestor ca64503a8f06ec HEAD` → buggy
  function present
- [Phase 4] `b4 dig` without commit hash failed (needs `-c COMMITISH`)
- [Phase 4] Lore/patch.msgid.link fetch blocked by bot protection —
  UNVERIFIED
- [Phase 4] GitHub issue #927 fetched; line ~2620 confirms same root
  cause and fix
- [Phase 5] `grep mt7925_mcu_bss_rlm_tlv` → callers at lines 2421, 2867
  in `mcu.c`
- [Phase 5] `mt76_connac_chan_bw()` in `mt76_connac.h` lines 283–300
  maps 320MHz correctly
- [Phase 5] `CMD_CBW_320MHZ` exists at `mt76_connac.h:59`
- [Phase 5] Other 320MHz reference at `mcu.c:2151` (`ch_width[]`)
- [Phase 6] Read current `mcu.c:2325–2350` — missing 320MHz case
  confirmed
- [Phase 6] `git log -S "case NL80211_CHAN_WIDTH_320" -- mt7925/mcu.c` →
  empty (fix not in tree)
- [Phase 6] PCI IDs `0x7925`, `0x0717` in `pci.c` since `c948b5da6bbec`
- [Phase 8] `mt7925_init_eht_caps()` (`main.c:231–236`) advertises only
  80/160 MHz MCS — noted as scope limiter for vanilla 320MHz
  negotiation, but does not negate the bug in `bss_rlm_tlv()`

**YES**

 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 1d63bfa58c437..0e45f9c757351 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2342,6 +2342,10 @@ void mt7925_mcu_bss_rlm_tlv(struct sk_buff *skb, struct mt76_phy *phy,
 	case NL80211_CHAN_WIDTH_160:
 		req->bw = CMD_CBW_160MHZ;
 		break;
+	case NL80211_CHAN_WIDTH_320:
+		req->bw = CMD_CBW_320MHZ;
+		req->center_chan2 = ieee80211_frequency_to_channel(freq2);
+		break;
 	case NL80211_CHAN_WIDTH_5:
 		req->bw = CMD_CBW_5MHZ;
 		break;
-- 
2.53.0

