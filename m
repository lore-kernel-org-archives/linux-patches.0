Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CB59E3AD;
	Mon, 19 Oct 2026 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418365; cv=none; b=hcbfUJLILZiHVR58fXfWtQv2jk5cGl+MB3t2DNLofVp9gHR5KOm7hP7AwoNZgS9m3g47b/1m+S9TWHHaUNrwJgDpq0L2b76p+OHn7RW5AjKGTO+eyLstg+7ppCg1DAS0pl5CTcBLQQ1cNwpASKHaQxv2bURdbrD8rFS7M8kwPn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418365; c=relaxed/simple;
	bh=BKFfN43nGp3VVpTNr/Lo+W/WKIX7D9y9XlEAqk2L2mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzE17NDFSyECNqZty8hMq3BvXPttXNbmVme0gZGJqM5YycQh+XpULItQFh/kxQ32z98367lpFoJUUi1Cpvm1qTMCH/iQ4uKktWP6hkPeOU6ptK8A+GzdGCygoLB1DrpbZpKDvD2IMqf8L8Ep5f8YFjKUuFkCDYWOjZFva1fH74M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jh/uACEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jh/uACEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E220C1F000C7;
	Mon, 19 Oct 2026 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418362;
	bh=MOv2BYNXyBuekzXIr95SQ6L2BOOc1CRfATxmrksmpro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jh/uACEBb3d1DWQyrV66BeLfnKPMADETSxW2XjSG60kZNlsQ7oJLHP/wWWrVX8S5e
	 ygbqzEiQHmdS8GB5yTKoW4CkGvATKlQi8JbiPHyaCmTvtVpT8mFXNJ/w+MdWD6t2g2
	 UZbeYcso/CzOQ7Q83Znn1r2lNx/D62BH65n+Gts9upgG3acMk8KAsH6t/S5807BGRl
	 rmcjfAOz44VQ/+JwWYX2yqf87OI7yWN/3igPoQMzCc2GNR4potwcJx1yIyzh1y2k/b
	 2rmAYYgTg8ySBFvG+jl8CYwZoAw9YDYw/ddMdyTrSOuBJOuuL6c1plihXV03xCc9OT
	 qv+nnrxR2g5Ow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fu Hao <fuhao@open-hieco.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda: Add support for Hygon family 18h model 5h HD-Audio
Date: Mon, 19 Oct 2026 09:48:05 -0400
Message-ID: <20261019135441.1420968-194-sashal@kernel.org>
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

From: Fu Hao <fuhao@open-hieco.net>

[ Upstream commit 41212ff3e4ed475d9f91d26b5324075087702987 ]

Add the new PCI ID 0x1d94 0x14a9 for Hygon family 18h model 5h
HDA controller.

Signed-off-by: Fu Hao <fuhao@open-hieco.net>
Link: https://patch.msgid.link/8b38f2941375553e4246167736c6acb5a541e833.1781523812.git.fuhao@open-hieco.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`). The
verdict is only about this tree: the existing HD-Audio PCI driver is
present, Hygon vendor IDs already exist, and this is a PCI ID addition
to that driver.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA/hda] [Add] [PCI ID 0x1d94:0x14a9 for Hygon family 18h
model 5h HD-Audio controller]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by:` / `Acked-by:` — none on the commit
- `Link:` `https://patch.msgid.link/8b38f2941375553e4246167736c6acb5a541
  e833.1781523812.git.fuhao@open-hieco.net`
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Fu Hao <fuhao@open-hieco.net>` (author)
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
[Bug description] Hygon family 18h model 5h HD-Audio is missing from the
existing Intel/generic HDA PCI ID table, so `snd-hda-intel` never binds.
[Symptom] No HD-Audio controller on that SoC (no `snd_hda_intel` probe).
[Version information] None in the message.
[Root cause] New PCI device `vendor 0x1d94` / `device 0x14a9` was never
listed.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. This is explicit hardware enablement via a PCI
ID. Cover letter (v3 0/7) calls it “initial support for the integrated
HD-Audio controller.” A follow-up (v3 7/7) adds a dword-access quirk
because byte writes to GCTL/SD_CTL fail on this controller.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/controllers/intel.c` only (`+7` lines, no deletions)
- Functions/data: `#define PCI_DEVICE_ID_HYGON_18H_M05H_HDA`, enum
  `AZX_DRIVER_HYGON`, `driver_short_names[]`, `azx_ids[]`
- Scope: single-file surgical PCI ID + driver-type tag

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `azx_ids[]` has Intel/AMD/ATI/Zhaoxin/Loongson/etc.; no Hygon
  entry. AMD/ATI class wildcards do not match vendor `0x1d94`. Probe
  never runs for this device.
- After: PCI match `PCI_VDEVICE(HYGON, 0x14a9)` with `AZX_DRIVER_HYGON |
  AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_NO_MSI`, then normal `azx_probe()`.
- Path: PCI enumeration / module probe, not an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Hardware enablement / PCI ID]` Existing driver does not claim
this controller. New enum value is an internal tag (same pattern as
Loongson/Zhaoxin), not a new driver. Caps reuse existing
`AZX_DCAPS_POSFIX_LPIB` and `AZX_DCAPS_NO_MSI`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Minimal and obviously correct. Regression risk is low and
limited to this PCI ID. `azx_max_codecs[]` is sparse; HYGON stays 0, and
`azx_probe_codecs()` treats 0 as `AZX_DEFAULT_CODECS`. Companion quirk
(7/7) is needed for reliable register writes; this ID patch still
compiles and applies alone.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Insertion is next to Loongson IDs (`28bd137a3c8e1`, 2023) and
the table terminator (`{ 0, }`, ancient). Not a recent regression; the
ID was never present. `PCI_VENDOR_ID_HYGON` (`0x1d94`) has been in
`include/linux/pci_ids.h` since `c6babb5806b77` (2018).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. N/A.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related: `054940f79377d` / upstream `e096c24e7f97` — “Fix single
byte writing issue for Hygon family 18h model 5h” (series 7/7). That
patch depends on `AZX_DRIVER_HYGON` from this one. Other nearby HDA ID
work (Lisuan, denylist) is unrelated. This ID commit is standalone for
bind/enable; the quirk is a separate follow-up.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Fu Hao submitted the Hygon 18h models 4h–8h series (CPU
topology, perf, microcode, HDA). Not the ALSA maintainer. Takashi Iwai
applied both HDA patches to for-next.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `PCI_VENDOR_ID_HYGON`, `PCI_VDEVICE()`,
`AZX_DCAPS_POSFIX_LPIB`, `AZX_DCAPS_NO_MSI`, and
`sound/hda/controllers/intel.c` (moved in `2d9223d2d64cb`, already in
v6.18.53). All present. Does not need series patches 1–5
(x86/perf/microcode). Patch 7/7 is recommended so audio actually works,
but is not a compile/apply prerequisite.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c 41212ff3e4ed` →
https://patch.msgid.link/8b38f2941375553e4246167736c6acb5a541e833.178152
3812.git.fuhao@open-hieco.net
Series: **[PATCH v3 0/7] Add support for Hygon family 18h models 4h-8h**
(2026-06-15). This is **6/7**. `b4 dig -a` listed v3 as the matching
series. v1→v2: switched to existing `access_sdnctl_in_dword` instead of
a Hygon-specific flag; v2→v3: “Refine the code of Hygon HD-Audio device
ID.” Takashi: “Applied to for-next branch now.” No NAK on 6/7 or 7/7.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients: Fu Hao, Bjorn Helgaas, Jaroslav Kysela
(`perex@perex.cz`), Takashi Iwai, linux-kernel, linux-sound, linux-pci,
tingyin.duan. ALSA maintainers were on To/Cc. Takashi applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Hardware enablement from Hygon (open-hieco).
No public crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 1–5 are x86 CPU/perf/microcode (independent). 6 = this ID. 7 =
dword-access quirk using `AZX_DRIVER_HYGON`. Audio support is 6+7; 6 is
still a valid PCI ID addition by itself.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org `/stable/` returned HTTP 403 (WebFetch and
curl). UNVERIFIED whether stable@ discussed this ID.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function bodies changed. Data only: ID define,
`AZX_DRIVER_HYGON`, `driver_short_names`, `azx_ids[]`. Runtime path is
existing `azx_probe()`.

**Step 5.2: TRACE CALLERS**
Record: `azx_ids` → `azx_driver.id_table` → PCI core → `azx_probe()` →
`azx_first_init()` / `azx_probe_continue()`. Device-enumeration path,
not IRQ/hot path until the device exists.

**Step 5.3: TRACE CALLEES**
Record: Unchanged. Probe uses existing PCI/HDA init, LPIB position fix,
MSI disable.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace does not trigger it; PCI probe does on Hygon 18h m5h.
No class wildcard for `PCI_VENDOR_ID_HYGON` (only
Intel/Glenfly/NVIDIA/Creative/ATI/AMD). Without this ID, the controller
is not claimed.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same pattern as Loongson (`28bd137a3c8e1`) and many other HDA
PCI ID additions already in this tree (Alder Lake, Glenfly, AMD display
HDA, etc.).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. v6.18.53 `azx_ids[]` ends at Loongson then `{ 0, }`. No
Hygon entry. `git merge-base --is-ancestor` of the candidate vs
`v6.18.53` is false (not in 6.18.53). Driver file and
`PCI_VENDOR_ID_HYGON` are present.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Dry-run apply of upstream `41212ff3e4ed` onto v6.18.53 `intel.c`
succeeded (`patch -p1 --dry-run`; later hunks applied at offsets because
mainline grew extra IDs). Expected backport difficulty: **clean apply /
trivial offsets**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: v6.18.53 has no Hygon HDA ID and no Hygon dword-access quirk.
`access_sdnctl_in_dword` already exists (Loongson). No alternate fix for
0x1d94:0x14a9.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[sound/hda PCI controller] [IMPORTANT]` — not core mm/net, but
the standard HD-Audio stack used on PCs/servers with this SoC.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (denylists, Nvidia BDL, other PCI IDs). PCI ID table is
the normal extension point. Maintainer Takashi Iwai applied the patch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / platform-specific: Hygon family 18h model 5h
with HD-Audio `0x1d94:0x14a9`. Other machines unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on that hardware (PCI probe). Not a race. Not
unprivileged-syscall. Without the ID, audio is simply missing.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[No HD-Audio device bind] [MEDIUM for those users; exception-
qualified]` Not a panic. Follow-up 7/7: byte writes fail so audio can
still be broken after bind if 7/7 is omitted.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit: high for that hardware (enables existing driver). Risk:
very low (+7 lines, one PCI ID, existing caps). Ratio favors backport.
Best if 7/7 is taken with it so GCTL/SD_CTL writes succeed.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Classic PCI ID addition to an existing driver (stable exception #1)
- Driver, path `sound/hda/controllers/intel.c`, and
  `PCI_VENDOR_ID_HYGON` all exist in 6.18.53
- No Hygon class wildcard; without this ID the device is never bound
- +7 lines, existing `AZX_DCAPS_*`, applies to v6.18.53
- Applied by ALSA maintainer Takashi Iwai
- Same pattern as Loongson and other HDA PCI IDs already in this tree

AGAINST:
- Part of series 6/7; 7/7 is the functional quirk (byte writes fail)
- No `Reported-by` / crash / CVE
- Adds an internal `AZX_DRIVER_HYGON` enum (needed for the quirk, not a
  UAPI)

UNRESOLVED:
- Stable mailing list (lore 403)
- How widely this SoC is deployed on 6.18-based distros

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — ID table entry; maintainer
   applied; v3 after review
2. Fixes a real bug that affects users? **PASS** — missing bind = no
   audio on this controller
3. Important issue? **PASS** under the device-ID exception (not a panic)
4. Small and contained? **PASS** — 7 lines, one file
5. No new features or APIs? **PASS** — existing driver, internal enum,
   no UAPI
6. Can apply to the local tree? **PASS** — dry-run on v6.18.53 `intel.c`
   succeeded

**Step 9.3: EXCEPTION CATEGORIES**
Record: **New device ID on an existing driver.** Also adjacent to a
hardware quirk (7/7), which is a separate YES-class patch.

**Step 9.4: DECISION**
This is hardware enablement for a controller the 6.18.53 HDA driver
already knows how to drive, blocked only by a missing PCI ID. That is
standard stable material. Series patches 1–5 are unrelated. Patch 7/7
should also be considered so register writes work, but it does not make
6/7 unsuitable.

---

### What the commit solves for this tree
On 6.18.53, `snd-hda-intel` never matches Hygon `0x1d94:0x14a9`. This
adds that ID (with LPIB position fix and `NO_MSI`) so probe runs. That
matters for users of Hygon 18h model 5h who stay on this LTS kernel.

### Risk vs benefit
Benefit is enabling audio hardware; risk is confined to that PCI ID.
Companion quirk 7/7 should travel with it so byte-only GCTL/SD_CTL
writes do not fail after bind.

### Concerns
Apply is clean. No missing symbols. Incomplete without 7/7 for full
functionality, but 6/7 is still a valid, self-contained ID addition.

---

Verification:
- [Phase 1] Parsed tags: author Fu Hao, Link msgid, SOB Takashi Iwai; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +7 lines in `sound/hda/controllers/intel.c` (define,
  enum, short name, `azx_ids[]`)
- [Phase 2] Confirmed no generic Hygon HD-Audio class match; AMD/ATI
  wildcards only
- [Phase 2] `azx_probe_codecs(..., 0)` uses `AZX_DEFAULT_CODECS`
  (`sound/hda/common/controller.c`)
- [Phase 3] `PCI_VENDOR_ID_HYGON` since `c6babb5806b77` (2018); present
  in v6.18.53 `pci_ids.h:2616`
- [Phase 3] File move `2d9223d2d64cb` is ancestor of v6.18.53
- [Phase 3] `git merge-base --is-ancestor <candidate> v6.18.53` → not in
  6.18.53
- [Phase 3] Follow-up `e096c24e7f97` / `054940f79377d` is series 7/7
  (dword access)
- [Phase 4] `b4 dig -c 41212ff3e4ed`: v3 6/7, lore msgid above; `b4 dig
  -a`: series v3 0/7; `b4 dig -w`: tiwai/perex/linux-sound
- [Phase 4] mbox: Takashi “Applied to for-next”; no NAK on HDA patches
- [Phase 4] UNVERIFIED: lore.kernel.org WebFetch/curl 403 (including
  /stable/)
- [Phase 5] Call chain: `azx_ids` → `azx_probe` (PCI enumeration)
- [Phase 6] `make kernelversion` / Makefile: 6.18.53; `git describe
  HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`
- [Phase 6] Dry-run `patch -p1` of `41212ff3e4ed` onto v6.18.53
  `intel.c`: success
- [Phase 6] `AZX_DCAPS_POSFIX_LPIB` / `AZX_DCAPS_NO_MSI` present in
  v6.18.53
- [Phase 8] Failure mode: missing PCI bind → no HD-Audio on that SoC;
  severity medium, exception-qualified

**YES**

 sound/hda/controllers/intel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 98367b87d8017..f07fc5dc5cede 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -100,6 +100,8 @@ enum {
 #define ATIHDMI_NUM_CAPTURE	0
 #define ATIHDMI_NUM_PLAYBACK	8
 
+/* Hygon HD Audio controller */
+#define PCI_DEVICE_ID_HYGON_18H_M05H_HDA	0x14a9
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
@@ -241,6 +243,7 @@ enum {
 	AZX_DRIVER_ZHAOXIN,
 	AZX_DRIVER_ZHAOXINHDMI,
 	AZX_DRIVER_LOONGSON,
+	AZX_DRIVER_HYGON,
 	AZX_DRIVER_GENERIC,
 	AZX_NUM_DRIVERS, /* keep this as last entry */
 };
@@ -357,6 +360,7 @@ static const char * const driver_short_names[] = {
 	[AZX_DRIVER_ZHAOXIN] = "HDA Zhaoxin",
 	[AZX_DRIVER_ZHAOXINHDMI] = "HDA Zhaoxin HDMI",
 	[AZX_DRIVER_LOONGSON] = "HDA Loongson",
+	[AZX_DRIVER_HYGON] = "HDA Hygon",
 	[AZX_DRIVER_GENERIC] = "HD-Audio Generic",
 };
 
@@ -2814,6 +2818,9 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_LOONGSON | AZX_DCAPS_NO_TCSEL },
 	{ PCI_VDEVICE(LOONGSON, PCI_DEVICE_ID_LOONGSON_HDMI),
 	  .driver_data = AZX_DRIVER_LOONGSON | AZX_DCAPS_NO_TCSEL },
+	/* Hygon HDAudio */
+	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_HYGON_18H_M05H_HDA),
+	  .driver_data = AZX_DRIVER_HYGON | AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_NO_MSI },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-- 
2.53.0

