Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98183F7AA9;
	Wed, 20 May 2026 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276061; cv=none; b=OtpmvwfKq9kI9sHkIJ5SYx28YzWmiWkfa7AXtL+MHnaCAfMHKjeB9gKyNE92q2DGJdaJcoDOdY5uO23WWMNtmBMCcUdvirUtXtOFsw56+Vrz0Lt+nkD7AM+m7aUCn+Y0Bib1J70lnKgFkqNOInOUpwznprWZgnNN9/Fq0ylqquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276061; c=relaxed/simple;
	bh=0xxZol44F4hcM8ECcpKTGhNLkaDUQS+6DnHRlwMRPZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/EkL9lagp0pYoPcOxXMG3yk5M4fHyXSEGFtUjaM9rDvBcPp1cbEPu5gVU9BC/5ldgq7sXje1jklwwvns2kyItC76lKutaCVgfIui6ZxUwqxZ9iok2m1KDYX1Flr64b4zRK9ijz6ikEG+PvTtpIP+vcQyyDccZMeQXXXX93/vjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApmKzAEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApmKzAEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561CE1F00894;
	Wed, 20 May 2026 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276057;
	bh=A6I+UaJfx4VtYeDC9wXibAsHX+VrY8JE84i64An35Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApmKzAEKDa5pVBXe6qoTmfpb0Duk98ldyllpvToCZ6LEmf3YFqDz9SteUOTTLKIVY
	 bK3E5ZN95NlqB7jMzz/40+FCP4+7c1Q1mgWuo2FygcSueV//gyIUpbjUgnShH7rCAh
	 gI+YXhl7LUnH/Iv2ppmf3qd44qfSG/nOTrAlc0rk9SOaWRcd3hXSixvGynDqsrPnz3
	 e556K6JaR9T49dOouwHcYaIBEzQNToEEvU3JocWtmrRvebb+/lgm+tZ4VigmlxHug0
	 gPudeXox6p4t/Hx/ODFqwWwHxTJQlbF+N5d74OpEIvhzOOOGpZiMSN1Lj4LIYQ1+R3
	 +djfOqI3EnlPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paolo Pisati <p.pisati@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	luke@ljones.dev,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8407AA
Date: Wed, 20 May 2026 07:19:23 -0400
Message-ID: <20260520111944.3424570-51-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Paolo Pisati <p.pisati@gmail.com>

[ Upstream commit 2997606dd17729404cef9821ce66dd037b6019eb ]

Use the existing zenbook duo keyboard quirk for the UX8407AA model too.

Signed-off-by: Paolo Pisati <p.pisati@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260508070956.62201-1-p.pisati@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `platform/x86: asus-nb-wmi`; action verb
`add`; intent is to add a DMI match for `ASUS Zenbook Duo UX8407AA` to
reuse an existing Zenbook Duo keyboard quirk.

Step 1.2 Record: Tags found: `Signed-off-by: Paolo Pisati`, `Reviewed-
by: Denis Benato`, `Link:
https://patch.msgid.link/20260508070956.62201-1-p.pisati@gmail.com`,
`Reviewed-by: Ilpo Järvinen`, `Signed-off-by: Ilpo Järvinen`. No
`Fixes:` tag and no explicit stable tag in the commit.

Step 1.3 Record: The commit body says only: “Use the existing zenbook
duo keyboard quirk for the UX8407AA model too.” The underlying quirk was
verified in local history: it suppresses spurious WLAN key events on
Zenbook Duo keyboards, avoiding unintended wireless/rfkill behavior.

Step 1.4 Record: This is a hardware quirk addition, not disguised
cleanup. It fixes model-specific behavior by making an already-existing
workaround apply to another DMI-identified ASUS model.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `drivers/platform/x86/asus-nb-wmi.c`,
9 insertions, no removals. Modified area: `asus_quirks[]` DMI table.
Scope: single-file surgical hardware quirk.

Step 2.2 Record: Before, UX8407AA did not match `asus_quirks[]`, so
`quirk_asus_zenbook_duo_kbd` was not selected for that model. After,
matching DMI vendor/product strings select `quirk_asus_zenbook_duo_kbd`.

Step 2.3 Record: Bug category is hardware workaround/DMI quirk. Verified
quirk behavior: `quirk_asus_zenbook_duo_kbd` sets `key_wlan_event =
ASUS_WMI_KEY_IGNORE`; `asus_nb_wmi_key_filter()` maps WMI codes `0x5D`,
`0x5E`, and `0x5F` to that quirk value when set; without the quirk,
those codes remain `KEY_WLAN` events.

Step 2.4 Record: Fix quality is high: 9-line DMI table entry, no new
API, no shared logic change. Regression risk is very low and limited to
systems whose DMI strings match `DMI_SYS_VENDOR=ASUS` and
`DMI_PRODUCT_NAME=Zenbook Duo UX8407AA`.

## Phase 3: Git History Investigation
Step 3.1 Record: Blame around the table showed the existing UX8406MA
quirk entry came from `9286dfd5735b` and UX8406CA from `7dc6b2d3b550`.
Blame of the quirk definition showed `quirk_asus_zenbook_duo_kbd` was
introduced by `9286dfd5735b`, later converted to `key_wlan_event =
ASUS_WMI_KEY_IGNORE` by `132bfcd24925`.

Step 3.2 Record: No `Fixes:` tag is present, so there is no introducer
tag to follow.

Step 3.3 Record: Recent related history includes `9286dfd5735b` fixing
spurious rfkill on UX8406MA, `7dc6b2d3b550` adding UX8406CA, and later
key handling fixes `132bfcd24925` and `225d1ee0f5ba`. The candidate is
standalone where `quirk_asus_zenbook_duo_kbd` exists.

Step 3.4 Record: `git log --author="Paolo Pisati" -10 --
drivers/platform/x86` showed no prior local platform-x86 commits by this
author. The patch was reviewed by Denis Benato and Ilpo Järvinen; Ilpo
committed it.

Step 3.5 Record: Dependency is the existing Zenbook Duo keyboard quirk.
Verified present in releases `v6.12` and newer in this repo; absent from
`v6.6`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 2997606dd17729404cef9821ce66dd037b6019eb`
found the exact lore thread at the patch message-id URL. `b4 dig -a`
showed only v1, so no newer revision was found.

Step 4.2 Record: `b4 dig -w` showed recipients included Corentin Chary,
Luke D. Jones, Denis Benato, Hans de Goede, Ilpo Järvinen, and
`platform-driver-x86@vger.kernel.org`. The patch received `Reviewed-by`
from Denis Benato and Ilpo Järvinen.

Step 4.3 Record: No separate bug report or `Reported-by` tag was found
in the commit. The b4-fetched thread contained Denis’s review and Ilpo’s
applied notice, but no detailed user report.

Step 4.4 Record: No multi-patch series; b4 identified this as a single-
patch v1 series. Related local commits are the previous Zenbook Duo
quirk additions and key handling corrections.

Step 4.5 Record: Direct `WebFetch` searches on lore/stable were blocked
by Anubis. I could not verify stable-list discussion via WebFetch. `b4`
did successfully fetch the exact patch thread.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified data structure: `asus_quirks[]`. Existing
functions involved by flow: `dmi_matched()`, `asus_nb_wmi_quirks()`,
`asus_nb_wmi_key_filter()`, and `asus_wmi_handle_event_code()`.

Step 5.2 Record: `asus_nb_wmi_quirks()` is wired through
`.detect_quirks` in `asus_nb_wmi_driver`; `asus_wmi_add()` calls
`detect_quirks()` during driver probe. `asus_nb_wmi_key_filter()` is
wired through `.key_filter`; `asus_wmi_handle_event_code()` calls it
before reporting input events.

Step 5.3 Record: Key callees/operations: `dmi_check_system(asus_quirks)`
performs DMI matching; `dmi_matched()` assigns `quirks =
dmi->driver_data`; event handling calls `sparse_keymap_report_event()`
unless the filter changes the code to `ASUS_WMI_KEY_IGNORE`.

Step 5.4 Record: Reachability is from ASUS WMI platform driver probe and
ACPI/WMI event notifications on matching ASUS notebook hardware. This is
hardware/model-specific, not a general syscall-triggered path.

Step 5.5 Record: Similar patterns found: UX8406MA and UX8406CA already
use `quirk_asus_zenbook_duo_kbd`; ROG Z13 uses the same DMI table
pattern with vendor `ASUS`.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: `git grep` over tags showed
`quirk_asus_zenbook_duo_kbd` exists in `v6.12`, `v6.15`, `v6.16`,
`v6.17`, `v6.18`, `v6.19`, and `v7.0`; it was not present in `v6.1` or
`v6.6`. UX8406CA exists from `v6.16`; ROG Z13 context exists from
`v6.17`.

Step 6.2 Record: `git apply --check` against the current tree succeeded.
Expected backport difficulty: clean for trees with matching nearby
context; minor context adjustment for trees where UX8406CA or ROG Z13
entries are absent, but the quirk symbol exists.

Step 6.3 Record: No existing UX8407AA entry or related UX8407AA fix was
found in local `git log --grep="UX8407AA"`.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is `drivers/platform/x86`, ASUS notebook WMI
driver. Criticality: peripheral/driver-specific, affecting users of the
ASUS Zenbook Duo UX8407AA.

Step 7.2 Record: The subsystem and file are active: recent local history
includes multiple ASUS WMI quirk/keymap fixes and platform-x86 changes.

## Phase 8: Impact And Risk
Step 8.1 Record: Affected population is driver-specific: users of ASUS
Zenbook Duo UX8407AA with `asus-nb-wmi`.

Step 8.2 Record: Trigger is hardware-specific WMI keyboard attach/detach
or wireless-console events. I verified the relevant event codes are
mapped as `KEY_WLAN` unless the quirk rewrites them to ignore.

Step 8.3 Record: Failure mode is unintended WLAN/rfkill-style input
events on this model. Severity is medium: user-visible connectivity
disruption, not a crash, data corruption, or security issue.

Step 8.4 Record: Benefit is high for affected hardware and low globally.
Risk is very low: a DMI-only quirk entry using existing behavior,
isolated to one model string.

## Phase 9: Final Synthesis
Evidence for backporting: this is exactly the stable-accepted hardware
quirk category; it is small, reviewed, isolated, uses existing code, and
fixes real model-specific input/rfkill behavior for affected hardware.

Evidence against backporting: no explicit `Cc: stable`, no separate bug
report in the thread, and older stable trees without
`quirk_asus_zenbook_duo_kbd` need prerequisites or are not applicable.

Stable rules checklist: obviously correct: yes; fixes real hardware
behavior: yes; important enough for affected users: yes, though not
critical; small and contained: yes, 9 insertions in one DMI table; no
new APIs/features: yes; applies to stable: yes for current tree, likely
minor context-only adjustments for some older applicable trees.

Exception category: hardware-specific DMI quirk/workaround, which is a
standard stable exception.

## Verification
- [Phase 1] Parsed commit metadata from `git show
  2997606dd17729404cef9821ce66dd037b6019eb`.
- [Phase 2] Verified diff is one DMI entry in
  `drivers/platform/x86/asus-nb-wmi.c`.
- [Phase 3] Ran `git blame` on the DMI table and quirk definition;
  identified existing quirk history.
- [Phase 3] Checked related commits `9286dfd5735b`, `7dc6b2d3b550`,
  `132bfcd24925`, `225d1ee0f5ba`.
- [Phase 4] Ran `b4 dig -c`, `b4 dig -a`, `b4 dig -w`; found exact v1
  patch thread and recipients.
- [Phase 4] Ran `b4 mbox`/`b4 am` by message-id; confirmed Denis review
  and Ilpo applied notice.
- [Phase 5] Used `rg` and file reads to trace `detect_quirks`,
  `key_filter`, and event reporting.
- [Phase 6] Used `git grep` over version tags to verify which releases
  contain the existing quirk machinery.
- [Phase 6] Ran `git apply --check`; candidate applies cleanly to the
  current tree.
- UNVERIFIED: Direct lore/stable search results, because WebFetch was
  blocked by Anubis.
- UNVERIFIED: Actual UX8407AA firmware DMI strings beyond the submitted
  patch and maintainer review.

This should be backported to stable trees where the existing Zenbook Duo
keyboard quirk is present, with trivial context adjustment if needed.

**YES**

 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b4677c5bba5b4..8005c088e9eee 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -544,6 +544,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_zenbook_duo_kbd,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS Zenbook Duo UX8407AA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook Duo UX8407AA"),
+		},
+		.driver_data = &quirk_asus_zenbook_duo_kbd,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "ASUS ROG Z13",
-- 
2.53.0

