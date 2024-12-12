Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF591487CD;
	Thu, 12 Dec 2024 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017386; cv=none; b=nDsGNLIPf1o6xzyXamFYlJ9LwirKhwaZzsWT8T9T1jLP1RhRi08AivQKxEdFeSl+xbizPEMm6Hjo2N4/y7AOfwnH+7ZmhfBFiRfh4xuK8wMMZeRNqgan0GDDPo0Pxvm1u4g49A8sjr+Xr3bE4tetLyO6Z1pwtDkbcbklVRfZb6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017386; c=relaxed/simple;
	bh=EGu6xzX878jpmugpFSAcBj/JqdpLC9buPQIWDpAno2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0RYeNmSFbUjxIDgCW4jQIbw/bt2A8WmGVsGxi3B/Oi3CCwc8sHOCiVToM+MEy1M3XsQmMDELCqxvFvg39bmAKgFmeCpQNxnpHDIAMbxeR+IeAYpN2uAYwfYDD0TrHee9MAqtvqp1GlPVDaz6C8+xBpr/wQPKZrHVDN395qh9Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgbXPwQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgbXPwQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25BEC4CECE;
	Thu, 12 Dec 2024 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017386;
	bh=EGu6xzX878jpmugpFSAcBj/JqdpLC9buPQIWDpAno2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgbXPwQuLYUAw8jWht97EWLqQ16lK54vWrIYHgnn9wzZ+Gp4CqH3vEmNStjYTJJjt
	 8qgLIv0Z3BjDxsULYubNpFm+WZnapgaTTpTGHmOjr+i4kzOPrIfSGhw16u9WKOAnZA
	 lvxSv0d55NwhqZZdQ2nI9UZEKHEWgDCk14VqJZHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 465/466] ALSA: hda/realtek: Fix spelling mistake "Firelfy" -> "Firefly"
Date: Thu, 12 Dec 2024 16:00:34 +0100
Message-ID: <20241212144325.239277898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

commit 20c3b3e5f2641eff3d85f33e6a468ac052b169bd upstream.

There is a spelling mistake in a literal string in the alc269_fixup_tbl
quirk table. Fix it.

Fixes: 0d08f0eec961 ("ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20241205102833.476190-1-colin.i.king@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10512,7 +10512,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firelfy 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),


