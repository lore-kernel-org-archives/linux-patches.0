Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A83D16F7;
	Mon, 30 Mar 2026 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874331; cv=none; b=J6ZATg27b1V3Wt0n4KGgAeKzP14Q8skPKApWDZZgDWJ9O2gEEOeGFZ01qg+jR4o3wE6/NLqzohQR5APEX5YwrM4Zn06i1nFlgmEbaXVXi9C4THvEyrbxaFV35MGjK6sBbTzYXpALtb8zSRo96CEbLTW17Lrbd4uD0Q07taIzHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874331; c=relaxed/simple;
	bh=uujdV5K8kf267EBdHO8hDWeHkE+dhVf5akE4yMxwd0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9mqV46pGWSCkVuMj91V2UYJZ6Km8uPQLGIG1X4wDj0rBf55jIX7Q4kgVrnMC6/ryp+pPoUsQYw2hk/KQWNpTIn7yGd/x6naXJwkntVV17gsj+lj36SD2nhBBm0KTwlSSrySMrgbfmbUZXRL6T60PebFpZyChvogQGwKBXmVmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIv9/zBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIv9/zBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B20DC2BCB1;
	Mon, 30 Mar 2026 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874330;
	bh=uujdV5K8kf267EBdHO8hDWeHkE+dhVf5akE4yMxwd0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIv9/zBdZ+nGcJRGs/qb6LYeMC9nA/ES+Y2iTnnjEtmrU4v9NVBtORSPr4FilE7mp
	 SmXYJXKUY4joGj1S0NlPl6uwDyj1phYULgxXMKPOqbbbLF+VPCuScuUbDLazMOKOvF
	 +G6fGQiV1GFxB6IfNSufqDXr0Q7mK43BrPjVFEwWEBX1ZD9TNERgp+IK6Q5LW8xCu0
	 WboLlb5HLpYDt6tJrlSVsLfW26oMcUcr29yG9AhuxCidIsfVkUK70CFEqFFxrckXJ0
	 ZZdjMZX10jwK8NWEgqhlGazVYgmi7k9Wb9n2W8CcV5aL5X4Tdd9fIuY/Tq4L0+DNJM
	 ofe1aOln4QQ2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	luke@ljones.dev,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] platform/x86: asus-nb-wmi: add DMI quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 30 Mar 2026 08:38:18 -0400
Message-ID: <20260330123842.756154-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 0198d2743207d67f995cd6df89e267e1b9f5e1f1 ]

The ASUS ROG Flow Z13-KJP GZ302EAC model uses sys_vendor name ASUS
rather than ASUSTeK COMPUTER INC., but it needs the same folio quirk as
the other ROG Flow Z13. To keep things simple, just match on sys_vendor
ASUS since it covers both.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260312212246.1608080-1-matthew.schwartz@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the facts verified. Here is the complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [platform/x86: asus-nb-wmi] [add] [Broaden DMI vendor match for
ASUS ROG Flow Z13-KJP GZ302EAC so the existing folio quirk applies]

**Step 1.2: Tags**
- Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev> (author)
- Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
- Reviewed-by: Denis Benato <denis.benato@linux.dev>
- Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com> (subsystem
  maintainer)
- Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
  (maintainer sign-off)
- Link: https://patch.msgid.link/20260312212246.1608080-1-
  matthew.schwartz@linux.dev
- No Fixes:, Reported-by:, Tested-by:, or Cc: stable tags (expected for
  candidates)

Record: Triple Reviewed-by including subsystem maintainer; strong
quality signal.

**Step 1.3: Body Text**
The GZ302EAC model reports `sys_vendor` as "ASUS" rather than "ASUSTeK
COMPUTER INC." The existing Z13 DMI entry matched only the longer
string, so the GZ302EAC variant never received `quirk_asus_z13`. The fix
broadens the vendor match to "ASUS" to cover both strings.
Record: [Bug] DMI vendor string mismatch prevents quirk application.
[Symptom] Missing folio/tablet and key-remap behavior on this model.
[Version info] None explicit. [Root cause] `sys_vendor` differs across
Z13 variants.

**Step 1.4: Hidden Bug Fix Detection**
Record: This is explicitly a hardware quirk fix — the existing Z13 quirk
fails to match a real hardware variant, causing functional regressions
for that model's users.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: [1 file: `drivers/platform/x86/asus-nb-wmi.c`, +1/-1]
[asus_quirks[] data table, Z13 entry] [Single-file, single-line surgical
fix]

**Step 2.2: Code Flow Change**
Before: The Z13 DMI entry matched `DMI_SYS_VENDOR` substring `"ASUSTeK
COMPUTER INC."` plus `DMI_PRODUCT_NAME` substring `"ROG Flow Z13"`.
After: Same entry matches `DMI_SYS_VENDOR` substring `"ASUS"` plus same
product name.

Verified in `drivers/firmware/dmi_scan.c` lines 864-866 that
`DMI_MATCH()` uses `strstr()` for non-exact matches:

```864:866:drivers/firmware/dmi_scan.c
                        if (strstr(dmi_ident[s],
                                   dmi->matches[i].substr))
                                continue;
```

Since "ASUS" is a substring of "ASUSTeK COMPUTER INC.", all previously-
matching devices continue to match. The broader string also covers
models reporting just "ASUS".
Record: [Widens vendor match safely; existing devices still match;
GZ302EAC now also matches]

**Step 2.3: Bug Mechanism**
Category: Hardware workaround / DMI quirk match fix.

The `quirk_asus_z13` provides:

```153:156:drivers/platform/x86/asus-nb-wmi.c
static struct quirk_entry quirk_asus_z13 = {
        .key_wlan_event = ASUS_WMI_KEY_ARMOURY,
        .tablet_switch_mode = asus_wmi_kbd_dock_devid,
};
```

Without matching, the driver falls back to `quirk_asus_unknown` (line
561), resulting in:
- Side button erroneously triggering WiFi rfkill toggle instead of
  emitting KEY_PROG3
- No tablet mode detection when the folio keyboard is detached

Record: [DMI match failure prevents `quirk_asus_z13` application on
GZ302EAC variant; fix widens vendor match safely]

**Step 2.4: Fix Quality**
Record: Obviously correct — single string change in a data table,
mechanically verifiable via `strstr()` semantics. Product-name match
(`"ROG Flow Z13"`) still constrains the match. Regression risk: very
low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
`git blame` shows the Z13 DMI entry was introduced by commit
`132bfcd24925d4` (Antheas Kapenekakis, 2025-08-08): "platform/x86: asus-
wmi: Fix ROG button mapping, tablet mode on ASUS ROG Z13".
Record: [Buggy code introduced by `132bfcd24925d4`] [First released in
v6.17]

**Step 3.2: Fixes: tag**
Record: N/A — no Fixes: tag present (expected for candidates).

**Step 3.3: File History**
Recent history shows `132bfcd24925d4` (Z13 quirk) and `7dc6b2d3b5503`
(Zenbook Duo UX8406CA quirk addition — same pattern). The candidate is a
standalone follow-up. No other GZ302 or KJP commits found.
Record: [Related: `132bfcd24925d4` prerequisite only] [Standalone fix]

**Step 3.4: Author**
No prior commits by Matthew Schwartz in this subsystem found in local
history. However, three subsystem-relevant reviewers signed off,
including the maintainer Ilpo Järvinen.
Record: [Author is not a regular contributor] [Maintainer reviewed and
signed off]

**Step 3.5: Dependencies**
`git tag --contains 132bfcd24925d4` confirms the prerequisite is in
v6.17, v6.18, and v6.19. It is NOT in v6.12 or older LTS trees (exit
code 1, empty output). The candidate is only meaningful for trees that
already contain this commit.
Record: [Depends on `132bfcd24925d4`; relevant for v6.17+; irrelevant
for v6.12.y, v6.6.y, v6.1.y, v5.15.y]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.4:**
Lore.kernel.org and patch.msgid.link were inaccessible due to Anubis
anti-bot protection. The commit message itself carries three Reviewed-by
tags and maintainer sign-off, which are strong acceptance signals.
Record: [Lore thread content UNVERIFIED; relying on commit tag signals]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions/Data**
Record: `asus_quirks[]` table, `asus_nb_wmi_quirks()`,
`dmi_check_system()`, `dmi_matched()`, `quirk_asus_z13`

**Step 5.2: Callers**
`asus_nb_wmi_quirks()` is the `.detect_quirks` callback in
`asus_nb_wmi_driver`, called from `asus_wmi_register_driver()` during
`asus_nb_wmi_init()` → module initialization. Runs on every boot/module
load for affected hardware.
Record: [Called during normal driver initialization, not a hot path]

**Step 5.3: Callees**
`asus_nb_wmi_quirks()` calls `dmi_check_system(asus_quirks)`. On match,
`dmi_matched()` sets the global `quirks` pointer. This subsequently
affects `asus_nb_wmi_key_filter()` (key remapping) and tablet-switch
initialization in `asus-wmi.c`.
Record: [Quirk drives key event handling and tablet mode detection]

**Step 5.4: Call Chain**
`module_init(asus_nb_wmi_init)` → `asus_wmi_register_driver()` →
platform probe → `wdrv->detect_quirks()` → `asus_nb_wmi_quirks()` →
`dmi_check_system(asus_quirks)` → `dmi_matched()` sets quirks.
Record: [Reachable on every boot on affected hardware]

**Step 5.5: Similar Patterns**
The same file has many similar `DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK
COMPUTER INC.")` entries. The sibling commit `7dc6b2d3b5503` (Zenbook
Duo UX8406CA) shows the same pattern of small, single-entry DMI quirk
additions.
Record: [Standard pattern in this file]

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
Verified via `git tag --contains`: The Z13 quirk (commit
`132bfcd24925d4`) exists in v6.17, v6.18, v6.19 and their point
releases. It does NOT exist in v6.12 or earlier LTS trees.
Record: [Relevant for v6.17.y, v6.18.y, v6.19.y ONLY]

**Step 6.2: Backport Complications**
One-line string change in a static data table. The Z13 entry is
identical across v6.17, v6.18, and v6.19.
Record: [Clean apply expected on all relevant trees]

**Step 6.3: Duplicate Fixes**
No evidence of an equivalent fix already shipped in stable.
Record: [No duplicates found]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:**
Record: [platform/x86 — ASUS notebook WMI driver] [PERIPHERAL: affects
specific ASUS laptop hardware, not universal]

**Step 7.2:**
Record: [Actively maintained; steady stream of DMI quirk and key-mapping
updates]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
Record: [Driver-specific / model-specific: owners of ASUS ROG Flow
Z13-KJP GZ302EAC and any other Z13 variant reporting `sys_vendor` =
"ASUS"]

**Step 8.2: Trigger Conditions**
Record: [Triggers on every boot/module-load on affected hardware; not
timing-dependent, not privilege-dependent]

**Step 8.3: Failure Mode Severity**
Without the quirk: the driver falls back to `quirk_asus_unknown`, so the
side button erroneously toggles WiFi rfkill and tablet mode detection
when the folio keyboard is detached does not work.
Record: [Functional hardware issue; severity MEDIUM for affected users]

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Correct hardware behavior for a real device variant (HIGH for
  those users)
- RISK: 1-line data-only change, still constrained by product-name match
  (VERY LOW)
Record: [Strongly favorable ratio]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: Fixes real DMI matching bug; trivial 1-line change; hardware
  quirk stable exception; triple Reviewed-by including maintainer;
  prerequisite exists in v6.17+; `strstr()` semantics verified; zero
  regression risk to existing devices
- AGAINST: Narrow impact (single model variant); not a
  crash/security/corruption fix
- UNRESOLVED: Lore thread content inaccessible; exact KJP DMI strings
  from external source unverified

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivially verifiable,
   maintainer-reviewed
2. Fixes a real bug? **YES** — hardware quirk not applied to real device
3. Important issue? **YES for affected users** — functional hardware
   regression
4. Small and contained? **YES** — 1 line, 1 file, data-only
5. No new features or APIs? **YES** — extends existing quirk coverage
6. Can apply to stable? **YES** — clean apply on v6.17+ trees

**Step 9.3: Exception Category**
Record: **Hardware quirk/workaround** — explicitly in the "quirks and
workarounds" class suitable for stable.

**Step 9.4: Decision**
This is a textbook hardware quirk fix: a single-line broadening of a DMI
vendor match so that an existing quirk applies to a real hardware
variant. It falls squarely into the stable exception for hardware quirks
and workarounds. The fix is trivially correct (verified via `strstr()`
semantics), carries effectively zero regression risk (product-name match
still constrains it), and has strong review signals. It should be
backported to stable trees v6.17.y, v6.18.y, and v6.19.y (the only trees
containing the prerequisite Z13 quirk commit `132bfcd24925d4`).

---

## Verification

- [Phase 1] Parsed subject/body/tags from commit message; found 3x
  Reviewed-by (Mario Limonciello, Denis Benato, Ilpo Järvinen) plus
  maintainer sign-off
- [Phase 2] Read diff: 1 line changed in `asus_quirks[]` — vendor string
  `"ASUSTeK COMPUTER INC."` → `"ASUS"`
- [Phase 2] Verified `DMI_MATCH()` uses `strstr()` in
  `drivers/firmware/dmi_scan.c` lines 865-866
- [Phase 2] Verified `quirk_asus_z13` at lines 153-156: sets
  `key_wlan_event = ASUS_WMI_KEY_ARMOURY` and `tablet_switch_mode =
  asus_wmi_kbd_dock_devid`
- [Phase 2] Verified fallback: `asus_nb_wmi_quirks()` initializes
  `quirks = &quirk_asus_unknown` (line 561) before `dmi_check_system()`
- [Phase 3] `git blame -L 547,555`: Z13 entry introduced by
  `132bfcd24925d4` (Antheas Kapenekakis, 2025-08-08)
- [Phase 3] `git show 132bfcd24925d4`: original commit is "Fix ROG
  button mapping, tablet mode on ASUS ROG Z13"
- [Phase 3] `git tag --contains 132bfcd24925d4`: present in v6.17,
  v6.18, v6.19 and their point releases
- [Phase 3] `git tag --contains 132bfcd24925d4 | grep v6.12`: empty —
  NOT in v6.12 or older LTS trees
- [Phase 3] `git log --oneline -20 -- drivers/platform/x86/asus-nb-
  wmi.c`: confirmed recent history and similar pattern (`7dc6b2d3b5503`)
- [Phase 4] WebFetch on lore.kernel.org and patch.msgid.link blocked by
  Anubis — lore thread UNVERIFIED
- [Phase 5] Confirmed call chain: `module_init` →
  `asus_wmi_register_driver()` → `.detect_quirks` →
  `asus_nb_wmi_quirks()` → `dmi_check_system()`
- [Phase 6] Z13 quirk only exists in v6.17+; fix irrelevant for v6.12.y
  and older
- [Phase 6] Z13 DMI entry identical across v6.17/v6.18/v6.19; clean
  apply expected
- [Phase 8] Failure mode: wrong quirks on affected hardware (missing key
  remap, missing tablet mode); severity MEDIUM
- UNVERIFIED: Exact DMI output of GZ302EAC (claim from commit message
  only)
- UNVERIFIED: Lore discussion content, stable nominations by reviewers,
  any NAKs

**YES**

 drivers/platform/x86/asus-nb-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a38a65f5c550d..b4677c5bba5b4 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -548,7 +548,7 @@ static const struct dmi_system_id asus_quirks[] = {
 		.callback = dmi_matched,
 		.ident = "ASUS ROG Z13",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow Z13"),
 		},
 		.driver_data = &quirk_asus_z13,
-- 
2.53.0

