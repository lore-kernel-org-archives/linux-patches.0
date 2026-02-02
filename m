Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4856244186;
	Mon,  2 Feb 2026 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068830; cv=none; b=WJWEIJVr5JRXBSDXCf4LyuJS9y5uU/ps79aIdayJAtKAcVxZ4yFN+c4je1cWQklfS6NWJZMIuXOv5v8Lb6rLggkT4T2GCPYjVEite5bkQomkc3ZCRqvFyOCCWBRURCDSD+sPbSMx8B3Dx280PablWHBI4jRkJfa4HhDR48F5PWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068830; c=relaxed/simple;
	bh=rf76p7P7EQrUbXBDSkkDe2pkCFjhVruNCBUmHdBWNj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV/K/9f3rmw78X1qP1qg7x7aaWLDaXctCLVN4exdRS/zntDA36Wor1iz/VNXijFbJpQ4LnWTztyP7FnMV9iaAUH+cCIle1nFoE1PV3irQzhZaUb1W77uaJ7UdNUDLX2jZO10DE/yY38sc2fEWP5NoKTIEnBKo3fnmmHJtL2zlDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juYS+oBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juYS+oBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B8FC19421;
	Mon,  2 Feb 2026 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068830;
	bh=rf76p7P7EQrUbXBDSkkDe2pkCFjhVruNCBUmHdBWNj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juYS+oBemepquZygEhUW/5rhpD/JZqh3uVV9c0bPLmrlDSthy2DrEjWb+6gqj27/s
	 raAPSjzDuLwbsdNQqEI6evq/6+rRL62h3vEtuTvbW1w/VDBFlnAmDeHa2FixazgGhd
	 MfhT2r1bIj5XtjwJb4ieJBoKFQ1QT5VRHjFruevugVMhcTqZjXzajsXb4gu469dUq0
	 WWCYR1BkfIkqeGmYm4Rd6M9ASTPzEw5H7zEvrGhuz5RIjb/lvXTaNZEcZVKycry4Yy
	 RMIUWK2sbAhoLrb4PCu/4z3Kd6If9Oq2nYXcM6prKBa16WttR0dJYgtNKEg8K0QUZ5
	 8P5pmSOxGxpsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for Inspur S14-G1
Date: Mon,  2 Feb 2026 16:46:06 -0500
Message-ID: <20260202214643.212290-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 9e18920e783d0bcd4c127a7adc66565243ab9655 ]

Inspur S14-G1 is equipped with ALC256.
Enable "power saving mode" and Enable "headset jack mode".

Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260126073508.3897461-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: ALSA: hda/realtek: Add quirk for Inspur S14-G1

### 1. COMMIT MESSAGE ANALYSIS

The commit message is straightforward:
- Subject indicates this adds a quirk for the Inspur S14-G1 laptop
- The device uses an ALC256 codec
- The quirk enables "power saving mode" and "headset jack mode"
- Has proper sign-offs and review chain (Takashi Iwai is the HDA
  subsystem maintainer)

No Fixes: tag or Cc: stable tag is present, which is expected for
commits under review.

### 2. CODE CHANGE ANALYSIS

The change is a single line addition to the `alc269_fixup_tbl[]` quirk
table:

```c
SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1",
ALC295_FIXUP_CHROME_BOOK),
```

This adds a PCI quirk entry with:
- Vendor ID: `0x2039` (Inspur)
- Device ID: `0x0001`
- Description: "Inspur S14-G1"
- Fixup: `ALC295_FIXUP_CHROME_BOOK`

The `ALC295_FIXUP_CHROME_BOOK` fixup is an existing, well-tested fixup
that's already used by other devices in this table (e.g., Intel NUC 13
at line 8086:3038).

### 3. CLASSIFICATION

**This is a HARDWARE QUIRK addition** - one of the explicit exceptions
allowed in stable trees.

This falls under the category of "QUIRKS and WORKAROUNDS" which are
explicitly allowed because:
- The driver (snd-hda-intel with Realtek codec support) already exists
  in stable
- Only a device ID mapping is being added
- The fixup being used (`ALC295_FIXUP_CHROME_BOOK`) already exists and
  is tested
- This enables proper audio functionality on specific hardware

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- 1 line changed
- 1 file touched
- Adds entry to a static quirk table
- No logic changes whatsoever

**Risk: EXTREMELY LOW**
- The quirk table is a simple array of PCI ID to fixup mappings
- This change only affects devices with vendor:device ID `0x2039:0x0001`
- No other hardware can be affected
- The fixup being applied (`ALC295_FIXUP_CHROME_BOOK`) is already proven
  stable

### 5. USER IMPACT

**Who is affected:**
- Users of Inspur S14-G1 laptops (a specific Inspur laptop model)

**Problem without this patch:**
- Headset jack may not work properly
- Power management for audio may not be optimal
- These are real usability issues for affected hardware owners

**Severity:** Moderate - affects audio usability but not a crash or data
corruption

### 6. STABILITY INDICATORS

- Signed off by Takashi Iwai (long-time HDA maintainer at SUSE)
- Follows the standard pattern used by hundreds of other quirk entries
  in this file
- Uses an existing, tested fixup (`ALC295_FIXUP_CHROME_BOOK`)

### 7. DEPENDENCY CHECK

**Dependencies: NONE**
- The `ALC295_FIXUP_CHROME_BOOK` fixup has existed in the kernel for
  years
- The quirk table structure is stable across kernel versions
- This will apply cleanly to any stable tree that has the Realtek HDA
  driver

### Summary

This commit is a textbook example of a stable-appropriate quirk
addition:

1. **Meets stable rules:**
   - Obviously correct (single line addition to quirk table)
   - Fixes a real bug (audio not working properly on specific hardware)
   - Small and contained (1 line)
   - Does NOT add new features (uses existing fixup)

2. **Falls under allowed exceptions:**
   - Hardware quirk/workaround for a specific device
   - Enables proper functionality on hardware that exists in the field

3. **Risk vs Benefit:**
   - Risk: Near zero (only affects one specific device ID)
   - Benefit: Audio functionality for Inspur S14-G1 users

4. **No concerns:**
   - No dependencies
   - Applies cleanly to any kernel with the Realtek HDA driver
   - Standard practice followed by hundreds of similar entries

This is exactly the type of patch that stable trees accept regularly - a
simple hardware quirk that enables device support without any risk to
other systems.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 32cba2c81ccdd..4ab89cb6e55f2 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7239,6 +7239,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.51.0

