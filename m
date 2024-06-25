Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996E81487E9;
	Tue, 25 Jun 2024 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309532; cv=none; b=kSnuz1oN8ix1s8fyd9W15uP7C0PYfzz1XlFwYnUESHXm5lviRPycfSKOUkuxLOfwfud6iwCxhBMZglGkucQKpxLCTmO/YVXjUF548XYfF/39SP5vrdwf1dOcGQaXSvG6/LwbTUmEP2DGmjXwcOrxCu3LIspJLeHzPdzVNkD+ykY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309532; c=relaxed/simple;
	bh=IGug6vzBIWdxulqy2hYNTj/bCOQFYd3MyW///EL6cFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlM45iE1rX+MnWdVmTB9YlzLPyB6D5/uWZMH8h7vg0k+jDAZjEoj8NXod4vhjkvUu995qbQO960B6Jm1/Q9E1TfHO9Mi8NY8OpoX6jDTRcL21rmSOmrUKH19okh2+Sz0Yeaeh+unmV7DGQeBPeHKvWbvVMiZV24aCtc79SU6raQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaApV0Y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaApV0Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAABC32781;
	Tue, 25 Jun 2024 09:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309532;
	bh=IGug6vzBIWdxulqy2hYNTj/bCOQFYd3MyW///EL6cFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaApV0Y6K6MRCxw/E9/byHee2g15R/wvl8myyBVphOOJbQW5CPgGazDayBZbMAB3U
	 CTOeL4s8ph9ct2dwkF+ddLZ+qXmoBm7L0Tl/BWut2lrOsbIQceZnikPmOsSh6Qu6Dg
	 3MZ7sawq68yeKnHgdU2O1BaTPxFC7tuqUSF6zk24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/131] ALSA: hda/realtek: Remove Framework Laptop 16 from quirks
Date: Tue, 25 Jun 2024 11:33:23 +0200
Message-ID: <20240625085527.777675768@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit e799bdf51d54bebaf939fdb655aad424e624c1b1 ]

The Framework Laptop 16 does not have a combination headphone/headset
3.5mm jack; however, applying the pincfg from the Laptop 13 (nid=0x19)
erroneously informs hda that the node is present.

Fixes: 8804fa04a492 ("ALSA: hda/realtek: Add Framework laptop 16 to quirks")
Signed-off-by: Dustin L. Howett <dustin@howett.net>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240605-alsa-hda-realtek-remove-framework-laptop-16-from-quirks-v1-1-11d47fe8ec4d@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 35dabe6ce0d7a..e602776eb7ec8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10152,7 +10152,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0xf111, 0x0005, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
-- 
2.43.0



