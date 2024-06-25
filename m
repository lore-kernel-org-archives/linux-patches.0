Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68482148315;
	Tue, 25 Jun 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308474; cv=none; b=oluUP2TfXETMcGJoqAdU/YQPdK0aHNG3XTfiywkc8HtItJznJS4J+UeXn6QnpPeQAJ6CpNKOgO1i2ADz+xAA/OXFrpFo+/4trILVBjBIywXtz7TbGrhUrMC2zLR6RKq3+X5Ol0M3EMhTbklY5ovrAgWex/FNzj8rF5RzCbiixf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308474; c=relaxed/simple;
	bh=tqLspkJWWf9lhG5mGhUZZXkPJvXfq8widan5F8Wp2BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB6MCL9yuyE42yb0s7icadNvlIwGx5+9AqO2FGYPoNP8ASJBBrpri7hgmsQ/xCF0S/WaRSyjtmQBZeZ27hFLVZpocrZRgJVN7KpYv0Zf4njSUIkd+AtgLUb/tltaZtqMCi2JvmzdG56lerbmpkGbjthBoTI2OO7b+kNkVdc1JvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=femKwgxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="femKwgxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B71C32781;
	Tue, 25 Jun 2024 09:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308474;
	bh=tqLspkJWWf9lhG5mGhUZZXkPJvXfq8widan5F8Wp2BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=femKwgxqY26P519MfL2BRT16GOjdGBHnhx0vSTeel1/1t2CLAFCSAI8YAXl3gGAXo
	 5BG+KcwgZUY2n/RDjSUW9HRTaf/FqodnM5TKuls5AL/kkcVg+n0VVPoSUHseSEaPHh
	 GlFSpd8RGOdHHcDRLKPLWfBFZpKpolDjzc5k/U/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/250] ALSA: hda/realtek: Remove Framework Laptop 16 from quirks
Date: Tue, 25 Jun 2024 11:31:00 +0200
Message-ID: <20240625085551.985761440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1e77bbba8de11..61cb908717f27 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10592,7 +10592,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0xf111, 0x0005, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
-- 
2.43.0



