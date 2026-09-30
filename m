Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BF8514765;
	Wed, 30 Sep 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782596; cv=none; b=tZtpLb/4DkyJccodBqRU0tHjXNYlaDRDclBAsMil1JaelsMN+G5qilOhTTO3bRYEYpyMhb9zMgTS1JjvnqyOVG7pn7MvAmdia2SD5XF7XXpd5Km6oubEjb9hRQgRjN0YSekyzdjiH7u+hwbtIWgbnj7F4Pv22qcuIWu4dshBpWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782596; c=relaxed/simple;
	bh=1etYz/GY6ZB3muyyQ1YYra2C/pQRKGRT3g/8zS3UPRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFf1TrsBShsNfbiFXFPdkR8OXP01zFWDhmvrh3MxgFz87xCWjkCG+Qrudie5i9YdxqBl3hqksjv+AwiAFHLLgX6nqUUTXpyzm//bA4V5EobWbWtE/rBmenoGRbKPJCWZMQINYb4jKj+GXp19yv8C2YnZax7NOO9wKIFYO0od1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3J0a2G3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3J0a2G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531461F000FF;
	Wed, 30 Sep 2026 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782589;
	bh=3uUX5z3PWe34FVYo88uTPke1vLqtnBoHbrYiBL20tUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3J0a2G3RmeCk0e4asa2yIviVafFEpZaQyKmecGG4pjufcTEoosIL7UvKLYDCiV83
	 QSZ2gyu3vEErNFUdJ4uvxypWBSH7QslcvShwQPOnG2RkNDaujOuGKasG/3tJpma1uW
	 5/Yx/WV+VM1mMfez9+3waQ+3/6e8Prsw1dqGYUAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Faleichyk <andrei.faleichyk@noogadev.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/595] ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP
Date: Wed, 30 Sep 2026 17:19:52 +0200
Message-ID: <20260930152349.866389321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 31cf426f026c9..1b4d22d246672 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9355,6 +9355,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x197e, "ASUS VivoBook X509DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



