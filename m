Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C231E840;
	Thu, 12 Mar 2026 20:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346754; cv=none; b=OjRozd4aCfNeyoOt0BWxaEXk4oXXRGn3qtSMCqEqy9P0rRnzumTQBsdJ9MA7sh9EEGMBUWLue2ix65gaMB9moxi93az9ejHmM5PNyaxmNGQINU2eZkG5DHF177P0sQiW/mHOxqMMxZ6Q2z4NBjJ3IO9G6McSK7z7mk8A3Bitpp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346754; c=relaxed/simple;
	bh=o8+S1h+8Fk0uaaMUzQaldUrMh9AcQvRGhKhSq2/nAg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9Pc7zEl+3J3Cyo6UhVeF2VXpyp/6OquVCTmIv4dXHEG9CioZqkl5xE2wlEro8gYPMOLpMZmUzriE6cFnvgTIw3fZUh/gY2ELXEoU3wGsTasuRfXGsMtsadBJS2tvDvvSA1R7JvC0meTG/2HrQAg1LM9GpIQ3f3lLIkRyXlpq3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQmIiNHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQmIiNHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC7C4CEF7;
	Thu, 12 Mar 2026 20:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346753;
	bh=o8+S1h+8Fk0uaaMUzQaldUrMh9AcQvRGhKhSq2/nAg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQmIiNHiUkrx51Nz4jwpTOwIgJ7j3jRTuwY8lnUPytPG6wpHViR+miIir14WiiLjj
	 N7p3N7ByhoxobJuLlg0g8591RNdyqKmpxetP1rGsNwJphF6xi58Pzuj2op9/U2wPFq
	 xAGfFLJ39/hEljaI2epd35FYJh0rdG3y2pARWPb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/265] ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
Date: Thu, 12 Mar 2026 21:08:21 +0100
Message-ID: <20260312201022.357808106@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1585cf83e98db32463e5d54161b06a5f01fe9976 ]

It was reported that we need the same quirk for HP ZBook Studio G4
(SSID 103c:826b) as other HP models to make the mute-LED working.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/64d78753-b9ff-4c64-8920-64d8d31cd20c@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221002
Link: https://patch.msgid.link/20260207131324.2428030-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 482e801a496a1..9dc11d922612b 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1081,6 +1081,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x826b, "HP ZBook Studio G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
-- 
2.51.0



