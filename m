Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825622D785;
	Tue, 22 Jul 2025 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192819; cv=none; b=fQsq+dG+CFeiTGdG2+3PwySpPbNViOywbPZXB4vI4TqNhKbBcq/qJQz/dqnGmFvAThFADtGNg54suk6HMxGWms5g54UKbzHJmiVygrPCbBMpCuwyUyPtwp9cDOqyT+A2wYDIkN9KNKLXWzc7qj61/cpgymBvjZslomENX0Sf6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192819; c=relaxed/simple;
	bh=iz7feAaAEpPH0t6I2NGWvB7LS1xnjMYR5fC48bfBdDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s16+H9PFHisc7VMWh+Jb+mKzFWVtnC4mV3GCyekxNupOPx8cttaGQjfwzR5bED9rel9a3yezZGa+FX97VAo/46wQLedqCqvelT8jABSa1ZB5kOxqSfvIhMnjanQB9kedB0aZM1zTNVsDi7b1aCaEAAX2Ao6du01JRntrI9uFpn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWpQKeQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWpQKeQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB4CC4CEEB;
	Tue, 22 Jul 2025 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192819;
	bh=iz7feAaAEpPH0t6I2NGWvB7LS1xnjMYR5fC48bfBdDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWpQKeQG7+Wq3xdK/lna0LJ80C0wbxMW/lVbEupF8/D2zJDNCjEEw15IBdNV6OjfH
	 XG0+HiHGh0UIq7Wp69xIhJQPWhVMVJkDxP6QTNGauIjmc9U5rLAfrfzXAlxOrpSyEO
	 bi+Tu9ibj6TDTpOE7yhb24qmTQLy7Weq/ARw64Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 033/158] ALSA: hda/realtek - Fix mute LED for HP Victus 16-r0xxx
Date: Tue, 22 Jul 2025 15:43:37 +0200
Message-ID: <20250722134341.987212335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit d9b99eb3d76a603442311926617654f0e35581d4 upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on Victus 16-r0xxx Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250710131812.27509-1-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10731,6 +10731,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bb3, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bb4, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8bbe, "HP Victus 16-r0xxx (MB 8BBE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),


