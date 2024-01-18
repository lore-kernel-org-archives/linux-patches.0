Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B34BE7F;
	Thu, 18 Jan 2024 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575773; cv=none; b=sWPuWU95nYYG6IooAwpUy3fzSQeWwEeIq1ktRyhctfcXqjSBuEnn344Gk2Kht3YLJjwb9umSQ7nsdOWLYFf8Kqup6TUEetJbfOGISLEFQ8/NlcwVJKWeWaPsTkzqO4w+pwOijM651FdRN0xfSN4cCJA1QALE5aInlqsW9ge53jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575773; c=relaxed/simple;
	bh=xS2AJ6lREOk6xZaNgfEFi/jjudxommn45Ita2L98fHc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=g7Irf9qDmMe7jBadCBUXBOM77y/5V/XQN5Iv0yE4NvVvF7tYNhQyuTGMZvfeI9NYiW/STIGqmqp/BVLRnfIPg2tc9Cwa16DdSoz+CLxpGVGRhIGt0j+U/8oQ+kQIFoROS9KeJkolsdtcaWUvDi47ed5egLHVpx8BLml0164FFyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHWUQsn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHWUQsn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D4DC433F1;
	Thu, 18 Jan 2024 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575772;
	bh=xS2AJ6lREOk6xZaNgfEFi/jjudxommn45Ita2L98fHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHWUQsn2CEDLLN3cOeOSidWhfvuzawwH+KDR8+uUtW57TaxjBYhS0a9xh0iPGLDHD
	 JX/C5k64YwsIC5wP5MWJwLy4a2bdALazdj+zABJbWdkFwbfnP1ZQ4JTV1orSrRRJx+
	 2tJCa+yrplQImuYXKOFOWxJlI+jQ9O8rKHgaqnew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/100] ALSA: hda/realtek: Add quirks for ASUS Zenbook 2022 Models
Date: Thu, 18 Jan 2024 11:49:17 +0100
Message-ID: <20240118104313.950531546@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 51d976079976c800ef19ed1b542602fcf63f0edb ]

These models use 2xCS35L41amps with HDA using SPI and I2C.
Models use internal and external boost.
All models require DSD support to be added inside
cs35l41_hda_property.c

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231218151221.388745-6-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index beefb522a85d..24f7f6d98922 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9779,17 +9779,20 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
+	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
-	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.43.0



