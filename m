Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA46E571;
	Tue, 21 Jan 2025 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482437; cv=none; b=Q1/+oos6WcztG+Ef6rtXocQt2zYzYHuWpqECuUHn6kPduxPjOBlkn86m92VNjogjdk60fFZ2By5VyNKemhvwSEcUUUcTSQzIa67/iYBgLra+fPrIzH/eGjhepfVJRQIXXZZlz/B3HPa0Bui4f0dxQZy96YZnzNznItcM44fYek0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482437; c=relaxed/simple;
	bh=DikL7T/B3rxqIpkp2rzyjBpsdR8aZjV9xVpyLBB0hEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc1g5FT2TFnFs3+Fm03TJl7DbXLvM4oP+p9desLSjpncm+WSbfCr7IQaVMRsUh44rUmJG00OUH1u+VWsZUyQhK4Ox2UrqoMSREbvJztgxCbNEJZJcyCnjJTuGMI7Pe040lLzBTt2tAQOyZQIgzwgoZlZAPEHJ0qLy3So3/EZzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkHBc7Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkHBc7Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2625C4CEDF;
	Tue, 21 Jan 2025 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482437;
	bh=DikL7T/B3rxqIpkp2rzyjBpsdR8aZjV9xVpyLBB0hEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkHBc7Lc8PdiiF5pZ4dZsCQdMvR1jKnt4Io/0YuEfmUSe/Zngtxt9i5+ISTNyvWDf
	 lXvGZ+SPNNBBMmFjrKeUPKSgZgsJ3Xp88MH3m4U7cS5/bejVigl1U78hjCL6tJyoX1
	 LDijqi4umsX79ivGMRkdR7eK0h6WZbg0segqTJnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 077/122] ALSA: hda/realtek: fixup ASUS H7606W
Date: Tue, 21 Jan 2025 18:52:05 +0100
Message-ID: <20250121174535.977249938@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

commit 44a48b26639e591e53f6f72000c16576ce107274 upstream.

The H7606W laptop has almost the exact same codec setup as the GA403
and so the same quirks apply to it.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250111022754.177551-2-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10625,6 +10625,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
+	SND_PCI_QUIRK(0x1043, 0x1e63, "ASUS H7606W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e83, "ASUS GA605W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),


