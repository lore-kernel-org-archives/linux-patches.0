Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF714BFA2;
	Sun,  7 Sep 2025 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276328; cv=none; b=TS8XGxuEYQCoPIsI0rg669Wdb5PaNF+yJswgBq793nCcHfRDfjr4YWwKr3D8mUSWCR2lLCjvTMJMQNOLbD00TCOcyBLgBv8m9ANfp9zKhjNoeK4au6uUUZg0XYD+cBg4XtP0UXnZr8Kdah/Wfk0NFpb+8V+Hv8vXxodfACSyZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276328; c=relaxed/simple;
	bh=TPhfzhoVDnbNL0+kvqoo/eDHZTPSDL0q7E8qYkhq+y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o50SHtVIHf/YDZ2Xx0uWfFN9lrIYyezE+lf/Y2ctXX56HENxVwNZuzA39qt1yd1MAArMfptFV1Gb6Hkst8XgjIR9Ps41N+FwR6XZIRUdMhkQif/pcZLsUDtZKiuSFNlTHsi7cSkMlk0yNDLDiDif/kA4DD8con5+BIdTbPWAMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ID4jOzkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ID4jOzkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D600C4CEF0;
	Sun,  7 Sep 2025 20:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276328;
	bh=TPhfzhoVDnbNL0+kvqoo/eDHZTPSDL0q7E8qYkhq+y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID4jOzkmA29XyPBhATUzhzbqo1OIBHklkW9Z5XTu3CX0p9+LHBWh9/WmP2I+VXYeD
	 CKC25KZ8QlZuygC3q4+WLxc0Z0UIPBdSOy0tG3PL51nDAPnyffYxeitPKUYPIFxEGg
	 kOT+NyIQPoNQhq0cl43INV9M3loCceqxViYMD1p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/104] ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup
Date: Sun,  7 Sep 2025 21:58:20 +0200
Message-ID: <20250907195609.313559817@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit f709b78aecab519dbcefa9a6603b94ad18c553e3 ]

New HP ZBook with Realtek HDA codec ALC3247 needs the quirk
ALC236_FIXUP_HP_GPIO_LED to fix the micmute LED.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250520132101.120685-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10093,6 +10093,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e1d, "HP ZBook X Gli 16 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


