Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46AF19A29C;
	Thu, 25 Jul 2024 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918372; cv=none; b=eqM+OBXMFxlidCwlVj4SEfktp6C0VNcKkgvTkE0VmRLCxZCvd9OpeLQFg7MnHc7NWurwq7KAtiUkAt5SzURQEKK79FEXQWjJP2XZpv+HqsKw9dkplJzljZWw8QuuHTKgcg0JL5p2Sa+Og5I4kOUUaquDUPYwfxS19ibfkx6oaPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918372; c=relaxed/simple;
	bh=2U5Rlz3rS7iPbNqm2sbJH59myweHmNSv3UvVmavbAAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6ufC8vjp7uVoZifK/9B2ZKMODTao/nFBNSgtnDpkyxWbbaLHe0xiH9QXF/1FAN7lFH9EdZE4McVzO3RL1IdWFuo4G0GbDVh8Wm3Fyy3P0K2blPVhvCzCyw1D5KECVaTRkwcFWZvmxqjxISC2O85ApI0RoYciRrvQK5HMnjlJt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FYW3mw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FYW3mw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9FDC116B1;
	Thu, 25 Jul 2024 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918372;
	bh=2U5Rlz3rS7iPbNqm2sbJH59myweHmNSv3UvVmavbAAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FYW3mw1TCA2KBKoDIgFeQiz0TW10xWd9eVxSVxnR7phcMe5ZnV3jn1HelwgUP6z8
	 q0cQrCwH14b2BuF0GEB8BLog4J9VNJd8Ua3ZqAtji9QwT2BtsFht75SxVPdk65mASo
	 MZzY2eT/RbDbkcer0Y9fmtptkNucQdv3qQXY1TzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 08/29] ALSA: hda/tas2781: Add new quirk for Lenovo Hera2 Laptop
Date: Thu, 25 Jul 2024 16:36:24 +0200
Message-ID: <20240725142732.131045499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit 1e5597e5ff18d452cf9afa847e904f301d1ac690 upstream.

Add new vendor_id and subsystem_id in quirk for Lenovo Hera2 Laptop.

Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240717115305.723-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10539,6 +10539,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x231a, "Thinkpad Z16 Gen2", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x231e, "Thinkpad", ALC287_FIXUP_LENOVO_THKPAD_WH_ALC1318),
 	SND_PCI_QUIRK(0x17aa, 0x231f, "Thinkpad", ALC287_FIXUP_LENOVO_THKPAD_WH_ALC1318),
+	SND_PCI_QUIRK(0x17aa, 0x2326, "Hera2", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x30bb, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x30e2, "ThinkCentre AIO", ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY),
 	SND_PCI_QUIRK(0x17aa, 0x310c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),


