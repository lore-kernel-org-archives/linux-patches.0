Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E32B21CFEF;
	Sat, 14 Feb 2026 01:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031208; cv=none; b=kd3HVhNCKFyiimY1v1kQFS/yIB9uMaNY8H+aJVt3YJ7BEPv9K9JPREmRLaRm1Cl7+vULtJB+LqvAr801xHFYpC7woFKZ/UxgkW0VNiw9Z3qW5rR0e87EoS0CAQDqcCS44DraBMSkjZ1S+g/+5/h5H3S1Xm3f+ij4N+xZwEDEJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031208; c=relaxed/simple;
	bh=ErIXLtXmnLJXDU9uxisZH+zLzYsqLvazsjokZmoqO2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XEFTjNc6Y4PoGQSMlV0Gg6PLseWm6jotx5ys/1aAgX/HxpkYkfW48gsEgTVpPwiV9Pq1mNNI35CXTJfGs3Ufbga18Ip51VzgQbwKsWXFzYHVzQph8xeAJFf680VQeEpcyby14/QZGZSFIFtKCs/T9jkGa4Qugo198wceB9VK2CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IXHMfd3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IXHMfd3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F34FC116C6;
	Sat, 14 Feb 2026 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031208;
	bh=ErIXLtXmnLJXDU9uxisZH+zLzYsqLvazsjokZmoqO2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXHMfd3N8FOWVwwSOK50GQMMow7EGuUkP94vqGjzqB+uTuR6MEavPlgtq09m7totL
	 hbfR8L4LGf4QwVKo38YQO6XE2UqUaWEXoq6k4IHp73Iq9uQcI5XEsTjYq/pYRMsJgZ
	 gLNXJ2n1KvUW6uiAsac+4pyHPnvRbJII+xBnIcLE2wUhkKCbohYmSoHUo9ZHEm2+6H
	 /5Ui5ZyYzR+7W5jNnjn2AO1njF4ROB10igZEZTQ8e7JoPo4idqvM09uLVtdd9ZuPon
	 UjjtU3tKpUTxYePzHF5FiiFFJkT5bJNdyLx95XL4J+ky/Idx3swvZ/q87V+u6r5O2g
	 dj+FO85TXNAow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: gongqi <550230171hxy@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	wangdicheng@kylinos.cn,
	yelangyan@huaqin.corp-partner.google.com,
	rf@opensource.cirrus.com,
	john-linux@pelago.org.uk
Subject: [PATCH AUTOSEL 6.19-6.6] ALSA: hda/conexant: Add headset mic fix for MECHREVO Wujie 15X Pro
Date: Fri, 13 Feb 2026 19:59:42 -0500
Message-ID: <20260214010245.3671907-102-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: gongqi <550230171hxy@gmail.com>

[ Upstream commit f2581ea2d9f30844c437e348a462027ea25c12e9 ]

The headset microphone on the MECHREVO Wujie 15X Pro requires the
CXT_FIXUP_HEADSET_MIC quirk to function properly. Add the PCI SSID
(0x1d05:0x3012) to the quirk table.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-5-550230171hxy@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds a hardware quirk (`CXT_FIXUP_HEADSET_MIC`) for the
MECHREVO Wujie 15X Pro laptop, identified by PCI SSID `0x1d05:0x3012`.
The headset microphone does not function without this quirk entry. This
is a straightforward audio codec quirk addition.

### Code Change Analysis

The change is a single line addition:
```c
SND_PCI_QUIRK(0x1d05, 0x3012, "MECHREVO Wujie 15X Pro",
CXT_FIXUP_HEADSET_MIC),
```

This adds a PCI SSID entry to the `cxt5066_fixups[]` quirk table in the
Conexant HDA codec driver. The `CXT_FIXUP_HEADSET_MIC` fixup already
exists in the driver — this just associates a new device's PCI subsystem
ID with that existing fixup.

### Classification

This falls squarely into the **hardware quirk** exception category. As
documented in the stable kernel rules analysis:

- **Audio codec quirks** (`SND_PCI_QUIRK` entries for specific laptop
  models) are explicitly listed as YES for stable
- The quirk type (`CXT_FIXUP_HEADSET_MIC`) already exists in the driver
- Only the device identification (PCI SSID) is new
- This fixes a real user-facing problem: the headset microphone doesn't
  work at all without it

### Scope and Risk Assessment

- **Lines changed**: 1 (single line addition)
- **Files changed**: 1 (`sound/hda/codecs/conexant.c`)
- **Risk**: Essentially zero. The `SND_PCI_QUIRK` macro only matches the
  specific PCI SSID `0x1d05:0x3012`. It cannot affect any other
  hardware.
- **Dependencies**: None. The `CXT_FIXUP_HEADSET_MIC` fixup code already
  exists in the driver.

### User Impact

Without this quirk, the headset microphone on the MECHREVO Wujie 15X Pro
laptop is completely non-functional. This is a real hardware enablement
issue affecting actual users of this specific laptop model. Audio input
is a basic expected functionality.

### Stability Indicators

- Accepted by Takashi Iwai, the ALSA subsystem maintainer
- The pattern is identical to dozens of other quirk entries in the same
  table
- The fixup mechanism (`CXT_FIXUP_HEADSET_MIC`) is well-tested and used
  for other devices

### Conclusion

This is a textbook example of a stable-worthy hardware quirk addition: a
single-line `SND_PCI_QUIRK` entry that enables existing functionality
for a specific device. Zero risk of regression, fixes a real hardware
issue, trivially small, and completely self-contained.

**YES**

 sound/hda/codecs/conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 5fcbc1312c697..2384e64eada36 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1123,6 +1123,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad/Ideapad", CXT_FIXUP_LENOVO_XPAD_ACPI),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
+	SND_PCI_QUIRK(0x1d05, 0x3012, "MECHREVO Wujie 15X Pro", CXT_FIXUP_HEADSET_MIC),
 	HDA_CODEC_QUIRK(0x2782, 0x12c3, "Sirius Gen1", CXT_PINCFG_TOP_SPEAKER),
 	HDA_CODEC_QUIRK(0x2782, 0x12c5, "Sirius Gen2", CXT_PINCFG_TOP_SPEAKER),
 	{}
-- 
2.51.0

