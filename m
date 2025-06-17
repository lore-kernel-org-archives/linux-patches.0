Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509F61E98E3;
	Tue, 17 Jun 2025 16:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177842; cv=none; b=SUE2ftU0TgVWBvcWVhlFSEWtkpx9kGMEwmSnW445w8MlZkU7BYfTxlVbZ5J1QXo/5Sa+Frq+srl+Y7wdGxx6tYLZ0dvqXEZQzqL5p4ewvqTmeUnCkp/cDwjt7WiYh+1iY5s3+DNGFLlTQ3q6YPG8VJojP725HzYHWRy7kuqlOa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177842; c=relaxed/simple;
	bh=9q2Dq3MCiqkDUZf1e7LxAzef6RvUcCL2nZi2Ot93Udg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjjVhq6Pz3hNTcv9rlsYTpsElemhbAc9ojaKmt9xJATsd3h+57VJ59O5kGSYWfvAOVPbDJT3InQ0hcub8uoimX+AHnwBqaOu9/Gul+rd2wu024Yl9KteEKEVyW9VBscR4nrBdLOIv3R2XnaqE1Me7oCjyvnFPHW1d96L8K7kI58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgEC6Uzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgEC6Uzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43FAC4CEE3;
	Tue, 17 Jun 2025 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177842;
	bh=9q2Dq3MCiqkDUZf1e7LxAzef6RvUcCL2nZi2Ot93Udg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgEC6UzkQw+omOZjK8MKaaOqcc0vYIfFgwqPzEMT6EopMh6acPA0PHkfHQFD8jTy2
	 N4skzk79qUjLdrKiDWdzDPaQmR9K3uMsQlrj3W6UMAQe1LusjKiF7PMLFqhtyjlY7z
	 s11z49OheJq0ARzRlu6w2IeRQDN6ne5lu3Bos8iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/512] ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup
Date: Tue, 17 Jun 2025 17:26:10 +0200
Message-ID: <20250617152435.951868126@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit f709b78aecab519dbcefa9a6603b94ad18c553e3 ]

New HP ZBook with Realtek HDA codec ALC3247 needs the quirk
ALC236_FIXUP_HP_GPIO_LED to fix the micmute LED.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250520132101.120685-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10828,6 +10828,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC245_FIXUP_HP_ZBOOK_FIREFLY_G12A),
 	SND_PCI_QUIRK(0x103c, 0x8e1b, "HP EliteBook G12", ALC245_FIXUP_HP_ZBOOK_FIREFLY_G12A),
 	SND_PCI_QUIRK(0x103c, 0x8e1c, "HP EliteBook G12", ALC245_FIXUP_HP_ZBOOK_FIREFLY_G12A),
+	SND_PCI_QUIRK(0x103c, 0x8e1d, "HP ZBook X Gli 16 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e2c, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e36, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e37, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),


