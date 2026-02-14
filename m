Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D1194098;
	Sat, 14 Feb 2026 01:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031091; cv=none; b=GGpZ57Hnr259Op4qwd0LNRG34laz/QpK8GCM1obt3zcgIIZKSWnN+m7k6029eumxKCahvW8zYdXvh221GWND+0YMnIWD+DE33HpnHkmMLz6v0qSnSt6xDdcgvHoX3M8PGMhNya4jTSF0CqdQGCEqEXJShR/QyiulSRI3ynVsBZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031091; c=relaxed/simple;
	bh=JWpIsAxX37m3Pcjxfuw2UdnL2xPqmSqusRuYJyWw3y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A22BXyj4KnkgYbHvzgVDNLNb2GhG09R5VGV7ueEMOxiazz9gfEJEt2VQPHWfJ04tRvfE/t7YhxuzkMGw1N9mYjdWN0sNxsJ5p5hYUh73Yeqtnh7fzHJ4WBIgTAtYDJNSXw/pFG4MQ+BYpd/yoUtAwUYRNKBnP+lSNJpThSyYgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/svTsOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/svTsOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F86AC16AAE;
	Sat, 14 Feb 2026 01:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031091;
	bh=JWpIsAxX37m3Pcjxfuw2UdnL2xPqmSqusRuYJyWw3y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/svTsOsXpaxKZFcsjEZ2ggczMRD+PtDX1ENJjc5qZy7YJXX1VJvFfuPu1DOOa8bW
	 lMNspmi5bKyBteCwxAdn2O5f3Q696JeGdXoSxR+YHRWW+aT5kPgxeaAngCDoUGNVA4
	 7GJ93/NidTNAJJtDk+rPAK6h+8NgzIkbaXyAkRmtAN/fKMVtd+/wRQRbbgWU5MbxmA
	 azcLEJ0x1Afvgj4cybWujO85VQ6Ybrly1w+yrvIGB/TNPsYhcTXKUQBucWOGm9kBb3
	 KfCUTdbqja+qCBFoZ3ZPr2w7+6dmvF9metLnoPbGV5DYInafNrYoX7SwqAUHuUC70H
	 /jxO5Yrl2qehQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19] ALSA: ctxfi: Add quirk for SE-300PCIE variant (160b:0102)
Date: Fri, 13 Feb 2026 19:58:57 -0500
Message-ID: <20260214010245.3671907-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Harin Lee <me@harin.net>

[ Upstream commit 3a92733e052753d87fdd56bd6f621f969be28447 ]

Add quirk for the Onkyo SE-300PCIE variant with PCI subsystem ID
(160b:0102). This variant (OK0011) was found in the official Windows
driver packages.

Also, reorder entries and fix the indentation to maintain
consistency.

Signed-off-by: Harin Lee <me@harin.net>
Link: https://patch.msgid.link/20260208133001.680550-1-me@harin.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds a quirk entry for a new PCI subsystem ID variant
(160b:0102) of the Onkyo SE-300PCIE sound card to the ctxfi driver. It
also reorders existing entries and fixes whitespace (tabs vs spaces) for
consistency.

### Code Change Analysis

The changes are:

1. **New device quirk addition**: `SND_PCI_QUIRK(0x160b, 0x0102,
   "OK0010", CTOK0010)` - This adds a new PCI subsystem ID for a variant
   of the Onkyo SE-300PCIE card. The existing quirk `(0x160b, 0x0101)`
   already exists for the OK0010 model, and this new entry (0x0102) maps
   to the same `CTOK0010` type. This is a straightforward hardware ID
   addition to an existing driver.

2. **Reordering**: The `SB1270` entry and `OK0010` entry are moved to
   maintain a more logical order, and the `HENDRIX` quirk mask is placed
   after specific entries. This is purely cosmetic reordering.

3. **Whitespace fix**: In `ct_subsys_name`, the indentation for
   `CTSB1270` and `CTOK0010` entries is changed from spaces to tabs to
   match the rest of the table. This is a pure style fix.

### Classification

This falls squarely into the **"NEW DEVICE IDs / HARDWARE QUIRKS"**
exception category for stable backports:

- The driver (ctxfi) already exists in stable trees
- The quirk type (`CTOK0010`) already exists in stable trees
- Only a new PCI subsystem ID is being added to enable a hardware
  variant
- This is a trivial one-line functional addition

Without this quirk, the SE-300PCIE variant with subsystem ID 0x0102
would not be properly identified and configured by the driver,
potentially resulting in the card not working correctly or at all.

### Scope and Risk Assessment

- **Lines changed**: Very small - one new line of functional code, rest
  is reordering and whitespace
- **Files affected**: 1 file (`sound/pci/ctxfi/ctatc.c`)
- **Risk**: Extremely low. The new quirk entry only matches a specific
  PCI subsystem ID (160b:0102). It cannot affect any other hardware. The
  reordering doesn't change behavior. The whitespace changes are
  cosmetic.
- **Regression potential**: Near zero. SND_PCI_QUIRK entries are matched
  by exact vendor:device ID pairs.

### User Impact

- Users with the Onkyo SE-300PCIE OK0011 variant need this quirk for
  their hardware to work properly
- The variant was found in official Windows driver packages, confirming
  it's real shipping hardware

### Dependencies

- The `CTOK0010` enum value must exist in the stable tree. Since the
  existing `0x0101` quirk for `CTOK0010` is already present, this
  dependency is satisfied.

### Concerns

- The reordering and whitespace changes are mixed in with the functional
  change, which slightly increases the diff size but doesn't affect
  correctness or risk.
- The commit applies cleanly to any tree that has the existing OK0010
  quirk entry.

### Conclusion

This is a textbook example of a hardware quirk addition that belongs in
stable. It adds support for a specific hardware variant by adding a
single PCI subsystem ID entry to an existing quirk table. The risk is
minimal, and the benefit is enabling hardware that otherwise won't work
properly.

**YES**

 sound/pci/ctxfi/ctatc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 227d8c8490e1f..a25a599fc5bec 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -52,18 +52,19 @@ static const struct snd_pci_quirk subsys_20k1_list[] = {
 static const struct snd_pci_quirk subsys_20k2_list[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB0760,
 		      "SB0760", CTSB0760),
-	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB1270,
-		      "SB1270", CTSB1270),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB08801,
 		      "SB0880", CTSB0880),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB08802,
 		      "SB0880", CTSB0880),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB08803,
 		      "SB0880", CTSB0880),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_CREATIVE, PCI_SUBDEVICE_ID_CREATIVE_SB1270,
+		      "SB1270", CTSB1270),
+	SND_PCI_QUIRK(0x160b, 0x0101, "OK0010", CTOK0010),
+	SND_PCI_QUIRK(0x160b, 0x0102, "OK0010", CTOK0010),
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_CREATIVE, 0xf000,
 			   PCI_SUBDEVICE_ID_CREATIVE_HENDRIX, "HENDRIX",
 			   CTHENDRIX),
-	SND_PCI_QUIRK(0x160b, 0x0101, "OK0010", CTOK0010),
 	{ } /* terminator */
 };
 
@@ -78,8 +79,8 @@ static const char *ct_subsys_name[NUM_CTCARDS] = {
 	[CTSB0760]	= "SB076x",
 	[CTHENDRIX]	= "Hendrix",
 	[CTSB0880]	= "SB0880",
-	[CTSB1270]      = "SB1270",
-	[CTOK0010]    = "OK0010",
+	[CTSB1270]	= "SB1270",
+	[CTOK0010]	= "OK0010",
 	[CT20K2_UNKNOWN] = "Unknown",
 };
 
-- 
2.51.0

