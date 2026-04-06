Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89809331A46;
	Mon,  6 Apr 2026 11:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473601; cv=none; b=Tkm2CR8I1q40c0fACc7bRIL31bTdoPtBSjKl5zpdM+WhhiFH49Jz8Nv+dexq//o8iJBZO9VeZXJRFZxvNCFunQtgNSlvFwqFjgEaQMCq/BzvsCqRT3FKNwqv7sN2IuUYRPAr5yzc7oVLdD2LnjuvMC9G/sDSxJyjXXmKzTW7YR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473601; c=relaxed/simple;
	bh=h0OrzOtPN18awklmTVHMgRxC+frVKQsNaHlsTHEdipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zxt8julKoSbb3No9VKs4HhYkpgJOm1GNwu88XNkjELb5HtdeWxjUUjzlGPIEAHjgxWmQfJIZZuy1e5T8ShF1aH5d89r2H8cRx6iMkhakoytX0s0vNjJsabPfaqjQE/nZU43e5XyhSbKJP6+83YVKSkGKW0bLDQVhtdb5BBKriiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hysnyUF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hysnyUF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBC2C4CEF7;
	Mon,  6 Apr 2026 11:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473601;
	bh=h0OrzOtPN18awklmTVHMgRxC+frVKQsNaHlsTHEdipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hysnyUF91Pwh/AWNodeuW4F+uT6H6zLZUyeH/OC0YxSKnzecjaL33kqtvSk9vqKj6
	 xw8AHGejii+3krjApiI4bvr5UGxdC2Ng26nuYez+exGtQ0s1cjntpuwkkq07839nuS
	 butruPzuCRkZ26g1sEX4gjsQuA99auFj3Fuh5+yaabwNbW+ree5mNUm3vMcJJ78Tn9
	 Ssh9f7J2ddhZSy78MV9EucYyzhq6D3NPfM2T2GZG4OsdqlfPwKdYaPL8KfUosLTwSr
	 AAE+Q4GQ24/19ccYsoV2jaOWw4Stm3EUuN1CcVXplzBEPZLPtwZJ73swNZMp/Qim8Q
	 EdAjtH6ATBq+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Throw <zakkabj@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek: Add quirk for Samsung Book2 Pro 360 (NP950QED)
Date: Mon,  6 Apr 2026 07:05:44 -0400
Message-ID: <20260406110553.3783076-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ea31be8a2c8c99eac198f3b7f2dc770111f2b182 ]

There is another Book2 Pro model (NP950QED) that seems equipped with
the same speaker module as the non-360 model, which requires
ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS quirk.

Reported-by: Throw <zakkabj@gmail.com>
Link: https://patch.msgid.link/20260330162249.147665-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Record: [ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS was introduced in v6.12-rc1
cycle] [Applicable to stable trees >= 6.12.y] [Note: file was moved from
sound/pci/hda/patch_realtek.c to sound/hda/codecs/realtek/alc269.c —
backport may need path adjustment for older trees]

**Step 6.2:** The quirk table structure is stable. Adding a single entry
should apply cleanly or with trivial context adjustment to any tree that
has the `ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS` enum and fixup definition.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: ALSA/HDA (sound subsystem) — IMPORTANT level, affects
  laptop users
- Author: Takashi Iwai — THE ALSA subsystem maintainer
- Quirk table additions are routine and very common in stable
Record: [ALSA/HDA] [IMPORTANT] [Authored by subsystem maintainer]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected: Users of Samsung Galaxy Book2 Pro 360 (NP950QED)
specifically.

**Step 8.2:** Trigger: Every boot on this hardware — speakers don't work
correctly without the quirk.

**Step 8.3:** Failure mode: Audio output broken/incorrect on specific
laptop. Severity: MEDIUM-HIGH (hardware doesn't function as expected,
but not a crash).

**Step 8.4:**
- BENEFIT: High — makes speakers work correctly on a popular Samsung
  laptop
- RISK: Near-zero — single line in quirk table, only matches one PCI
  subsystem ID, cannot affect any other hardware
Record: [High benefit, near-zero risk]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**
FOR backporting:
- Hardware quirk addition — explicitly allowed exception category
- Single line addition (+1 line), zero regression risk
- Only affects one specific hardware model
- User-reported issue (Reported-by tag)
- Authored by ALSA subsystem maintainer (Takashi Iwai)
- Same quirk already used by sibling Samsung models (NP950XED, NP950XEE)
- Fixes real hardware functionality (speakers)

AGAINST backporting:
- None identified

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? YES — same quirk as identical hardware siblings
2. Fixes real bug? YES — speakers don't work without it
3. Important issue? YES — hardware doesn't function
4. Small and contained? YES — 1 line
5. No new features/APIs? CORRECT — no new features
6. Applies to stable? YES — clean apply for trees with the fixup enum
   (6.12+)

**Step 9.3: Exception Category**
This is a **hardware quirk/workaround** — one of the explicitly listed
exception categories that are automatically YES for stable.

## Verification

- [Phase 1] Parsed tags: Reported-by from user, Link to patch
  submission, SOB from Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff: +1 line SND_PCI_QUIRK entry in alc269_fixup_tbl[] for
  PCI ID 0x144d:0xc1ac
- [Phase 3] Grep confirmed ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS used by 2
  sibling Samsung models (lines 7390-7391)
- [Phase 3] git log -S confirmed the fixup enum was introduced in commit
  7e4d4b32ab953 (v6.12-rc1 cycle)
- [Phase 3] Takashi Iwai confirmed as ALSA maintainer via git log
- [Phase 5] Data-only change to static quirk table, no logic changes
- [Phase 6] Fixup exists in 6.12+ trees; file path changed in recent
  kernels (may need adjustment for older trees)
- [Phase 8] Impact: speakers non-functional on specific Samsung laptop
  without this quirk; risk: near-zero

This is a textbook stable backport candidate: a single-line hardware
quirk addition by the subsystem maintainer, fixing real audio hardware
for a specific laptop model, with zero regression risk.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 19f23c92fdcdb..1e10af67fdb04 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7376,6 +7376,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc188, "Samsung Galaxy Book Flex (NT950QCT-A38A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1ac, "Samsung Galaxy Book2 Pro 360 (NP950QED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.53.0

