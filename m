Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30E22F83B0;
	Mon, 15 Dec 2025 00:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759309; cv=none; b=Ytr7688yc94JFyASxQBN83TkLlvIcTxm8aISTttKU5Rn2+/f8RVB6mHLQ/SSfE56bi7ArbZ+1CQhjJwDCTRQU8F966lhaHPzg70NsE4NvESk5nIk7jiz77Xixj5R5X/XykgM+U/o0R4PgU3Vkur0MfcbU7HYfSCQMThLq6xs/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759309; c=relaxed/simple;
	bh=bZpoNcqV+EuYPAa9lowON2hHYQ4jAVfPjQilz2Ki4ao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILNe2EHjEBpi2jS3UcVSPPF0Cxjaq2sD7gdf2uft80YhydzL4Aa/i3vtyMKJbKCv8ZyRmnNwbSz0EZ65YDDMFhB9SmHE18dTiz6okhzgi/YjU/wrngz3YBzjiYEhvGPfNIVgyO2OIpKZqR4PRdicsUWmHUBXvJeSe3AXeP1Y1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pm6Hcbjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm6Hcbjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D0FC4CEFB;
	Mon, 15 Dec 2025 00:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759308;
	bh=bZpoNcqV+EuYPAa9lowON2hHYQ4jAVfPjQilz2Ki4ao=;
	h=From:To:Cc:Subject:Date:From;
	b=pm6HcbjtzWJdPcZ+jsQvrrS4F6MTbsp1o9xBS6FqSQ6Gyc3XZKXshF7vQO2w/KdNQ
	 o0d2ij0L1cMfbUlsrieOR4ScjCJK6lsAl1uIaKUrPJiSjC85WaV3T1yDwnN/odQ4I0
	 T1LU6MFeMq57xs1FBwLJbmZ7aCNCnycJ2TXAKgcTg83sDOCKcHK9+nGn5q+wJ49MEm
	 +gXHPZ8GGagwSdFUWcZWNLpXCTNRqmn6VtjwP8udsX8kO1FtRb9VRA9uSV9Bl7xAvA
	 YlIJA9GTzga5DAOyiVI8sre1GvHi5RLwOa2X4zaUCAkwKT7A04Yh9eGaYuH1VPbQQN
	 Q8swDmC871wMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.17] ALSA: hda/realtek: Add support for ASUS UM3406GA
Date: Sun, 14 Dec 2025 19:41:18 -0500
Message-ID: <20251215004145.2760442-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 826c0b1ed09e5335abcae07292440ce72346e578 ]

Laptops use 2 CS35L41 Amps with HDA, using External boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20251205150614.49590-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: ALSA: hda/realtek: Add support for ASUS UM3406GA

### 1. COMMIT MESSAGE ANALYSIS

The commit message is straightforward: it adds support for a specific
ASUS laptop model (UM3406GA) that uses 2 CS35L41 amplifiers connected
via I2C with external boost. The message describes the hardware
configuration, which is standard for such device ID additions.

No Fixes: or Cc: stable tags are present, but as noted, this is expected
for commits requiring manual review.

### 2. CODE CHANGE ANALYSIS

The entire change is a single line addition:
```c
SND_PCI_QUIRK(0x1043, 0x1584, "ASUS UM3406GA ",
ALC287_FIXUP_CS35L41_I2C_2),
```

This adds:
- Vendor ID: 0x1043 (ASUS)
- Device/Subsystem ID: 0x1584 (ASUS UM3406GA)
- Fixup: `ALC287_FIXUP_CS35L41_I2C_2` (an **existing** fixup already
  used by many other ASUS models)

Looking at the surrounding code, multiple other ASUS laptops use the
same fixup:
- ASUS PM3406CKA (0x1454)
- ASUS G513PI/PU/PV (0x14e3)
- ASUS G733PY/PZ/PZV/PYV (0x1503)
- ASUS GV302XA/XJ/XQ/XU/XV/XI (0x1533)
- ASUS UM3402YAR (0x1683)

### 3. CLASSIFICATION

This is a **NEW DEVICE ID** addition - explicitly listed as an exception
that IS appropriate for stable backporting. The driver infrastructure
and fixup code already exist; this merely adds an ID to enable the
existing fix for new hardware.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 line
- **Files touched**: 1 file
- **Complexity**: Zero - table entry addition only
- **Risk**: Extremely low - this cannot affect any other hardware
- **No new code paths**: Uses pre-existing `ALC287_FIXUP_CS35L41_I2C_2`
  fixup

### 5. USER IMPACT

- **Who is affected**: Owners of ASUS UM3406GA laptops
- **Problem without fix**: Audio (specifically the CS35L41 amplifiers)
  won't function properly
- **Severity**: Non-working audio is a significant user-facing issue for
  laptop users

### 6. STABILITY INDICATORS

- Signed-off by Takashi Iwai (ALSA maintainer at SUSE)
- Standard quirk addition pattern used extensively throughout this file
- Follows exact same format as dozens of other ASUS quirk entries

### 7. DEPENDENCY CHECK

- The fixup `ALC287_FIXUP_CS35L41_I2C_2` has been in the kernel for some
  time, supporting multiple other ASUS models
- No other commits are required for this to work
- This should apply cleanly to stable trees that have the CS35L41
  support infrastructure

### CONCLUSION

This commit is a textbook example of what should be backported to stable
trees:

1. **Falls under explicit exception**: Adding device IDs to existing
   drivers is explicitly allowed
2. **Minimal change**: Single line, single table entry
3. **Zero regression risk**: Cannot affect any hardware except the
   targeted laptop
4. **Uses existing infrastructure**: The fixup is already well-tested on
   similar ASUS models
5. **Fixes real user problem**: Enables audio on a production laptop
6. **Obviously correct**: Identical pattern to surrounding entries

The risk-benefit analysis strongly favors backporting: virtually zero
risk with clear user benefit (working audio on a specific laptop model).

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b45fcc9a3785e..008bf9d5148e1 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6752,6 +6752,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1584, "ASUS UM3406GA ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.51.0

