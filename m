Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3199F5166EB;
	Mon, 19 Oct 2026 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418237; cv=none; b=YnIreQZ/1KI+KHPfxN/qkT5sGUluBq1ywBiLsPRLgRkuD+rP4Yq0d6xMCbomG2rW3NzEN6LMVYSO4NuhQ9KRnd7lfjL7MseCYzm/ZPIjZ3uvjXsik68acV4kGWnXq0vJy0mViKIIksuXO5MxV8tzAQcVvlOemuBXQfFCFkPvUDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418237; c=relaxed/simple;
	bh=RFs5uFlalXGqx9N88N58xsb+5vzkPj50bTMdwXiPIeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGqa8Xh+gszWBQbpdN7ZdSF6IoCaHcY75+YEqzgoIq8XR8PJNFW9wPfdPZlW+L3v6e5sko644Vss2Y5cDv6CYxw93LJkz82n8abFsq+cCE/1lS5V3tMO1wjT4pkNc+s5OuRTeEneNb9eRImEXbUAL9mHS1HQLBh+sulUswS3g8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCJxTYLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCJxTYLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020AF1F000C5;
	Mon, 19 Oct 2026 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418234;
	bh=v4Mta69ia7glAl/5rdNScM6vXNkJjJ7JytjXsu0GMmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCJxTYLSixX7GjLCTCdpGz2IjY6Aeg9kPcW0tmbafH68tAouwB7ij0USJ1gsXTk3/
	 Tiz1tzv4OVlJplK6nLNTO+0VCuGfnV8KsbVYJkbQuWYwGnfz/vmptlPHDMFjPR9pwA
	 nSrTepX1GXaz7p59C72OlhXiS5TkhG/i/HOmCTcjsMsYB+lOsnX4pGQQrRDcivzm6T
	 UL+QuynVEoK5W9rtvm7G6l000NqMAppf8Yfi+1Vw/fa65Hgsd7vE4SunEeR6FLHhQ/
	 f5vH9wneTDwe1yoTujlLVqRvt7Z4Mv/XaQEtnz2kUnhw3j7X4Wq98F4Q/wZ+zSsq7Q
	 VyXyKdR7ct3FQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: rt712-sdca: Pull high JD2 to prevent from entering TV mode
Date: Mon, 19 Oct 2026 09:46:38 -0400
Message-ID: <20261019135441.1420968-107-sashal@kernel.org>
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

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit dfb8bc1d286fd97b7cf47e3af5df84cfb068d214 ]

Add a patch setting to prevent ALC712 from entering TV mode which
may cause unexpected issues.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/20260820092415.2979641-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The candidate is
mainline `dfb8bc1d286fd97b7cf47e3af5df84cfb068d214`. It is not in this
checkout; the VB init path it patches is.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[ASoC/rt712-sdca] [Pull high] Pull JD2 high so ALC712 does
  not enter TV mode`

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Jack Yu <jack.yu@realtek.com>` (vendor author)
  - `Link: https://patch.msgid.link/20260820092415.2979641-1-
    jack.yu@realtek.com`
  - `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence is expected for this review)
  - Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
    ignored

**Step 1.3 — Body**
- Record:
  - Bug: ALC712 can enter **TV mode** if JD2 is not pulled high
  - Symptom: “unexpected issues” only — no stack trace, no jack/audio
    failure description, no machine name
  - Root cause (author): missing vendor register write during VB I/O
    init
  - Version info: none in the message; change is only in
    `rt712_sdca_vb_io_init()`, so version B only

**Step 1.4 — Hidden bug fix?**
- Record: Not disguised cleanup. It is a vendor hardware workaround
  worded as “add a patch setting.” That matches HDA/ASoC codec init
  quirks, not a refactor.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record:
  - `sound/soc/codecs/rt712-sdca.c`: +1 (write in
    `rt712_sdca_vb_io_init`)
  - `sound/soc/codecs/rt712-sdca.h`: +1 (`#define RT712_JD_CTL3 0x0b`)
  - Scope: single-driver, two-line surgical change

**Step 2.2 — Flow**
- Record: Before, VB init never programmed JD_CTL3. After, every
  `rt712_sdca_vb_io_init()` call writes NID `RT712_VENDOR_REG` (0x20),
  index 0x0b, value `0x7778` via existing `rt712_sdca_index_write()`.
  The write is unconditional (not gated on
  `FUNCTION_NEEDS_INITIALIZATION`), so it runs on first attach and later
  re-init. Normal init path, not an error path.

**Step 2.3 — Bug mechanism**
- Record: **Hardware workaround / codec quirk.** Jack-detect pin JD2 is
  pulled high so the analog frontend stays out of TV (CE) jack mode. The
  driver already uses JD1 for HP detection (`rt712->jd_src = RT712_JD1`;
  enum has no JD2). This is the same class of change as HDA Realtek
  pin/coef quirks.

**Step 2.4 — Fix quality**
- Record: Minimal and matches surrounding vendor init writes. Regression
  risk is low: one extra MBQ register write at SoundWire attach.
  Theoretical risk is a board that needed JD2 floating/low; this driver
  does not implement JD2 as a jack source, and Realtek submitted the
  value for all VB parts. Magic `0x7778` is undocumented but typical for
  this driver.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Insertion point in this tree is after the `func_status` debug
  print, blamed to `936abb09c1c7c` (“ASoC: rt712-sdca: add the function
  for version B”, Shuming Fan, 2024-06-20). `RT712_JD_CTL1` came from
  that same commit. Driver itself landed in `6c39710da75ca` (2023-02).
  VB init has been in 6.12 since the branch.

**Step 3.2 — Fixes: tag**
- Record: None. Missing init is the “bug”; there is no later bisect
  commit that introduced TV mode.

**Step 3.3 — File history**
- Record: Recent in this tree: `8ad30bd5c1088` (reset at io_init for
  silent headphone, already backported; that is VA calibration, not this
  JD2 write). No other JD_CTL3 work. Standalone, not patch X/Y.

**Step 3.4 — Author**
- Record: Jack Yu is a Realtek ASoC contributor (`jack.yu@realtek.com`).
  Other codec work in this tree includes rt722/rt5682s/rt5645 fixes.
  Recipients in the original mail include Shuming Fan and other Realtek
  codec people.

**Step 3.5 — Dependencies**
- Record: Needs `rt712_sdca_index_write()`, `RT712_VENDOR_REG`, and
  `rt712_sdca_vb_io_init()` — all present. No new helpers. Applies
  standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c dfb8bc1d286fd97b7cf47e3af5df84cfb068d214` →
  https://patch.msgid.link/20260820092415.2979641-1-jack.yu@realtek.com
- `b4 dig -a`: **v1 only**, no later revision
- Thread (mbox): patch + Mark Brown “Applied to … for-7.3”. **No NAK, no
  review comments, no Cc: stable in review**
- Takashi Iwai then included it in **sound fixes for 7.3-rc1** (LKML
  pull, listed under “Codec fixes for … rt712 …”)

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `broonie@kernel.org`, `lgirdwood@gmail.com`, `alsa-devel@alsa-
  project.org`, Realtek codec engineers (`shumingf`, `flove`,
  `oder_chiou`, `derek.fang`), MediaTek `Trevor.Wu`. ASoC maintainers
  were on To.

**Step 4.3 — Bug report**
- Record: No bugzilla/syzbot/user report. Symptom stays vendor-stated
  “unexpected issues.”

**Step 4.4 — Series**
- Record: Standalone 1/1. Later mainline `d56fe35` (“reconfigure PLL2 to
  fix calibration time-out”) is a **different** Jack Yu fix, not a
  prerequisite or revert of JD_CTL3.

**Step 4.5 — Stable list**
- Record: lore.kernel.org HTTP is 403 from this environment. No stable-
  thread evidence found via b4. UNVERIFIED: whether anyone already asked
  stable@ for this SHA.

## Phase 5: Semantic / call chain

**Step 5.1 — Functions**
- Record: `rt712_sdca_vb_io_init()` only (plus header define).

**Step 5.2 — Callers**
- Record: `rt712_sdca_io_init()` → if `version_id != RT712_VA` →
  `rt712_sdca_vb_io_init()`. `rt712_sdca_io_init()` is called from
  `rt712_sdca_update_status()` in `rt712-sdca-sdw.c` when the SoundWire
  slave is `SDW_SLAVE_ATTACHED` and `hw_init` is false. That is
  boot/resume enumeration, not a syscall hot path.

**Step 5.3 — Callees**
- Record: `rt712_sdca_index_write()` → `regmap_write()` on `mbq_regmap`.
  Same helper used throughout this file.

**Step 5.4 — Reachability**
- Record: Yes, from userspace-visible audio: plugging/using headset on
  Intel SoundWire laptops with RT712 VB (ACPI match tables exist for
  MTL/TGL/LNL in this tree). Unprivileged users do not program the
  register; they hit it by using audio after attach.

**Step 5.5 — Similar patterns**
- Record: Many sibling vendor `rt712_sdca_index_write()` calls in the
  same function. No other `TV mode` / `JD_CTL3` in this tree. `0x7778`
  appears in HDA `ALC256_FIXUP_ASUS_HPE` as an unrelated EAPD coef —
  same number, different codec, not this bug.

## Phase 6: This tree (6.12.y)

**Step 6.1 — Buggy code present?**
- Record: Yes. `rt712_sdca_vb_io_init()` at
  `sound/soc/codecs/rt712-sdca.c:1721` has the exact pre-patch context.
  `RT712_JD_CTL3` is **not** defined. `git merge-base --is-ancestor
  dfb8bc1d… HEAD` fails (commit not here). `936abb09c1c7c` **is** an
  ancestor. Bug/missing workaround exists since VB support (v6.11-era,
  in 6.12).

**Step 6.2 — Backport difficulty**
- Record: **Clean apply with line offset.** Mainline hunk is ~1779; here
  the same lines are ~1734. Context strings match; `RT712_JD_CTL3` is
  free in the header.

**Step 6.3 — Related fixes already here?**
- Record: `8ad30bd5c1088` resets the codec for VA silent headphones. It
  does not pull JD2 / program JD_CTL3. No substitute for this
  workaround.

## Phase 7: Subsystem

**Step 7.1**
- Record: ASoC codec driver (`sound/soc/codecs/`). Criticality:
  **IMPORTANT** for SoundWire Intel laptops with RT712; not core mm/fs.
  Peripheral relative to the whole kernel, but a shipping laptop codec.

**Step 7.2**
- Record: Driver is mature in 6.12 (added 2023, VB in 2024). This is a
  late vendor init correction, not churn from a brand-new subsystem.

## Phase 8: Impact and risk

**Step 8.1 — Who**
- Record: Config `SND_SOC_RT712_SDCA_SDW` + RT712/713/716/717 **version
  B** on SoundWire (Intel MTL/TGL/LNL match files in-tree). Not
  universal.

**Step 8.2 — Trigger**
- Record: Device attach / `io_init`. Common for those machines. Not a
  race. Not unprivileged memory-safety.

**Step 8.3 — Failure mode**
- Record: Author did not specify. For Realtek PC codecs, TV mode
  typically means **wrong jack detect / headset routing / analog
  misbehavior**, not an oops. Severity **MEDIUM** as described, **HIGH**
  if it silences the jack on real VB laptops. Exact user symptom is
  **not independently verified**.

**Step 8.4 — Benefit vs risk**
- Record: Benefit: hardware init correction from the vendor, 2 lines,
  same class as HDA/USB quirks that stable takes. Risk: very low (one
  init write, no locking/API change). Ratio favors backport.

## Phase 9: Synthesis

**Evidence FOR**
- Two-line vendor codec workaround; hardware-quirk exception in the
  stable rules
- Target function and surrounding init sequence exist in 6.12
- Applies with offset only
- ASoC maintainer applied it; it went in **sound fixes for 7.3-rc1**
- RT712 is used on current Intel SoundWire laptops; this tree already
  took a related headphone-init fix
- Driver defaults to JD1; pulling unused JD2 high is consistent with
  PC/laptop use

**Evidence AGAINST**
- Commit text is vague (“may cause unexpected issues”); no reporter, no
  machine, no crash
- Not a UAF/deadlock/corruption class bug
- Magic coef with no bit documentation
- VB-only (VA machines, e.g. some Lunar Lake ThinkPads, are unaffected)

**Unresolved**
- Exact user-visible TV-mode symptom (UNVERIFIED)
- Whether stable@ already discussed this SHA (lore HTTP 403)

**Stable rules checklist**
1. Obviously correct and tested? **PASS** — one existing helper write;
   vendor + Mark Brown; no NAK
2. Real bug affecting users? **PASS** — missing hardware init that lets
   the codec enter the wrong analog mode (vendor statement; typical
   jack/headset breakage, not proven with a public report)
3. Important? **PASS** under the **audio codec quirk** exception
   (headphone/JD misconfig), not as a panic/CVE
4. Small and contained? **PASS** — +2 lines, one driver
5. No new features/APIs? **PASS** — existing init path, existing write
   helper
6. Can apply to this tree? **PASS** — context matches; JD_CTL3 unused

**Exception category:** Hardware workaround / audio codec quirk (JD pin
config), analogous to HDA Realtek coef/pin quirks.

This is a contained vendor register quirk for hardware that 6.12 already
supports. Benefit is correct analog/jack behavior on RT712 VB; risk is a
single init write. It should be backported to this tree.

Verification:
- [Phase 1] Parsed subject/tags/body from the provided message and
  GitHub `dfb8bc1d286fd97b7cf47e3af5df84cfb068d214`
- [Phase 2] Diff is +1 write in `rt712_sdca_vb_io_init` and +1 `#define
  RT712_JD_CTL3 0x0b`
- [Phase 3] `git blame` on this tree: insertion point from
  `936abb09c1c7c` (2024-06-20); `git merge-base --is-ancestor
  936abb09c1c7c HEAD` true
- [Phase 3] `git merge-base --is-ancestor
  dfb8bc1d286fd97b7cf47e3af5df84cfb068d214 HEAD` false (not in 6.12)
- [Phase 3] `git log --oneline -20 -- sound/soc/codecs/rt712-sdca.c`:
  related `8ad30bd5c1088` is a different VA reset fix
- [Phase 4] `b4 dig -c dfb8bc1d…` / `-a` / `-w` / `-m`: v1, alsa-devel,
  applied by Mark Brown to for-7.3; no NAK
- [Phase 4] LKML: Takashi listed this under 7.3-rc1 sound fixes
- [Phase 4] lore.kernel.org WebFetch/curl: 403
- [Phase 5] Callers: `rt712_sdca_update_status` → `rt712_sdca_io_init` →
  `rt712_sdca_vb_io_init`; intel ACPI match files reference rt712
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111; hunk
  context present; `RT712_JD_CTL3` absent
- [Phase 8] Failure mode: TV-mode analog/JD misbehavior (vendor); not a
  kernel oops — UNVERIFIED exact symptom
- UNVERIFIED: datasheet meaning of `0x7778`; whether every VB board
  needs it; stable@ discussion

**YES**

 sound/soc/codecs/rt712-sdca.c | 1 +
 sound/soc/codecs/rt712-sdca.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index d8b40663fa92f..a799b8aab73aa 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1786,6 +1786,7 @@ static void rt712_sdca_vb_io_init(struct rt712_sdca_priv *rt712)
 	dev_dbg(dev, "%s jack/mic/amp func_status=0x%x, 0x%x, 0x%x\n",
 		__func__, jack_func_status, mic_func_status, amp_func_status);
 
+	rt712_sdca_index_write(rt712, RT712_VENDOR_REG, RT712_JD_CTL3, 0x7778);
 	/* DMIC */
 	if ((mic_func_status & FUNCTION_NEEDS_INITIALIZATION) || (!rt712->first_hw_init)) {
 		rt712_sdca_index_write(rt712, RT712_VENDOR_HDA_CTL, RT712_DMIC2_FU_IT_FLOAT_CTL, 0x1526);
diff --git a/sound/soc/codecs/rt712-sdca.h b/sound/soc/codecs/rt712-sdca.h
index 7ab7d5feb50a2..46740281a5c17 100644
--- a/sound/soc/codecs/rt712-sdca.h
+++ b/sound/soc/codecs/rt712-sdca.h
@@ -74,6 +74,7 @@ struct rt712_dmic_kctrl_priv {
 #define RT712_JD_PRODUCT_NUM			0x00
 #define RT712_ANALOG_BIAS_CTL3			0x04
 #define RT712_JD_CTL1				0x09
+#define RT712_JD_CTL3				0x0b
 #define RT712_IO_CTL				0x0c
 #define RT712_LDO2_3_CTL1			0x0e
 #define RT712_PARA_VERB_CTL			0x1a
-- 
2.53.0

