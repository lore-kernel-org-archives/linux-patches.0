Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A201C84BD;
	Mon,  2 Feb 2026 21:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068810; cv=none; b=RgBNidGOrkw4REkXjg9xfNZ7Xzw6uz8yHxN3SccilJkxNrg4l3Toj+pDscfy76XHatas60kx3ig1hef9jq6qFGrkGtWR6nxxpq71FMmN8MUpomfALjDwMzQqJkyuqBoPzxIozF+p3OwLXbL+6Kl4FE9LS2WrTrp6DEA1Xe+/4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068810; c=relaxed/simple;
	bh=M+86yXXtwc6Wdmj+Dht6yANTQh5BXKZtJY6Y7N4/HYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntHextbgrZXpuBmJMdPkHMoQm+swas/bulqvOQA7hcHvYOuDZGwOxZK23ZxFTdtwnbGaBQwadX5Cswc8Ls/2c59ele1LLxTvBm0Tt5QkVphFtehq/oGEVL2LXGL4OYlCLZz/y/mEHyvZ3p9XhwsYucmDLolFTMDAjLJEZ7CW6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtweiGnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtweiGnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEBDC19421;
	Mon,  2 Feb 2026 21:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068810;
	bh=M+86yXXtwc6Wdmj+Dht6yANTQh5BXKZtJY6Y7N4/HYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtweiGnZcOlN+3Gk5BhiWqEljo7502Ycn91MUdbiekK6N4oa5YGfHjQLRXYql5vZQ
	 hlp46n2cqn2E6FrmYipNyHRdire6Rjv4ESNIhpqD/vpK8mJ864AFEkpqyfrdi/el3I
	 8W7fNepmp7CXXWyzld5J1OJD4UFPWtX3i2X7YA3duA6KM746cGFv/Bxa4VaX/JbLFo
	 ZgQmHCWo7XHzis3FJ9ZQGrQRTCsbXFwfev/Jgnka8rRdQMLiocLNBP396l0dDde5+O
	 GcIxaAafGxyCRLnlyHK7pG7+wRo+9nHs2pFEh+6ddLRirjhf5LL4XjfDQTqkOBl7Fh
	 5ui75sYqtxMwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Mon,  2 Feb 2026 16:45:57 -0500
Message-ID: <20260202214643.212290-2-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

[ Upstream commit b48fe9af1e60360baf09ca6b7a3cd6541f16e611 ]

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260119151626.35481-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `ALC274_FIXUP_HP_HEADSET_MIC` fixup was added in October 2020, so it
exists in all currently maintained stable trees (6.1.y, 6.6.y, 6.12.y,
etc.). The new quirk entry will apply cleanly.

### 8. SIMILAR COMMITS PATTERN

This follows the exact same pattern as countless other HDA pin quirk
additions that are routinely backported to stable. The HDA realtek
driver has hundreds of similar entries in this table, all following the
same format.

---

## Summary

**What problem it solves:** Fixes non-functional headset microphone on
TongFang X6AR55xU laptops by adding a pin quirk entry that applies an
existing, proven fixup.

**Meets stable kernel rules:**
- ✅ Obviously correct - simple table entry addition following
  established pattern
- ✅ Fixes a real bug - hardware doesn't work without it
- ✅ Small and contained - 4 lines, 1 file, no logic changes
- ✅ No new features - uses existing `ALC274_FIXUP_HP_HEADSET_MIC` fixup
- ✅ Falls under "hardware quirks/workarounds" exception

**Risk vs Benefit:**
- **Risk:** Essentially zero - only affects specific hardware, cannot
  impact other devices
- **Benefit:** High for affected users - enables basic audio
  functionality

**Concerns:** None. The fixup already exists in stable trees since 2020.
The change applies cleanly with no dependencies.

This is a textbook example of a backport-worthy commit: a minimal
hardware quirk that fixes a real user-facing issue with zero risk to
other systems.

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fedbc5afc4067..57bad9884158c 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7676,6 +7676,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},
-- 
2.51.0

