Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD78322F0F;
	Thu, 18 Jan 2024 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575035; cv=none; b=JG4GHjdYEUpaHjXBHMuIMtUgrUKjuh0dKzgdSJelc0zw9h4dL9Qs2Melbh/mX6J+nvRr5nSY1xP+pUhHrVCFuKt0voZPhZRP0aeLbKAyODzARs4d1VvKFe+J7YtqY4Rjw4tn5LYCbDT53xCmKEe6vfttdOfs6PXFvMeJaZnrxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575035; c=relaxed/simple;
	bh=bv+Lt+xqi1qHxjmKnDuZouXo5sRZnvzU+A1Ol8ZEV20=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=nkCSpZYCQYfWCkD1Sy5pes56J5r5pKjQNyCJDv7prsO8loRSOCCQ1SIkoQOHlgx59O58QucNO7hyEmSNjTUwZkLfWhJaaUzJ12ggBxgRyKRSs+lQeFUQud1eIYxP8Igq+aZ8JovYbMEWtUZEMuJ7BN6mUYcxTbGn8c0DhB2I/O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg6kcc/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg6kcc/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589F9C433C7;
	Thu, 18 Jan 2024 10:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575034;
	bh=bv+Lt+xqi1qHxjmKnDuZouXo5sRZnvzU+A1Ol8ZEV20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zg6kcc/0kOK9PGUAP0CL6aPyoYq22fEv4HrV4Gzm0X3b4IJsowHFpoXYCPT2IUxZ6
	 vwhVgXLxFAWyoZu8plekptxyhHre5WpUUld19ft5dEZkVBh7r45mkEhmJIqrQyRbJN
	 vk3kBi8nyANIZ3+YjqMN6TA6MzwRgtR/c8K7aRaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dorian Cruveiller <doriancruveiller@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 06/28] ALSA: hda/realtek: enable SND_PCI_QUIRK for Lenovo Legion Slim 7 Gen 8 (2023) serie
Date: Thu, 18 Jan 2024 11:48:56 +0100
Message-ID: <20240118104301.457309052@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dorian Cruveiller <doriancruveiller@gmail.com>

commit 99af5b11c57d33c32d761797f6308b40936c22ed upstream.

Link up the realtek audio chip to the cirrus cs35l41 sound amplifier chip
on 4 models of the Lenovo legion slim 7 gen 8 (2023). These models are
16IRH8 (2 differents subsystem id) and 16APH8 (2 differents subsystem ids).

Subsystem ids list:
 - 17AA38B4
 - 17AA38B5
 - 17AA38B6
 - 17AA38B7

Signed-off-by: Dorian Cruveiller <doriancruveiller@gmail.com>
Cc: <stable@vger.kernel.org> # v6.7
Link: https://lore.kernel.org/r/20231230114001.19855-1-doriancruveiller@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10242,6 +10242,10 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3886, "Y780 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a7, "Y780P AMD YG dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a8, "Y780P AMD VECO dual", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38b5, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38b6, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38b7, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38ba, "Yoga S780-14.5 Air AMD quad YC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38bb, "Yoga S780-14.5 Air AMD quad AAC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38be, "Yoga S980-14.5 proX YC Dual", ALC287_FIXUP_TAS2781_I2C),


