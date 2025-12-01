Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77626AC3;
	Mon,  1 Dec 2025 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764553375; cv=none; b=CgCLUt5xGzhxsl6A0DkZZI9rJaxsYFrrzLk00Zts32zV0xB4cKUv7t+UK4wNccGxtKosC2kfcQHG7yVCCq+Cs6cgApW0dcWvrB14P0TxPV1n1AYlhCEpvgvEyJKUU7EP594DMhozkulkI0jJ3s1DczItXpGeVNh78HUkPVOzCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764553375; c=relaxed/simple;
	bh=ATDrXlJ0VyDe0fE9l6dxnABfnxefY8VPojlREwtZWoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RInX1eNUAQg7sFuevRJpgQCWYmbL0b6puIUxoYnvw97kditZaOCqYr3XQwPFyAOgrFO4SV6yjSwxoLP4pd1Mcbc1ZbMXrNx3c9+6JBXM2fZozEmiCDkAdXAQRuxW7l0iLYmZYtKXsF5I5Y4gtF82PorkXiKP0lp4L50m6rcXCd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjoiEi6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjoiEi6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CD8C19421;
	Mon,  1 Dec 2025 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764553375;
	bh=ATDrXlJ0VyDe0fE9l6dxnABfnxefY8VPojlREwtZWoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjoiEi6vNnNhEB4/B23FqKdS9tuREv3nqd2eHSZ3bi9vjkk/sFIg5ImVTbduvXuEK
	 0QYNjD3z/iAxWg+vBPqdd4lowlkmsa2oB4nAzgrLMYhXqZaEqDQkmcPwvzknnNgccB
	 UjRv0rmnBMBeypLZBsz5UzaygBpZD2piiellZfsSebesLQRqQwYmE994/Oh2G95eYd
	 5gAgekk6cvDYGJPhw77oOhPBYGvw/SUo50MZKlcjihwb/Tj3o1u3jMRreMus22294j
	 ioWeQfXVQGhCPficzLCXcju23jcrgPaA3TJCy8ZZGYtzrpg4xJq0yR1AqbuTniv/An
	 tcXaiVHEuLpRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jacob Zhong <cmpute@qq.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.17] ALSA: hda/realtek: add quirk for HP pavilion aero laptop 13z-be200
Date: Sun, 30 Nov 2025 20:42:06 -0500
Message-ID: <20251201014235.104853-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251201014235.104853-1-sashal@kernel.org>
References: <20251201014235.104853-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jacob Zhong <cmpute@qq.com>

[ Upstream commit be4c9abdf04b86bb33f4a2ce59fd7cb64a739c51 ]

The laptop uses ALC287 chip (as shown in /proc/asound/card1/codec#0).
It seems that every HP pavilion laptop in the table uses the same quirk,
so I just copied them. I have verified that the mute LED on my laptop
works with this patch.

For reference, here's the alsa-info of my laptop:
https://alsa-project.org/db/?f=2d5f297087708610bc01816ab12052abdd4a17c0

Signed-off-by: Jacob Zhong <cmpute@qq.com>
Link: https://patch.msgid.link/tencent_E2DFA33EFDF39E0517A94FA8FF06C05C0709@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: ALSA: hda/realtek: add quirk for HP pavilion aero
laptop 13z-be200

### 1. Commit Message Analysis

**Problem:** The mute LED does not function on the HP Pavilion Aero
Laptop 13z-be200 with ALC287 audio codec.

**Solution:** Adds a PCI quirk entry to enable the mute LED using an
existing fixup mechanism.

**Tags:**
- No "Cc: stable@vger.kernel.org" tag
- No "Fixes:" tag
- Signed-off by Takashi Iwai (ALSA/Sound subsystem maintainer at SUSE)
- Author verified the fix works on the actual hardware
- Includes alsa-info diagnostic link for validation

### 2. Code Change Analysis

The change adds a single line to the `alc269_fixup_tbl[]` quirk table:

```c
SND_PCI_QUIRK(0x103c, 0x8bd6, "HP Pavilion Aero Laptop 13z-be200",
ALC287_FIXUP_HP_GPIO_LED),
```

**Scope:**
- 1 line added
- 1 file changed (sound/hda/codecs/realtek/alc269.c)
- Uses existing `ALC287_FIXUP_HP_GPIO_LED` fixup mechanism
- No new code introduced - only a table entry

**Technical Mechanism:**
The `ALC287_FIXUP_HP_GPIO_LED` fixup maps to `alc287_fixup_hp_gpio_led`
which calls `alc_fixup_hp_gpio_led(codec, action, 0x10, 0)` to configure
GPIO for proper mute LED behavior. This is a well-established,
thoroughly tested code path used by many HP laptops.

**Code Context:**
Looking at the diff, the table currently jumps from 0x8bd4 to 0x8bdd,
leaving 0x8bd6 unsupported. The new entry fills this gap. The
surrounding entries show this is a standard pattern - there are hundreds
of similar HP quirk entries (vendor ID 0x103c) in this table, including
other HP Pavilion Aero models like "HP Pavilion Aero Laptop 13-be0xxx"
that use the same fixup.

### 3. Stable Kernel Rules Compliance

This commit falls under **two explicit exception categories** documented
in stable kernel rules:

1. **NEW DEVICE IDs:** Adding PCI IDs to existing drivers - trivial one-
   line additions that enable hardware support
2. **QUIRKS and WORKAROUNDS:** Hardware-specific quirks for broken/buggy
   devices

**Checklist:**
- ✅ Obviously correct: Trivial table entry using existing, proven
  infrastructure
- ✅ Fixes real bug: Mute LED doesn't work without this quirk
- ✅ Small and contained: Single line change
- ✅ No new features: Reuses existing fixup mechanism
- ✅ No new APIs: Data-only change
- ✅ Applies cleanly: Simple table entry addition

### 4. Risk Assessment

**Regression Risk:** Essentially zero
- The quirk is scoped to a specific PCI subsystem vendor/device ID
  (0x103c:0x8bd6)
- Only affects this exact hardware model
- Cannot impact any other systems

**Benefit:** Direct hardware functionality fix
- Users with this laptop get a working mute LED
- Without the fix, the mute LED is non-functional

### 5. User Impact

**Affected Users:** Owners of HP Pavilion Aero 13z-be200 laptops
**Severity:** Medium - broken hardware functionality
**Real-world Impact:** The mute LED provides important user feedback,
particularly for video conferencing scenarios where knowing microphone
state is critical

### 6. Historical Context

This follows an extremely well-established pattern:
- The Realtek HDA driver contains hundreds of similar quirk entries
- Similar HP Pavilion Aero quirk additions have been made for other
  model variants
- This type of quirk addition is routinely accepted for stable trees

### Conclusion

This is a textbook example of a hardware quirk addition that is
explicitly allowed by stable kernel rules. It:
- Fixes real, user-facing hardware functionality (mute LED)
- Is trivial (one line)
- Uses existing, well-tested infrastructure
- Has zero risk of affecting other hardware
- Has been verified by the hardware owner
- Was accepted by the sound subsystem maintainer

Even without an explicit "Cc: stable@vger.kernel.org" tag, device ID and
quirk additions are routinely backported because they fix real user-
facing hardware issues with essentially zero regression risk. The
risk/benefit ratio overwhelmingly favors inclusion in stable trees.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2126e022848e..b651290ca8b4 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6564,6 +6564,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bd4, "HP Victus 16-s0xxx (MB 8BD4)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8bd6, "HP Pavilion Aero Laptop 13z-be200", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bdf, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.51.0

