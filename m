Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC32E3563D4;
	Fri, 24 Apr 2026 13:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037685; cv=none; b=tIUL6yePAZGgxFj4GH/t6x+Ap5DZIFRjY9/fTtk4Tg8zpcUoZJ8cign3Z+PjgxD5dMxjqpfnlbIj2/rYwviJlBfbvW6xe7KqEyj3OaI7ovE6e0xm+A8q+rOT2tSHagxUS9TqoVhI51Rccwd2tgrCakesV/Daj94rvf3c1f3TdAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037685; c=relaxed/simple;
	bh=UCeBcjwTgKk15snRWfk/5i9DGrU3Zbh4GhG8S64A7OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enh9Jq9snakcb0INepMZNE7Sz6hFIrd+4puu51FBzI3LzeIUrQi6ksrRIVXPMD663/wf2aFkCjasALQSgfgxADjq2nOyucLZ9RIDicvGPrZZsLkUiADcHt2sl3xZWmUuDXmkHwkZiZghZOfm4vHFBNC8uKq1lEsltS/2l4j9uKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTftdR9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTftdR9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61649C19425;
	Fri, 24 Apr 2026 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037685;
	bh=UCeBcjwTgKk15snRWfk/5i9DGrU3Zbh4GhG8S64A7OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTftdR9zZtTrEVAPP/yY7oBJAtInj4CqFpCfmqmT04Dkue8Fl9xMHtipY7DT0Ggfe
	 W3f19hsitjwTBRP2UWZ1GyLG2M+GTaCT1BKHYCj9nfGQwewmfOEe1zV2wYu6dxdtf7
	 RgkX5lwZjquILrpY25BH1UtnHSXKBrv2MsUWCfbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/166] ALSA: hda/realtek: add quirk for Framework F111:000F
Date: Fri, 24 Apr 2026 15:28:47 +0200
Message-ID: <20260424132535.670286571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit bac1e57adf08c9ee33e95fb09cd032f330294e70 ]

Similar to commit 7b509910b3ad ("ALSA hda/realtek: Add quirk for
Framework F111:000C") and previous quirks for Framework systems with
Realtek codecs.

000F is another new platform with an ALC285 which needs the same quirk.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://patch.msgid.link/20260327-framework-alsa-000f-v1-1-74013aba1c00@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0efc2b8aedb4a..0ac8846326abe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10671,6 +10671,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0



