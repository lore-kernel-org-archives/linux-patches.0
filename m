Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C742676037;
	Wed, 21 Feb 2024 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524623; cv=none; b=EYOKo9eIe7tVCXQ09cM9KiTff52CsQ3mmzJAzTqMLQZINzPgICdiHYqazk6st+QICQDbKLeJiizbknk1sNztm/ylDwjlgB/ztTpXbX0XJxooQym0Xbc2VLVnjLNEEC9R6mT1hJ9BACZ89zGwxjEdovgjyJqfLGp0XdJbnkx50lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524623; c=relaxed/simple;
	bh=0YRtSVp6lQgY3llOHeNMh8N/251suzpfOOCNAEQ8I/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDEQb1ZJk5qwr0MGDeY+RVAsRe+uffyHU7fBfR0R8NsM/iWqKvmXpppQPSjMHe9kGKraQGzfGprxN/S01OSHmHoPOsWXXM5RZAaspWNOnN549gcwGQ/p5Tfk+hke9A4hp96jvXd18Qx+Unztg8ZKKptU9n/VzPeGiGr9G8W1SkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1J5rYZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1J5rYZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53789C433F1;
	Wed, 21 Feb 2024 14:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524623;
	bh=0YRtSVp6lQgY3llOHeNMh8N/251suzpfOOCNAEQ8I/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1J5rYZTcWfgJ0fs++bd1fJr4Qxv1vCT8LN6WNFu0vxDCKRqcZKEAh4AFGdGvxWGF
	 3+Gv3WiRMGFopdsbWOagj6qmBi21D3WKbIKevhTZYbujHw9nBsCNxfAbuAdlI4l5d/
	 cZxZ0aLgUjlEbM4RksbLUXppHUeSPgFo6gBzYNB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Senoner <seda18@rolmail.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 299/379] ALSA: hda/realtek: Fix the external mic not being recognised for Acer Swift 1 SF114-32
Date: Wed, 21 Feb 2024 14:07:58 +0100
Message-ID: <20240221130003.768217128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8841,6 +8841,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x126a, "Acer Swift SF114-32", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),


