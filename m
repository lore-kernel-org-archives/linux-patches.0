Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061144;
	b=WYOqsD3Zyq8ZzBkAHhIGg06xk+JB4xexBR1ZcfpTNmn6fIJm5gmvnHHdL9VMHjonkZuv
	 jpaWy33R8YMT3/A5cxl0S138hNZYJoRL8ZyJHkuzD0KhxkR0v5vxXGT6qJNi9Qs0Jj41u
	 d9OImfxER2KaxI71m4BHaNC8BaOvgPpQ3F+hJeBhyH0f+hnhsdeM08/X4WQZZr2mNWRdG
	 +Odk4p4BKG5RTd6sKQVTo8z0Lf/96q29UuB7N5sEcwtGluQs9eSiQPVnHH/mshwiFb6p3
	 bkDGTf0Fda92ECyBFb6iyplRC0NHwlchzZDaa2/yWjUpV2jO1HbyDGSipVDpPI08kbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LEcXQRrCFYpZZyiZSZy8wIciQ6iLANpv9x067pdVDoA=;
	b=Vi3ShnGo83I/R0+AbDwzSlt+OCIuIrAZQ1JmKe43FBTYPp9lnBOWPp1m1QVP2D8INrhx
	 byGdpIHyWlU30hbdYwFGr3pxl9UePCy+q2CysisfyFyzLBo7Hw2QWTngPPyd2OdUS5gxx
	 GRExCA2GE1ZzNstp/h0TpjMTTVbsGw1E3w9+/Jywmelw7MNjhrohn1N9KKkI2lVomIXiV
	 yWdBuJ/tdoSQjipYzqZejKIDmVGRwptZYePl/bESZpqtpgKdsxE9bae9hhWyNuRblOToH
	 APLIH2Mzw4uEDFttHQwNuHD2HKQGZUDg9MPZa4eE5OgmfnjICKyV8bGcGesa1qgQfxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5KygpBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC228606D810;
	Sat,  7 Nov 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w5KygpBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA821F0089F;
	Sat,  7 Nov 2026 14:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061143;
	bh=LEcXQRrCFYpZZyiZSZy8wIciQ6iLANpv9x067pdVDoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5KygpBD/BBeVPNdkOl/6GY8nS12o4toGdiNSh4z5PIMHtuvEVpYesyatTLkaXBHo
	 h3XNtneO3puJv2iHL+UYW9TqHliFGHQwN44BjC9WfKYLJffk5Uz8b+bs5S5Ha4VRcr
	 WqwISUbhdIctrf2FTAdp6mpcfxt5w7oAkxJVw3ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0415/1536] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook G8+
Date: Sat,  7 Nov 2026 08:40:31 -0500
Message-ID: <20261107135009.229691465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 4322ac247f4ce7932edbd46aa37f3dae62cde424 ]

Fix Bass Speaker volume control on Lenovo ThinkBook G8+ by adding
quirk 17aa:38dc with ALC285_FIXUP_SPEAKER2_TO_DAC1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221799
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 52aba6f9ce6f2..cf2ffff796d69 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11649,6 +11649,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38d5, "Yoga S990-16 Pro IMH YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d6, "Yoga S990-16 Pro IMH VECO Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38dc, "Lenovo ThinkBook G8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Yoga Y990 Intel YC Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38e0, "Yoga Y990 Intel VECO Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f8, "Yoga Book 9i", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



