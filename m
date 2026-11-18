Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034373;
	b=48A5QKJeEHu8UNfexcXMwlW6hIDrIeBOk7mGY+ny6DHqriV52Y3uEVVHp0ycwQg1V/Kk
	 imShJZVvvhSSFgnGbZzXy1qwosSNf3/E2pfgT9qYSKsVqbvpQN91A0IKU7nHU8WpCp1y4
	 XIshs0FVJvsAxWw3ekTLmT1CMPq2F4wUvc9/qxKF6rnaf34RaTqccUEB/vI0aPDcWTeSf
	 X/Qicv+61jPGubEX/dVC0DzhumIM2wb7DSrk9QtKjSA4NfCCQzMgCs2vVEoMnXB1mF5rI
	 YbMWO7103DkXRbgbVn48b7FiTg67JcNs1wyudu6DjX44bAu5PkweTUCIy8qU3dmWcPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLrRdcc/o4gneYFGy6bQKxrvhb99Xf2sS+0v63bYR1I=;
	b=GII1lzr/qqFmpDU1Myc/3aClpUCWlSYqIzDEqMIvFb5JICm8ftJPAHw655asUWlPHsJA
	 lXOGrU671rRGA5kGLBStXtFQRz76cHzz6zCgDznXLE/IJdg+bTkCQUxbVI2n+cSza8ClC
	 AIJZkrsfsGIQommkrpOYI82kaLG/n8YkSojKVyZsnHw258Cvxq9ZmIRBXS41lHYUjOSJJ
	 nJ0x9pLQui6VujlQsPTujEx7c4cayhzJ99UFGpV109TLh4KbUze97wkGojnh/NJ1dERoe
	 SZCorlvBQdgkOPke/eGc4RiNvD0OW+zFR4WGGekLCTGh/WbgC2Z6PpAz7/okaLeB9rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8bLrzmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45469606A31C;
	Wed, 18 Nov 2026 20:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8bLrzmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E761F000C4;
	Wed, 18 Nov 2026 20:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034373;
	bh=uLrRdcc/o4gneYFGy6bQKxrvhb99Xf2sS+0v63bYR1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8bLrzmmYxlUSVA5o0ObWKsvZccZwmCwQeQsqNOjZsMpvnhL9QmF85gjRLyjbuQdL
	 2T/+Ev/l6ibhsgUAkDmFTk1LnDT1vFBJ20Ybq8zwXIe+J0chGKm5voF4VP34TuxZ93
	 qhWJVZCdsqkFUhD+9I+hy5VTPtOUOXNK3smW9x0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0347/3318] ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA
Date: Wed, 18 Nov 2026 15:16:09 +0100
Message-ID: <20261118150326.449039422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>

[ Upstream commit 0eee030c2c09c7a44be778de5f451d9e7a2f09c1 ]

The ASUS ExpertBook PM3406CHA uses an ALC256 codec with subsystem
ID 1043:1664. On Linux boot, the internal speakers are silent even
though playback is routed to the codec and the speaker pin is
configured for output.

The codec starts with coefficient 0x10 set to 0x1d20. Writing 0x7f20
to coefficient 0x10 immediately restores internal speaker output.

This was reproduced on the affected hardware from a fresh boot using
hda-verb. Reducing a larger initialization sequence showed that this
coefficient write alone is sufficient; no GPIO, EAPD, pin-control, or
other coefficient changes are required. After applying the coefficient
in userspace, speaker output also remains functional across suspend
and resume.

Add a machine-specific HDA fixup that writes the required coefficient.

The fixup has been compile-tested, but could not be boot-tested because
the affected hardware is no longer available.

Closes: https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/2162718
Signed-off-by: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>
Link: https://patch.msgid.link/20260924144512.3989-1-muhtaseem2005@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7910e31584c61..79fdf52840b84 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7361,6 +7361,7 @@ enum {
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
+	ALC256_FIXUP_ASUS_PM3406CHA,
 	ALC269_FIXUP_SKU_IGNORE,
 	ALC269_FIXUP_ASUS_G73JW,
 	ALC269_FIXUP_ASUS_N7601ZM_PINS,
@@ -7716,6 +7717,14 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC256_FIXUP_ASUS_PM3406CHA] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7f20 },
+			{}
+		}
+	},
 	[ALC269_FIXUP_SKU_IGNORE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_sku_ignore,
@@ -10365,6 +10374,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
-- 
2.53.0



