Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ED83E0C56;
	Mon, 20 Apr 2026 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691470; cv=none; b=VXpLp6wkoejowfyAi1Keb5xtQsYlv9a0Q0/FVd7i4QXLZbYYAq+CWv5xkvUXlYh49Y4Kd3EmzI960rjv37Stkfe2YtJf3svYZbUOaYPID2rTI7NNCkiD26I0VNDZ+SrCfT3Vbx3FNANwQrSB+x0SvJU7K6EJKOsMoEob/jT8DhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691470; c=relaxed/simple;
	bh=f6QPOIIGf0z10Meo2LBJgjPd1cjbcB4hiFCPNOlNWSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peHjqHvcOa/5Xru25cx7Hzc+c+ByRXqUAJvBzv9OptPhFTFunAHt954O3EFjW1ilR55OOYsPfhZBOrtkc5QnxjlitvkWUpackOjdNe8DrSm2aWRgcMmkFqEAuEtHWZzA13/e/FCvufz8fCvsVAiJ6s390JNjF2YLcB0E6+ki2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpsLKZrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpsLKZrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31939C19425;
	Mon, 20 Apr 2026 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691470;
	bh=f6QPOIIGf0z10Meo2LBJgjPd1cjbcB4hiFCPNOlNWSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpsLKZrU3QmVjM9SPESUqLMSlZUYcMQykUmiqQV9bjzV+S+PjEbi2AOVgW9facCKA
	 9QzrBMao8qdH9ky4jdc0PibBvSG8GsPCPJuGqHvvhVc6mm/xC6HnKdCbOyQab+VAeT
	 yxGEXiqmdJIaK4S8t2rAajyhRmlpCSaEGjq7vzrao5DAmya1yO97XI3GmgX0oP8Fpp
	 AuBiTknendveR69CS9ha49hSWuMsXdilpm5e0T3YrXhlxM+kniLDz3PSe/E9t/zN2M
	 Yz65LWlSrZo6eLfrVxzcWpLAqieR6zq1nORtWiEPKwxMlJZu6x////3cMXBNF6l96X
	 JV3UKKEHxlBKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Satish Kharat <satishkh@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] enic: add V2 SR-IOV VF device ID
Date: Mon, 20 Apr 2026 09:17:22 -0400
Message-ID: <20260420132314.1023554-48-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Satish Kharat <satishkh@cisco.com>

[ Upstream commit 803a1b02027918450b58803190aa7cacb8056265 ]

Register the V2 VF PCI device ID (0x02b7) so the driver binds to V2
virtual functions created via sriov_configure. Update enic_is_sriov_vf()
to recognize V2 VFs alongside the existing V1 type.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Link: https://patch.msgid.link/20260401-enic-sriov-v2-prep-v4-2-d5834b2ef1b9@cisco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `enic` (Cisco VIC Ethernet NIC driver,
  `drivers/net/ethernet/cisco/enic/`)
- **Action verb**: "add" — adding a new device ID
- **Summary**: Add V2 SR-IOV VF PCI device ID to the enic driver

### Step 1.2: Tags
- **Signed-off-by**: Satish Kharat `<satishkh@cisco.com>` (author, Cisco
  employee — the hardware vendor)
- **Link**: `https://patch.msgid.link/20260401-enic-
  sriov-v2-prep-v4-2-d5834b2ef1b9@cisco.com` — patch 2 of series "enic-
  sriov-v2-prep", version 4
- **Signed-off-by**: Jakub Kicinski `<kuba@kernel.org>` (networking
  subsystem maintainer)
- No Fixes: tag, no Reported-by:, no Cc: stable — expected for this
  review pipeline.

### Step 1.3: Commit Body
The commit body states: Register the V2 VF PCI device ID (0x02b7) so the
driver binds to V2 virtual functions created via `sriov_configure`.
Update `enic_is_sriov_vf()` to recognize V2 VFs alongside the existing
V1 type. Without this change, V2 VFs exposed by the hardware will not be
claimed by the enic driver at all.

### Step 1.4: Hidden Bug Fix Detection
This is a **device ID addition** — a well-known exception category.
Without this ID, users with V2 VF hardware cannot use SR-IOV on their
Cisco VIC adapters. This is a hardware enablement fix.

Record: [Device ID addition for hardware that the driver already
supports] [Not disguised — clearly a device ID add]

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **File changed**: `drivers/net/ethernet/cisco/enic/enic_main.c`
  (single file)
- **Lines added**: 3 functional lines
  1. `#define PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2   0x02b7`
  2. `{ PCI_VDEVICE(CISCO, PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2) },` in
     the PCI ID table
  3. `|| enic->pdev->device == PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2` in
     `enic_is_sriov_vf()`
- **Scope**: Single-file, surgical, 3-line addition

### Step 2.2: Code Flow
- **Before**: Driver only recognized PCI device 0x0071 as an SR-IOV VF.
  V2 VFs (0x02b7) were unrecognized.
- **After**: Driver recognizes both 0x0071 (V1) and 0x02b7 (V2) as SR-
  IOV VFs. V2 VFs get identical treatment as V1 VFs.
- `enic_is_sriov_vf()` is called in 6 places throughout the driver to
  branch behavior for VFs (MTU handling, MAC address, station address,
  netdev_ops selection). All behave correctly with V2 VFs after this
  change.

### Step 2.3: Bug Mechanism
- **Category**: Hardware workaround / Device ID addition (category h)
- Without the ID in `enic_id_table`, the PCI core won't bind the enic
  driver to V2 VFs at all
- Without the `enic_is_sriov_vf()` update, even if bound, V2 VFs would
  get incorrect PF (physical function) code paths

### Step 2.4: Fix Quality
- Obviously correct: mirrors the existing V1 VF pattern exactly
- Minimal and surgical: 3 lines
- Zero regression risk: only affects devices with PCI ID 0x02b7
- No API changes, no lock changes, no memory management changes

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- The original V1 VF support (PCI ID 0x0071) was added in commit
  `3a4adef5c0adbb` by Roopa Prabhu in January 2012, over 14 years ago.
- The `enic_is_sriov_vf()` function and PCI ID table entry have been
  untouched since then.
- The enic driver itself dates to 2008 (commit `01f2e4ead2c512`).

### Step 3.2: Fixes Tag
- No Fixes: tag (expected for device ID additions).

### Step 3.3: File History
- Recent commits to `enic_main.c` are mostly cleanup/refactoring
  (kmalloc conversion, timer rename, page pool API). No conflicting
  changes around the PCI ID table or `enic_is_sriov_vf()`.

### Step 3.4: Author
- Satish Kharat is a Cisco employee listed in MAINTAINERS for enic
  (commit `9b8eeccd7110d` updates enic maintainers). He is a regular
  contributor and domain expert for this driver.

### Step 3.5: Dependencies
- This is patch 2 of the "enic-sriov-v2-prep" series. However, the diff
  is **completely self-contained**: it only adds a `#define`, a table
  entry, and an OR condition. None of these reference anything
  introduced by patch 1 of the series.
- The code applies cleanly to the current v7.0 tree — the PCI ID table
  and `enic_is_sriov_vf()` are unchanged from when this patch was
  written.

Record: [Self-contained, no dependencies on other patches]

---

## PHASE 4: MAILING LIST

### Step 4.1-4.5
- b4 dig was unable to match directly (the commit isn't in this tree's
  history). Lore.kernel.org returned anti-scraping pages.
- The Link tag shows this is **v4** of the series, meaning it went
  through 4 rounds of review. Applied by Jakub Kicinski (net-next
  maintainer).
- The earlier v2 series from the same author
  (`v2_20260223_satishkh_net_ethernet_enic_add_vic_ids_and_link_modes`)
  shows the author was actively contributing VIC subsystem ID and link
  mode support around the same timeframe.

Record: [Patch went through v4 review, applied by net-next maintainer
Jakub Kicinski]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Impact
`enic_is_sriov_vf()` is called in 6 locations:
1. **Line 365**: MTU change notification handling (VFs schedule work vs
   warn)
2. **Line 1010**: MAC address setting (VFs accept zero MAC)
3. **Line 1736**: Open path (VFs skip station addr add)
4. **Line 1804**: Close path (VFs skip station addr del)
5. **Line 1864**: MTU change (VFs return -EOPNOTSUPP)
6. **Line 2831**: Probe path (VFs get `enic_netdev_dynamic_ops`)

All 6 call sites already handle VFs correctly — they just need the VF
detection to work for V2 devices. The change in `enic_is_sriov_vf()`
propagates the correct behavior automatically.

### Step 5.5: Similar Patterns
The original V1 VF ID addition (commit `3a4adef5c0adbb` from 2012)
followed the exact same pattern: define + table + function. This V2
addition mirrors it exactly.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
- Current HEAD is `v7.0`. The enic driver code is identical to mainline
  at the branch point.
- The PCI ID table, `enic_is_sriov_vf()`, and all call sites exist
  unchanged in this tree.
- This code has been present since 2012 (kernel 3.3+), so it exists in
  ALL active stable trees.

### Step 6.2: Backport Complications
- The diff applies cleanly — no intermediate changes to the PCI ID table
  or `enic_is_sriov_vf()`.
- No conflicts expected.

### Step 6.3: Related Fixes
- No other fixes for V2 VF support exist in stable.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: Network drivers / Cisco VIC Ethernet
- **Criticality**: IMPORTANT — Cisco VIC adapters are used in enterprise
  data centers (UCS servers)

### Step 7.2: Activity
- The enic driver receives periodic updates. The maintainer (from Cisco)
  is actively contributing.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
- Users with Cisco VIC adapters that create V2 SR-IOV virtual functions.
  This is enterprise/data center hardware.

### Step 8.2: Trigger
- Any user enabling SR-IOV on a Cisco VIC that produces V2 VFs (PCI ID
  0x02b7). Without this patch, VFs simply don't work.

### Step 8.3: Severity
- Without this patch: V2 VFs are **completely non-functional** (driver
  won't bind). Severity: HIGH for affected users.

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH — enables SR-IOV V2 VF functionality for Cisco VIC
  users
- **Risk**: VERY LOW — 3 lines, only affects devices with PCI ID 0x02b7,
  mirrors existing V1 pattern exactly
- **Ratio**: Excellent — high benefit, near-zero risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Classic PCI device ID addition — explicitly allowed exception in
  stable rules
- Only 3 functional lines of code
- Self-contained, no dependencies
- Applies cleanly to v7.0 tree
- Author is Cisco engineer / enic maintainer
- Applied by net-next maintainer (Jakub Kicinski)
- Went through v4 review cycle
- Mirrors existing V1 VF pattern from 2012
- Enables hardware that is completely non-functional without this change
- Zero regression risk (only affects new PCI device ID)

**AGAINST backporting:**
- Part of a multi-patch series — but this patch is self-contained
- No Fixes: tag — expected for device ID additions

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — mirrors existing V1 pattern
   exactly, v4 review, from vendor
2. Fixes a real bug? **YES** — V2 VFs don't work without this
3. Important issue? **YES** — complete hardware non-functionality
4. Small and contained? **YES** — 3 lines, 1 file
5. No new features or APIs? **YES** — just adds device ID to existing
   driver
6. Can apply to stable? **YES** — clean apply expected

### Step 9.3: Exception Category
**PCI Device ID addition to existing driver** — this is a canonical
example of the exception category.

### Step 9.4: Decision
This is a textbook PCI device ID addition: 3 lines, single file, from
the hardware vendor, enables V2 SR-IOV VFs on Cisco VIC adapters. It
meets all stable criteria and falls into the explicit "new device IDs"
exception category.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Cisco author and net-next
  maintainer; Link to v4 patch 2
- [Phase 2] Diff analysis: 3 lines — 1 define, 1 PCI table entry, 1 OR
  condition in `enic_is_sriov_vf()`
- [Phase 3] git blame: Original VF support (0x0071) added by
  `3a4adef5c0adbb` (2012, kernel 3.3); unchanged since
- [Phase 3] git show `3a4adef5c0adbb`: Confirmed identical pattern for
  V1 VF
- [Phase 3] git log: No conflicting recent changes to PCI ID table or
  `enic_is_sriov_vf()`
- [Phase 3] Author: Satish Kharat (Cisco), listed in MAINTAINERS update
  commit `9b8eeccd7110d`
- [Phase 4] b4 dig: Could not match commit (not in tree's history); Lore
  blocked by anti-scraping
- [Phase 4] Series context: v4 series "enic-sriov-v2-prep", applied by
  Jakub Kicinski
- [Phase 5] grep `enic_is_sriov_vf`: 6 call sites — all branch VF/PF
  behavior correctly; V2 VFs get same treatment
- [Phase 6] HEAD is v7.0; enic PCI table unchanged; clean apply
  confirmed
- [Phase 8] Failure mode: V2 VFs completely non-functional (driver won't
  bind), severity HIGH for affected users
- [Phase 8] Risk: Near-zero — new PCI ID only affects matching hardware

**YES**

 drivers/net/ethernet/cisco/enic/enic_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index e839081f9ee44..e16dfbcd2c229 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -66,12 +66,14 @@
 #define PCI_DEVICE_ID_CISCO_VIC_ENET         0x0043  /* ethernet vnic */
 #define PCI_DEVICE_ID_CISCO_VIC_ENET_DYN     0x0044  /* enet dynamic vnic */
 #define PCI_DEVICE_ID_CISCO_VIC_ENET_VF      0x0071  /* enet SRIOV VF */
+#define PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2   0x02b7  /* enet SRIOV V2 VF */
 
 /* Supported devices */
 static const struct pci_device_id enic_id_table[] = {
 	{ PCI_VDEVICE(CISCO, PCI_DEVICE_ID_CISCO_VIC_ENET) },
 	{ PCI_VDEVICE(CISCO, PCI_DEVICE_ID_CISCO_VIC_ENET_DYN) },
 	{ PCI_VDEVICE(CISCO, PCI_DEVICE_ID_CISCO_VIC_ENET_VF) },
+	{ PCI_VDEVICE(CISCO, PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2) },
 	{ 0, }	/* end of table */
 };
 
@@ -307,7 +309,8 @@ int enic_sriov_enabled(struct enic *enic)
 
 static int enic_is_sriov_vf(struct enic *enic)
 {
-	return enic->pdev->device == PCI_DEVICE_ID_CISCO_VIC_ENET_VF;
+	return enic->pdev->device == PCI_DEVICE_ID_CISCO_VIC_ENET_VF ||
+	       enic->pdev->device == PCI_DEVICE_ID_CISCO_VIC_ENET_VF_V2;
 }
 
 int enic_is_valid_vf(struct enic *enic, int vf)
-- 
2.53.0

