Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FDA3AE18D;
	Tue, 17 Mar 2026 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747183; cv=none; b=sO7o0Qd1zKkDyBhr/KblZkJvwr54hslL6L0RWDmrp1oRCY54n/SLHnBbasQtwRIHYGmPL/a6sPsrxJdi8jwp5qdTEdD18HHH5GSBjaj0vIH4SsXFW3SDdYVzeQh262rd967MqDu4zJpSekVcom/lohJJRGi+Kk9c4lFCDYL8+Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747183; c=relaxed/simple;
	bh=+JM2tjMeVXAO1CS/F5tFHtTKkD1y46T3nIZLDfPO1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQUtvSt6TY8DdkuToPLVFrnnVDEd+imcjaiqVzQyFtdJh0820RvZOeI763O7etGnaQeWw5ue+3EdbrJRf+1faMexqmE/GThMRQrpvd+2MG4q07cTFDBcivGf4Wu45LxSWJOZx3MLpTCHqavEOXhs1BMFK8IARsG752aISHSOaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msVysCTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msVysCTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969FAC2BCB2;
	Tue, 17 Mar 2026 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747183;
	bh=+JM2tjMeVXAO1CS/F5tFHtTKkD1y46T3nIZLDfPO1jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msVysCTcOfNVPHhokB03F3kFkCPY948GP2N4oORtkiU+Rp50MnR7dDFomKc+tzPuu
	 0J13bwAcqmsfaKWR+2VC0ySV/VD/LO2L3VuMAkiLkPG+QUN7HcJrWboQYVEaZQvNHA
	 fuAFpj+7M+a8QYR+Gaye3jxS7GI0Xb97xyCvfDWowhT2L4zVdoO7ZTqAC8NmieJJtr
	 cXsiXgRpBgin2PGWp3MYCbQAO9qbZJtZQtsHrA4vFulazjgc3uU3YHhXPG9x8Vxaau
	 onZQ1dxUrf6OBSGbi+/vP8hDGRJ1SM5E4zv7Vo2kaekzQcERFJRW7osU3v9MWgqVnZ
	 QTAnuMtaLPQBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek: add quirk for ASUS UM6702RC
Date: Tue, 17 Mar 2026 07:32:41 -0400
Message-ID: <20260317113249.117771-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d3429f12133c2ca47aa82ddab2342bc360c47d3 ]

The sound card of this machine cannot adjust the volume, it can only
be 0 or 100%. The reason is that the DAC with pin 0x17 is connected
to 0x06. Testing found that connecting 0x02 can fix this problem.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220356
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260306123317.575346-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have all the information needed for analysis.

## Analysis

### 1. Commit Message Analysis
This commit adds a hardware quirk for the ASUS UM6702RC laptop where
volume control is broken (only 0% or 100%). The root cause is
identified: DAC pin 0x17 is connected to 0x06 (which lacks volume
control), and connecting to 0x02 fixes it. The commit links to
**bugzilla.kernel.org bug #220356**, confirming a real user-reported
issue. Accepted by ALSA maintainer Takashi Iwai.

### 2. Code Change Analysis
The change adds a single line:
```c
HDA_CODEC_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC",
ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1),
```
This is placed before the existing `SND_PCI_QUIRK` entry for the same
device. The `HDA_CODEC_QUIRK` macro matches by **codec SSID** (rather
than PCI SSID), enabling the `ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1`
fixup which:
1. Overrides the connection list for NID 0x17 to route to DAC 0x02
   instead of 0x06 (fixing volume control)
2. Chains to `ALC287_FIXUP_CS35L41_I2C_2` (the existing CS35L41
   amplifier configuration)

### 3. Classification
This is a **hardware quirk addition** — one of the explicitly allowed
exception categories for stable backports. It fixes broken audio volume
control on a specific ASUS laptop model.

### 4. Scope and Risk
- **One line added** — minimal change
- Only affects this specific ASUS UM6702RA/RC hardware
- Zero risk to other hardware — quirks only match specific vendor/device
  IDs
- The fixup function (`alc285_fixup_speaker2_to_dac1`) is well-
  established and used for other devices (Lenovo Carbon X1, ASUS GU605,
  etc.)

### 5. User Impact
Users with ASUS UM6702RC laptops have effectively **non-functional
volume control** — audio is either completely silent or at maximum
volume. This is a significant usability issue that makes the laptop's
audio nearly unusable for normal tasks.

### 6. Dependency Analysis
- **`ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1`**: Present in v6.6+ and
  v6.12+ stable trees ✓
- **`HDA_CODEC_QUIRK` macro**: Introduced in commit `5b1913a79c3e0`
  (v6.13-rc1). **NOT present in v6.12.y or older stable trees**
- **File reorganization**: Code moved from
  `sound/pci/hda/patch_realtek.c` to `sound/hda/codecs/realtek/alc269.c`
  in v6.19+

For **v6.13.y+**: The `HDA_CODEC_QUIRK` infrastructure exists; backport
needs only file path adjustment.
For **v6.12.y and older**: Would need adaptation — either backport the
`HDA_CODEC_QUIRK` infrastructure or use the older codec SSID matching
mechanism. The fixup itself exists but the macro to reference it in the
quirk table does not.

### Verification
- Confirmed `ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1` exists in v6.6
  (`git show v6.6:sound/pci/hda/patch_realtek.c`) and v6.12
- Confirmed `HDA_CODEC_QUIRK` was introduced in commit `5b1913a79c3e0`
  (Oct 2024, v6.13-rc1) via `git tag --contains`
- Confirmed the existing `SND_PCI_QUIRK(0x1043, 0x1ee2, ...)` entry
  exists in v6.12 stable tree
- Confirmed the `alc285_fixup_speaker2_to_dac1` function overrides NID
  0x17 connection to DAC 0x02 (read from current source)
- Confirmed the `ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1` chains to
  `ALC287_FIXUP_CS35L41_I2C_2` (verified in source at line 5006)
- Bug report exists at bugzilla.kernel.org #220356 (linked in commit
  message, not independently fetched)

### Conclusion
This is a textbook stable-worthy hardware quirk. It's a single-line
addition that fixes completely broken volume control on a specific ASUS
laptop, reported by a real user with a bugzilla entry. The fix uses an
existing, well-tested fixup mechanism. The only concern is that
backporting to v6.12.y and older requires adaptation due to the
`HDA_CODEC_QUIRK` infrastructure dependency, but that's a mechanical
concern for the stable maintainers, not a reason to reject the backport.
For v6.13.y+, it's a trivial backport.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f213f8792b01f..1a9973e1e9a84 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7251,6 +7251,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e93, "ASUS ExpertBook B9403CVAR", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1ed3, "ASUS HN7306W", ALC287_FIXUP_CS35L41_I2C_2),
+	HDA_CODEC_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
-- 
2.51.0

