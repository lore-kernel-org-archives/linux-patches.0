Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F319EEC6;
	Thu,  6 Jun 2024 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683556; cv=none; b=hSQVB1LuON5NRC+rH/8XJWFRjy7IL2L6Zc3UISKDKmgQtBA+ZbVNdHQpCXdVvcbjADCzevl3T8+bpyadiO+pif8gKHFy/+V6gppb6GjXUbVmDuHaLNy36H1q8jlZ1urdEOAyOFt56CYIsDzH19rmwyMrmPzjbDcbImdtQC7IzKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683556; c=relaxed/simple;
	bh=e4baXh57UCybRsIfx1zKI3hmVcPWL6PGxf/odJ6s6No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cw6XmcJqP0QJJUgQYubuDpDfil57EkTG7uERURhW8Ac+eBMnqwvasN+Ze0KilaUHdFaLfiAX9I03egjiT91aYEkh/s1avLzaWGMRDmKJTn/SahDDX7qGIZY+v8xTRMTDfcIQilnVWomaCSEuvv5t5mnz1FvvOWfFNHb6dQGTcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waPihUHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waPihUHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85110C32781;
	Thu,  6 Jun 2024 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683556;
	bh=e4baXh57UCybRsIfx1zKI3hmVcPWL6PGxf/odJ6s6No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waPihUHjl8W6joxjXYmJByEg2H/sWIuC3oVAbTXIeIQ5pv7YN7cYha67dF6fcfCBa
	 N6TtPvEOvCOrpZYYkz6BpWegeSsRcriAsScTZRi72WwMpXYpLFo3Y/CdAmAggZtE6b
	 lC/hv0Y4jAawxnQ9gZ4KmrzzImB3LHhG0UdDzc/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 447/473] ALSA: hda/realtek: Amend G634 quirk to enable rear speakers
Date: Thu,  6 Jun 2024 16:06:16 +0200
Message-ID: <20240606131714.496228667@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit b759a5f097cd42c666f1ebca8da50ff507435fbe ]

Amends the last quirk for the G634 with 0x1caf subsys to enable the rear
speakers via pincfg.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230704044619.19343-4-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2be46155d792 ("ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4d7c23b20cce0..c08bf42c602dd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7207,6 +7207,7 @@ enum {
 	ALC285_FIXUP_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_HEADSET_MIC,
+	ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS,
 	ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_I2C_HEADSET_MIC,
 	ALC280_FIXUP_HP_HEADSET_MIC,
@@ -8214,6 +8215,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_ASUS_SPEAKER2_TO_DAC1
 	},
+	[ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170120 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_ASUS_HEADSET_MIC
+	},
 	[ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_speaker2_to_dac1,
@@ -9860,7 +9870,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
-	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
-- 
2.43.0



