Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6DB1DF754;
	Tue,  8 Oct 2024 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393706; cv=none; b=uiPPSYhxg0/bjzfaHklS7lmV35+FYIN0gK5IRIDoEtG9Esnm2oi2kRBaIfjZxyibX7fsB3xb2nvQ8a+ooaAa6Yy7UiANWcBmxfAr3ZhXMMDOD/MXpJYcNzNUNGAYGeg31zOCFkiAQycX31pLXIYUbSJd7z3iHP2HYPZs1jH/CbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393706; c=relaxed/simple;
	bh=Tn3t5fdjwmAbT4trlVxlqymDXFjPyw5rK2t9NKEyYZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arFbzOftFKirJULmbnHU5JU+6cwmkoO5YmHds94ijjJAna47vgCPNGSbDUTk0p9scyQArd0YbmP5Mav6QegYILdXwUcAUXLb/EeSwV8sRSdpxo2o2/+V6DIktVwC+RHqY68gCSmRF2rO/prUJWucbWAFORd5bpQVrVl4GySaPKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIatQI/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIatQI/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A7DC4CEC7;
	Tue,  8 Oct 2024 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393705;
	bh=Tn3t5fdjwmAbT4trlVxlqymDXFjPyw5rK2t9NKEyYZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIatQI/7nhgpzzIrnFyGYfIJXNke72QrSenILBea3Ip0sdKBT+gyilQ89HWSptYAw
	 WoXFvotn/yg8rkc1lW8PotKI/Me/79vW30owiIRwK1u4f+c1KsEhxl6MeXOwlmXYkq
	 nJBn3Xhh/WNbDej4WxjOsAUuUBbANtnVJXCLcwPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 224/386] ALSA: hda/tas2781: Add new quirk for Lenovo Y990 Laptop
Date: Tue,  8 Oct 2024 14:07:49 +0200
Message-ID: <20241008115638.221208200@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -10330,6 +10330,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x38cd, "Y790 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d2, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


