Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058A038A728;
	Tue, 10 Mar 2026 11:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142028; cv=none; b=R3R8wDe5fG++jXkd+TlvI0QkVR/iikUv+/nlzNIBPXYIvlFKzQt8uKQmecOq29n5lNVi8U3Won6qI/QzGxnkoeLDrQ+1974HXwN3HwG2sEnmhxtarK+Cgnj3O+LzeeGOvMCmeV1Fbu37xgC70O880MNTouUP7efZ9YK/0OzKmpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142028; c=relaxed/simple;
	bh=qk8XMHKP+wTnO1S38sADNUNrvL5dtGZSZ76a6MGgkN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5vXTEHg2CB3FxT3yAcCjPhCFOJjK8/m/G6u6CnMFlDAemSQVCJllfgXhhPpjOYZ1+X/FOQF0MfQ9/I2+zpk5XC3JRWMvjemVQmgQVlHbpdIUhz2gJlhfoh0PETg9WB5/ivzDObZYReuDaU8TO/hVYKlrerTv+eW4VgurwTbFdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcvtOBsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcvtOBsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C14C2BCAF;
	Tue, 10 Mar 2026 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142027;
	bh=qk8XMHKP+wTnO1S38sADNUNrvL5dtGZSZ76a6MGgkN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcvtOBsZdgn4UnS6qizty5sB0rU08+3kDurSW0+Oeh+ypTVROkT7RaejZPfvrAlNR
	 CzkKUCMK/a6659LEKdDRcyP3dLxYIHtYraKbKS/3AjOT6oSH6CFosnzZu6qDb6y5T9
	 RySmet8Iw0tNNoagHwN6VUE4X3Z18chEt6lMW4YIqIsLDWDU8L1Ig1/MPuN4WipGHr
	 mNJufHmlrQdc3D1oy+tQGu51ofALi/nz8sebXnzceHSF7wYyKGGQk+utjrmltSXUNd
	 d8REX60Zg1YEp3m+vrY2+gLSO0d0C0xK4nT7iOECUm4H9XrERrVWZYnPse3Uhfz0TN
	 lTY39obw8HPXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 154/314] ALSA: hda/realtek: Add quirk for HP Pavilion 15-eh1xxx to enable mute LED
Date: Tue, 10 Mar 2026 07:16:53 -0400
Message-ID: <af8004c969c7dde10ed7a6edd0e1082c14a086b7.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

commit 068641bc9dc3d680d1ec4f6ee9199d4812041dff upstream.

The HP Pavilion 15-eh1xxx series uses the HP mainboard 88D1 with ALC245
and needs the ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT quirk to make the
mute led working.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215978
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260227121327.3751341-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6d3d464f1f6c6..e1e0b4de4a69f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6732,6 +6732,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88b3, "HP ENVY x360 Convertible 15-es0xxx", ALC245_FIXUP_HP_ENVY_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.51.0

