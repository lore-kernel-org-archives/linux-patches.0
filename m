Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A391DF246;
	Tue, 28 Oct 2025 00:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611999; cv=none; b=cVYD+q9faAsIcQEhuWFXwUW/mT7PFu78MJSij3sH2R/lzRLjrrZuUtlxD+e/NBKbB+a/c4qGh5gYM5FReyR6wZw5H2xj70myg37sR8xc74RJTdYL6Ny+eakDIC63RMFgCbTmkxzHJGQgtdZhA2dMCs65lbWQuIt/2uwwhM5nhEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611999; c=relaxed/simple;
	bh=ecpcfMoltN5WFdrm+xz2KcNrUUHhCYslMSIvVtT3aSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iuI9qeSscTMHdjvCAfH6qYKfvlcc+c4lvp0biNSf24OC8eQEOZS2M3tGpZ4tCyu2vZ67gdMS4QimxRJ0fH5jQ8QjdCYDG5qo7/zaz2df5EO224uLUIvws8f2nIXSkOD1XbX1U3kdloiucxTHEzWE6nEwBsRuzsteCSMWGB65GjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn81EJoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn81EJoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B68C4CEF1;
	Tue, 28 Oct 2025 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761611998;
	bh=ecpcfMoltN5WFdrm+xz2KcNrUUHhCYslMSIvVtT3aSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hn81EJoP0ZfhujJtxh41xZBTMUPoaFVamnv3uOQr1xifs5Q3EOd/mtXsYhvbxlqHK
	 nHKq/wqpE5SIUQZr6ABeAZHXPg1vTqXhXCoJuVOuMTO90Ib7iUrLniqLRi2SomBV3t
	 FdbYVbs9o+9iPwLlJYQMs09KVS/C3DCUk4whnzNlvLtSSY6V2Iiy3F5vj2U0KQG/hl
	 VIqtg/bMpiU4dcyeErn2P0SCII4QSStE3fHvqbPvHK6RaQey/PaKbLzLsuuF4Fi580
	 wkvAahDwmoeTzJxOH+6/PHv49YnIEhew5Xg+hIaV3ketpeOgDOBFlwFymckgp++NTA
	 cyZZsNx1hFoAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dawn Gardner <dawn.auroali@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.17] ALSA: hda/realtek: Fix mute led for HP Omen 17-cb0xxx
Date: Mon, 27 Oct 2025 20:38:51 -0400
Message-ID: <20251028003940.884625-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dawn Gardner <dawn.auroali@gmail.com>

[ Upstream commit 2a786348004b34c5f61235d51c40c1c718b1f8f9 ]

This laptop uses the ALC285 codec, fixed by enabling
the ALC285_FIXUP_HP_MUTE_LED quirk

Signed-off-by: Dawn Gardner <dawn.auroali@gmail.com>
Link: https://patch.msgid.link/20251016184218.31508-3-dawn.auroali@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis using semantic code analysis tools
and repository examination, here is my determination:

## **Backport Status: YES**

### Detailed Analysis:

#### 1. **Semantic Code Analysis Performed**

**Tools Used:**
- `mcp__semcode__find_function`: Located `alc285_fixup_hp_mute_led`
  (sound/hda/codecs/realtek/alc269.c:1621-1626)
- `mcp__semcode__find_callers`: Verified no direct function callers
  (called indirectly via HDA fixup framework)
- `Grep`: Analyzed quirk table structure and fixup definitions
- `git log`: Examined commit history and similar patches

**Key Findings:**
- The fixup function `alc285_fixup_hp_mute_led` is a simple wrapper that
  calls:
  - `alc285_fixup_hp_mute_led_coefbit()` - Sets mute LED coefficients
    (idx=0x0b, mask/on=1<<3, off=0)
  - `alc285_fixup_hp_coef_micmute_led()` - Sets micmute LED coefficients
    (idx=0x19, mask/on=1<<13, off=0)
- Both functions only configure hardware-specific parameters during
  `HDA_FIXUP_ACT_PRE_PROBE` action
- No behavioral changes, no new code paths, just hardware initialization

#### 2. **Code Changes Analysis**

**What Changed:**
```c
+       SND_PCI_QUIRK(0x103c, 0x8603, "HP Omen 17-cb0xxx",
ALC285_FIXUP_HP_MUTE_LED),
```

**Specifics:**
- Single line addition to `alc269_fixup_tbl[]` at
  sound/hda/codecs/realtek/alc269.c:6400
- Adds PCI subsystem ID (0x103c, 0x8603) mapping for HP Omen 17-cb0xxx
- Uses existing fixup `ALC285_FIXUP_HP_MUTE_LED` (already defined at
  line 3622)
- Verified PCI ID 0x8603 is unique - no conflicts in codebase

#### 3. **Impact Scope Analysis**

**User Impact:**
- Fixes broken mute LED functionality on HP Omen 17-cb0xxx laptops
- Only affects devices with exact PCI ID match (0x103c, 0x8603)
- Zero impact on other hardware - quirk table entries are device-
  specific

**Dependency Analysis:**
- No new dependencies
- Uses existing, well-tested fixup infrastructure
- No changes to function signatures or data structures

#### 4. **Stable Tree Compliance Evidence**

**Pattern Analysis:**
Found multiple identical commits that were explicitly tagged for stable:

1. **d33c3471047fc** - "Fix mute led for HP Laptop 15-dw4xx" - Tagged
   `Cc: <stable@vger.kernel.org>`
2. **956048a3cd9d2** - "Fix mute LED for HP Victus 16-s0xxx" - Tagged
   `Cc: <stable@vger.kernel.org>`
3. **bd7814a4c0fd8** - "Fix mute LED for HP Victus 16-r1xxx" (implied
   stable)
4. **a9dec0963187d** - "Fix mute LED for HP Victus 16-d1xxx" (implied
   stable)

All follow identical pattern: single-line quirk table addition for HP
laptops.

#### 5. **Risk Assessment**

**Risk Level: MINIMAL**
- ✅ Bug fix (non-functional mute LED)
- ✅ Not a new feature
- ✅ No architectural changes
- ✅ Extremely contained scope (single hardware model)
- ✅ No performance implications
- ✅ No security implications
- ✅ Cannot cause regressions on other hardware
- ✅ Well-established code pattern

**Subsystem:** ALSA HDA - Non-critical, hardware-specific audio driver

#### 6. **Why This Should Be Backported**

1. **Fixes User-Visible Bug**: Mute LED doesn't work on specific laptop
   model
2. **Follows Established Pattern**: Identical commits are routinely
   backported to stable
3. **Zero Regression Risk**: Quirk only applies to exact PCI ID match
4. **Stable Tree Rules Compliant**:
   - Bug fix ✓
   - Small and contained ✓
   - Obvious and correct ✓
   - Tested (implied by author) ✓
5. **Author Note**: Although not explicitly tagged for stable, the
   commit message clearly states "Fix" indicating bug fix intent

### Conclusion

This commit is an ideal candidate for stable tree backporting. It's a
minimal, safe, hardware-specific fix that follows the exact pattern of
dozens of similar commits that have been successfully backported. The
lack of explicit stable tag appears to be an oversight rather than
intentional exclusion.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8fb1a5c6ff6df..0f8170e1194e2 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6390,6 +6390,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
+	SND_PCI_QUIRK(0x103c, 0x8603, "HP Omen 17-cb0xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.51.0

