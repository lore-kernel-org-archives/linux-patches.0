Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0272ECD38;
	Tue, 22 Jul 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193377; cv=none; b=MC8jqGSrefaKfyuX3JZKQaZ8lv1Y+PZER+M+3zlr7WWuaYzgQFMRAt+NNrRFj5eA45T0axtyLqZLKilIoNaH7FMIx3NV0pcvJVsJ+PZtaam1HZCFX1P32q/SVYZuS/YbB3xZJQPbCvrtR3GDVoCnir9NmUUVrfG0AvztKPKwHDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193377; c=relaxed/simple;
	bh=DoESKRfz3cdfOD9Z77hLrV8rmUA8xyj1kypkKaPm8T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI0XFF61ehHaIRhmAZ9bjRUMeDg3AK4hcZVGjjNLgGVdKAOA50yyivc77nFde9jfW8QIIz9UH7zCIauAl+Q8MZO4PtDQF/szXKPm+oX714uavCoJBwwHnDexNpr6nbZ8UyhAVZKHIwzRf0MxB+3DjN4bWE793aM4r/zVw3On760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6+6cQBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6+6cQBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416CC4CEEB;
	Tue, 22 Jul 2025 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193377;
	bh=DoESKRfz3cdfOD9Z77hLrV8rmUA8xyj1kypkKaPm8T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6+6cQBnTWAXqgQo6G23o+0flGYGl/RHKl1L9iaLAInpeiujkY3FnS8BBmJD/sTsN
	 nwtM0s4ex6MY8cvqumpP6XOZgd30Ta7gH9q6oOl6DlIcJUSL/ghj5mLgqWWnJn+W/k
	 FGzWerFpEpWTnYDiJiipGPz0qeHrg0f3RIPZkqnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 040/187] ALSA: hda/realtek - Fix mute LED for HP Victus 16-r0xxx
Date: Tue, 22 Jul 2025 15:43:30 +0200
Message-ID: <20250722134347.249316415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10791,6 +10791,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bb3, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bb4, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8bbe, "HP Victus 16-r0xxx (MB 8BBE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),


