Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E619A19DF53;
	Tue, 16 Jul 2024 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145124; cv=none; b=E+e85T86HtY9WLP2Fa3Jkr/j+fi6HjDKApAhi+WJ0jEKKlGt1ZzjlG0uF6aMzsBfQkmtAD+HfaMQvQUIJmdPLUajtWDeITwPx+jfbE7IdafwjO3BLruE2poLjSUqZE3DpMmXVZmCrwpjCWcakfzlHpqk/yf8RgMmH4Di8w7UL5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145124; c=relaxed/simple;
	bh=kX5fOQEQTidfaH3YGZIyVjGe+tl9PtvHifqHrOk+Nr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvj0Q/DRbmF1J9z4NNROSLlXqB4UIw23rIGYvylKmVW8misfKSecjo7Lw4pU5+z6cHHMboWt68CDZLM1HAIbR5ALX0UnVmp/nr9Tnho+YND9Q+T8z6hHKLL4LEjria05SnVIeARocQpIn6My30XP/UaHJZ68mmYakkSS9eGKpN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNZPIS2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNZPIS2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3A5C116B1;
	Tue, 16 Jul 2024 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145123;
	bh=kX5fOQEQTidfaH3YGZIyVjGe+tl9PtvHifqHrOk+Nr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNZPIS2x7XJWW/Nl2Jg+FBrJA8Km7KE9HLVAdENRwumW8dAYwvVRvxLyOO+V1gvAd
	 vSZwN00duRKOzubskS+H4j7IH3A9F+RzezdvGDjGA0gu/vVJlLhYFAqCSwE3LXxASv
	 aQyQoJnic+k5ui5Ax+YKnrDrzXPlIRDejGBE3ifk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 107/143] ALSA: hda/realtek: Enable Mute LED on HP 250 G7
Date: Tue, 16 Jul 2024 17:31:43 +0200
Message-ID: <20240716152800.093242984@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Nazar Bilinskyi <nbilinskyi@gmail.com>

commit b46953029c52bd3a3306ff79f631418b75384656 upstream.

HP 250 G7 has a mute LED that can be made to work using quirk
ALC269_FIXUP_HP_LINE1_MIC1_LED. Enable already existing quirk.

Signed-off-by: Nazar Bilinskyi <nbilinskyi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240709080546.18344-1-nbilinskyi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9999,6 +9999,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x84a6, "HP 250 G7 Notebook PC", ALC269_FIXUP_HP_LINE1_MIC1_LED),
 	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),


