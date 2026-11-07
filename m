Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063489;
	b=QhFIl0WSCO/RYAmBxv5LxGs9Nm6CmqcUDgrytqsefIHKhW2bRSfZnDCUowRRHsny1+BB
	 IIcHMVjZd5LzqFRPi1IW+LW7mIhio6T6DygqJjlcQ2cu8bOGQysyWjN7hgGUuNezjsMrv
	 TG/gybCRSDDdXEeo1HBlmd+/4IiuTjG8zs7dR+iYpk+lxeZqmePlZ+Lm6p2/CvBS4xjWy
	 2CcLah04kHZsmawCE//3nISgKuVjxN9VJ3LgZ6OqqcgcKiD01761VBLGJEHjItB20TMX5
	 +1HFwZVJdc7S31fCtD1rBheEqaZqgkUv9njuPGUHNM0R+qw0kGWdwH6UScuBO3hOVug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPOqOlXPRDIjYXAn/27Yi+qGXPOWAAqRDsZt0+vatyY=;
	b=W9mFeZuYjk/I6c7LUQ89KoM3eSq45r2VJzoCdjB6e0OuirLYd+JErcNiWwvm/BNvqo66
	 Z8+Xlnxi0eH+kdmDCcCtb7AjR23IA28B0pAORM2NGCuE/8vgEXO2I5RZBk9OiAY67Eug1
	 4xIkjRTO1E1RGfMUcoHvxueqILtrYVaWxJznvxvYy52KPylbc3KhykEXxQcFAT2onSKBv
	 4qy4CJ1xgDutDcSEGb3B66u7+HiAVdfPFznyrkuzZm8guueeik7sliY6WkvajH3x1V1S8
	 /hP7xtcYLhcigWiVY/ElT+Tin7fUHBPVrPcbVrWRoVoHQ+Nl77CTnlIWuHh16KfCcsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOmC0eYR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FA5606B884;
	Sat,  7 Nov 2026 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOmC0eYR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164DC1F008A6;
	Sat,  7 Nov 2026 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063489;
	bh=MPOqOlXPRDIjYXAn/27Yi+qGXPOWAAqRDsZt0+vatyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOmC0eYRi9/ODC/Y1Rjf8aUcJVB1Qg2T+P0paW4a0t8atmtRdrwrDgwOPuHw0u1OH
	 c5wrfKItHXqWFLAHXqWb4kuHzydcK+xuQ+NragIMsoTxUQEdMSNXkFxOZazEhyE/cb
	 ZaaNuMAqyQNz9oumdeiB2lgiu4LwFodr4bwNgjUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 635/869] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Sat,  7 Nov 2026 08:55:17 -0500
Message-ID: <20261107134914.480088277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit f6e8d5ebde5ceb7d3c0eef6e9e4d82862b503ade ]

ASUS X55A requires the same workaround like other machines with
VT1802, otherwise it loses the codec power on a few nodes and the
sound stays silent.

Link: https://bugzilla.altlinux.org/45606
Cc: <stable@vger.kernel.org>
Tested-by: Nikita Maksimov <nickstogramm@yandex.ru>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20261017101257.215166-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/via.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/via.c b/sound/hda/codecs/via.c
index 6becea9bb810c..b35eb727cf2ad 100644
--- a/sound/hda/codecs/via.c
+++ b/sound/hda/codecs/via.c
@@ -933,6 +933,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct hda_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



