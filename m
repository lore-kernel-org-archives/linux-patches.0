Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721DD1EE004;
	Wed,  6 Nov 2024 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897194; cv=none; b=Qfkeh8KgbYXSpF9rLlkpoVx5lMJoNvbQO47r7iz5RjO4yD2Gp7ONtLqBDETwd+7Gg9mMdLIPf24C1/paSsWaKvL5K0BFwylKzxTwTmvCOxX9rqWirSPGB1eX8iw43NpcxPgSpy8Nyu5cQAhGWUgFocwynbge+bG++TbDzDzSYNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897194; c=relaxed/simple;
	bh=+qH9YaIAhESJLjQt9RblCloqBxmD+s+7EqS/xfdqZRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQeVBJUqF+DswfZmCVnZZ2m4ojmhkbmPRj7wOiNt6CcplaASPHpWN9ruHMawQF+KtthWmAJqG/a92hGxwqhIzGxNhAMYcu7TkkfIDdaUUt0UqFQ4uTpYCFbDSeUua/MVoxDMx+k39y+v2c03ov6wAEspHSZrOL0VIxS8qhVHTQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu4bUjF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu4bUjF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A3C4CECD;
	Wed,  6 Nov 2024 12:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897194;
	bh=+qH9YaIAhESJLjQt9RblCloqBxmD+s+7EqS/xfdqZRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bu4bUjF9yzX4jnQuvCiKjffpb2dPkQxvsWgoOVInUkhNPpw6LQbeyhpMvbs3U5rxM
	 zCsy6b+iLqY8/GJUST4wa08I4dwyOqGgs0KMXMu5sBsLJAJDWfAPXh4kzUq5VrAUrq
	 ltYoxQBdYWVUT0FCN0aqt1sU1ut2fVfrcqkPkWWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/126] ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1
Date: Wed,  6 Nov 2024 13:04:59 +0100
Message-ID: <20241106120308.713088950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

[ Upstream commit e49370d769e71456db3fbd982e95bab8c69f73e8 ]

Quirk is needed to enable headset microphone on missing pin 0x19.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029151653.80726-2-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3cbd9cf80be96..d750c6e6eb984 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10214,6 +10214,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.43.0



