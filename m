Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25BE1DF72E;
	Tue,  8 Oct 2024 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390522; cv=none; b=EGXfCUu7L6VegI0QFumTvo5+sghzv4i6bCyJfKcm6/NL9AiYpT2N84Flbb6I+lPfFMALBzPZcwYQIn/m+/LkIQdO0YW9xJh+1BrGuloQ/TSa7aGvFXOWqb4ymwZ6c9YrDGwXXQFx8HTN7pd4AhLSQAkvIXFu3T9h18H5l3qyKjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390522; c=relaxed/simple;
	bh=Oj+FvhSg7OTUn9L0I/vjD82XvFS8Iy74vqHREfQPxrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKp+8SbxZWinE6c/ujGSrHa2MLxUGCz41ztezuelZ7ZAsZ0eHBH9EndeigPye2BH1M8r9Y0t05kTfNyaPW6xgzLX0rOlXCLWW/ggsZNKnk03jYMvLX2mI1n/EXR8HYEf0VTy3+lvj42Zg3bm+movpg6tHBqQsUK++xJY6JdJfpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vILm5ntE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vILm5ntE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D35C4CEC7;
	Tue,  8 Oct 2024 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390522;
	bh=Oj+FvhSg7OTUn9L0I/vjD82XvFS8Iy74vqHREfQPxrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vILm5ntEJCGdD6N6846+nVBBBi4+mmSL0GrkAPNtlgKjzcdBEOIs3UZM/Yw39XPuM
	 PySQL/lwkc3KxKlHNzskoWfjy1Hm30zK9Q9kossttg7ZYOUWv+xY0MxvIwTlOnuSUG
	 dN/apmWCVvAEBSp8Ngc6k7/ONSqehjoKPluO89yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 314/482] ALSA: hda/tas2781: Add new quirk for Lenovo Y990 Laptop
Date: Tue,  8 Oct 2024 14:06:17 +0200
Message-ID: <20241008115700.790626929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Baojun Xu <baojun.xu@ti.com>

commit 49f5ee951f11f4d6a124f00f71b2590507811a55 upstream.

Add new vendor_id and subsystem_id in quirk for Lenovo Y990 Laptop.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240919075743.259-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10651,6 +10651,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x38cd, "Y790 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d2, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


