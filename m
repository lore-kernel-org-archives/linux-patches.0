Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B623CFF66;
	Wed, 30 Sep 2026 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794908; cv=none; b=ouSTp6KFaH50zFNDwM9/kBPfPECOtSb0uDpY6XL8yMVhXgaLVdZa1+6gvJXoXjygZIzRVJxqCjY51u3RWF+XgFN0/0wxGvIwBjP9q69UCCL/zp0xOeeaHKZYeujU0q7QW7JU8GtgPqfzoVKnmQLdGqaGwbA770pr/e7tRUXZV4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794908; c=relaxed/simple;
	bh=1ff2y1/Vyn4eshlRBm/be+H4URHyH5ZR+1opChtLQC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBtcdypw2iGbqrNHdGGKmoTmYkPjfw9rKxwtWo0kElBOoFVEiUGspErD2jzSCCZfRESYpuQ29e6g3RDzg6LfmgltHSPbT18/2O83aLQbGYZ50Y3/DCgBJb4YrIDAvQPekTxMyQmApAoS3JxbW7HJ2MDLXYKNowpvUxvVmGO9YC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul0PFBT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul0PFBT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672891F000FF;
	Wed, 30 Sep 2026 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794907;
	bh=gBo/xFJMUdFkB4MIbt2bwE7LTN55vUMER+fwziSR004=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ul0PFBT+tkIOWLS4nvPFGE8gwmAOID+dtK3ADusNr5+Q4h8X6CwssBt5DTIFsiUyJ
	 +3KiN4XU08QDlmjt+GVYf7nL3gKOePJg3oW4pJWfgRTFFMD/bLWSQH/a9k/4u59V9e
	 uMdM7mHxoy7VOxXdyEyXOt1+nzS57ZuuD/hqBUH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0330/1193] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Wed, 30 Sep 2026 17:16:54 +0200
Message-ID: <20260930152441.474437068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavender Singh <madhav@disroot.org>

[ Upstream commit bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd ]

This laptop with an ALC236 codec requires the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup for its mute LED to function correctly.

Add the subsystem ID 0x103c:0x86c8 to the quirk table to apply this
fixup.

Signed-off-by: Madhavender Singh <madhav@disroot.org>
Link: https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6a1a97a7784f3..c05e87a0f4f74 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10104,6 +10104,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0



