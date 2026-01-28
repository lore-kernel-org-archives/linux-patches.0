Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D5C34320A;
	Wed, 28 Jan 2026 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639615; cv=none; b=lB9aOyfrqsNHro4F3kKg6Si35/3hktM1ue7l5Hm6rMpyys2H04Jz1k+mJ0OSnXjVaJraNr9h9u5/N1khFMiUp8F4J82qMNq6OKVNUsho37UgGWWQSS2AGz3bCcQNdpUP3VP4Lgr5aJG6K/izHdb6ryWbm59RfMsqKPZgZKWWS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639615; c=relaxed/simple;
	bh=SxiNVeutUJnMn/FhT8q4x184T0tOPDLPqI9mPIgaTlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C9jGKPvcJxlIyOiAwgeVlzBwvlRUk0u8bOp3Uj3tgLmOi9HZCzMGqnKriVvxv3bU9eNLDdtSfJHgYfcdk59KR4VpKhrBG5cuqgnYvANFv2QkNHRxvqP4G/k4Q1jpwjT9VsWwefYqSae+s0aYjCcyIB3d/RTJpN/h+ANMmuqohVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np86+uKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np86+uKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11700C4CEF1;
	Wed, 28 Jan 2026 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769639615;
	bh=SxiNVeutUJnMn/FhT8q4x184T0tOPDLPqI9mPIgaTlo=;
	h=From:To:Cc:Subject:Date:From;
	b=np86+uKI+zP7JQOP31JzxwVMgki5FKDcJTbk4k4XI2f7NCvrXgpyAFHhTHWMESnSc
	 YRwNo+HAwaxehIoBIprym7FWI2dtD4QOThCJSPPO5PPcmz6rL2dDX8joX8YxdmwUJm
	 WPCQuOlZnnFMqXlZd0R39f1nb64Q3iCKEK2zLZ0waBQlplkvZN5MV6HWYuMpi2mMbQ
	 U4R3StJ0n0alO3cHrglRJi5TUIvfhB6nxEjklT/TcKXm6TBc8MPcJYDVPBKhw6D8ro
	 GckmmtT2Cy8rvnQwjx40rDlWUa9ynA/OwGl0Aljk3xy331f97ZALjJ3rU3dzj96tEK
	 u1rhcS43+FF0Q==
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
Date: Wed, 28 Jan 2026 17:32:59 -0500
Message-ID: <20260128223332.2806589-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.7
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
index b5aa8da1e50a8..c6dc44f5d3ab7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7675,6 +7675,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
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

