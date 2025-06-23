Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AC61E3DCD;
	Mon, 23 Jun 2025 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717195; cv=none; b=h630IGPnfjb7OqouzBMxDXt3QHRCD1eQVdYzQi9pqPsC0QigHgazID7JM6m5/mtW7bajnajyMgBY6lCA+5mDPquWCjK9+5f0GprcqfS7o+JCWGloSAz+BRQ+JyKCal13qhHnv3Fcv0/n8NdVDlNj/AhCfzbY8Hn/xcByD4C+lUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717195; c=relaxed/simple;
	bh=kQ+EtbMakcFyG6zKR9OCV8lpDoiJnts9cRt6DvxT7SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUQluU/ezUquY/JNV5b2sJbW9Ru5qLBtHv5652eTTpcsBJ+up0W6D9aGubiIxn10DoxZDCxEZ/ntTqSwRoSixJVrx3jX0QbXjD75fHJfD0zn7+YayGbJgi47GDIKCJpIfkuC+5FFNA+Aaoa14X2YxR/qMX6blX7HY92hPm4qhg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBGLE+o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBGLE+o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1107C4CEEA;
	Mon, 23 Jun 2025 22:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717195;
	bh=kQ+EtbMakcFyG6zKR9OCV8lpDoiJnts9cRt6DvxT7SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBGLE+o5GG18Y+7mdXOtY56R3uWRNa0ij9gbNx7Nd6LB21qDjyq6od8tBB4PcXU5F
	 sgB9CAFzWxrXei6K1QpcyPVA8rHPH6mAy9R3fSSIwqfLDc0WB8VTTHv4h7WqZKhTZL
	 Unxv/3TNK5QaJ1CRatq89eSWyTsgNnGmO10E9Dh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Nick Karaolidis <nick@karaolidis.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 336/414] ALSA: hda/realtek: Add quirk for Asus GU605C
Date: Mon, 23 Jun 2025 15:07:53 +0200
Message-ID: <20250623130650.383276623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 7b23887a0c70d15459f02c51651a111e9e5cab86 upstream.

The GU605C has similar audio hardware to the GU605M so apply the
same quirk.

Note that in the linked bugzilla there are two separate problems
with the GU605C. This patch fixes one of the problems, so I haven't
added a Closes: tag.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Nick Karaolidis <nick@karaolidis.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220152
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250609102125.63196-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10841,6 +10841,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1032, "ASUS VivoBook X513EA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


