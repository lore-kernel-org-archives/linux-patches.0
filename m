Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C56515B10D;
	Mon, 28 Oct 2024 06:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097142; cv=none; b=kuT/a49kcHxNqcPwVkBFjmLLp15fPE3/zxvnx3gE8q34J/9od5BwAXjXCYLEFhbbQF/jSE7XTND8Qp9w3AnN8j8RSQFgD+PTXRIOxbYi9zyfWkp9ReBu7irYRTDYYAZmk3gGHshAe+DZxR15BrZjE9gsWysOrduQE4upP6qUKeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097142; c=relaxed/simple;
	bh=pgNThje12XToHy9TlCGoCtTCDVNY5+Sc9aXYO9Nt44A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hx2Ue493DLVaST1x//FzUeoyRcL3IUguskLDItn1qxMALml6B/6jO3TZJCDe4+0zkeFm1fIL4G8QVyYXw49KOwbT/5G3qIkRGIIJC+ywDrOAjd+NhMdVl5TdJ9YOShRUaP+S3CXCENOtQYwSJ7DgZ1xfaauxUJyS0MNYGMfe2t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3nGZpTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3nGZpTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E2FC4CEC7;
	Mon, 28 Oct 2024 06:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097142;
	bh=pgNThje12XToHy9TlCGoCtTCDVNY5+Sc9aXYO9Nt44A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3nGZpTI9n2tx9I563rA6R99heV0Hag9oJUC34TSX/VA8t/AGhHG5pj6We80Z6Tik
	 4rKy3JlbnPlqo+lFYdc9xW9U2Ru0JqcIstBYVzMwCd6x+WJSPIJh/DepRde8iA3x64
	 z6gzDAgds8Mfj7lhrXLlH/3T8P2na7YKFyDCs/L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Relvas?= <josemonsantorelvas@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 74/80] ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593
Date: Mon, 28 Oct 2024 07:25:54 +0100
Message-ID: <20241028062254.666910937@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7024,6 +7024,7 @@ enum {
 	ALC286_FIXUP_ACER_AIO_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
+	ALC255_FIXUP_PREDATOR_SUBWOOFER,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
 	ALC289_FIXUP_DELL_SPK2,
@@ -8259,6 +8260,13 @@ static const struct hda_fixup alc269_fix
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
@@ -8997,6 +9005,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x110e, "Acer Aspire ES1-432", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1166, "Acer Veriton N4640G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x1167, "Acer Veriton N6640G", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x1025, 0x1177, "Acer Predator G9-593", ALC255_FIXUP_PREDATOR_SUBWOOFER),
+	SND_PCI_QUIRK(0x1025, 0x1178, "Acer Predator G9-593", ALC255_FIXUP_PREDATOR_SUBWOOFER),
 	SND_PCI_QUIRK(0x1025, 0x1246, "Acer Predator Helios 500", ALC299_FIXUP_PREDATOR_SPK),
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),


