Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729D71E1A17;
	Wed, 30 Sep 2026 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794337; cv=none; b=nMhZLGanICUtOUSBMZPgjIslslmkXBjVqORYD+EEZFgOmNLPVY+XIIRGlE0/ebWX+ccnW8tzZy/A+VUs2ellrCv8xw5e/71OpyO1o/I/YvGJCYXC6j6sF8OhfVuapw2h4BcyFZZEXvRWTbcg7z/q40u6qrw+BsegqC5UHYwcwK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794337; c=relaxed/simple;
	bh=zwedzVE2UDvIMBs1hhFexVJdkPJ0jE4eAmi1tooUwyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZEl0E/a6C5WCKMkH9gj5XCD6UsntZPQw2sonfJofAK57YZFolxigMTf5I8ttit89aKizAMyqWco0o9PezbK6FX1mG5SeV8Vgqj1eFdYGDweU11SOzQcSUbZMSRfh5OPY2745b6JbYT+Q/+4H0fnG6p/DT1/rroiv9tTOdAx1O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAPiTk24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAPiTk24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD80F1F000FF;
	Wed, 30 Sep 2026 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794336;
	bh=mnwU+R8VfIckmoFFUXE2uW6+R8y8PuQ3n3qKD+VLleg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAPiTk24noVT2m3NSXf3pttZyXgbcfhaJZ8LYs+9qI0bDI02VKTMFTcTLsAI4kr4F
	 vIkAlGup46pK89r+uJWgrCLgQOLcyZ927LfcgMLJ+I0hnXeQ/KrE/J8Mmsi+yNgWKL
	 bQvyA5FbyzSXMocb+zoY9Fb7jVxe+KutQjPYZ8Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Faleichyk <andrei.faleichyk@noogadev.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0175/1193] ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP
Date: Wed, 30 Sep 2026 17:14:19 +0200
Message-ID: <20260930152438.082318992@linuxfoundation.org>
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

From: Andrei Faleichyk <andrei.faleichyk@noogadev.com>

[ Upstream commit 3580bc53520ce4efc94ece5886ad3670b93667ba ]

The internal microphone on ASUS VivoBook X509DAP (subsystem ID
0x1043:0x197e) is not detected without a quirk entry. Add
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to fix the issue.

Signed-off-by: Andrei Faleichyk <andrei.faleichyk@noogadev.com>
Link: https://patch.msgid.link/20260603213313.6298-1-andrei.faleichyk@noogadev.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 937f3fdbab252..caf5347406cdd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10310,6 +10310,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x197e, "ASUS VivoBook X509DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



