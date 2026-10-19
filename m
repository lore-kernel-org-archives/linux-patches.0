Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5038C596EA8;
	Mon, 19 Oct 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418348; cv=none; b=fK4diy5K85F/BdeTxnFEmpNXp99so6vC4BiwYLJ5wmCyMgIG2BcEhnP1dr/ADGWjZmYsZKfOif0JUPNBVY3r5R2gz+vfKzmXsMjjXqZ9ekwYqieoqs+P5jU8qLofedUExePD4plLT+rp8fiCypUXTvhmyK+J5+zNR5VW8AIYiKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418348; c=relaxed/simple;
	bh=F24kcNkfWDJLq8TruH7HPiQ4zsPX2FXXcHbq9lsX72c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0bOpGm1gEfI88RdQ3mNaxugci2jexVI2rWVwowcJAipPvix6bjxH+LGSA+SECzyxnEz3A9j8hGYANxhih8hD+9Iznz6UdFf3bNX4Pzq/FH/n+zOLDc6k5+jtRMwvPkjmGQWu7LcTaWwL1Ys8oVhc3l2eMQOufNY9vulPH5pGFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/+NFhMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/+NFhMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8071F000C7;
	Mon, 19 Oct 2026 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418345;
	bh=reLorp6E8UuH9HUYnacpZqI1G6WEWU1dQvNeLGOAOi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/+NFhMgWDfPRD1Nxe8fwIq5DvoKOeUiEioDp1hwsom76cEdLltT0WwM58ps6Uuo2
	 vYZk3rYXIoOO/1Mmd9tNbUbceOIUfMZKKYJsWD7N2EquS8MIHzdXZHUeBHNkE6OvyV
	 YdPnLIEjvdBnJn3ElWpSgnRsHoSKaCjkAVk3Wnx4LqE42u1SBSmdn4C2+p5DP81vRG
	 5CiBUAUjSlil6lADDDcFCOw9sbwgPGwFGsDezBKonBYkPf6R3k0JUuAwR5He4toyfa
	 p5orHLzjoGUcOElv1bvOxKvBJVddXDvfR9rJ2SKggV3WYCR0hVElA52SDlvvssq4cU
	 Yp68Xl3RxH9gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda: Add Lisuan HDMI controller and codec support
Date: Mon, 19 Oct 2026 09:47:52 -0400
Message-ID: <20261019135441.1420968-181-sashal@kernel.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit ceaebef91d1aff671a512d5f003766ea41152d94 ]

Lisuan GPUs expose an HD-audio controller at PCI ID 4c54:5010 and an
HDMI/DP codec with codec ID 0x4c545020.  Neither ID is currently matched
by the HDA stack, leaving HDMI/DP audio unavailable on these devices.

The existing downstream support uses the generic HDMI codec path and
attaches no Lisuan-specific capability flags to the controller.  Its
dedicated AZX driver type only changes the short driver name.

Use the corresponding generic upstream paths instead: bind 4c54:5010 to
AZX_DRIVER_GENERIC, register 0x4c545020 as MODEL_GENERIC, and add the
Lisuan codec vendor name.  This keeps the enablement minimal and avoids
a vendor-only AZX driver type with no vendor-specific behavior.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/DE1B62191D573D37+20260817085531.992573-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide. This is a four-line device-ID enablement; the
6.12 HDA driver already has the matching tables under the older paths.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA: hda] [Add] [Lisuan HDMI controller PCI ID 4c54:5010 and
codec ID 0x4c545020 so HDMI/DP audio binds on existing generic HDA
paths]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Fixes: none (expected)
- Reported-by: none
- Tested-by: none
- Reviewed-by: none
- Acked-by: none
- Link: https://patch.msgid.link/DE1B62191D573D37+20260817085531.992573-
  1-raoxu@uniontech.com
- Cc: stable: none (expected)
- Signed-off-by: Xu Rao <raoxu@uniontech.com> (author)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer; applied
  the patch)
- Ignore Signed-off-by: Sasha Levin if present (pipeline)

Notable: no syzbot, no crash report. This is hardware enablement, not a
sanitizer fix. Maintainer SOB is present.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug/problem: Lisuan GPUs expose HD-audio at PCI 4c54:5010 and HDMI/DP
  codec 0x4c545020. Neither ID is matched, so HDMI/DP audio is
  unavailable.
- Symptom: no HDMI/DP audio on these devices.
- Version info: none in the message. Lore shows this was pulled for
  7.3-rc1 (Takashi's "sound updates for 7.3-rc1" on 2026-08-19).
- Root cause: missing ID table entries. Downstream already used the
  generic HDMI codec path and attached no Lisuan-specific AZX capability
  flags; a dedicated AZX driver type would only change the short name.
- Fix: bind PCI ID to AZX_DRIVER_GENERIC, register codec as
  MODEL_GENERIC, add vendor name "Lisuan".

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden UAF/race/leak fix. It is a device-ID addition:
hardware does not bind without the IDs. That is the stable exception for
PCI/codec IDs on an existing driver, not a disguised cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- sound/hda/codecs/hdmi/hdmi.c: +1 (codec ID 0x4c545020, "Lisuan
  HDMI/DP", MODEL_GENERIC)
- sound/hda/controllers/intel.c: +2 (comment + PCI_DEVICE(0x4c54,
  0x5010) → AZX_DRIVER_GENERIC)
- sound/hda/core/device.c: +1 (vendor 0x4c54 → "Lisuan")
- Total: +4 lines, 0 removals
- Functions/tables: snd_hda_id_generichdmi[], azx_ids[],
  hda_vendor_ids[]
- Scope: single-driver ID-table addition (three tables in one subsystem)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- HDMI codec table: unmatched 0x4c545020 did not hit the generic HDMI
  driver by explicit ID. After: it matches MODEL_GENERIC /
  patch_generic_hdmi.
- PCI table: 4c54:5010 was not in azx_ids and this tree has no
  vendor/class catch-all for 0x4c54, so snd-hda-intel did not probe.
  After: it probes as AZX_DRIVER_GENERIC with no extra DCAPS.
- Vendor table: unnamed vendor used "Generic 4c54". After: name is
  "Lisuan" (cosmetic for mixer/proc).
- Paths: probe/init only. No hot-path, locking, or API change.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware enablement / device ID] Controller and codec never
matched. PCI ID is required for bind. Codec ID selects the generic HDMI
parser. Vendor string is display-only. Not UAF, leak, race, or overflow.

Step 2.4: ASSESS THE FIX QUALITY
Record: Minimal and consistent with VIA/VMware/RDC generic HDMI IDs.
Author says downstream used generic path with no vendor DCAPS.
Regression risk is the usual new-ID risk (hardware might later need
NO_MSI / POSFIX_LPIB / etc.). No new AZX_DRIVER type, no new API.
Quality is high for an ID add.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: This tree has no Lisuan entries. Insertion point in 6.12 HDMI
table is beside Glenfly Arise IDs from c51e431052e2e (2023). PCI table
terminator at azx_ids[] is original (Linus 1da177e4c3f41); last entries
are Loongson (28bd137a3c8e1, 2023). Vendor table around 0x434d/0x8086 is
Takashi Iwai 7639a06c23c7d4 (2015). The HDA ID tables have been stable
for years; this is not a bug in newly added 6.12 code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. Missing IDs were never introduced
by a prior commit; they were never added.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Same files already received ID adds in this 6.12 tree, e.g.
2b331e7b6cc57 "ALSA: hda: Add new pci id for AMD GPU display HD audio
controller" (in HEAD), e8336a63de03e Intel BMG, e9481d9b83f8d Intel PTL
HDMI codec, c51e431052e2e Glenfly. Standalone; not patch X/Y. No Lisuan
follow-ups on lore.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: git log --author='Xu Rao' on sound/ in this tree is empty.
UnionTech contributor; not the ALSA maintainer. Takashi Iwai applied it
the same day. Weight comes from maintainer accept, not author history
here.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs existing snd-hda-intel + HDMI codec + AZX_DRIVER_GENERIC.
All present. Does not need a new driver type, Hygon entries, or
MODEL_GENERIC (6.12 uses HDA_CODEC_ENTRY(..., patch_generic_hdmi)).
Standalone with a path/macro translation. No DRM Lisuan driver in this
tree; HDA PCI bind does not require it.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig -c HEAD failed (lore server error; this tree's HEAD is
  unrelated).
- Lore (linux-sound and all): exactly one series, v1 only.
  - Patch: https://lore.kernel.org/linux-
    sound/DE1B62191D573D37+20260817085531.992573-1-raoxu@uniontech.com/
  - Also mirrored at https://lists.openwall.net/linux-
    kernel/2026/08/17/647
- b4 dig -a: not obtained (b4/lore error). Lore search shows no v2/v3.
- Feedback: Takashi Iwai: "Applied now. Thanks." No NAK, no requested
  changes, no Cc: stable in review.
- Pulled in "[GIT PULL] sound updates for 7.3-rc1".

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients from the openwall/lkml copy: perex@perex.cz, tiwai,
peter.ujfalusi, kai.vehmanen, tglx, broonie, linux-sound, linux-kernel,
plus a few others. Subsystem list and ALSA maintainer were on To/Cc.
Maintainer applied v1 immediately.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Evidence is the commit text plus "existing
downstream support". Hardware impact is real for Lisuan GPU HDMI audio
users; no public crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 4-line patch. lore.kernel.org/all/?q=Lisuan returns
only this patch, Takashi's apply, and the 7.3-rc1 pull. No companion DRM
or quirk series on lore.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable/?q=Lisuan returned no hits. Not discussed
on stable@ yet.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS
Record: No function bodies changed. Tables: snd_hda_id_generichdmi[] /
snd_hda_id_hdmi[], azx_ids[], hda_vendor_ids[]. Consumers: azx_probe
(PCI match), hda_codec_match / snd_hda_codec_configure (codec match),
get_codec_vendor_name().

Step 5.2: TRACE CALLERS
Record:
- azx_ids is MODULE_DEVICE_TABLE(pci) for snd-hda-intel; probe is
  azx_probe on PCI enumeration.
- Codec table is MODULE_DEVICE_TABLE(hdaudio); hda_codec_match()
  compares vendor_id.
- codec_bind_generic() can still fall back to HDA_CODEC_ID_GENERIC_HDMI
  via is_likely_hdmi_codec() if the controller is bound and the codec
  looks like HDMI-only. PCI match is the gating bind. Codec ID is
  explicit matching/naming, not the only possible codec path.
- Context: device probe, not IRQ/hot path.

Step 5.3: TRACE CALLEES
Record: ID tables do not call allocators or locks. AZX_DRIVER_GENERIC in
this tree is already used (VIA 0x9170/0x9140, RDC, VMware, some AMD).
Stream-count fallback treats AZX_DRIVER_GENERIC like the default ICH6
counts (hda_intel.c ~1987).

Step 5.4: FOLLOW THE CALL CHAIN
Record: PCI enumeration → azx_probe → codec discovery → HDMI parser.
Reachable whenever the Lisuan HDMI audio function is present.
Unprivileged userspace cannot create the device; plug-in hardware users
are affected. HDMI audio is a user-visible function.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same pattern as Glenfly HDMI IDs, Loongson HDMI, AMD GPU display
HDA PCI IDs, Intel BMG/PTL HDMI IDs — all already in this 6.12 tree. No
other 0x4c54 / 0x4c545020 / "Lisuan" matches in the tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: pending-6.12, kernel 6.12.111 (git describe
  p-6.12-3-gc504cf0baa3d8; Makefile VERSION=6 PATCHLEVEL=12
  SUBLEVEL=111).
- git log --grep=Lisuan -- sound/: empty. IDs are not here.
- Mainline paths sound/hda/codecs/hdmi/hdmi.c,
  sound/hda/controllers/intel.c, sound/hda/core/device.c do not exist
  (post-6.12 HDA split).
- Equivalents do exist:
  - sound/pci/hda/hda_intel.c azx_ids[] — AZX_DRIVER_GENERIC at line
    244, table ends at Loongson then {0,}
  - sound/pci/hda/patch_hdmi.c snd_hda_id_hdmi[] — HDA_CODEC_ENTRY +
    patch_generic_hdmi
  - sound/hda/hdac_device.c hda_vendor_ids[] — same vendor list, no
    0x4c54
- SND_HDA_INTEL and SND_HDA_CODEC_HDMI exist (sound/pci/hda/Kconfig).
- "Bug" is missing IDs, not a regression introduced after 6.12. Lisuan
  hardware on 6.12 still fails to bind.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Will not apply as a raw mainline diff (wrong paths,
HDA_CODEC_ID_MODEL vs HDA_CODEC_ENTRY). Mechanical 3-site remap:
  1. patch_hdmi.c: HDA_CODEC_ENTRY(0x4c545020, "Lisuan HDMI/DP",
     patch_generic_hdmi)
  2. hda_intel.c: { PCI_DEVICE(0x4c54, 0x5010), .driver_data =
     AZX_DRIVER_GENERIC }
  3. hdac_device.c: { 0x4c54, "Lisuan" }
Same class of backport as 2b331e7b6cc57 (AMD PCI ID into hda_intel.c on
this branch). Difficulty: minor / needs small backport, not a rework.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No Lisuan IDs. No alternate Lisuan HDA quirk. Nothing to
conflict besides inserting three table rows.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [ALSA HD-audio / HDMI codec + PCI controller] [IMPORTANT for
HDMI audio users; PERIPHERAL in that only Lisuan 4c54:5010 is newly
matched; core HDA stack is mature]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: sound/pci/hda/ is actively receiving ID and quirk backports in
this tree (AMD GPU ID, ThinkPad PM denylist, Panther Lake, etc.). Mature
tables, routine ID churn. Matches stable practice.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / hardware-specific: owners of Lisuan GPUs with
HD-audio 4c54:5010. No effect on other devices. Population is smaller
than Intel/AMD HDMI, but that is normal for vendor ID adds (Glenfly,
Loongson, etc.).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is having the PCI function present (boot/hotplug GPU).
Common for those machines; zero for everyone else. Not an unprivileged
syscall attack. HDMI audio is the user-visible feature.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [HDMI/DP audio never appears] [MEDIUM for affected users:
functional gap, not oops/corruption]. Stable still takes these as
device-ID exceptions. Without the PCI ID, snd-hda-intel never binds
(verified: no 0x4c54 class catch-all in azx_ids[]).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HDMI/DP audio on Lisuan using the existing generic HDA path.
  High for those users; none for others.
- Risk: 4 lines, probe-only, AZX_DRIVER_GENERIC already used. Residual
  risk is missing hardware quirks; author/downstream say none are
  needed.
- Ratio: favorable. Same as other HDA PCI/codec ID backports already on
  6.12.y.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Classic PCI + codec ID add to an existing driver (snd-hda-intel + HDMI
  codec present in 6.12).
- Explicit stable exception: "NEW DEVICE IDs".
- +4 lines, no new API, no new AZX_DRIVER type, no new module param.
- Without PCI ID, controller does not bind in this tree.
- ALSA maintainer applied v1 immediately.
- Same pattern already backported here (AMD GPU HDA PCI ID, Intel HDMI
  codec IDs, Glenfly).
- Downstream already used generic HDMI with no extra DCAPS.

AGAINST:
- Not a crash/UAF/security fix.
- Raw diff does not apply (HDA tree split after 6.12).
- No Tested-by / Reported-by on the list.
- No in-tree Lisuan DRM driver; ELD/display integration may be limited
  without a GPU driver (HDA still needs the PCI ID).
- Possible later quirks if generic AZX flags are wrong (unverified
  beyond author's downstream claim).

UNRESOLVED:
- Mainline SHA not in this checkout; merge-base --is-ancestor of the
  upstream commit was not run (commit absent).
- b4 dig failed on lore; thread recovered via lore/openwall instead.
- Could not independently test Lisuan hardware.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — four table rows; maintainer
   applied; downstream generic path described.
2. Fixes a real bug that affects users? PASS — HDMI/DP audio never binds
   without the PCI ID.
3. Important issue (crash, security, corruption, deadlock)? FAIL on that
   strict list; PASS under the documented device-ID exception (hardware
   enablement).
4. Small and contained? PASS — +4 lines, three ID tables.
5. No new features or APIs? PASS — no new driver, syscall, or userspace
   API; IDs only.
6. Can apply to the local tree? PASS with a small backport (patch_hdmi.c
   / hda_intel.c / hdac_device.c). Equivalent tables and
   AZX_DRIVER_GENERIC exist.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Device ID addition to an existing driver (PCI ID + HDMI codec ID
+ vendor label). This is the standard YES exception. Vendor string is
documentation-level.

Step 9.4: MAKE YOUR DECISION
This belongs in 6.12.y. The HDA controller/codec drivers are here; only
the Lisuan IDs are missing. The mainline file move is a mechanical
remap, not missing infrastructure. Risk is low; benefit is making
HDMI/DP audio work on that GPU.

What the commit solves for stable users: 6.12.y systems with a Lisuan
GPU HD-audio function 4c54:5010 currently do not bind snd-hda-intel.
Adding the PCI ID (and codec/vendor rows) enables the existing generic
HDMI path.

Risk vs benefit: four probe-only table entries vs silent non-function of
HDMI audio. Same class as ID adds already on this branch.

Concerns: backport must retarget 6.12 paths and use HDA_CODEC_ENTRY(...,
patch_generic_hdmi) instead of HDA_CODEC_ID_MODEL(..., MODEL_GENERIC).
No other prerequisites.

Verification:
- [Phase 1] Parsed tags: author Xu Rao; Link msgid
  DE1B62191D573D37+20260817085531.992573-1-raoxu@uniontech.com; SOB
  Takashi Iwai; no Fixes/Reported-by/Cc: stable
- [Phase 1] Body: missing 4c54:5010 and codec 0x4c545020; downstream
  generic HDMI, no extra DCAPS
- [Phase 2] Diff: +1 codec ID, +2 PCI ID/comment, +1 vendor name; 3
  files, +4/-0
- [Phase 3] git describe / Makefile: this tree is 6.12.111 pending-6.12
  (p-6.12-3-gc504cf0baa3d8)
- [Phase 3] git log --grep=Lisuan -- sound/: not in this tree
- [Phase 3] Equivalent files: sound/pci/hda/hda_intel.c,
  sound/pci/hda/patch_hdmi.c, sound/hda/hdac_device.c
- [Phase 3] AZX_DRIVER_GENERIC exists (hda_intel.c:244, used e.g. VIA
  0x9170)
- [Phase 3] HDA_CODEC_ID_MODEL absent; HDA_CODEC_ENTRY in
  include/sound/hda_codec.h:86
- [Phase 3] Precedent in tree: 2b331e7b6cc57 AMD GPU HDA PCI ID (git
  merge-base --is-ancestor: yes)
- [Phase 3] Blame: HDMI Arise IDs c51e431052e2e (2023); azx_ids
  terminator 1da177e4c3f41; vendor table 7639a06c23c7d4 (2015)
- [Phase 4] lore linux-sound: 3 hits only (patch, apply, 7.3-rc1 pull);
  v1 only; Takashi "Applied now"
- [Phase 4] b4 dig -c HEAD: lore server error; used lore/openwall
  instead
- [Phase 4] lore.kernel.org/stable/?q=Lisuan: no discussion
- [Phase 5] azx_ids has Intel/NVIDIA/ATI/Glenfly class catch-alls, not
  vendor 0x4c54 — PCI ID required
- [Phase 5] hda_bind.c codec_bind_generic() can fall back to generic
  HDMI after controller bind; PCI ID remains the bind gate
- [Phase 5] grep Lisuan/0x4c545020/PCI_DEVICE(0x4c54: no matches
- [Phase 6] No sound/hda/codecs/hdmi/hdmi.c or
  sound/hda/controllers/intel.c here (split after 6.12)
- [Phase 6] SND_HDA_INTEL / SND_HDA_CODEC_HDMI present in
  sound/pci/hda/Kconfig
- [Phase 8] Failure mode: no HDMI/DP audio device, not a panic
- UNVERIFIED: live Lisuan hardware; whether later quirks are needed
  beyond author's downstream statement; exact mainline SHA (not in this
  checkout)

**YES**

 sound/hda/codecs/hdmi/hdmi.c  | 1 +
 sound/hda/controllers/intel.c | 2 ++
 sound/hda/core/device.c       | 1 +
 3 files changed, 4 insertions(+)

diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index 42e4dc0949ec9..480d1c5f129fd 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -2348,6 +2348,7 @@ static const struct hda_device_id snd_hda_id_generichdmi[] = {
 	HDA_CODEC_ID_MODEL(0x1d179f8e, "KX-7000 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x1d179f8f, "KX-7000 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x1d179f90, "KX-7000 HDMI/DP",	MODEL_GF),
+	HDA_CODEC_ID_MODEL(0x4c545020, "Lisuan HDMI/DP",	MODEL_GENERIC),
 	HDA_CODEC_ID_MODEL(0x67663d82, "Arise 82 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x67663d83, "Arise 83 HDMI/DP",	MODEL_GF),
 	HDA_CODEC_ID_MODEL(0x67663d84, "Arise 84 HDMI/DP",	MODEL_GF),
diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 3ed33cba7d83f..fd61dc8e21a53 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2830,6 +2830,8 @@ static const struct pci_device_id azx_ids[] = {
 	/* Hygon HDAudio */
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_HYGON_18H_M05H_HDA),
 	  .driver_data = AZX_DRIVER_HYGON | AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_NO_MSI },
+	/* Lisuan HD-audio */
+	{ PCI_DEVICE(0x4c54, 0x5010), .driver_data = AZX_DRIVER_GENERIC },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
diff --git a/sound/hda/core/device.c b/sound/hda/core/device.c
index ebaa106d0f018..010dd38007a99 100644
--- a/sound/hda/core/device.c
+++ b/sound/hda/core/device.c
@@ -664,6 +664,7 @@ static const struct hda_vendor_id hda_vendor_ids[] = {
 	{ 0x1af4, "QEMU" },
 	{ 0x1fa8, "Senarytech" },
 	{ 0x434d, "C-Media" },
+	{ 0x4c54, "Lisuan" },
 	{ 0x8086, "Intel" },
 	{ 0x8384, "SigmaTel" },
 	{} /* terminator */
-- 
2.53.0

