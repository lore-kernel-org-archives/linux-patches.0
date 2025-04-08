Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1126A0FD;
	Tue,  8 Apr 2025 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116808; cv=none; b=phUUwyk5wuZMOX9Y7/VLGYAVtML6teKnR1WS6WBo0AEOq5VuK6PH2KXyS/oqrC+0pyxw1wreqowaUP2dYM1f2ySYRPbLV5bNPvGc/n6/Z0QKZfs/jx962JruopFQ+MaxwkH+bAXBAlhbRIpGDg4H1RlYT3EKBwIEnIeTlhV3E4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116808; c=relaxed/simple;
	bh=e3VJT/a1IGGO1h1g2NE0pMyyi36cvWjWDlfi0ss9g10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eizcF0GcAf2EvgCqlJx4KHbEJbHyh3dbjCBiht/9AUrbPPIlt4q2HiMcT6Mxk/WCo0jgjVVUM9ddjqPg7WPDQvleLXza3nQVKwBJSmw3Quv8tflzeFjA5hUMluq5phOa2B2N4fNtt6ikd4BJRYwS5sM8lXxUsTFRAgu/rT9b7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVI00tvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVI00tvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6E0C4CEE5;
	Tue,  8 Apr 2025 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116808;
	bh=e3VJT/a1IGGO1h1g2NE0pMyyi36cvWjWDlfi0ss9g10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVI00tvU8MDPB47Kq6I9bnygRLoz+vRfFGiKyJK887njJmU8Q7p11ENZHPurAAcQa
	 SxAlSikp3SWI40STu43t0noYOZ/SGFqd2iUS4IBF8mlYD/UcAmEiZ8IgJO3J5+CN/A
	 QlzmDsOrNM2EfRPaVineU3Jw/g3VQwGKoMJQNRqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/423] ALSA: hda/realtek: Add support for ASUS ROG Strix GA603 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104852.222196876@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 16dc157346dd4404b02b42e73b88604be3652039 ]

Add support for ASUS GA603KP, GA603KM and GA603KH.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-3-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 93986c0482f07..a960ef29a7036 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10727,6 +10727,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a60, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
+	SND_PCI_QUIRK(0x1043, 0x3d78, "ASUS GA603KH", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3d88, "ASUS GA603KM", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e00, "ASUS G814FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e20, "ASUS G814PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e30, "ASUS TP3607SA", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5



