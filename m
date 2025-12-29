Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01A93328F9;
	Mon, 29 Dec 2025 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025882; cv=none; b=u5aNJHglrh2NW2alwfdEZMHO++nTsxYTsSSDLELWUNgA/DjvKDGboi0ypoU0mqq2YR6J/nph4QXGYb/BJydj8l9NgD/lBqAi3dsMaHZWir9tuFKgQgybKh5EPbOHNdIWMbs1MQPXV99JPZHB/9Ykjyc1HIJMW45689UVRR5Oxms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025882; c=relaxed/simple;
	bh=xFuVAnIqpRu8v+vYORtigU7rx0/NAaWK7xks099hIkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp/zpgxQtnZX1xBa/SWJbhr0RJ2vZSyzVsxEG2ZT4zeVVcDDboEIaVBvlqxmmKGhG8towDSXZyjNbA5efAvaTMjDj5rb2/gEVVE8OWAA35HaDhP8q4dvatMjicdkDEMnZ/L2VcDwkcm0KK4MsKfdq4sdpBnZLbJBDgP8nwzGlOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w23uUkQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w23uUkQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8E7C4CEF7;
	Mon, 29 Dec 2025 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025882;
	bh=xFuVAnIqpRu8v+vYORtigU7rx0/NAaWK7xks099hIkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w23uUkQcv1P9MLeJIqk1CTR9TWLIqCn0o8bymQNQMRSNJ2hxgsdpfKEWFKR+QymLS
	 ZLn9zF2KA2LWUl0QMkTxRBR6JDGWZcE+dKqHUueRo7iDJ48id0t5snxO+VI2Ap3Gqk
	 Nz+N5NOuJlXhB77Hgr4iLEQE/sgcQFylmHe7EVWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 370/430] ALSA: hda/realtek: Add Asus quirk for TAS amplifiers
Date: Mon, 29 Dec 2025 17:12:52 +0100
Message-ID: <20251229160737.941290712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit f7cede182c963720edd1e5fb50ea4f1c7eafa30e upstream.

By default, these devices use the quirk ALC294_FIXUP_ASUS_SPK. Not
using it causes the headphone jack to stop working. Therefore,
introduce a new quirk ALC287_FIXUP_TXNW2781_I2C_ASUS that binds
to the TAS amplifier while using that quirk.

Cc: stable@kernel.org
Fixes: 18a4895370a7 ("ALSA: hda/realtek: Add match for ASUS Xbox Ally projects")
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20251216211714.1116898-1-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3703,6 +3703,7 @@ enum {
 	ALC295_FIXUP_DELL_TAS2781_I2C,
 	ALC245_FIXUP_TAS2781_SPI_2,
 	ALC287_FIXUP_TXNW2781_I2C,
+	ALC287_FIXUP_TXNW2781_I2C_ASUS,
 	ALC287_FIXUP_YOGA7_14ARB7_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 	ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT,
@@ -5993,6 +5994,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	},
+	[ALC287_FIXUP_TXNW2781_I2C_ASUS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = tas2781_fixup_txnw_i2c,
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_SPK,
+	},
 	[ALC287_FIXUP_YOGA7_14ARB7_I2C] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = yoga7_14arb7_fixup_i2c,
@@ -6736,8 +6743,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1314, "ASUS GA605K", ALC285_FIXUP_ASUS_GA605K_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1043, 0x1384, "ASUS RC73XA", ALC287_FIXUP_TXNW2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x1394, "ASUS RC73YA", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x1384, "ASUS RC73XA", ALC287_FIXUP_TXNW2781_I2C_ASUS),
+	SND_PCI_QUIRK(0x1043, 0x1394, "ASUS RC73YA", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1433, "ASUS GX650PY/PZ/PV/PU/PYV/PZV/PIV/PVV", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),


