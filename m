Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C728003C;
	Tue, 27 May 2025 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368519; cv=none; b=qNceQAfMbKBDaR20wTyeYR4WMiD6cBqaxNoVnmd706Kgm3A8nsw7umLNiBdH3L5FNmIxQ1SVopkElvFJCepaj13jllIdt9tqr5yBw4S4In8K/iN2pc6gXUzRTpDQxw13Nm7LmqZUBIIoCgCTI0YIgO1yDxNbQeUqokGjKJNy8Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368519; c=relaxed/simple;
	bh=xD0oBtAOBBbLYprpkXGfRIYU967ikzibJeMXP6RdA5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1F5yO+IVm8U71PJs3nyYEqgxRrQ4GIc/ERu6Im36M9nV6lWvgW/cFLgh9m/rfXVZetgaIZZL4RH3OxGUtecS1v1RO9o9RoG6wn0Jr4/Z8i9GA5WuX/ROrQP9EfRbbqtGEhuiCJG2kyth6A4bGunLgcGOe6qiyfFWnDLq9CV35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvPoRwYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvPoRwYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64F4C4CEEB;
	Tue, 27 May 2025 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368519;
	bh=xD0oBtAOBBbLYprpkXGfRIYU967ikzibJeMXP6RdA5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvPoRwYAQ7Ce0lO+piYF5myyiD8cwWrC1l8v+ZhMvTensRMmBouJFQZTpywtOQQe9
	 xOCNaPZo5ZVHRyYUSAlE8ja956Wk/M8gp4VcvZI+Ll8gtCSFLV4c9RU1zcQug2W52A
	 fCPkgoONAXjuDBJa2cpZ0ZJgbPxRHO9LzKaCwBs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Burcher <git@edburcher.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 732/783] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14ASP10
Date: Tue, 27 May 2025 18:28:49 +0200
Message-ID: <20250527162542.934365943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Burcher <git@edburcher.com>

commit 8d70503068510e6080c2c649cccb154f16de26c9 upstream.

Lenovo Yoga Pro 7 (gen 10) with Realtek ALC3306 and combined CS35L56
amplifiers need quirk ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN to
enable bass

Signed-off-by: Ed Burcher <git@edburcher.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250519224907.31265-2-git@edburcher.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11234,6 +11234,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
+	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TAS2781_I2C),


