Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C7A5DE999;
	Mon, 19 Oct 2026 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418539; cv=none; b=sQSxs9yknSLwNhtGfyipRc3iqgxDztYDdinMr8A2Qnglu+d8xBZ6U9iAiING/IW26yzBOhI31J2Utd7jI5GFTOst1EfmiDiZqQvj/DMxQb5KQhCSNIR46VooLc3H2wNre5egu8Pph07RkVA6H4x0iq6G+slMuyxfIMP2pXRRIVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418539; c=relaxed/simple;
	bh=2p0mEzJLWfOGEC5OD/3TM2/rVM6Kn5a7xXK7lqvUKQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ua8SUNNLpkFctNwZOjgfivelO6c2zmS5gDiGM51IgR0g++Esjcz+dvfmgd8N7VkZHoKWyjx4VQ1V+3Dsb4BUVOT+UgmcLLND7W/jvYQ+CpnRrdaqin/b7+ILhQrAqPtkd6Y41EfbkhYyIjXpOvQLBGIdD//RVVo7vm6FEtx5mN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nqx9rlDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nqx9rlDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E9D1F000C4;
	Mon, 19 Oct 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418534;
	bh=RSFCUUn9tTT4o2aFy4MJqRVfv+N/W91AMgfdwSwp4fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nqx9rlDXesh3DNKxHVXSSASUTzLsrfkDaPfNlOjfxePn/MjXrTc2voJboy0hLNOcC
	 wYyXkuGJVMBvbcF/ta98ypi6l40Db4ArsnQ7Ko44++3k1aydrhuV3f9BjUYUgECrnl
	 lwwsDHqIQW170v/bZ4nIWAKwHlyCxWHzLs3D5LL9Z6Qvp7RWR8FjTbXDpgghhUC5XV
	 ZCHCOM6a6w8BcvuNNMLpx07SJWfkwnWov4R3qUvYta2SgjChJ0dgUIWyvxEw0eJ6mh
	 IDo72EOVTGoWSi2nCA9OsO4ZGWJeGLt9EwRQPm6PONHPrTaufshHk5EAm16XGFs7Zc
	 lwVqG6DJLs+LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Mon, 19 Oct 2026 09:50:07 -0400
Message-ID: <20261019135441.1420968-316-sashal@kernel.org>
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

From: Tomasz Bojanowski <tomasz@bojanowski.me>

[ Upstream commit 7b457ae8cf711831f19d20963f5ed2fdf4842d3a ]

The USB audio device 0db0:cc78 (Realtek ALC4080) on the MSI MAG B850M
MORTAR WIFI motherboard exposes all playback controls as "PCM", which
makes it hard to tell the outputs apart.

Its mixer layout matches the one of the MSI MPG X570S Carbon Max Wifi
(units 29, 30 and 32), so reuse msi_mpg_x570s_carbon_max_wifi_alc4080_map
for this device too. With the mapping applied, the controls show up as
"Speaker", "Front Headphone" and "IEC958".

Tested with a patched snd-usb-audio module on a 7.2.7 kernel.

Signed-off-by: Tomasz Bojanowski <tomasz@bojanowski.me>
Link: https://patch.msgid.link/20260923184957.6687-1-tomasz@bojanowski.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a four-line USB mixer-map ID addition for an existing `snd-usb-
audio` quirk table. The local tree is **6.18.57**; the reused ALC4080
map is already here, and the new ID is not in `v6.18.57`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ALSA/usb-audio] [Add] mixer mapping for MSI MAG B850M MORTAR
WIFI (USB ID 0db0:cc78)**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review class)
- **Reported-by:** none
- **Tested-by:** none as a tag; body says the author tested a patched
  `snd-usb-audio` on **7.2.7**
- **Reviewed-by / Acked-by:** none in the commit; mailing-list apply-ack
  from Takashi Iwai
- **Link:**
  `https://patch.msgid.link/20260923184957.6687-1-tomasz@bojanowski.me`
- **Cc: stable:** absent (not a negative signal)
- **Signed-off-by:** Tomasz Bojanowski (author); Takashi Iwai
  `<tiwai@suse.de>` (SOUND maintainer). Ignore Sasha Levin.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** USB audio `0db0:cc78` (Realtek ALC4080 on MSI MAG B850M
  MORTAR WIFI) exposes every playback control as `"PCM"`, so speaker,
  front headphone, and S/PDIF cannot be told apart.
- **Symptom:** unusable/ambiguous mixer controls;
  PulseAudio/PipeWire/UCM cannot bind the right output.
- **Root cause:** generic USB mixer names; layout matches existing MSI
  ALC4080 maps (units 29, 30, 32).
- **Fix:** reuse `msi_mpg_x570s_carbon_max_wifi_alc4080_map`.
- **Version info:** tested on 7.2.7; hardware is a current AM5 board, so
  6.18.y users have this device.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a hidden fix.** It is an explicit hardware quirk / mixer-
map ID addition. Not cleanup or a new API.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `sound/usb/mixer_maps.c` — **+4 / −0**
- **Function/data:** `usbmix_ctl_maps[]` only
- **Scope:** single-file surgical table entry

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: **Before:** `snd_usb_mixer_controls()` walks `usbmix_ctl_maps`;
`0x0db0:0xcc78` misses, so units keep generic `"PCM"` names. **After:**
that ID selects `msi_mpg_x570s_carbon_max_wifi_alc4080_map`, and
`find_map()` / `check_mapped_name()` rename units 29/30/32. Probe-time
mixer build only; other USB IDs unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / USB mixer-map ID]** — same pattern as
PCI/USB ID additions. No leak, race, or crash.

Verified map in this tree:

```476:481:sound/usb/mixer_maps.c
static const struct usbmix_name_map
msi_mpg_x570s_carbon_max_wifi_alc4080_map[] = {
        { 29, "Speaker Playback" },
        { 30, "Front Headphone Playback" },
        { 32, "IEC958 Playback" },
        {}
};
```

Lookup in `snd_usb_mixer_controls()`:

```3278:3286:sound/usb/mixer.c
        for (map = usbmix_ctl_maps; map->id; map++) {
                if (map->id == state.chip->usb_id) {
                        state.map = map->map;
                        state.selector_map = map.selector_map;
                        mixer->connector_map = map->connector_map;
                        break;
                }
        }
```

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct.** Four lines, reuses a 2022 map already
used for two MSI ALC4080 IDs. **Regression risk: very low** — scoped to
one USB ID; wrong names would only affect that board, and the author
tested it. No locking, allocation, or API change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Candidate lines blamed to `53b3abbe6e262` (this patch). Reused
map from **`5762f980ca10d`** (Johannes Schickel, 2022-01-15, “add
mapping for MSI MPG X570S Carbon Max Wifi”). Sibling ID `0x0db0:0xa073`
from **`4ddef9c4d70aa`** (2022-04-18, Torpedo Max). Neighboring
`usbmix_ctl_maps` MSI/ASUS entries date to 2020.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Bug is missing a device-specific map, not a
regression from a named commit. Prerequisite map **is** in this series:
`git merge-base --is-ancestor 5762f980ca10d v6.18.57` → yes; same for
`4ddef9c4d70aa`.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent `mixer_maps.c` work is more ID/quirk entries (Corsair
Virtuoso, Razer Barracuda dB map, KTMicro rename, Corsair HS80).
**Standalone.** No “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this ALSA commit in-tree. Author is a hardware reporter,
not the maintainer. Weight comes from **Takashi Iwai** applying it.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `msi_mpg_x570s_carbon_max_wifi_alc4080_map` and
`usbmix_ctl_maps[]`. Both exist at `v6.18.57`. **Applies standalone.**

Precedent: Torpedo Max (`4ddef9c4d70aa`) is the same reuse and carried
**`Cc: stable@vger.kernel.org`**. This 6.18.y tree already has later
mixer-map ID quirks (`5144ddfb71c18` Corsair Virtuoso later revision,
`a7de2b873f3db` HS80, `93adf20ff4d6e` KTMicro) — `git merge-base --is-
ancestor` of each vs `v6.18.57` is true.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 53b3abbe6e262` →
  https://patch.msgid.link/20260923184957.6687-1-tomasz@bojanowski.me
- `b4 dig -a`: **v1 only**, 2026-09-23
- Thread: submission + Takashi Iwai **“Applied now. Thanks.”**
  (2026-09-28). **No NAK, no revision requests, no stable discussion in-
  thread.**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc **Takashi Iwai**, **Jaroslav Kysela**,
`linux-sound`, `linux-kernel`. Right maintainers. Maintainer applied v1
unchanged.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Author hit it on real hardware. Related
userspace: alsa-ucm-conf PR #581 (“add UCM2 support for MSI MAG B850M
Mortar Wifi (ALC4080)”) describes **front-panel and S/PDIF routing
problems** on this board. Kernel mixer names matter for UCM. That PR is
supporting context, not a second kernel report.

**Step 4.4: RELATED PATCHES AND SERIES**
Record: Standalone 1/1. A later lore subject “USB-Audio: add MSI MAG
B850M Mortar **Max** WiFi (0db0:83ed)” is a **different** USB ID — not a
dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: `lore.kernel.org/stable/?q=...` returned **403**. Openwall/LKML
copies had **no stable NAK**. Unverified whether anyone mailed stable@
about this exact patch. Not used as a negative.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: No function bodies changed. Data consumed by
`snd_usb_mixer_controls()` → `find_map()` → `check_mapped_name()`.

**Step 5.2: TRACE CALLERS**
Record: `snd_usb_mixer_controls()` runs when `snd-usb-audio` builds
mixers for a matching USB audio interface (device probe). Userspace-
reachable via plugging/enumerating this onboard codec.

**Step 5.3: TRACE CALLEES**
Record: `find_map` is a linear table walk; `check_mapped_name` copies a
string into `kctl->id.name`. No alloc/lock beyond existing mixer control
creation.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: USB enumerate → `snd-usb-audio` probe → mixer parse → kcontrol
names. **Yes, reachable** for anyone with this motherboard. Unprivileged
users see the names via ALSA/PulseAudio; they cannot trigger a kernel
crash with this change.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same map already used for `0x0db0:0x419c` and `0x0db0:0xa073`.
This is the established ALC4080 pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **`v6.18.57-155-gcdf239ca885b2`**
- `make kernelversion` → **6.18.57**
- `v6.18.57:sound/usb/mixer_maps.c` has the ALC4080 map and IDs `0x419c`
  / `0xa073`, **not** `0xcc78`
- The unmapped-ID bug **exists on this 6.18.y base**
- `git merge-base --is-ancestor 53b3abbe6e262 v6.18.57` → **false** (not
  in the 6.18.57 tag)

(The candidate is present on current HEAD because autosel applied it for
evaluation. That is ignored as selection evidence.)

**Step 6.2: BACKPORT COMPLICATIONS**
Record: **Clean apply.** Context around the Torpedo Max entry is
identical at `v6.18.57`. Needle found; `0xcc78` absent; map symbol
present.

**Step 6.3: RELATED FIXES ALREADY HERE**
Record: Carbon Max and Torpedo Max maps are here. **No equivalent
`0xcc78` mapping** at `v6.18.57`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Record: **ALSA USB audio (`sound/usb/`)** — **IMPORTANT**
(common onboard USB audio on AM5 boards). Not core mm/net, not staging.

**Step 7.2:** Record: Active; this 6.18.y tree already backports mixer-
map ID quirks. SOUND maintainers: Takashi Iwai, Jaroslav Kysela
(`MAINTAINERS`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Record: **Driver-specific / USB-ID-specific** — MSI MAG
B850M MORTAR WIFI (`0db0:cc78`) with `CONFIG_SND_USB_AUDIO`. Other
devices unaffected.

**Step 8.2:** Record: Trigger is **every probe** of that codec. Common
for that board. Unprivileged users see wrong mixer names; not a syscall
crash.

**Step 8.3:** Record: **Failure mode:** all playback controls named
`"PCM"` → users cannot control speaker vs headphone vs IEC958
independently; userspace routing/UCM can pick the wrong output.
**Severity: MEDIUM** as a functional hardware quirk (not
oops/corruption). Still the class stable explicitly wants.

**Step 8.4:** Record: **Benefit: high for those boards, zero
elsewhere.** **Risk: very low** (4 lines, one ID). **Ratio: strongly
favorable.**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**For:**
- Official rule: *“fix a real bug that bothers people **or just add a
  device ID**”* and *hardware quirk* (`Documentation/process/stable-
  kernel-rules.rst`)
- Same class as USB/PCI ID and mixer-map quirks routinely taken into
  6.18.y
- Identical 2022 sibling (Torpedo Max) was **Cc: stable**
- Real hardware: ALC4080 with colliding `"PCM"` names
- 4 lines, reuses an in-tree map, maintainer-applied, author-tested
- Map + table exist at `v6.18.57`; applies cleanly
- Only that USB ID is affected

**Against:**
- Not a crash, UAF, or security fix
- No Fixes:/Cc: stable on this commit (expected; not a veto)
- No second independent reporter in the kernel thread

**Unresolved:**
- lore.kernel.org/stable search 403 — no verified stable-list thread
- Commit text says controls show as `"Speaker"` / `"Front Headphone"` /
  `"IEC958"`; table strings are `"* Playback"`. Same as the 2022 map.
  Does not change correctness.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 4-line ID add; author
   tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — indistinguishable
   mixer controls on real hardware
3. Important issue? **PASS** as **hardware quirk / device ID**
   (documented exception); not a panic
4. Small and contained? **PASS** — +4 lines, one file
5. No new features or APIs? **PASS** — existing map, existing driver
6. Can apply to the local tree? **PASS** — clean against `v6.18.57`

**Step 9.3: EXCEPTION CATEGORY**
Record: **Device ID addition + hardware quirk/workaround** (USB mixer-
map ID on existing `snd-usb-audio`).

**Step 9.4: DECISION**
Backport. This is the standard stable-eligible USB mixer ID quirk:
small, isolated, already-supported driver, real board, in-tree map.

---

### What the commit solves and why it matters here

On this 6.18.y tree, `snd-usb-audio` already drives Realtek ALC4080
motherboard codecs, but `0db0:cc78` has no name map. All playback
volumes appear as `"PCM"`, so users (and UCM) cannot separate speaker,
front headphone, and S/PDIF. The patch binds that ID to the existing MSI
ALC4080 map.

### Stable rules / risk vs benefit

Meets the written stable rules via the **device ID / hardware quirk**
exception. Benefit is correct mixer labels for this AM5 board; risk is
confined to that USB ID. No prerequisites beyond code already in
`v6.18.57`.

### Concerns

None material. Different Mortar **Max** ID `0db0:83ed` is a separate
patch and not required. Presence of this commit on current autosel HEAD
is evaluation-pipeline state, not a reason to skip a technical YES.

---

### Verification
- **[Phase 1]** Parsed subject/tags/body from `git show 53b3abbe6e262`;
  Link msgid `20260923184957.6687-1-tomasz@bojanowski.me`
- **[Phase 2]** Diff: +4 lines in `usbmix_ctl_maps[]`; map contents and
  `snd_usb_mixer_controls()` lookup read in this tree
- **[Phase 3]** `git blame` on map (5762f980ca10d, 2022) and ID rows;
  Torpedo Max `4ddef9c4d70aa` has `Cc: stable`; `git merge-base --is-
  ancestor` of map/Torpedo vs `v6.18.57` = yes
- **[Phase 3]** `git log --oneline -20 -- sound/usb/mixer_maps.c`;
  author search only this commit
- **[Phase 4]** `b4 dig -c/-a/-w` and `-m /tmp/thread.mbox`: v1 only; To
  Iwai/Kysela/linux-sound; Iwai “Applied now”
- **[Phase 4]** Openwall + LKML mirrors of the same thread;
  lore.kernel.org 403 on patch.msgid.link and stable search
- **[Phase 4]** Web search found alsa-ucm-conf PR #581 for this board
  (userspace routing)
- **[Phase 5]** Call path: `snd_usb_mixer_controls` → `find_map` →
  `check_mapped_name` verified in `mixer.c`
- **[Phase 6]** `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`;
  `make kernelversion` = 6.18.57; `git grep` on `v6.18.57 --
  sound/usb/mixer_maps.c`: map yes, `0xcc78` no; ancestor check of
  candidate vs `v6.18.57` = no
- **[Phase 6]** Context around Torpedo Max entry identical at `v6.18.57`
  (clean apply)
- **[Phase 6]** Similar mixer-map ID quirks already in `v6.18.57`
  (Corsair Virtuoso, HS80, KTMicro)
- **[Phase 7]** SOUND maintainers in `MAINTAINERS`; `sound/usb/` still
  receiving 6.18.y quirks
- **[Phase 8]** Failure mode is misnamed mixer controls for one USB ID,
  not a kernel oops
- **UNVERIFIED:** whether this patch was already discussed on stable@
  (lore stable search 403)

The patch is a contained hardware quirk for an existing driver and
should be taken into this 6.18.y tree.

**YES**

 sound/usb/mixer_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index ace4ccad8f51c..a82b9c1d578d9 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -718,6 +718,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x0db0, 0xa073),
 		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
 	},
+	{	/* MSI MAG B850M MORTAR WIFI */
+		.id = USB_ID(0x0db0, 0xcc78),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
-- 
2.53.0

