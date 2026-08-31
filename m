Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D6C570968;
	Mon, 31 Aug 2026 13:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184123; cv=none; b=jcF/HdqBGZByiwWw4OpxjPI3fj3NP2iM/2ScV+UMPTwq1e5JiNwJbUiNevGWbh1ETut0reOJSUENmzj8CqSIowHgzebgE4E1qCexdGi+k9qRLUCLTelARClT5oGQwTMW1lzIK8GbDunprOxE3cXkHXERa6NKc9KozrdiwDbolvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184123; c=relaxed/simple;
	bh=mpjtqHeKpKlYJNv6qneam1hU3pUvmE24NiYPxMgMIW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+kQhWgCmywRnWv76wXv0SJQdBmqRT18f6t7K39AnbP3TSt4ZIOauAv8HuiQw9jVkHGNd4b5vI1Fhv8397fZoKgrW/9am/Y2UX4C3iKqgykY57qJk271ZHMsqWcXuS8HeLTt9lyEfxx4GygJjdJ7sryP9QWLbxwHBHBd6jMEjYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBdSfq0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBdSfq0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E501F00ACA;
	Mon, 31 Aug 2026 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184120;
	bh=1KhTpkn9Gs5/XGZEuqcuUtf2rr5RFDnDzDilx9TUMJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBdSfq0wKrYi7AXQ86WjpCHQpR4tuHExNrJVbSm6fueBaajxQxeYYy+s38g0HCmdc
	 Z9SC3fKBwftawBaMDPyMqW022fR/pk/wHkmvaxN2QmXP+5MMaxAoLl2kUm98hLLL3S
	 eAdiRPgDmlCqV1U/2NU9mrDaECu02jx0NceM3oJzuIlGPD5vT4dHK7GAYkJZJVEmyb
	 dx6kb4nYSuzaO303CmgHrAB81opv+8ZqwYN/dOuxS7cg7EMb94pIwIP7tcJstBpXfs
	 KxP3u+vXF52JWouOwd4SZgX6oAyUDpv1QJ7XyA/rrfX6A6abxkbcuvoi+5T0e4cCbK
	 Slu7A6NSoY1NA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: rtw89: disable CSI STBC for VHT 160MHz
Date: Mon, 31 Aug 2026 09:28:52 -0400
Message-ID: <20260831133314.4125787-504-sashal@kernel.org>
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

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit d1fba55228685a7a237681be739683eaf698b9bc ]

Fix interoperability problem where CSI feedback with STBC enabled at
VHT 160MHz BW cannot be properly decoded by certain APs, causing CSI
reports to be rejected. This problem is specific to Wi-Fi 7 chips,
as Wi-Fi 6 defaults to 20MHz CSI BW. Therefore, disable STBC encoding
for CSI transmission in VHT 160MHz mode to ensure CSI feedback is
accepted by these APs and maintain smooth throughput.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260424072552.59220-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `wifi: rtw89: disable CSI STBC for VHT
160MHz`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: rtw89]` `[disable]` — disable STBC encoding for CSI
feedback in VHT 160MHz mode on BE-generation (Wi-Fi 7) chips.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Dian-Syuan Yang `<dian_syuan0116@realtek.com>`
  (author)
- **Signed-off-by:** Ping-Ke Shih `<pkshih@realtek.com>` (Realtek rtw89
  maintainer)
- **Link:**
  https://patch.msgid.link/20260424072552.59220-4-pkshih@realtek.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: no syzbot/fuzzer report; vendor-driven IOT fix

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** CSI feedback with STBC enabled at VHT 160MHz cannot be
  decoded by certain APs; CSI reports are rejected.
- **Symptom:** Degraded throughput when beamforming CSI feedback fails
  on 160MHz links with incompatible APs.
- **Root cause (author):** Wi-Fi 7 chips use wider CSI bandwidth than
  Wi-Fi 6 (which defaults to 20MHz CSI BW); STBC in CSI at 160MHz
  triggers AP-side rejection.
- **Version info:** Commit message says Wi-Fi 7 chips; cover letter
  (series 0/3) incorrectly says "WiFi 6 chips" — code only touches
  `mac_be.c`, which is the BE/Wi-Fi 7 path.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit interoperability (IOT)
workaround, not cleanup. It falls under the hardware-quirk / AP-
compatibility exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/net/wireless/realtek/rtw89/mac_be.c` (+4 lines)
- **Function:** `rtw89_mac_set_csi_para_reg_be()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `stbc_en` could remain set (default 1, masked by peer
  capabilities) and was written into `B_BE_BFMEE_CSIINFO0_STBC_EN` for
  all VHT configurations.
- **After:** If the link STA advertises
  `IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ`, `stbc_en` is forced to 0
  before register encoding.
- **Path:** Called during association when the peer AP has beamformer
  capability (`rtw89_mac_bf_assoc_be()` →
  `rtw89_mac_set_csi_para_reg_be()`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / interoperability (hardware quirk workaround)
- **Mechanism:** STBC-enabled CSI frames at VHT 160MHz are malformed or
  incompatible with certain AP decoders; disabling STBC makes CSI
  feedback acceptable, restoring beamforming throughput.

### Step 2.4: Fix quality assessment
**Record:** Obviously correct vendor IOT workaround; minimal diff; very
low regression risk. Only affects CSI parameter encoding on the BE chip
path when 160MHz VHT capability is present. No lock/API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** The surrounding CSI setup code in `mac_be.c` dates to the
file's introduction in this tree (commit `19eef1d98eeda`, Linux 6.18-rc7
merge base). The buggy STBC-default behavior has been present since
`mac_be.c` was added.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: File history for related changes
**Record:**
- Related CSI fix already in this tree: `fa8301c29079a` ("wifi: rtw89:
  mac: correct page number for CSI response") — also a beamforming/CSI
  fix in `mac_be.c`.
- Part of a 3-patch interoperability series submitted Apr 2026:
  1. PCI CLK ready for RTL8922DE
  2. Disable HTC field in AP mode
  3. **This patch** (CSI STBC)
- Series applied to `rtw-next` branch; this patch is **standalone**
  (only touches `mac_be.c`).

### Step 3.4: Author's other commits
**Record:** Ping-Ke Shih is the rtw89 maintainer (authored CSI page fix
`fa8301c29079a` already backported here). Dian-Syuan Yang is a Realtek
contributor.

### Step 3.5: Prerequisites
**Record:** No dependencies. Applies independently of patches 1/2 in the
series. Only requires `mac_be.c` and `rtw89_mac_set_csi_para_reg_be()` —
both present in 6.18.43.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:** https://lore.kernel.org/linux-
  wireless/20260424072552.59220-4-pkshih@realtek.com/
- **Series:** `[PATCH rtw-next 0/3] wifi: rtw89: update hardware
  settings to fix interoperability`
- **Revisions:** Single submission (rtw-next 3/3); applied to rtw-next
  branch Apr 29, 2026
- **Reviewer feedback:** Only maintainer self-reply confirming series
  applied; no NAKs, no explicit stable nomination
- Cover letter describes patch 3 as fixing beamforming CSI that "can't
  reply on 160MHz bandwidth"

### Step 4.2: Reviewers
**Record:** Sent to `linux-wireless@vger.kernel.org`; CC'd
`dian_syuan0116@realtek.com`. Maintainer applied directly to rtw-next.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or Bugzilla link. Vendor-
internal IOT discovery.

### Step 4.4: Related patches
**Record:** Sibling patches fix PCI L1SS stability and AP-mode HTC field
— separate issues. This patch does not depend on them.

### Step 4.5: Stable mailing list
**Record:** No stable-list discussion found for this specific fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rtw89_mac_set_csi_para_reg_be()`, called from
`rtw89_mac_bf_assoc_be()`.

### Step 5.2: Callers
**Record:**
- `rtw89_mac_bf_assoc_be()` → `rtw89_mac_ops.bf_assoc` (BE generation
  only)
- Invoked from `rtw89_mac_bf_assoc()` in `core.c` during STA association
  (`rtw89_core_sta_assoc()` path, line ~4787)
- Only runs when peer AP has beamformer capability
  (`rtw89_sta_has_beamformer_cap()`)

### Step 5.3: Callees
**Record:** RCU lock for `link_sta`, register read/write
(`rtw89_write16`, `rtw89_mac_reg_by_idx`), capability bit checks. No
allocation or complex locking.

### Step 5.4: Call chain / reachability
**Record:** Userspace connects to Wi-Fi → driver association →
beamforming init → CSI parameter setup. Reachable on every association
to a beamforming-capable AP. Unprivileged users trigger this via normal
Wi-Fi connection.

### Step 5.5: Similar patterns
**Record:** Wi-Fi 6 path (`rtw89_mac_set_csi_para_reg_ax()` in `mac.c`)
does **not** need this fix per commit message (20MHz default CSI BW).
Only BE chips (`RTW89_CHIP_BE`, currently RTL8922A only) use `mac_be.c`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** `rtw89_mac_set_csi_para_reg_be()` at lines
2109–2176 in `mac_be.c` sets `stbc_en = 1` by default with no 160MHz
guard. Fix comment/string not present (grep confirmed). RTL8922A
(`RTW89_CHIP_BE`) and `rtw8922ae.c` PCI driver are present.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Identical context at lines
2148–2150 matches the patch hunk. No conflicting recent changes in this
function.

### Step 6.3: Related fixes already present?
**Record:** `fa8301c29079a` (CSI page number) is present; this STBC fix
is **not** yet applied or duplicated.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/realtek/rtw89/` — **IMPORTANT** (Wi-Fi
driver, affects users of RTL8922A/8922AE hardware). Not core kernel, but
real production hardware.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple rtw89 fixes already backported
to 6.18.y (CSI, PCI validation, bounds checks, resume fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **RTL8922A/8922AE** (Wi-Fi 7) hardware on
**6.18.y**, connecting to beamforming-capable APs at VHT 160MHz. Driver-
specific, config-dependent (beamforming + 160MHz).

### Step 8.2: Trigger conditions
**Record:**
- Wi-Fi 7 BE chip (8922A family)
- Association to AP with SU/MU beamformer capability
- VHT 160MHz channel width capability advertised
- **Common** for intended use case of this hardware; not a rare edge
  case

### Step 8.3: Failure mode severity
**Record:** CSI reports rejected → beamforming feedback loop broken →
**throughput degradation** (not crash, hang, oops, or data corruption).
Severity: **MEDIUM** — functional performance issue on supported
hardware with common AP configurations. Per `stable-kernel-rules.rst`,
hardware quirks and notable performance issues qualify.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for affected 8922AE users — restores beamforming CSI
  at 160MHz with incompatible APs
- **Risk:** VERY LOW — 4 lines, BE-path only, no API/lock changes
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real IOT/AP compatibility bug on supported Wi-Fi 7 hardware in this
  tree
- Hardware quirk / interoperability workaround (stable-rules exception)
- Small (4 lines), obviously correct, standalone
- Same driver's CSI/beamforming fixes already backported to 6.18.y
- rtw89 maintainer authorship and sign-off
- Buggy code confirmed present; clean apply expected
- Affects normal association path for primary hardware use case (160MHz
  + beamforming)

**AGAINST backport:**
- No crash, security, corruption, or deadlock
- Throughput/performance impact only (not connectivity failure)
- Narrow hardware scope (8922A BE chips only)
- No external user/syzbot reports
- Not yet in mainline at time of tree inspection (rtw-next only)

**Unresolved:** No independent Tested-by or distribution bug report;
severity is vendor-reported throughput impact only.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — vendor IOT workaround,
   maintainer SOB, applied to rtw-next
2. Fixes a real bug affecting users? **PASS** — CSI rejection with
   certain APs on 8922AE at 160MHz
3. Important issue? **PASS** — hardware quirk / notable performance
   issue per stable-kernel-rules.rst (not CRITICAL crash class, but
   qualifies)
4. Small and contained? **PASS** — 4 lines, 1 file
5. No new features or APIs? **PASS** — workaround only
6. Can apply to local tree? **PASS** — code exists, clean apply

### Step 9.3: Exception category
**Record:** **Hardware quirk / interoperability workaround** —
explicitly labeled "IOT issues with certain APs" in the patch.

### Step 9.4: Decision rationale

This is a vendor IOT workaround for RTL8922A Wi-Fi 7 hardware that is
already supported in Linux 6.18.43. Without it, CSI beamforming feedback
at VHT 160MHz is rejected by certain APs, causing measurable throughput
loss on a common configuration for this chipset. The fix is minimal,
touches only the BE MAC path, matches the pattern of other rtw89 CSI
fixes already backported to this stable tree, and fits the stable-
kernel-rules.rst hardware-quirk category. It does not fix a kernel crash
or security issue, but the conservative stable bar explicitly includes
hardware quirks and user-visible performance problems on supported
hardware.

---

## Verification

- [Phase 1] Parsed subject, tags, body; fetched patch 3/3 from lore mbox
- [Phase 1] Cover letter vs. commit body chip-generation discrepancy
  noted (cover says WiFi 6, patch says Wi-Fi 7; code is `mac_be.c` only)
- [Phase 2] Read `mac_be.c` lines 2109–2176; confirmed 4-line addition
  point matches diff
- [Phase 2] Confirmed `stbc_en` encoded into
  `B_BE_BFMEE_CSIINFO0_STBC_EN` at line 2164
- [Phase 3] `git describe HEAD` → v6.18.43
- [Phase 3] `git blame` lines 2141–2148 → present since `mac_be.c`
  introduction
- [Phase 3] `git log --oneline -20 -- mac_be.c` → CSI page fix
  `fa8301c29079a` present
- [Phase 3] `git log -S rtw89_mac_set_csi_para_reg_be` → function
  introduced with `mac_be.c`
- [Phase 4] curl lore mbox: series 0/3 interoperability, patch applied
  to rtw-next Apr 29 2026
- [Phase 4] Thread: no NAKs, no stable nomination, maintainer applied
  confirmation only
- [Phase 5] `grep bf_assoc` → `core.c:4787` calls during association
- [Phase 5] `grep RTW89_CHIP_BE` → only `rtw8922a.c` sets BE generation
- [Phase 5] `mac_ax` CSI function (`rtw89_mac_set_csi_para_reg_ax`) has
  no 160MHz STBC guard — unaffected by design
- [Phase 6] `grep "Disable stbc_en in VHT 160MHz"` → not in tree (fix
  absent)
- [Phase 6] `rtw8922ae.c` PCI IDs and `rtw8922a_chip_info` with
  `RTW89_CHIP_BE` confirmed present
- [Phase 6] Patch context at lines 2148–2150 matches upstream diff hunk
- [Phase 8] Failure mode: throughput degradation, severity MEDIUM; no
  crash/security path identified

**YES**The analysis is complete: **this commit should be backported to
the local 6.18.43 tree.**

It’s a small Realtek rtw89 interoperability fix for RTL8922A/8922AE (Wi-
Fi 7) hardware. When beamforming CSI feedback runs at VHT 160MHz with
STBC enabled, certain APs reject the reports and throughput suffers. The
patch disables STBC for that case in `mac_be.c` — 4 lines, low risk, and
the buggy code is already present in this tree.

It fits the stable “hardware quirk / interoperability” category, similar
to other rtw89 CSI fixes already in 6.18.y. It’s not a crash or security
fix, but it does address a real performance issue on supported hardware.

**YES**

 drivers/net/wireless/realtek/rtw89/mac_be.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index e5a61c628b731..b03392612f252 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2147,6 +2147,10 @@ static int rtw89_mac_set_csi_para_reg_be(struct rtw89_dev *rtwdev,
 		sound_dim = min(sound_dim, t);
 	}
 
+	/* Disable stbc_en in VHT 160MHz to avoid IOT issues with certain APs */
+	if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+		stbc_en = 0;
+
 	nc = min(nc, sound_dim);
 	nr = min(nr, sound_dim);
 
-- 
2.53.0

