Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E0D34404B;
	Mon, 20 Apr 2026 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700068; cv=none; b=Xd3sEXPFoWNlrmcoTJb5J/vJ/eiWXJOAvRUr6HcbA4u2pL64M+AKNxTHmJUtaRAAPbNETFFyvYg7/vc+vnhM5gxtbBsp7AYTk4sASVOCHOo56sv/MHA54jiam8YL9J1W/NTj0gi1Je7AOZcF0wZMYJ1HfT4ndI0uNiODuALyoOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700068; c=relaxed/simple;
	bh=2DsV1n6IKHWGWj1Emabuyb13WwoOIgfgufgVJ4YENyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTSBKeN/8hHWNWJuWVcWfPK2SXMAU69yX1Alxpte57zHxXbPm1C07LnJYgymcbeELtGtF/WGt0n/nznzikiV9CoxPX9F8G8QsI1dNZY9uK5fd+pele6e/3RjNSnYKp1E4UKkAvp2bcu/wRV+ArCWLu4YLXAXc00IaoloTGDiaYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSamCNnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSamCNnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB264C2BCB4;
	Mon, 20 Apr 2026 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700068;
	bh=2DsV1n6IKHWGWj1Emabuyb13WwoOIgfgufgVJ4YENyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSamCNnFMqaXT3LJ2YgI7VuKcQQ5mR2osCFXvGbLy0QgDWVswzdQgGNfwrMxuLssz
	 F1AHpTOi18f33kGQNuLRAsSpcWlPdGYApQMlf6Viy0jIRY6Jn/1thgQG/pNzOS66/J
	 TPUD19MBW4KJuwfZ7kQrDHzhSA/4gdqY83gtyjGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Throw <zakkabj@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 029/220] ALSA: hda/realtek: Add quirk for Samsung Book2 Pro 360 (NP950QED)
Date: Mon, 20 Apr 2026 17:39:30 +0200
Message-ID: <20260420153935.079088635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ea31be8a2c8c99eac198f3b7f2dc770111f2b182 ]

There is another Book2 Pro model (NP950QED) that seems equipped with
the same speaker module as the non-360 model, which requires
ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS quirk.

Reported-by: Throw <zakkabj@gmail.com>
Link: https://patch.msgid.link/20260330162249.147665-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e3277293dac6a..61ca80ff3757b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7410,6 +7410,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc188, "Samsung Galaxy Book Flex (NT950QCT-A38A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Book Flex (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1ac, "Samsung Galaxy Book2 Pro 360 (NP950QED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.53.0



