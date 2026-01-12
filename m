Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B162D8375;
	Mon, 12 Jan 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229960; cv=none; b=tIS1JUbHf8zCpc+YjFZANEORXJO7OxHUdodWxxrfhg+ArcpVwmw8MMaBBKqz5fY/Me22cRcMG1u9PsQk2SpisqIqAYm4yRYRt4iAWHvDHp8ztKGNO+VMARvHGxyTecflMtlzzH5HSCOhqzwMnpVE9/+5VIOmb34Ao1TNizm9HRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229960; c=relaxed/simple;
	bh=qfnVeAP+2teYA0lF85IxNyRRcQKU/0KkYpsbjWBYG88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kza7hg/9rX6hwTeUf3pj7JXrMyAJoPEQo5RcGvDpJvBSNotgTVFPrlpx6rb5lxpew8BzZsYFQriuFVZBzwywOx3ceOZgJne81z4vAkHuea9azCtQyNvenQdGOE0NE0S4Ap2bbGLKVMFYW7yh+iR4kaxQQVUBjlKDt53tuWqPkTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ic0TOjWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ic0TOjWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563A6C19423;
	Mon, 12 Jan 2026 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229960;
	bh=qfnVeAP+2teYA0lF85IxNyRRcQKU/0KkYpsbjWBYG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ic0TOjWhJjdV/cCmFMT8ovvigb0q7bdVeK8BiMkBUhOimBmzH/jHxxs5TCpkRf+is
	 YOp78oUT/EkW7ccYqM8irBt9JbsUJXv1Fxym4x3w28+DkfWYY0I/R+DJ01gKiayaCG
	 yYGQfjmuvVo+Fft0RZZc7DcpDECw6V6q/X/LSLvqD9/kmX2uiJyZ5XU2a1+1uLaV6V
	 RDrdDDvhLsqUyc6QzmNnHFYm7Q0MY9gUv1kjIRizD3dDBw24OjiaTL6gwAsUfdFvDx
	 +mPgFq0p3dkgso8g+rpy5Ni13PgnaqPmm50r6U+CmC48pZfmOsd4CRomxefbOvykal
	 G66Lw/5c2uUdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Matou=C5=A1=20L=C3=A1nsk=C3=BD?= <matouslansky@post.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55
Date: Mon, 12 Jan 2026 09:58:23 -0500
Message-ID: <20260112145840.724774-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Matouš Lánský <matouslansky@post.cz>

[ Upstream commit 9be25402d8522e16e5ebe84f2b1b6c5de082a388 ]

Add headset mic quirk for Acer Nitro AN517-55. This laptop uses
the same audio configuration as the AN515-58 model.

Signed-off-by: Matouš Lánský <matouslansky@post.cz>
Link: https://patch.msgid.link/20251231171207.76943-1-matouslansky@post.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55

### 1. COMMIT MESSAGE ANALYSIS

The commit adds a headset mic quirk for the Acer Nitro AN517-55 laptop.
The message clearly states this laptop uses the same audio configuration
as the AN515-58 model, which already has a quirk entry. The commit has
proper sign-offs from the submitter and the ALSA maintainer (Takashi
Iwai).

### 2. CODE CHANGE ANALYSIS

The change is a **single line addition** to the quirk table in
`sound/hda/codecs/realtek/alc269.c`:

```c
SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55",
ALC2XX_FIXUP_HEADSET_MIC),
```

Breaking this down:
- `0x1025` - Acer's PCI vendor ID
- `0x1597` - Subsystem ID for the AN517-55 model
- `ALC2XX_FIXUP_HEADSET_MIC` - The fixup to enable headset microphone
  support

Looking at the context, the line immediately above is:
```c
SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58",
ALC2XX_FIXUP_HEADSET_MIC),
```

This confirms the AN517-55 uses the identical fixup as the AN515-58,
which is already proven to work.

### 3. CLASSIFICATION

This is a **HARDWARE QUIRK** - one of the explicitly allowed exceptions
for stable backports. It:
- Adds a PCI subsystem ID to an existing quirk table
- Uses an already-established fixup mechanism
- Does NOT add any new code logic or features

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1
- **Files touched:** 1
- **Complexity:** Trivial - table entry addition
- **Risk:** **Essentially zero** - This quirk entry ONLY affects devices
  with the exact PCI subsystem ID 0x1025:0x1597. It cannot possibly
  impact any other hardware.

### 5. USER IMPACT

- **Problem:** Headset microphone doesn't work on Acer Nitro AN517-55
  laptops without this quirk
- **Users affected:** Anyone with this specific laptop model who wants
  to use a headset with microphone
- **Severity:** This is a genuine hardware functionality bug - the mic
  input doesn't work without the quirk
- **Real-world impact:** Affects video calls, gaming chat, voice
  recording, etc.

### 6. STABILITY INDICATORS

- Signed off by Takashi Iwai (the ALSA maintainer)
- The `ALC2XX_FIXUP_HEADSET_MIC` fixup is well-established and used by
  many similar Acer models
- Pattern is identical to hundreds of other quirk entries in this file

### 7. DEPENDENCY CHECK

- **No dependencies** - the fixup being referenced already exists in
  stable kernels
- Will apply cleanly to any kernel with the HDA Realtek codec driver
- The quirk infrastructure has been stable for many years

## Conclusion

This is a **textbook stable backport candidate**:

1. **Fixes a real bug:** Headset mic doesn't work without it
2. **Obviously correct:** Identical to existing entry for similar
   hardware
3. **Small and contained:** Single line addition to a quirk table
4. **No new features:** Enables existing functionality for a new device
   ID
5. **Zero regression risk:** Only affects this specific laptop model
6. **Explicitly allowed:** Hardware quirks are called out as stable-
   appropriate in the rules

The stable kernel rules explicitly permit hardware quirks because they
fix real issues for specific hardware with essentially zero risk to
other systems. Users of this laptop on stable kernels would otherwise
have non-functional headset mic support until they upgrade to a newer
kernel.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b3582e390dfa3..705d6acc204cf 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6239,6 +6239,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.51.0

