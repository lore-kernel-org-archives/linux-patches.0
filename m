Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1234252C;
	Mon, 20 Apr 2026 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701175; cv=none; b=KnEFwZFxyc9pWJZz0bHdPS30jCEaYslAGIN7/dIKf2T/8pHnr0nKu6lCHsBvCG+ej0ZC251jnIJ/vsKeLx2J/MS8siT7UY4fNXJtygcvkzhUF6gl3OHckIGw/SyifvSAX4FHxhqwFrN9VOSpeclfvlCKBs+Dpt/5HNfVoWYGPpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701175; c=relaxed/simple;
	bh=RFoMvTt2iBGIsXGNek/xuFkAZOait5orCHpVLAeb3eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZilLZYzyya/6yGOrL9zR3+HvxFF0N7iXHKpM5H71Zt01+REDSAbgvsIjR5bP9X5nXnB5Nk3gL4tBiiX1+5ov0rj//yDUrYCapIM8iPsnbeEmU651E2oedy+mGDn1x7Dgi6mKUR+3ODPgh2QezTmmkXgRl+xXYsloSi/lRq9HQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8WIVsWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8WIVsWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918EEC2BCB6;
	Mon, 20 Apr 2026 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701174;
	bh=RFoMvTt2iBGIsXGNek/xuFkAZOait5orCHpVLAeb3eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8WIVsWmyGhI41qu3qj8ornkibPEk9185XVPvafizUnxIbGroA5O1DTolwH9dABpM
	 CXCcqp7Q6RV79LQ0Nl9K0mvKpWa4cT5eA+XOFqwByrWbwPYYro0KOxiVARklcVcsIB
	 GyQbLCRkHWvkrtfZ5OMfOI9klB82AhjYeTYuck1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/162] ALSA: hda/realtek: Add quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 20 Apr 2026 17:40:36 +0200
Message-ID: <20260420153927.171991385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 59f68dc1d8df3142cb58fd2568966a9bb7b0ed8a ]

Fixes lack of audio output on the ASUS ROG Flow Z13-KJP GZ302EAC model,
similar to the ASUS ROG Flow Z13 GZ302EA.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260313172503.285846-1-matthew.schwartz@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0dd789119f96b..96df0d12b68dc 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11197,6 +11197,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS G513PI/PU/PV", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x14f2, "ASUS VivoBook X515JA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1503, "ASUS G733PY/PZ/PZV/PYV", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1514, "ASUS ROG Flow Z13 GZ302EAC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.53.0



