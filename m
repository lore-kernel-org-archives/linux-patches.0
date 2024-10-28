Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9612AF07;
	Mon, 28 Oct 2024 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098435; cv=none; b=pomBP1YC3GRY50GdJqDRf7+/mmys/PNm0iLakkw/AkyYwWtQuiEsOUBhPEM4GwlUcxhVst0bfvOo1Hfb7gHSjNW41ok+fCtl9KTC05yqYzWfySpm3O6PZeFKCKceUC8Q9QYOoW9AHThzjMpBAN9VadlDQhXdzOX3IXtZtxJnWXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098435; c=relaxed/simple;
	bh=Qh7STZ94LJG+qaMm1ON1E/PO5CDy0HgkNStx5+E63zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZzjJrSBI9HwQh8hmmzijSxrniFeuBHC3RTqwiHi4+lLO/ATM/zcqzAwrSLRCTIW/Kq6vAoa/TNLLIxbq4ECoFuY/QJoyZJJCvoFV1luI70dXR4+Kbq8BwvRpP7UUYA442kSFoot//C/kZYb7OOPlelMckL30o/W0qcyqgjZUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLUR/vuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLUR/vuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC692C4CEC3;
	Mon, 28 Oct 2024 06:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098435;
	bh=Qh7STZ94LJG+qaMm1ON1E/PO5CDy0HgkNStx5+E63zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLUR/vuKLKhxcumQKZsQm3H+ksnlYNA6tQe+W7SDpIV9xWoihg8KPKot1xComZhom
	 8HZD/AbiC3ziuVx8TWFaN+YUwU3zJpVYIEWUUHTeO98VK1cmu1eW9nV6m7i6BVl0BD
	 zDqgkQ0J9bQ4LqL8P8OGzpCsZa8Ocrw9udss5ZKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Relvas?= <josemonsantorelvas@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 226/261] ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593
Date: Mon, 28 Oct 2024 07:26:08 +0100
Message-ID: <20241028062317.777565856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Relvas <josemonsantorelvas@gmail.com>

commit 35fdc6e1c16099078bcbd73a6c8f1733ae7f1909 upstream.

The Acer Predator G9-593 has a 2+1 speaker system which isn't probed
correctly.
This patch adds a quirk with the proper pin connections.

Note that I do not own this laptop, so I cannot guarantee that this
fixes the issue.
Testing was done by other users here:
https://discussion.fedoraproject.org/t/-/118482

This model appears to have two different dev IDs...

- 0x1177 (as seen on the forum link above)
- 0x1178 (as seen on https://linux-hardware.org/?probe=127df9999f)

I don't think the audio system was changed between model revisions, so
the patch applies for both IDs.

Signed-off-by: José Relvas <josemonsantorelvas@gmail.com>
Link: https://patch.msgid.link/20241020102756.225258-1-josemonsantorelvas@gmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7631,6 +7631,7 @@ enum {
 	ALC286_FIXUP_ACER_AIO_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
+	ALC255_FIXUP_PREDATOR_SUBWOOFER,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
 	ALC289_FIXUP_DELL_SPK1,
@@ -9047,6 +9048,13 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
 	},
+	[ALC255_FIXUP_PREDATOR_SUBWOOFER] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x17, 0x90170151 }, /* use as internal speaker (LFE) */
+			{ 0x1b, 0x90170152 } /* use as internal speaker (back) */
+		}
+	},
 	[ALC299_FIXUP_PREDATOR_SPK] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10138,6 +10146,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x110e, "Acer Aspire ES1-432", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1166, "Acer Veriton N4640G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x1167, "Acer Veriton N6640G", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x1025, 0x1177, "Acer Predator G9-593", ALC255_FIXUP_PREDATOR_SUBWOOFER),
+	SND_PCI_QUIRK(0x1025, 0x1178, "Acer Predator G9-593", ALC255_FIXUP_PREDATOR_SUBWOOFER),
 	SND_PCI_QUIRK(0x1025, 0x1246, "Acer Predator Helios 500", ALC299_FIXUP_PREDATOR_SPK),
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),


