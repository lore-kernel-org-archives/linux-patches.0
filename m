Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DEF7317D;
	Mon,  8 Apr 2024 13:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583634; cv=none; b=rCdTKq2JzPd+a66LCa6NhfuDkZnWbvz1n2Ks/1/7Vm29U5cQTbewE1oA6UUUntZkkzihxdtRv4BIYamhm42aYwFc8dgY8D5COG2tQe/j+NIHu/QO0MqaQDqavPTmiBxm7Co61aZG9BYYl+Z4IAe79pT8Wu2sArfC0EGDecDTB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583634; c=relaxed/simple;
	bh=vCRK9WzUeCCoykNQTc6cXnfyFl4kik/2ltD94iUHeDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrMm8gKC/rTp05kiry++D1OWmqcd7XXvYuyBhV5tENiKzjUCyNS6MDJR02MAPTBElZuggm8DEkPjYz9dNKvbV+Dt59U1XCORL0f9MkPK1/rqCFPmqkfeH8qELAb+zFUBLz/4S2Rrh9E9Dh6RaoEaj75MzExC2fq1HdXCq0Nf3+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYd38rsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYd38rsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FEBC433C7;
	Mon,  8 Apr 2024 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583634;
	bh=vCRK9WzUeCCoykNQTc6cXnfyFl4kik/2ltD94iUHeDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYd38rsui2yAV+4QpJ3Y64y29HZewmHJDQcS1PPwUWCYedmV9bo8GsaoN6BHe9tNs
	 Bq37G6oX8j3T0nJYwPk8emOcdeHus/MbZzywVq5dkJfVkWZyoMAP5Qpe1CajhGcvpt
	 XGdmZfO5N4n+NcjuStFJfC6UHufhPMz0FeaywJWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bendiksen <christian@bendiksen.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 203/273] ALSA: hda/realtek: Add sound quirks for Lenovo Legion slim 7 16ARHA7 models
Date: Mon,  8 Apr 2024 14:57:58 +0200
Message-ID: <20240408125315.638338037@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bendiksen <christian@bendiksen.me>

commit b67a7dc418aabbddec41c752ac29b6fa0250d0a8 upstream.

This fixes the sound not working from internal speakers on
Lenovo Legion Slim 7 16ARHA7 models. The correct subsystem ID
have been added to cs35l41_hda_property.c and patch_realtek.c.

Signed-off-by: Christian Bendiksen <christian@bendiksen.me>
Cc: <stable@vger.kernel.org>
Message-ID: <20240401122603.6634-1-christian@bendiksen.me>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda_property.c |    4 ++++
 sound/pci/hda/patch_realtek.c        |    2 ++
 2 files changed, 6 insertions(+)

--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -98,6 +98,8 @@ static const struct cs35l41_config cs35l
 	{ "10431F1F", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
 	{ "10431F62", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 0, 0, 0 },
 	{ "17AA386F", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "17AA3877", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
+	{ "17AA3878", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
 	{ "17AA38A9", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{ "17AA38AB", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{ "17AA38B4", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 0, 0, 0 },
@@ -435,6 +437,8 @@ static const struct cs35l41_prop_model c
 	{ "CSC3551", "10431F1F", generic_dsd_config },
 	{ "CSC3551", "10431F62", generic_dsd_config },
 	{ "CSC3551", "17AA386F", generic_dsd_config },
+	{ "CSC3551", "17AA3877", generic_dsd_config },
+	{ "CSC3551", "17AA3878", generic_dsd_config },
 	{ "CSC3551", "17AA38A9", generic_dsd_config },
 	{ "CSC3551", "17AA38AB", generic_dsd_config },
 	{ "CSC3551", "17AA38B4", generic_dsd_config },
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10361,6 +10361,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x387d, "Yoga S780-16 pro Quad AAC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x387e, "Yoga S780-16 pro Quad YC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3881, "YB9 dual power mode2 YC", ALC287_FIXUP_TAS2781_I2C),


