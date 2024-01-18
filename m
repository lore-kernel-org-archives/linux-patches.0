Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20A200AA;
	Thu, 18 Jan 2024 10:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575575; cv=none; b=GyxPcmzxWlxD7hpdKG45WM5Gx/zFC6huTViJ/CXUFrShkahnZSocUbokWxMCaICjnzjlvJXIkaGkcvS+kbwePbO5yx1PBhnc/fmzZ5CImeCH92ASlF3OxY+afXKW2GDNFy0gXTauwTEJ5uYSBx0qgqYheqXv71JxEFIUsS39iuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575575; c=relaxed/simple;
	bh=icoFE6PY8TEW8pmy6ua1JhWxiegQVgteMfTis8KBROo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=TeO0NdgfqnNvwhSWVmrJVXtTIxnWVTfT9WGhdpdcjCZTg+L2M/GJAGMyHdlMt27iqu80nSkrsZkxGwEK+Wyzy4Xy95yoC41F4fWDxk4lsg3DQGocMNbK4ddo07WhMvdnarAx8rU9zKYcgy2bQwG6CErgr785HV9whQVMVLYv+ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpUNc4zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpUNc4zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D0BC433C7;
	Thu, 18 Jan 2024 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575574;
	bh=icoFE6PY8TEW8pmy6ua1JhWxiegQVgteMfTis8KBROo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpUNc4zQDDWTUyL3L3VnbA2bW9zOCoJ1rAgu0XTqyvaoWvdzGAinTxnXTRnGVctTZ
	 7HL5eeAJFs1MiTVu4NDgCahzn1NQxJOxqle96cJmQ46xNx4Lrjjfhyh59qivmpElaT
	 vRece1H9mCJdUUB9Y62rg77eXr1OhEtHkYKr530Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/100] ALSA: hda - Fix speaker and headset mic pin config for CHUWI CoreBook XPro
Date: Thu, 18 Jan 2024 11:48:11 +0100
Message-ID: <20240118104311.034364129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 7c9caa299335df94ad1c58f70a22f16a540eab60 ]

This patch corrected the speaker and headset mic pin config to the more
appropriate values.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://lore.kernel.org/r/20231117170923.106822-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1c8ffc5cf97f..beefb522a85d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7108,6 +7108,7 @@ enum {
 	ALC290_FIXUP_SUBWOOFER_HSJACK,
 	ALC269_FIXUP_THINKPAD_ACPI,
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
+	ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO,
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC255_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
@@ -7454,6 +7455,14 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc269_fixup_pincfg_U7x7_headset_mic,
 	},
+	[ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x03a19020 }, /* headset mic */
+			{ 0x1b, 0x90170150 }, /* speaker */
+			{ }
+		},
+	},
 	[ALC269_FIXUP_AMIC] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10032,6 +10041,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.43.0



