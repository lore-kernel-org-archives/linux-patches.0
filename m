Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9277231F98D;
	Sat, 30 May 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164705; cv=none; b=lyvY8LCFtiyEGrSFPXdyoorFsWV0I7TPblZBdC7nBu3zdaBPX72cX3pDwpxMl7nDfAylL4o9/WWpvJXu1BM9l3OCiA4PjS3akFfi/GacBlJhfM+eSox892jy5vCKMcVkFLrDU0u8fpCCD/ZYe4bJeIWLSMTMYS5wbhcg5IYDirA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164705; c=relaxed/simple;
	bh=31N47ZF3hbDh7j5iMfQ8LK0VJoOaybwKkOGWHKDVBbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFqp1zCIzgki6BpYxPGqLApWMrDRSQGmw6mqu6fYCAE1PnPwJ+vKKW1rbvYdv2nHAQLgPv6fnWtLXFQ648Ye5HQ1HYUCa5H2lylJjtKj0FALLsUWwmuUljL2f14ylaPJFSspsvPIYx2UULh3QGF/6wsXcXh+dVVca8YPvgSPRVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNMyMwwt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNMyMwwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FC91F00893;
	Sat, 30 May 2026 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164704;
	bh=Np1c5ft+vBsygOZ9HfIpuSC8Xy5NoWC65GWmjy68Hx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNMyMwwtiCH1pFCkA9b5HFukbai8ly2N8UmYCsUlNdasIpwpGyuU4mKYE9VPtIrLp
	 7c1jueLeGXnQezwEQbqBpIAQl/vPhYXd/UCFJl3RxDdakiTiO8j2K+37sgs1WRODpO
	 XAwUGk+UDuVF+RtLgDBX+hMIjIvGMQLYiKXeCwmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bo liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 635/776] ALSA: hda/conexant: add a new hda codec SN6140
Date: Sat, 30 May 2026 18:05:49 +0200
Message-ID: <20260530160256.373119188@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bo liu <bo.liu@senarytech.com>

[ Upstream commit ca348e7fe1ab9192ad7d9ff029a82a1594e0e289 ]

The current kernel does not support the SN6140 codec chip.
Add the SN6140 codec configuration item to kernel.

Signed-off-by: bo liu <bo.liu@senarytech.com>
Link: https://lore.kernel.org/r/20220506025735.17731-1-bo.liu@senarytech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b0e2333a2311 ("ALSA: hda/conexant: Fix missing error check for jack detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 2d653b73e6795..e5837e47aa227 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1303,6 +1303,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
 
 static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d1, "SN6180", patch_conexant_auto),
-- 
2.53.0



