Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F18A295528;
	Mon, 14 Jul 2025 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534460; cv=none; b=A1chjxFXMQBidak8IGqEn0yB8LrNNmiCnFEst3PYSd/K3y8R3/+WaCbjt9B/RaJyZb9/BA72MVjfCDmuZgUvyW5SeZfyJPkXhMCCX3KfkXX6vCPeA/4u8b4zu33sBkpl4wGEY1p17rmnhn8BWEpthgjUkRdrymtZxQY+cDjHL68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534460; c=relaxed/simple;
	bh=OLADJV9NeEQ8fmm3553urbLG09zc1CrI/UXDE0Ebmso=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eLKH0TgsaA1O+auyDX5H58qhMcFsPLfLD6pO1Yieixok0thNsfGbjMMYG20xpdhGbZW4xWknbJ1Nm8u5bo9eFmmRAaDhDAG/dsaVWA4DYAgSAn/xATQCFj7E2d/luwjcHlvHVGif9nC3zi8pqyzf6uOE1WdcG6trxg2Us6wdM+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4vjzwCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4vjzwCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C3C4CEED;
	Mon, 14 Jul 2025 23:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534459;
	bh=OLADJV9NeEQ8fmm3553urbLG09zc1CrI/UXDE0Ebmso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4vjzwCId72rY8+KkfEtTo9Ue2utECSwPROPg9fTXsYP4lvoyBKhtCF8mfBmPMxrP
	 WBz7OH6SMu6FJoglW8EsKaOdnSDHGvfuK9spr9m070kpoSekQ89PF8gdN+OKuqkceq
	 ceHApX314ZoPgbPRixu+/zJOHYL6l9P00x6a+M4m54HwZ7Wy8kjQq3zUQcOz0/smQ8
	 KZcBhqDRBbhJxGfo84vyQfbNdXJDMEAC6TJ5rXrdqnw/65Yd19A2kOOT9iSwEr8S2y
	 cNGwpv/xvGJRnyNRqtQhFNU+0z8RkYLgZh51c8CttMSavjGbh0qGvAGLqIPOOTbp+1
	 WuxFi72O939Aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Anton Khirnov <anton@khirnov.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.12 11/12] ALSA: hda/realtek: Add quirk for ASUS ExpertBook B9403CVAR
Date: Mon, 14 Jul 2025 19:07:14 -0400
Message-Id: <20250714230715.3710039-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230715.3710039-1-sashal@kernel.org>
References: <20250714230715.3710039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.38
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit db98ee56851061082fecd7e6b4b6a93600562ec2 ]

ASUS ExpertBook B9403CVAR needs the ALC294_FIXUP_ASUS_HPE for the
headphones to work.

Closes: https://github.com/thesofproject/linux/issues/5472
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Tested-by: Anton Khirnov <anton@khirnov.net>
Link: https://patch.msgid.link/20250701133411.25275-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit message and code changes:

**YES** - This commit should be backported to stable kernel trees.

## Extensive Explanation:

### 1. **Nature of the Fix**
This commit adds a hardware quirk for the ASUS ExpertBook B9403CVAR
laptop to fix non-functional headphones. The change is:
```c
+       SND_PCI_QUIRK(0x1043, 0x1e93, "ASUS ExpertBook B9403CVAR",
ALC294_FIXUP_ASUS_HPE),
```

This is a simple one-line addition to the quirk table that enables the
`ALC294_FIXUP_ASUS_HPE` fixup for this specific laptop model (vendor ID
0x1043, device ID 0x1e93).

### 2. **Matches Stable Tree Criteria**
- **Fixes a real bug**: The commit explicitly states "for the headphones
  to work", indicating that without this quirk, headphones don't
  function on this laptop model
- **Small and contained**: It's a single-line addition to a quirk table
  with no architectural changes
- **Hardware enablement**: This type of fix enables basic functionality
  (audio output) on existing hardware
- **No new features**: Simply applies an existing fixup to a new
  hardware variant
- **Minimal regression risk**: The change only affects systems with this
  specific PCI ID combination

### 3. **Similar to Historical Backports**
The commit follows the exact same pattern as the similar commits
provided with "Backport Status: YES":
- All are simple quirk additions for ASUS laptops
- All use existing fixup methods (CS35L41, ALC294_FIXUP_ASUS_HPE, etc.)
- All address audio functionality issues
- All have explicit stable tags or were backported

### 4. **User Impact**
- **Without the fix**: Users of ASUS ExpertBook B9403CVAR laptops cannot
  use headphones
- **With the fix**: Basic audio functionality is restored
- The bug report reference
  (https://github.com/thesofproject/linux/issues/5472) indicates this
  was a user-reported issue affecting real systems

### 5. **Code Safety**
- Uses an existing, well-tested fixup (`ALC294_FIXUP_ASUS_HPE`)
- Placed correctly in numerical order in the quirk table
- No possibility of affecting other hardware models due to specific PCI
  ID matching
- The fixup itself only adjusts EAPD settings and chains to headset
  microphone fixes

### 6. **Comparison with Similar Commits**
All the provided similar commits with "Backport Status: YES" share these
characteristics:
- Single or few line additions to quirk tables
- Fix audio issues on specific ASUS laptop models
- Use existing fixup infrastructure
- Have clear user impact (non-functional audio components)

This commit matches all these characteristics perfectly, making it an
ideal candidate for stable backporting.

The commit represents exactly the type of hardware enablement fix that
stable trees are meant to include - it restores basic functionality on
existing hardware without introducing any new features or architectural
changes.

 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 30e9e26c5b2a7..7d68fc704fb5f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10943,6 +10943,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1e63, "ASUS H7606W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e83, "ASUS GA605W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1e93, "ASUS ExpertBook B9403CVAR", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1ed3, "ASUS HN7306W", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5

