Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00AA3019CB;
	Mon,  9 Feb 2026 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640042; cv=none; b=aJmLl9SPWNgrgeXD3Lll/DVS6jImqABYkv8BLYiSh5J9qRuxGAangN3rWh8rDI1RKtRTqycYGDOamcPUxFefStU8JPGE4VhmBXr/TU00BG4PJWqLWI3sctZ4C8H92FPoSbL4KXMzo6T54ZjCa8qyn328iZKIyB9RWDx5z67P61M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640042; c=relaxed/simple;
	bh=M3B2pZjyCkXe641TaQ0o94DpnZZS/K++m7V7Zkyr98w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b3cteqnJ9zb0w0ASCNKMVNcsH/7RiX51sWnQ93dD7IaR0cvkZyDCX+dz2u5CiZNurIC5Z4/dQJcAP9MVn/LhDKqhCpPLYPNMxcT3hBjnVmALmOg7xtTNS2GcWPbfNHF6wQfxC/UyhHmc+Kxt8ogE+JVzMqkO5VD9nKF4MZyi7XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CdiORnV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdiORnV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90963C16AAE;
	Mon,  9 Feb 2026 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640042;
	bh=M3B2pZjyCkXe641TaQ0o94DpnZZS/K++m7V7Zkyr98w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdiORnV76WfPl6HVPcO1ZOr2DsoQD2tqOqw+oY07eRaPryjx4X9jtusq/2DgYPT23
	 flRWIru/Ro7LmD7UK3M6mEgzhpUFb3jKFVc3xXez63joh1py9oKJ3NlQwu2QsI9yzh
	 XQu6ZoPEah6fa7uH05IbRi0VtVa5V6V0M81iwHzZSjY+MLXCgKlUM5jEDmIqy1GLrG
	 hnFIahfAVj6mk0O5pSzbQbfyfTfqotWOF50z7YxZ95UCQvVmlf1nUNjDeN2C2VnIq3
	 OtLr2UFnvVXMlV3oQsg5964k+Xrz5u6vTXUp9NPBwNHm3iPp59ptd2iCy9430177Em
	 DFf20yeLFYlOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Baptista <brenomb07@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Enable headset mic for Acer Nitro 5
Date: Mon,  9 Feb 2026 07:26:42 -0500
Message-ID: <20260209122714.1037915-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Baptista <brenomb07@gmail.com>

[ Upstream commit 51db05283f7c9c95a3e6853a3044cd04226551bf ]

Add quirk to support microphone input through headphone jack on Acer Nitro 5 AN515-57 (ALC295).

Signed-off-by: Breno Baptista <brenomb07@gmail.com>
Link: https://patch.msgid.link/20260205024341.26694-1-brenomb07@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: ALSA: hda/realtek: Enable headset mic for Acer Nitro 5

### Commit Message Analysis

This commit adds a hardware quirk entry (`SND_PCI_QUIRK`) for the Acer
Nitro 5 AN515-57 laptop to enable headset microphone input through the
headphone jack. The codec is ALC295, and the fixup applied is
`ALC2XX_FIXUP_HEADSET_MIC`.

### Code Change Analysis

The change is a **single line addition** in the `alc269_fixup_tbl[]`
quirk table:

```c
SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57",
ALC2XX_FIXUP_HEADSET_MIC),
```

- **Vendor ID 0x1025** = Acer
- **Subsystem ID 0x1539** = Acer Nitro 5 AN515-57
- **Fixup: ALC2XX_FIXUP_HEADSET_MIC** = an existing, well-tested fixup
  already used by similar Acer Nitro models

The entry is inserted in the correct sorted position (between 0x1534 and
0x159c), and notably, the adjacent entries for Acer Nitro 5 AN515-58
(0x159c) and AN517-55 (0x1597) already use the exact same
`ALC2XX_FIXUP_HEADSET_MIC` fixup. This is simply extending an existing
working quirk to another model in the same product family.

### Classification

This is a **hardware quirk addition** — one of the explicitly allowed
exception categories for stable backports. It:

1. Fixes a real user-facing problem: the headset microphone doesn't work
   without this quirk on the Acer Nitro 5 AN515-57
2. Uses an existing, proven fixup mechanism (`ALC2XX_FIXUP_HEADSET_MIC`)
3. Only affects the specific hardware identified by the PCI subsystem ID
4. Has zero risk of regression for any other hardware

### Scope and Risk Assessment

- **Lines changed**: 1 (addition only)
- **Files changed**: 1
- **Risk**: Essentially zero — the quirk is matched by PCI
  vendor/subsystem ID and only applies to the specific Acer laptop model
- **Subsystem maturity**: The HDA Realtek quirk table is one of the most
  stable and well-understood mechanisms in the kernel; hundreds of
  similar entries exist

### User Impact

Without this quirk, users of the Acer Nitro 5 AN515-57 cannot use the
headset microphone through the headphone jack. This is a common laptop
(gaming line) and headset mic support is essential for many users
(calls, gaming, etc.). The commit was submitted by an end user (Breno
Baptista) who presumably experienced the problem.

### Stability Indicators

- Accepted by Takashi Iwai (ALSA maintainer)
- Follows the exact same pattern as dozens of other quirk entries in the
  same table
- The same fixup (`ALC2XX_FIXUP_HEADSET_MIC`) is already proven on
  sibling models (AN515-58, AN517-55)

### Dependencies

None. This is a self-contained single-line quirk table entry addition.
The `ALC2XX_FIXUP_HEADSET_MIC` fixup and the quirk infrastructure
already exist in all stable trees that support this driver.

### Conclusion

This is a textbook example of a hardware quirk addition that belongs in
stable trees. It's a single-line addition to an existing quirk table,
using an already-proven fixup, fixing a real hardware issue (non-
functional headset mic) on a specific laptop model, with zero risk to
any other hardware or code path.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 9097de7d2e3d7..7604851d53b2f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6238,6 +6238,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.51.0

