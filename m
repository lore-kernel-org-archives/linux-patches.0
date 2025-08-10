Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3599B2033A;
	Sun, 10 Aug 2025 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844729; cv=none; b=kuQNGrYBbznGHMLt/8bagqZwmDu4vPvLj4g8hbGYTvRSnxuf/qMUosZm0SC3Mhu3k/1WD54voNeQU787x23nRv2ETxUZKvjwzbHAdGNKLv6nVDacLARVGnxB5DKqtPsNtZb0BDb7n6jg08KgnQWhwfx/gvAqVp18ewflW6OTZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844729; c=relaxed/simple;
	bh=L9KPac7qbj01D8Q0OrvieImoMBmqsEqasmSOnMt/ceg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DPennFBlp68DjhE2QibyHv6jPdrfycdWnlMc93iALpp4VkiPNcsBCkTGwMWvVGkqDErCOKzLyd7E4mKbE9kgRbhPJTtoc6NHSbj4cHbRwR9swUt/qwZUdpm5k/Civ5PBFLRzY8VD7MxLgaCuNahg4zGFc5wxsLxyXjdLVd2USF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJDc2mS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJDc2mS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF72C4CEEB;
	Sun, 10 Aug 2025 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844728;
	bh=L9KPac7qbj01D8Q0OrvieImoMBmqsEqasmSOnMt/ceg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJDc2mS120vsD1DTueG9POrJt/7pwy10AIq2Ubm5egYCGHtB4LkpHGYQ96SeM57Ej
	 TScJXszyxkq3ghB3SN/v7bOp/At4aTWRvnaPPP5bZNyYWmd4apWJY/r11dlvcX9/zu
	 FezTzvmOM0M8n4zfTupO3trGS7KD2cN8PHzl8Izu/e405ss8xbaOYQH0hlZUz2MsYv
	 FbIdUpft6Lp1y85f7aGIcG3xD/mILPjy7aHKr45Fzec17Cnj0vewB7ogl78/2oFPX1
	 +iucwVyo1bUQsmxmgUBlJWsJKr/+mMg299BrIXCkXGaoHweS4cn5q6sGfmy3hNrZOa
	 YM6Ir4yu2JOSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Croft <thomasmcft@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.16-6.12] ALSA: hda/realtek: add LG gram 16Z90R-A to alc269 fixup table
Date: Sun, 10 Aug 2025 12:51:45 -0400
Message-Id: <20250810165158.1888206-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Thomas Croft <thomasmcft@gmail.com>

[ Upstream commit dbe05428c4e54068a86e7e02405f3b30b1d2b3dd ]

Several months ago, Joshua Grisham submitted a patch [1]
for several ALC298 based sound cards.

The entry for the LG gram 16 in the alc269_fixup_tbl only matches the
Subsystem ID for the 16Z90R-Q and 16Z90R-K models [2]. My 16Z90R-A has a
different Subsystem ID [3]. I'm not sure why these IDs differ, but I
speculate it's due to the NVIDIA GPU included in the 16Z90R-A model that
isn't present in the other models.

I applied the patch to the latest Arch Linux kernel and the card was
initialized as expected.

[1]: https://lore.kernel.org/linux-sound/20240909193000.838815-1-josh@joshuagrisham.com/
[2]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0488
[3]: https://linux-hardware.org/?id=pci:8086-51ca-1854-0489

Signed-off-by: Thomas Croft <thomasmcft@gmail.com>
Link: https://patch.msgid.link/20250804151457.134761-2-thomasmcft@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a strong candidate for backporting to stable kernel trees
for the following reasons:

## Analysis of the Commit

### 1. **Bug Fix Nature**
This commit fixes a hardware enablement issue where the LG gram 16Z90R-A
laptop's audio hardware was not properly initialized. The existing quirk
table entry only covered subsystem IDs 0x0488 (for 16Z90R-Q and 16Z90R-K
models) but missed ID 0x0489 (for the 16Z90R-A model with NVIDIA GPU).

### 2. **Minimal and Contained Change**
The change is extremely minimal - it adds exactly **one line** to the
quirk table:
```c
SND_PCI_QUIRK(0x1854, 0x0489, "LG gram 16 (16Z90R-A)",
ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
```

### 3. **Low Risk of Regression**
- The change only affects devices with the specific PCI subsystem ID
  (0x1854:0x0489)
- It reuses an existing, proven fixup
  (`ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS`) that's already used for similar
  LG gram models
- The fixup function `alc298_fixup_samsung_amp_v2_4_amps` initializes
  speaker amplifiers, which is critical for proper audio output
- No architectural changes or new features are introduced

### 4. **User Impact**
Without this fix, users of the LG gram 16Z90R-A laptop experience:
- Non-functional or improperly initialized audio hardware
- Potential inability to use speakers or headphones correctly
- Poor user experience requiring manual workarounds

### 5. **Proven Solution**
- The commit message indicates the patch was tested on Arch Linux kernel
- The fixup is identical to what's used for other 16Z90R variants
  (0x0488) and 17ZD90R (0x048a)
- The Samsung amp v2 with 4 amplifiers initialization is a known working
  solution for this hardware family

### 6. **Hardware Enablement**
This is a classic hardware enablement fix that allows existing kernel
functionality to work with a specific hardware variant. Such fixes are
routinely backported to stable kernels to ensure hardware compatibility.

The commit follows stable kernel criteria perfectly: it's a small,
targeted fix for a real hardware issue that affects users, with minimal
risk of introducing regressions since it only activates for one specific
hardware ID.

 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2627e2f49316..8544fbd816fc 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11398,6 +11398,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0488, "LG gram 16 (16Z90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1854, 0x0489, "LG gram 16 (16Z90R-A)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1854, 0x048a, "LG gram 17 (17ZD90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5

