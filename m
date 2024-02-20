Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64DA612D7;
	Tue, 20 Feb 2024 21:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463520; cv=none; b=bUuLO7n0uIeJQQvUOOAAYVWtSGzoOCqpHmT9G+L6pTShmdomKvKT4RfMrU11XT1i9JzSfiyjPPN+OTD6+xAfWOo1b95dkdvVgB5QjAcfgQd9lV5Bvh830KQ2AH6ctaRFp27X7QZ6txo+lneeTJ8vrZStkD7HCtXC8cZLvDajB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463520; c=relaxed/simple;
	bh=Upnt1BVeyqXEQ118klnVOu7BPxraK1W2HWag2zqoBBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGjrffzHN+oYun+4jG2/bG2l7ze8apzCZC/lU12ITW74NIg4jvl1Pwi3QLu022AcDRiWIVwAFvyrJ/Z8K/01eFvq4XVvqKcTAHaWggpFzwWSTy06gFaL91Q3fbxZf55UpoFTJKP4/M+mn3MYUBJ4DUEhYyFVJMO8nW9pAhFcW8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki8qeZcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki8qeZcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9805C433F1;
	Tue, 20 Feb 2024 21:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463520;
	bh=Upnt1BVeyqXEQ118klnVOu7BPxraK1W2HWag2zqoBBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki8qeZcVoMjTsb8sxx3XiaXugrG8fcIUdbak32LXANpgmMYkIiYfusBSnZWz0lYFv
	 7+nH60QRz+5t+s2yDxuvIR2ieb4T5wwUekr5gCuyC5ZsC0pjAbTi7XB0QE8jXs3vs6
	 9shG06IJre2faM0ITLwbuLFN4PNi8gncwyD71IO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Senoner <seda18@rolmail.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 069/331] ALSA: hda/realtek: Fix the external mic not being recognised for Acer Swift 1 SF114-32
Date: Tue, 20 Feb 2024 21:53:05 +0100
Message-ID: <20240220205639.747705697@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Senoner <seda18@rolmail.net>

commit efb56d84dd9c3de3c99fc396abb57c6d330038b5 upstream.

If you connect an external headset/microphone to the 3.5mm jack on the
Acer Swift 1 SF114-32 it does not recognize the microphone. This fixes
that and gives the user the ability to choose between internal and
headset mic.

Signed-off-by: David Senoner <seda18@rolmail.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240126155626.2304465-1-seda18@rolmail.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9549,6 +9549,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x126a, "Acer Swift SF114-32", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),


