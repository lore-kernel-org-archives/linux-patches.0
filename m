Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CEB504590;
	Mon, 19 Oct 2026 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418403; cv=none; b=ZAaUB2Q9s4dYP3mOmz+KSh6/IIxMZVhRZm/edwHA0MGe21y1odUe09c2ykDqTTbapwoVBp07swpovrzlyKCX431t5wtwPMg5SdqyWhBYc5CpuI/k9mH2R/HNkLLKwJ5xOsgho4Ds8Wu8cXHh7sJXRm+4Ie7eMg9o+RU4lxDPt1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418403; c=relaxed/simple;
	bh=j+25EtGXlRmXOxmEW7NMe5ZCnGrKtICT/rtOAS6w7h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pQ+Zh4+mXqzdsrY3bSI4Go45huPyHNv+h4ffd5ZV2LOdmBaB5mIx7xD7iIAcMCNoecuEleePyL5spLlpyc1eALMXNfVzNQ6MQrY9+NT+ENalRKr2lqXwk8Wh1Ws0o1mRXDLugbEXazLiWZi3D2H5eThW9HOj1XH7xZ06zIwv4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcPZfMXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcPZfMXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEFE1F000C6;
	Mon, 19 Oct 2026 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418400;
	bh=yFZpNctuqc65JwbA5ST21nPpKZMLa1+35C3lsRlwGX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcPZfMXUal0KeOZMmgW8tltJVqW/JiKpFkYNWkyQiv2JSrbpGB4t7g/+2WlABELtZ
	 aUBtzQqRmepJXkZWqvm4nWnS/4F/jyUjcJ5Ta8s18TtdXx4rhqqIT7/rLDYllZfEan
	 r3wLHW0nsGqgONMoRLprHd2+ASS9jNDkEkWwF126RF3u9LQ0zNSqIzch8T6prOzmDQ
	 2DuBvii/jZc7vAmca6VikxFeiCeOenkrKbQJZWBRpQYrl9Z7XV+NGuAsd0AOFdbyQ7
	 83nKpyHyhdfNtsv7HPEtkXIhSSmeZFEbF7PGXZyjTSC9vARB/lZcP2856zQ27llHja
	 bZ+h/1Bo66SZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Mon, 19 Oct 2026 09:48:34 -0400
Message-ID: <20261019135441.1420968-223-sashal@kernel.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4** (mainline, `7.3.0-rc4`). The
candidate is a one-line NULL check in `alc269_probe()`. The unguarded
`codec->bus->pci->vendor` dereference is real: non-PCI HDA controllers
leave `bus->pci` NULL, and the same function already guards other PCI
accesses.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA hda/realtek] [add] missing NULL check for
codec->bus->pci`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Bob Song <songxiebing@kylinos.cn>` (author)
- `Link: https://patch.msgid.link/20260730015302.253008-2-
  songxiebing@kylinos.cn`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected)
- Message-Id suffix `-2` indicates patch 2 of a 2-patch series

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `alc269_probe()` dereferences `codec->bus->pci` with no NULL
  check in the ALC236 (`0x10ec0236`) case
- Symptom: kernel oops / NULL pointer dereference at codec probe
- Root cause: missing the same `codec->bus->pci &&` guard already used
  earlier in the same function
- No stack trace, reproducer, or version range in the message

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit NULL-deref fix (“add missing
NULL check”, “consistent with the existing pattern”).

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- Function: `alc269_probe()`
- Scope: single-file, single-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: In the `0x10ec0236` / ALC256 variant case, probe used to
evaluate `codec->bus->pci->vendor != PCI_VENDOR_ID_AMD` unconditionally.
After the change it short-circuits if `codec->bus->pci` is NULL and
leaves `spec->en_3kpull_low` at its default (`true`). PCI-present
behavior is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: NULL pointer dereference (memory safety)
- Mechanism: `hda_bus.pci` is optional. `azx_bus_init()` does `bus->pci
  = chip->pci`. Platform controllers (Tegra, ACPI HDA, CIX IPBLOQ) never
  set `chip->pci`, so it stays NULL. ALC236 probe then does
  `pci->vendor` and oopses. The 2014 commit `5100cd07d43a1` (“ALSA:
  hda/realtek - Allow NULL bus->pci”) already established that Realtek
  must tolerate a NULL PCI pointer.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; matches existing guards at lines 9119 and
9126 in the same function. No API, locking, or data-structure change. If
`pci` is NULL, skipping the AMD-specific `en_3kpull_low = false` keeps
the default — the same “optional PCI” policy as 2014. Regression risk is
very low.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Unguarded deref introduced in `69ea4c9d02b79` (“ALSA: hda/realtek -
  remove 3k pull low procedure”, 2023-07-13, in v6.5-rc3)
- Condition rewritten (still unguarded) in `46cdff2369cbd` (“ALSA:
  hda/realtek - Remodified 3k pull low procedure”, 2023-08-15, in
  v6.5-rc7)
- File later moved/split (`6014e9021b28e`, `aeeb85f26c3bbe`); logic
  unchanged until this fix

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The buggy pattern dates to `69ea4c9d02b79` /
`46cdff2369cbd`, both ancestors of this HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `alc269.c` history is mostly laptop quirks. Sibling in
the same series is `5b106b40ed220` (COEF error checks). That patch
touches `alc282_init` / `alc282_shutup` / `alc285_hp_init` /
`alc294_hp_init`, not `alc269_probe` or `bus->pci`. This NULL check is
standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Bob Song is a regular HDA contributor, not the subsystem
maintainer. Takashi Iwai applied the patch. Related author work around
the same time is the independent COEF-check patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None required. One added `&&` in an existing `if`. The v2 split
from the COEF patch was requested by Iwai because they are different
fixes.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 3b36ac93739e7` → https://patch.msgid.link/20260730015302.25
  3008-2-songxiebing@kylinos.cn
- v1: combined COEF checks + this NULL check
  (`20260729063803.1453980-1`)
- v2: split into two patches after maintainer request
- Applied version is v2 (latest)
- Direct lore HTTP fetch returned 403; thread recovered via `b4 dig -m`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `tiwai@suse.com`, `perex@perex.cz`, `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Takashi Iwai
(ALSA maintainer) applied it: “Applied to for-next branch now. Thanks.”
No NAK.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Found by code inspection
(missing check vs. siblings). No user crash report found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Two-patch v2 series. Patch 1 = COEF error checks (independent).
Iwai on v1: “Could you split the NULL check to another patch? Basically
it's a completely different sort of fix from others.” Confirms this is
self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned HTTP 403. No stable
discussion in the saved mbox. UNVERIFIED whether anyone already
nominated this for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `alc269_probe()` only.

**Step 5.2: TRACE CALLERS**
Record: Assigned as `alc269_codec_ops.probe`. Invoked from the HDA codec
driver probe path when a matching ID in `snd_hda_id_alc269[]` is
enumerated (includes `0x10ec0236` “ALC236”). Probe-time, not IRQ/hot
path.

**Step 5.3: TRACE CALLEES**
Record: The hunk only reads `codec->core.vendor_id` and
`codec->bus->pci->vendor`, then may set `spec->en_3kpull_low`. That flag
is later consumed by `alc256_shutup()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Device enumeration → HDA controller probe → codec bind →
`alc269_probe()`. Reachable on any machine with an ALC236 (very common
Dell/HP laptop codec). The NULL path is reached only when the controller
did not assign `bus->pci` (platform/ACPI/Tegra/CIX). Userspace can
trigger it by loading the codec module / booting with that hardware.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same function already uses `if (codec->bus->pci && …)` for
Acer/Lenovo rename quirks. `realtek.c` has `if (!codec->bus->pci)
return`. This site was the hole left by the 2023 3k-pull rewrite.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local tree is `v7.3-rc4-27-gf0100363d8c37` / `7.3.0-rc4`.
File `sound/hda/codecs/realtek/alc269.c` exists. The ALC236
`bus->pci->vendor` test is at lines 9188–9191; this commit
(`3b36ac93739e7`) is already an ancestor of HEAD. The bug was introduced
in v6.5-era code that this tree still contains.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected apply: clean. One context line in an `if`. No refactor
needed on this tree. (Older stables still using
`sound/pci/hda/patch_realtek.c` / `patch_alc269()` would need a
path/function-name adjustment; that does not apply to this checkout.)

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is already in HEAD. `5100cd07d43a1` (2014) added
the general “allow NULL bus->pci” policy; it did not cover this later
ALC236 site. No other substitute for this one-line guard.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/hda/codecs/realtek` — HD-audio Realtek codec.
Criticality: **IMPORTANT** (extremely common laptop audio), not core
mm/VFS.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed (quirks land frequently). The buggy PCI deref
itself has been stable since 2023; this is a late correctness fix, not
churn in new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/codec-specific: ALC236 (`0x10ec0236`) on a bus where
`hda_bus.pci` is NULL. Intel/AMD PCI HDA (the usual ALC236 laptops)
always set `pci` in `azx_create()` / SOF / AVS, so they do not crash.
Non-PCI controllers in this tree (Tegra, ACPI HDA, CIX IPBLOQ) never
assign `chip->pci`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Codec probe of ALC236 with `bus->pci == NULL`. Not a race. Not
unprivileged-syscall-exploitable beyond “device exists.” Commonness of
the crash path is low; commonness of ALC236 is high. The NULL case is a
supported configuration (explicit 2014 policy).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: NULL deref → oops at probe. Audio init fails; with
`panic_on_oops` the machine dies. Severity: **HIGH** (crash), trigger
rarity: low-to-medium.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: prevents a probe-time oops on a supported non-PCI HDA +
  ALC236 configuration; restores the documented NULL-PCI policy
- Risk: one `&&` in a probe-time `if`; PCI systems behave identically
- Ratio: high benefit / very low risk

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real NULL deref, not style
- Same function already NULL-checks `bus->pci` in two other places
- 2014 maintainer commit documented that Realtek must allow NULL
  `bus->pci`
- Platform HDA controllers in this tree leave `pci` NULL (verified: no
  `->pci =` in tegra.c, acpi.c, cix-ipbloq.c)
- One-line, obviously correct, applied by Takashi Iwai
- Independent of the sibling COEF patch
- Code and bug exist in this tree

AGAINST:
- No user crash report or syzbot hit
- Typical ALC236 laptops use PCI HDA, so they never take the NULL path
- No `Fixes:` / `Cc: stable` from the author (not a negative per the
  rules)

UNRESOLVED:
- Direct lore.kernel.org HTTP was 403 (thread recovered via b4)
- No confirmed stable-list discussion
- How often ALC236 actually sits behind Tegra/ACPI/CIX HDA is
  unverified; the NULL-PCI design is still supported

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one `&&` matching existing
   pattern; maintainer applied to for-next
2. Fixes a real bug that affects users? **PASS** — NULL deref on a
   supported non-PCI HDA configuration
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   probe-time oops
4. Small and contained? **PASS** — +1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file and surrounding code
   match; commit is already in this HEAD

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/doc exception. It is a straight
crash fix.

**Step 9.4: MAKE YOUR DECISION**

This is a one-line NULL check closing a hole left when the 2023 3k-pull
rewrite dereferenced `codec->bus->pci` without the guard the rest of
Realtek has used since 2014. On this v7.3-rc4 tree the buggy site
exists, non-PCI controllers still leave `pci` NULL, and the change
cannot alter PCI HDA behavior. It meets the stable rules: real crash,
tiny, obviously correct.

Verification:
- [Phase 1] Parsed tags: SOB Bob Song + Takashi Iwai; Link msgid `-2`;
  no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 line in `alc269_probe()` adding `codec->bus->pci
  &&` before `pci->vendor`
- [Phase 2] Confirmed sibling NULL checks at alc269.c:9119 and :9126
- [Phase 3] `git blame`: guard is `3b36ac93739e7`; surrounding code from
  `aeeb85f26c3bbe` (file split)
- [Phase 3] Unguarded deref from `69ea4c9d02b79` (v6.5-rc3) and
  `46cdff2369cbd` (v6.5-rc7); both are ancestors of HEAD
- [Phase 3] Sibling `5b106b40ed220` does not touch `alc269_probe` /
  `bus->pci` — not a prerequisite
- [Phase 3] `git merge-base --is-ancestor 3b36ac93739e7 HEAD` → already
  in this tree
- [Phase 4] `b4 dig -c 3b36ac93739e7`: lore URL found; v1 combined, v2
  split at Iwai’s request; Iwai applied v2
- [Phase 4] `b4 dig -w`: linux-sound, perex, tiwai on original To/Cc
- [Phase 4] lore HTTP 403; mbox saved with `b4 dig -m`
- [Phase 5] `alc269_probe` is `.probe` of `alc269_codec_ops`; ID
  `0x10ec0236` is in `snd_hda_id_alc269[]`
- [Phase 5] `azx_bus_init()` assigns `bus->pci = chip->pci`;
  tegra/acpi/cix-ipbloq never set `chip->pci`
- [Phase 6] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → `7.3.0-rc4`
- [Phase 6] Buggy ALC236 block present at alc269.c:9188–9191
- [Phase 6] Historical policy: `5100cd07d43a1` “Allow NULL bus->pci”
  (v3.15-rc1) is in HEAD
- [Phase 8] Failure mode: NULL deref at codec probe → oops; severity
  HIGH; PCI path unchanged
- UNVERIFIED: whether ALC236 is commonly wired to Tegra/ACPI/CIX in the
  field; lore.kernel.org/stable discussion (HTTP 403)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6bf500c0b5f9b..d88627558150f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -8451,6 +8451,7 @@ static int alc269_probe(struct hda_codec *codec, const struct hda_device_id *id)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0

