Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84AB2E265A;
	Mon, 12 Jan 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229948; cv=none; b=olaXPu05BPRYWFp1d78IaHwY1plWlgQFEqBsSxgMQwA+8vAbWHoIoj+8ky3Z/Fg2w40BPFDsL2Hy5xbNcCBB0CWNGiwJ5dtSYXvlMg9menNlqDlE7GMOqMGKZe5TYoHrs7tT5WPupTtFTWFfcSUNC4kc2DNRjDubr1pIsAUSJq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229948; c=relaxed/simple;
	bh=MvHTFuIbV3v7ViyPwDHswrpEdtUaZRkcU1bdSu0XMdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAkT67hBq+GsNnIhkBgDMhXsfArla1Y+tE9i2iOm7M/xNbJVXH9YyThWiGNWy1RHGR+ozNIO3pAXp2r1U+tWM7JTIecGtN5h2LwAo+lk89fwo5p+dmALne2Sbm8iBPmDC4lUiNmURyH/WzXjoXV47tOQAB6ojoO3cZljlZTbSdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eu7OYfZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eu7OYfZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D792C19422;
	Mon, 12 Jan 2026 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229948;
	bh=MvHTFuIbV3v7ViyPwDHswrpEdtUaZRkcU1bdSu0XMdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu7OYfZoCUauno5bJvvaLV/lESboE1sJhHpFz9eFIE8q05NG0h2mf/DL4TH8TKFQh
	 3sGjGBz/JniWHctTKiPLk4OtcAp2iVs5GTLGEcQ/f7pZLqGYwMCuQeen8fMplS27QG
	 BNrjHejSpibU61bVr3ttXvlaJus32+ynd8a5tZQI5WL03wMQBMmEFPuqAn4544sxj6
	 gH1eqH0pB2fPENUrdiDiLgZSWHJ0O4JvCo5NidQuDf1LaovQcxsMZ2YbmWHG8YJ+zC
	 dlWjym/Vlv1YoYo6AAVj+QwfCfBsN1MBEzQYZCtoSgHAsoQIiLf6AAoMPBLf90id+Z
	 O+vFpp9S+wnSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruslan Krupitsa <krupitsarus@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED quirk
Date: Mon, 12 Jan 2026 09:58:16 -0500
Message-ID: <20260112145840.724774-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Ruslan Krupitsa <krupitsarus@outlook.com>

[ Upstream commit 9ed7a28225af02b74f61e7880d460db49db83758 ]

HP Laptop 15s-eq1xxx with ALC236 codec does not enable the
mute LED automatically. This patch adds a quirk entry for
subsystem ID 0x8706 using the ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup, enabling correct mute LED behavior.

Signed-off-by: Ruslan Krupitsa <krupitsarus@outlook.com>
Link: https://patch.msgid.link/AS8P194MB112895B8EC2D87D53A876085BBBAA@AS8P194MB1128.EURP194.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED
quirk

### 1. COMMIT MESSAGE ANALYSIS

The commit adds a hardware quirk for the HP Laptop 15s-eq1xxx with
ALC236 codec. The mute LED does not function correctly without this
quirk entry. The fix uses an existing fixup
(`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`) that is already applied to several
other HP laptops.

Keywords: "quirk" - indicates hardware-specific workaround.

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** to the quirk table:

```c
SND_PCI_QUIRK(0x103c, 0x8706, "HP Laptop 15s-eq1xxx",
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
```

This adds:
- **Vendor ID**: 0x103c (HP)
- **Subsystem ID**: 0x8706 (specific to this laptop model)
- **Fixup**: `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` - an existing, well-
  tested fixup

Looking at the surrounding code, the same fixup is already used by
multiple other HP laptops:
- HP 15-db0403ng (0x84ae)
- HP Laptop 15-da3001TU (0x86c1)
- HP Laptop 14-fq0xxx (0x87b7)

### 3. CLASSIFICATION

This is a **hardware quirk/workaround** - one of the explicit exception
categories that ARE allowed in stable trees:
- It's a hardware-specific quirk for a device that doesn't work
  correctly without it
- The fixup mechanism already exists and is proven on other devices
- This is NOT a new feature - it's enabling existing functionality for a
  specific PCI subsystem ID

### 4. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | 1 |
| Files touched | 1 |
| Complexity | Trivial - table entry only |
| Risk | **Extremely low** |

The change:
- Only affects systems with the exact subsystem ID 0x8706
- Uses a pre-existing, battle-tested fixup
- Cannot break any other systems
- Follows an established, well-understood pattern

### 5. USER IMPACT

**Affected users**: Owners of HP Laptop 15s-eq1xxx
**Bug severity**: User-visible functionality issue (mute LED doesn't
work)
**Impact without fix**: The mute LED doesn't indicate mute state, which
is a usability problem

While not a crash or data corruption issue, non-working hardware
indicators are legitimate bugs that affect real users.

### 6. STABILITY INDICATORS

- Signed off by Takashi Iwai (ALSA subsystem maintainer)
- Uses an identical pattern to dozens of existing quirk entries
- The `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` fixup has been in the kernel
  and used by other devices for years

### 7. DEPENDENCY CHECK

- **No dependencies** on other commits
- The quirk table (`alc269_fixup_tbl[]`) exists in all stable kernels
- The `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` fixup enum value exists in
  stable kernels
- This patch will apply cleanly to any stable tree that has this file

### CONCLUSION

This commit is a textbook example of what should be backported to
stable:

1. **Hardware quirk addition** - explicitly allowed under stable rules
2. **Single line change** - minimal code, minimal risk
3. **Uses existing infrastructure** - no new code paths, just a table
   entry
4. **Precisely scoped** - only affects one specific hardware model
   (subsystem ID match)
5. **Cannot cause regressions** - doesn't touch any code paths for other
   devices
6. **Fixes real user-visible issue** - mute LED not working
7. **Well-established pattern** - this exact type of change is routinely
   backported

The fix is small, surgical, and meets all stable kernel criteria for
hardware quirk additions.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 705d6acc204cf..16c2314839c38 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6427,6 +6427,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8706, "HP Laptop 15s-eq1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8720, "HP EliteBook x360 1040 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
-- 
2.51.0

