Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA31487E9;
	Tue, 25 Jun 2024 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309022; cv=none; b=Py/Zd1639uhwPRBmGkAiq9NE7VsvP3yP48m49dECgnjw+hulU5odjrqyGJNXeOk3NWVe/ZJ6s2ATTSY7WXxfTQ8022H9ZWk/CNRx1c6nxy/LXxQ457eMk22IrXREKuUyxkIowYiC6730JjdeQ/pLNaDPUNhwthdMb6LC4GibQao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309022; c=relaxed/simple;
	bh=KYaaRK2il49T9+MNDtLgeyycE1cIjINW5qLPziyCX/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBjlTHA3gT7NtHoFW6QFwBJgBNGpVMIgeA7FDBBJ8bsf0+6qsJEMAW9oLE9zj1fWalw3EghxlwKhdSffyeXsoxz0ZoeiIPCSgIJQii5TVHF2RJrYg4JpNJLUNX9muqrYskglH457UQ5cdE18Vt5HtyEKoIDoDAVaCWqqB8+D4bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSad8bWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSad8bWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CC7C32781;
	Tue, 25 Jun 2024 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309021;
	bh=KYaaRK2il49T9+MNDtLgeyycE1cIjINW5qLPziyCX/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSad8bWkSCuBMq781UdeJdgdD1BCrmaGn5TtGLG41jendyoWi//PREYmJv8qJHmvg
	 eZdzygeWWO+jemi+tLtoytsUqXEBQwhEv+xPtsXhrfTnLyXwbN+WuJPnnmltvHLfws
	 /TXkMIqNaQhpmnFRCt5+q+AqbfUlX/Ds827z3WDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/192] ALSA: hda/realtek: Remove Framework Laptop 16 from quirks
Date: Tue, 25 Jun 2024 11:32:20 +0200
Message-ID: <20240625085539.782504319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit e799bdf51d54bebaf939fdb655aad424e624c1b1 ]

The Framework Laptop 16 does not have a combination headphone/headset
3.5mm jack; however, applying the pincfg from the Laptop 13 (nid=0x19)
erroneously informs hda that the node is present.

Fixes: 8804fa04a492 ("ALSA: hda/realtek: Add Framework laptop 16 to quirks")
Signed-off-by: Dustin L. Howett <dustin@howett.net>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240605-alsa-hda-realtek-remove-framework-laptop-16-from-quirks-v1-1-11d47fe8ec4d@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 44478e0af1e41..8e6574c07c975 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10336,7 +10336,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0xf111, 0x0005, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
-- 
2.43.0



