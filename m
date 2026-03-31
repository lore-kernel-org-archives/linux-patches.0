Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482873F7887;
	Tue, 31 Mar 2026 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974848; cv=none; b=AoHVJVWStcLdLghzRMWHkXatU8E2Cf9+lKypleCNYvPHGEOp/s2P5SffJwtjiwZqNWrp0WhR1LYLAcpkqLJmUkLSzweJxmqbT2V9w2mMGlMAzNefjpsG1BHoque4ozYyr0vAhZP2wTjKs1rg0xI7kPPswUc32uwRCaH99E0p4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974848; c=relaxed/simple;
	bh=b2A6OU4UBJpGWZFRi93+cRq5e6kd2OFg61xnsRYTRt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0fOWrER8EOp5OdZNUoaCk+58vKjDYSkuPEgmQAzcgoHDYswCPNDBeZtXO0FeMB6ht+vX82t36CKLOOf+X/03+gOA144lA/3Gr9QyeWAFto1R9LbPXqcAcH7G3Q22JBhYh6cH4ief+LN7af1cJVYbcupNqaP0WPevn+RX9MZ8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6jx2GQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6jx2GQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D246BC19423;
	Tue, 31 Mar 2026 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974848;
	bh=b2A6OU4UBJpGWZFRi93+cRq5e6kd2OFg61xnsRYTRt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6jx2GQu7mktSKUQKl9VP05EJdOL/q6+2k6OUpWxgkfTj3xD3UVpdrUCiXkokNWqr
	 kqxy3yAbLxUph6kO2O2v0rzpSP9huiejHDOVI7eZz1oTvovCsXyfewZvRytCxM4gYo
	 B99zsJUnkXybZpcwug3SET78nQ7ebGRhRqugPmSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 068/342] ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone
Date: Tue, 31 Mar 2026 18:18:21 +0200
Message-ID: <20260331161801.398881751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 56fbbe096a89ff4b52af78a21a4afd9d94bdcc80 ]

The BIOS of this machine has set 0x19 to mic, which needs to be set
to headphone pin in order to work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220814
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/b55f6ebe-7449-49f7-ae85-00d2ba1e7af0@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc662.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc662.c b/sound/hda/codecs/realtek/alc662.c
index 5073165d1f3cf..3a943adf90876 100644
--- a/sound/hda/codecs/realtek/alc662.c
+++ b/sound/hda/codecs/realtek/alc662.c
@@ -313,6 +313,7 @@ enum {
 	ALC897_FIXUP_HEADSET_MIC_PIN2,
 	ALC897_FIXUP_UNIS_H3C_X500S,
 	ALC897_FIXUP_HEADSET_MIC_PIN3,
+	ALC897_FIXUP_H610M_HP_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -766,6 +767,13 @@ static const struct hda_fixup alc662_fixups[] = {
 			{ }
 		},
 	},
+	[ALC897_FIXUP_H610M_HP_PIN] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x0321403f }, /* HP out */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk alc662_fixup_tbl[] = {
@@ -815,6 +823,7 @@ static const struct hda_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
+	SND_PCI_QUIRK(0x1458, 0xa194, "H610M H V2 DDR4", ALC897_FIXUP_H610M_HP_PIN),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
-- 
2.51.0



