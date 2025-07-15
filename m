Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03A2ED87C;
	Tue, 15 Jul 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587129; cv=none; b=gB+9qXdUyF3Ki/GII4pirNQApGYVXwPPI5xvCVJCQPl4XDbk/f3AI3inUZ6ff0gXnhg1QHQMTHsbPXXD6O8WVby7qBYTjNovyHaPT4FtC2XN/AKFJCxfNH34NP6Aq/+kyS9MJqoypV/GqEfswJxHDwXJORhzHSh5PTH7DjQ/epM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587129; c=relaxed/simple;
	bh=5eHxZqW7agTJAaUvZFWVdr7i6oOL3NWyZ9Xp/R1Wy7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5sKCGvqO9V8uGrrWrX20rPbCTaONfEhx4UrVVKYoVHM/zfUEcC1cuIvzX5wmWR1NBDfaotBw0JmamMcGepIxF3PBrKOCVvnyuXqBKCCAeGSzhWMOFD1yVqJlm0iOIRe/jWQtnCm2StmspqV2T8SoGmmA+ykfWQNOqeFRz8fwck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMSlQPXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMSlQPXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C6EC4CEE3;
	Tue, 15 Jul 2025 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587129;
	bh=5eHxZqW7agTJAaUvZFWVdr7i6oOL3NWyZ9Xp/R1Wy7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMSlQPXdsfhLyCGl2jXzzcepav/HWUcR8J8qBjYO1FPyE5lp9H8vFQpvcseWENn2G
	 NQ5Th9m2Q/1EhxNOlArwPUVOdE/ITMzKUM/OxBWPcJsaZptNJjSyDbLVpFXcqR7Iip
	 YX2AAdH9bWUT/Py87CQJYvsPFCWYZtcYUJ0lrYtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Crawford <tcrawford@system76.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 177/192] ALSA: hda/realtek: Add quirks for some Clevo laptops
Date: Tue, 15 Jul 2025 15:14:32 +0200
Message-ID: <20250715130822.014581918@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Tim Crawford <tcrawford@system76.com>

[ Upstream commit e41687b511d5e5437db5d2151e23c115dba30411 ]

Add audio quirks to fix speaker output and headset detection on the
following Clevo models:

- V350ENC
- V350WNPQ
- V540TU
- X560WNR
- X580WNS

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Link: https://patch.msgid.link/20250620204329.35878-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5cf5350439029..f7bb97230201f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2656,6 +2656,7 @@ static const struct hda_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),
 	SND_PCI_QUIRK(0x1558, 0x3702, "Clevo X370SN[VW]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x50d3, "Clevo PC50[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x5802, "Clevo X58[05]WN[RST]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
@@ -11117,6 +11118,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x14a1, "Clevo L141MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x2624, "Clevo L240TU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x28c1, "Clevo V370VND", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1558, 0x35a1, "Clevo V3[56]0EN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x35b1, "Clevo V3[57]0WN[MNP]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4018, "Clevo NV40M[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4019, "Clevo NV40MZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4020, "Clevo NV40MB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -11144,6 +11147,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x51b1, "Clevo NS50AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51b3, "Clevo NS70AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x5700, "Clevo X560WN[RST]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f2, "Clevo NH79EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -11183,6 +11187,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0xa650, "Clevo NP[567]0SN[CD]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa671, "Clevo NP70SN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa741, "Clevo V54x_6x_TNE", ALC245_FIXUP_CLEVO_NOISY_MIC),
+	SND_PCI_QUIRK(0x1558, 0xa743, "Clevo V54x_6x_TU", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0xa763, "Clevo V54x_6x_TU", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0xb018, "Clevo NP50D[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-- 
2.39.5



