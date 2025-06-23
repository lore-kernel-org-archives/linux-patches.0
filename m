Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85DC224AFA;
	Mon, 23 Jun 2025 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715973; cv=none; b=kc54FoUgm2tJBmbUIV94kx0WsfwZgx8c5UQvVfJMAjIYHMfba1VMShtR/A2gnJ4Ejfr8C01cD3zTalZ3akVqHng0+m92y3M0wV1SUKLNgT2uINVTzBU04OPKjaISdUitZLNOiDyPqCSsq6X5nIOCA88ESnB6G8k79dnNYw4DdY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715973; c=relaxed/simple;
	bh=xPN7JKgQGk/KLoQjZikTnmb66yyaHQAVYNuf5g5VZo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SByeZRowGMwC3c06YAJ8oTLp+z5r+BcA1ksGsE5zWf/o1hyesihJVthzbyQvujdVkOz7i7O52A0MvfB1e5hhThSUu/IqpZuCBM1rCcnEbxddx2wvp/8jn9Pgt4M2tBpIxWjPOTT1SYK2jimGOU71q2lEq7C7gjMrp6bMkWhMz8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FG2D6YOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FG2D6YOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFA2C4CEED;
	Mon, 23 Jun 2025 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715973;
	bh=xPN7JKgQGk/KLoQjZikTnmb66yyaHQAVYNuf5g5VZo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG2D6YOTgxU78BsGMqEF8gq12ssPtdbK4R1cTnD5FmT/GluAZOo9WV/JXJM20bbhG
	 EPnEIv+r6fLRGATLfRibO1jNzrAwdFj7h40NUUNrD2fdIorDSHtcxJZneqH4GU1bRC
	 FjUaTZaU8y0ljnOsVL84nNl6WLZv+Aps/TzWKbso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 494/592] ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X513EA
Date: Mon, 23 Jun 2025 15:07:32 +0200
Message-ID: <20250623130712.182144534@linuxfoundation.org>
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

From: Chris Chiu <chris.chiu@canonical.com>

commit c6451a7325874c119def1d4094f6815c0c8fdc23 upstream.

The built-in mic of ASUS VivoBook X513EA is broken recently by the
fix of the pin sort. The fixup ALC256_FIXUP_ASUS_MIC_NO_PRESENCE
is working for addressing the regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250610035607.690771-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10907,6 +10907,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1032, "ASUS VivoBook X513EA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


