Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA2E526AA8;
	Mon, 31 Aug 2026 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183866; cv=none; b=BBXJFClPEKqw39KnSd0N0ej3CLnO2VEkhBNSurh2dVgcatAopP4dvIkHOtDZTM+tLrTgciAoYZJnCpyYk9UCOCGV0e8HqGOw3oBuASoMi7Xo+onrOD5wy7ZI4Y8fspUV6u/qo/Jbc0OnPZOMbX3eGAN9Tt36jeBKgFtlRsG/0aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183866; c=relaxed/simple;
	bh=xXo7UTWYiXHAuHXJKBiaEAIMCFai0+FOmPY+ACFsCHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxSbeFUquM9Gm+74X+vXTH/JJVejN1NuFwsk2FMdRQ/zx0XNF1wAIUoqQP6mzLmVO909y5dIhaz0zN45v3b2G5wUyAUPyPPWZupIXTb/y4heE+5eIs7tLlEZQCc913HpLMVNqeNOtcq2to+0HPb0PJpa+w2CsM8psAcbLfyloYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+MEF+4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+MEF+4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910071F00A3F;
	Mon, 31 Aug 2026 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183863;
	bh=+LRBgQm6sj4tNo42HhUWLPZvzIm/BclzjpwzZc5im/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+MEF+4w3isN9xtQY5oyALpvYcmbD7zuNmNRezc1+iRLL07V+vBlrn3p5WP+uUYYI
	 knmpSZzpfl5+TFGm5SxChd/2+yQaQj3yjz4MvtY3b5/znP72WdSWcCq8FHF7+av6Ck
	 XA+OUbMNGfD4guc1VHotVsAmxOOC6Zwy/pycJsUDM9Nt4slZYEy2knX3EXGmxHlPgW
	 4WwloF1sknXRkOa59CJKYi5uNyHGlzRE3/FrxBvtlaF1evPobbvPhepR0/+9PIc7gR
	 wREU+Z4VuK2gN+kDXsEs6Kn7m9310/4B1NTRIcBvpKG3//yFx/5SyiIHb57yeerYnC
	 yw7KZ5fMb5iSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Javier Tia <floss@jetm.me>,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
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
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mt76: mt7925: populate EHT 320MHz MCS map in sta_rec
Date: Mon, 31 Aug 2026 09:26:17 -0400
Message-ID: <20260831133314.4125787-349-sashal@kernel.org>
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

[ Upstream commit e7bbd3d8b4f01473676da3aa8be17099e1604459 ]

The sta_rec_eht structure has a mcs_map_bw320 field, and the channel
width mapping includes NL80211_CHAN_WIDTH_320, but the 320MHz MCS/NSS
map was never copied from the station's EHT capabilities to the MCU TLV.
This prevents negotiation of 320MHz channel width even when both the
hardware and firmware advertise support for it.

Add the missing memcpy for the 320MHz MCS map, matching the existing
pattern for BW20, BW80, and BW160.

Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-5-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: wifi: mt76: mt7925: populate EHT 320MHz MCS
map in sta_rec

**Local tree:** `v6.18.44` (VERSION=6, PATCHLEVEL=18, SUBLEVEL=44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mt76: mt7925]` `[populate]` — Populate the missing
EHT 320MHz MCS/NSS map in the station-record EHT TLV sent to firmware.

### Step 1.2: Tags
**Record:**
- **Tested-by:** Marcin FM, Cristian-Florin Radoi, George Salukvadze,
  Evgeny Kapusta, Samu Toljamo, Ariel Rosenfeld, Chapuis Dario, Thibaut
  François, 张旭涵 (9 testers — strong real-world validation signal)
- **Reviewed-by:** Sean Wang `<sean.wang@mediatek.com>` (MediaTek/mt76
  maintainer)
- **Signed-off-by:** Javier Tia `<floss@jetm.me>` (author), Felix
  Fietkau `<nbd@nbd.name>` (mt76 maintainer)
- **Link:** https://patch.msgid.link/20260425195011.790265-5-
  sean.wang@mediatek.org (patch 5/N in a Sean Wang series)
- **No** Fixes:, Reported-by:, Cc: stable@vger.kernel.org, Acked-by:, or
  syzbot tags

**Notable pattern:** Heavy Tested-by list from multiple independent
users; maintainer Reviewed-by.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `sta_rec_eht` has `mcs_map_bw320`, and channel-width mapping
  includes `NL80211_CHAN_WIDTH_320`, but the driver never copies the
  station's 320MHz MCS/NSS map into the MCU TLV.
- **Symptom:** 320MHz channel-width negotiation fails even when hardware
  and firmware advertise support.
- **Root cause:** Missing `memcpy` for the 320MHz map; BW20/80/160 maps
  were populated, BW320 was not.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the neutral "populate" wording, this is a
functional driver bug — incomplete TLV population that prevents
advertised hardware capability from working. Not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wireless/mediatek/mt76/mt7925/mcu.c` (+1 line)
- **Function:** `mt7925_mcu_sta_eht_tlv()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** After allocating `STA_REC_EHT` TLV, driver copies
  `mcs_map_bw20` (conditionally), `mcs_map_bw80`, and `mcs_map_bw160`.
  `mcs_map_bw320` left zeroed.
- **After:** Adds `memcpy(eht->mcs_map_bw320, &mcs_map->bw._320,
  sizeof(eht->mcs_map_bw320));` matching the BW80/BW160 pattern.
- **Path:** Station association/update path when EHT-capable peer
  connects (`mt7925_mcu_sta_update` → `mt7925_mcu_sta_eht_tlv`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — incomplete firmware TLV population
- **Mechanism:** Firmware receives zero/empty 320MHz MCS map → refuses
  or cannot negotiate 320MHz despite peer and local HW supporting it.
  Sibling driver `mt7996` already populates this field correctly.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: mirrors existing BW80/BW160 `memcpy` calls and
  `mt7996_mcu_sta_eht_tlv()` at line 1394.
- Minimal, no unrelated changes.
- **Regression risk:** Very low — only adds data that should have been
  sent; no locking, no API change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `mt7925_mcu_sta_eht_tlv()` introduced in `c948b5da6bbec7` (2023-09-30,
  "add Mediatek Wi-Fi7 driver for mt7925 chips") without BW320 `memcpy`.
- Refactored in `b2f59773061920` (2024-06-12, MLO per-link STA) — BW320
  still missing.
- `mcs_map_bw320` field in `sta_rec_eht` also from `c948b5da6bbec7`.
- `NL80211_CHAN_WIDTH_320` mapping present since driver introduction.
- Bug present since driver inception (~2.5 years in this tree).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:**
- Recent mt7925 commits are mostly MLO, crash, and deadlock fixes — no
  prior fix for this issue.
- `mt7996` got `mcs_map_bw320` memcpy in `92aa2da9fa497` ("enable EHT
  support in firmware") — mt7925 was never updated similarly.
- Standalone one-line fix; patch 5 of a series but this hunk has no code
  dependency on other series patches.

### Step 3.4: Author context
**Record:** Javier Tia has one other mt7925 commit in this tree
(`b8bf7c221b364`, stale pointer fix). Sean Wang (reviewer) is primary
mt7925/MLO maintainer with extensive history in this driver.

### Step 3.5: Dependencies
**Record:** No prerequisites. `struct sta_rec_eht.mcs_map_bw320`,
`ieee80211_eht_mcs_nss_supp.bw._320`, and `mt7925_mcu_sta_eht_tlv()` all
exist in v6.18.44. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c db6df9da5b5d7` failed — commit not in this
checkout (upstream-only). Lore/patch.msgid.link URLs blocked by Anubis
bot protection; could not read thread content.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 -w (commit not in tree). Commit message
shows Reviewed-by Sean Wang and Signed-off-by Felix Fietkau.

### Step 4.3: Bug report
**Record:** No external bug report link. Nine Tested-by entries are the
primary evidence of user impact.

### Step 4.4: Series context
**Record:** Link indicates patch 5 of Sean Wang's 2026-04-25 series.
This specific change is self-contained (one `memcpy`). UNVERIFIED
whether other series patches are required for 320MHz to work end-to-end.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore.kernel.org/stable not accessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mt7925_mcu_sta_eht_tlv()` (modified), called from
`mt7925_mcu_sta_update()` path.

### Step 5.2: Callers
**Record:** `mt7925_mcu_sta_eht_tlv()` called from line 1993 inside sta-
rec update builder. `mt7925_mcu_sta_update()` called from:
- `main.c`: association (`mt76_sta_add`), disassociation, AP mode
  station add/remove, TDLS-related paths
- `mac.c`: one additional call site

All are normal WiFi connect/operate paths — common for any mt7925 user
associating to an EHT AP.

### Step 5.3: Callees
**Record:** `mt76_connac_mcu_add_tlv()`, `cpu_to_le16/le64`, `memcpy`.
TLV allocation zero-fills buffer; without the fix, `mcs_map_bw320` stays
zero.

### Step 5.4: Reachability
**Record:** Triggered on every EHT-capable station association/update
when `link_sta->eht_cap.has_eht` is true. Userspace connects to WiFi →
driver sends STA_REC to firmware. Reachable from normal network use; no
special privileges beyond using the WiFi interface.

### Step 5.5: Similar patterns
**Record:** `mt7996/mcu.c:1394` already has identical `memcpy` for
`mcs_map_bw320`. mt7925 was the outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 1687–1690 copies BW20/80/160
only; BW320 `memcpy` absent:

```1687:1691:drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
        if (link_sta->bandwidth == IEEE80211_STA_RX_BW_20)
                memcpy(eht->mcs_map_bw20, &mcs_map->only_20mhz,
sizeof(eht->mcs_map_bw20));
        memcpy(eht->mcs_map_bw80, &mcs_map->bw._80,
sizeof(eht->mcs_map_bw80));
        memcpy(eht->mcs_map_bw160, &mcs_map->bw._160,
sizeof(eht->mcs_map_bw160));
}
```

`sta_rec_eht.mcs_map_bw320[3]` exists in `mcu.h:416`.
`NL80211_CHAN_WIDTH_320` mapped at `mcu.c:2151`. Driver commit
`c948b5da6bbec7` is an ancestor of HEAD.

### Step 6.2: Backport complications
**Record:** Clean apply expected — single line insertion after the BW160
`memcpy`. No conflicting recent changes in this function.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep` found no "populate EHT 320MHz" or
`mcs_map_bw320` fix for mt7925 in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/net/wireless/mediatek/mt76/mt7925` — WiFi driver
(IMPORTANT; affects mt7925/Filogic 360 hardware users, not universal).

### Step 7.2: Activity
**Record:** Actively developed — many recent fixes (NULL deref,
deadlock, MLO, crash in reset). Driver is mature enough for stable
backports of targeted fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of mt7925-based WiFi 7 hardware (PCIe/USB) connecting
to EHT APs that support 320MHz. Config-specific: `CONFIG_MT7925` (driver
built-in or module).

### Step 8.2: Trigger conditions
**Record:** EHT-capable association where both ends support 320MHz.
Requires WiFi 7 AP with 320MHz and compatible firmware. Not every boot,
but normal for users seeking WiFi 7 performance. Unprivileged users
trigger via normal WiFi connection.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM** — No crash, hang, corruption, or security issue.
Functional defect: advertised 320MHz capability never negotiated; users
capped at lower bandwidth (160MHz or less). Significant performance
impact for affected WiFi 7 users, but system remains stable.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for mt7925 WiFi 7 users who cannot use 320MHz;
  enables hardware capability that driver structures already support.
- **Risk:** VERY LOW — one-line `memcpy`, proven pattern, 9 independent
  testers.
- **Ratio:** Favorable for backport to this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, long-standing driver bug (since Sep 2023 driver add)
- Bug confirmed present in v6.18.44
- One-line, obviously correct fix matching mt7996
- Nine Tested-by, maintainer Reviewed-by
- Completes existing EHT TLV — not a new API or feature
- Applies cleanly, no dependencies
- Users cannot use advertised 320MHz WiFi 7 bandwidth

**AGAINST backport:**
- Not a crash/corruption/deadlock/security issue
- Strict stable-rules reading: performance/capability limitation, not
  stability failure
- 320MHz WiFi 7 on mt7925 is a relatively narrow user base
- UNVERIFIED: whether other patches in the April 2026 series are also
  needed for full 320MHz operation

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors BW160 pattern and
   mt7996; 9 Tested-by + maintainer review.
2. Fixes a real bug affecting users? **PASS** — 320MHz negotiation
   broken for mt7925 EHT stations.
3. Important issue? **PASS (borderline)** — not crash/corruption, but
   clear functional hardware-enablement defect with documented user
   impact; fits "oh, that's not good" incomplete TLV population.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — fills existing struct field
   already allocated in TLV.
6. Can apply to local tree? **PASS** — all structures and code paths
   exist in v6.18.44.

### Step 9.3: Exception categories
**Record:** Closest match: hardware enablement / incomplete capability
population (analogous to quirks enabling advertised hardware behavior).
Not a device-ID addition, build fix, or docs fix.

### Step 9.4: Decision rationale
For **v6.18.44** specifically: the mt7925 driver, EHT support,
`sta_rec_eht.mcs_map_bw320`, and 320MHz channel-width mapping all exist.
The omission of one `memcpy` has prevented 320MHz negotiation since the
driver was added. The fix is trivial, well-tested, maintainer-reviewed,
and low-risk. While not a stability crash, it is a genuine, user-visible
functional bug in production WiFi 7 hardware support — the kind of
targeted driver fix stable trees routinely carry.

---

## Verification

- **[Phase 1]** Parsed subject, 9 Tested-by, Reviewed-by Sean Wang, Link
  tag; no Fixes:/syzbot
- **[Phase 2]** Confirmed 1-line `memcpy` addition in
  `mt7925_mcu_sta_eht_tlv()`
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → function
  from c948b5da6bbec7 (2023-09-30); BW320 never copied
- **[Phase 3]** `git log -S mcs_map_bw320` → field since driver add;
  mt7996 fix in 92aa2da9fa497
- **[Phase 3]** `git merge-base --is-ancestor c948b5da6bbec7 HEAD` →
  driver in tree
- **[Phase 4]** `b4 dig -c db6df9da5b5d7` → commit not in tree
  (expected)
- **[Phase 4]** lore.kernel.org / patch.msgid.link → blocked by Anubis;
  thread content UNVERIFIED
- **[Phase 5]** `grep mt7925_mcu_sta_eht_tlv` → caller at mcu.c:1993;
  `mt7925_mcu_sta_update` callers in main.c, mac.c
- **[Phase 5]** Read mt7996/mcu.c:1394 → identical BW320 `memcpy`
  present
- **[Phase 6]** Read mcu.c:1687-1691 → buggy code present (no BW320
  copy)
- **[Phase 6]** Read mcu.h:416 → `mcs_map_bw320[3]` exists
- **[Phase 6]** Read mcu.c:2151 → `NL80211_CHAN_WIDTH_320` mapped
- **[Phase 6]** `git log --grep` → no existing fix in tree
- **[Phase 8]** Failure mode assessed as functional/MEDIUM, not crash

**YES**

 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 18efcfa614400..1d63bfa58c437 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1693,6 +1693,7 @@ mt7925_mcu_sta_eht_tlv(struct sk_buff *skb, struct ieee80211_link_sta *link_sta)
 		memcpy(eht->mcs_map_bw20, &mcs_map->only_20mhz, sizeof(eht->mcs_map_bw20));
 	memcpy(eht->mcs_map_bw80, &mcs_map->bw._80, sizeof(eht->mcs_map_bw80));
 	memcpy(eht->mcs_map_bw160, &mcs_map->bw._160, sizeof(eht->mcs_map_bw160));
+	memcpy(eht->mcs_map_bw320, &mcs_map->bw._320, sizeof(eht->mcs_map_bw320));
 }
 
 static void
-- 
2.53.0

