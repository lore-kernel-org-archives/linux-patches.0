Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B737221DA8;
	Mon, 23 Jun 2025 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715990; cv=none; b=NmCNbFECE0zMOlDDtiRCAw99TQMukszzFQLzMGGicjd+nNyGIqTgvPDu+VDa/l3Up8k57/M2WxY9ZlVZ/qkJLGiSPwGxtHVMzXh9yrP3AiaftoN7nAWpWY74vWpaCD2K3S9wxO/zJCaeq2BjiWayGISzoao5y2HwvJyvmeqVlMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715990; c=relaxed/simple;
	bh=2blfCXFKmwFtE8hXEHOSf6n7CF9mnJ0IxUuWZxLaI1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMlWjaMLTxAc65MHGGRill+6RcTeQuUilAZtRAx4e1J3xsJJ0K/kozRhr+7c2dTZuQSZHUS5nIUDxkWDbBkbUspl2HYAGzSqL7Pzxy49UN2vupcm9gS4YRWcLTGkw/bCN42iK6J4pzt0glNpjtoMzRl4AD8JVkT4l1jblHnq7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/8QKf+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/8QKf+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ADDC4CEEA;
	Mon, 23 Jun 2025 21:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715990;
	bh=2blfCXFKmwFtE8hXEHOSf6n7CF9mnJ0IxUuWZxLaI1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/8QKf+S7fZKWm6uIMYm4zU541boKm3EbvruVHgjdMroI04cbjNG26dLDBWvfCrPn
	 sKuf+RxkfNVEzZroIDqjqAJdvW14hH78CjXVe90ba+iw3YPvHZfsAZf7M5YZjTPX8w
	 2hXwwve6Atd9Z+TmwNgWFeJSH1xKvsxE/zak3mhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Nick Karaolidis <nick@karaolidis.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 495/592] ALSA: hda/realtek: Add quirk for Asus GU605C
Date: Mon, 23 Jun 2025 15:07:33 +0200
Message-ID: <20250623130712.206040397@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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
@@ -10908,6 +10908,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1032, "ASUS VivoBook X513EA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


