Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF921250C00;
	Thu,  3 Apr 2025 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693965; cv=none; b=L01wa37z5MUTnCxWrBG+o6LvaDG+YvDvHJaaihdXDTWe72Tksp+YUCj9LMjSH9vE6JfUcPbAkPTEfORtkt3XlU7nAGiHOrzeW39cRWp1msaGDFNayWc3kSuUbu5sH1flwbkO9KeOMEHzNuTZUCrdbca1qL7YeuhG5/nv2GMOJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693965; c=relaxed/simple;
	bh=Dl03cPUP7OeWGuPbasjhk0r6fJHuEaQW+uKF3t5xMKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IasyoJ5Weq106efasyPckY4hbBVSCkjSF+uUGg3Vrh5CUe+oGbTnXByLBa5eemwMIDcb1v+Ky5do3fUw6kiRisOuxtCpbM3Ix0pjNxzDmpWLwU7PXiHfCsUyKFMPPmPekgOTyySah1+FlyQTsGsK96Ie3WZfj76rJG+u4icTzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSD6apXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSD6apXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477ADC4CEE3;
	Thu,  3 Apr 2025 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693965;
	bh=Dl03cPUP7OeWGuPbasjhk0r6fJHuEaQW+uKF3t5xMKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSD6apXpjubgN6wiuSO39+TbCJPOQmc3RIpx6iHga85SmTAcPpuAkXGt1vtm0ywZq
	 +758SxXMIsdLejo8t6vRBVTlnDbfp/Gfn/Xeg0M1mNI2Pxzal75oOJ0c4mUoRfCpFZ
	 3yl9TPmmKmh93r7iny0wFn1uDfPI8cB0mM/Vd0hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres Traumann <andres.traumann.01@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 08/23] ALSA: hda/realtek: Bass speaker fixup for ASUS UM5606KA
Date: Thu,  3 Apr 2025 16:20:25 +0100
Message-ID: <20250403151622.514476203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andres Traumann <andres.traumann.01@gmail.com>

commit be8cd366beb80c709adbc7688ee72750f5aee3ff upstream.

This patch applies the ALC294 bass speaker fixup (ALC294_FIXUP_BASS_SPEAKER_15),
previously introduced in commit a7df7f909cec ("ALSA: hda: improve bass
speaker support for ASUS Zenbook UM5606WA"), to the ASUS Zenbook UM5606KA.
This hardware configuration matches ASUS Zenbook UM5606WA, where DAC NID
0x06 was removed from the bass speaker (NID 0x15), routing both speaker
pins to DAC NID 0x03.

This resolves the bass speaker routing issue, ensuring correct audio
output on ASUS UM5606KA.

Signed-off-by: Andres Traumann <andres.traumann.01@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250325102535.8172-1-andres.traumann.01@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10730,6 +10730,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1df3, "ASUS UM5606WA", ALC294_FIXUP_BASS_SPEAKER_15),
+	SND_PCI_QUIRK(0x1043, 0x1264, "ASUS UM5606KA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),


