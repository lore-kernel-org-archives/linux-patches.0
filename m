Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061151;
	b=cdZscMSAskF30fIT29nAAzn+6Nri1R7VcoaP+Rpd8muVhxC//jlpSU9BEdRronQam3HH
	 hxMAazbQR8CdI+/iOTB75v/EilIIyJqMlGqWux1X1hRo61pQiR9QJ4T+/kohtcbVXlPkD
	 h76bA18wt3Dal52t1fy7PxI4YdoEohkd7FotaGVg6MvrFQf5GpLFFxi2og3VBfnwc/8NT
	 XFddJBz/xdnXxrmK0NINTQ8mIEL/AFB7u193FDAVClog+nz4Oy+1lf6cLPRuziWYmQBAY
	 QAl/Yge756R2/MLdb2o22atovVYILKsriL6Yk+g4K8PH134366DD8kDI4iUHoZnZUEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Og01ubOU30pN0mMV1Bg1T1liCYORyINQvun7VdHO+Uc=;
	b=sYiUFMxlApsSo4Jfu+9TKrFndMsGYAMe+1744YpHouwp+lGC+4Q1nfM7AyTXrhfPhDB+
	 uNnNaw3IGhmm7DNElhHTFAz4l7QabezCHbrziUGFDoKRerXqCFK8eEB06nhSHaCnUngjD
	 qUC0T2rmiXxNOvAsuNqaueDtM2PzBXXBeShNyOIiCllbdVPR4In4uD8dAvFHHsLcPhgIU
	 l2xkWlLysSH578fqnJjcCFBXKIkpeC+IhfiDbfThLgDL23ZILamx5E3KJMlBgisYR/zex
	 3J9Kl+EInP/N4+KtU8ZWGuP4PiDBzfDjMwZhKFOeAlj3mG5y7+Q9n+VzSSNFYjNlg4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aS+5Y+tW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B683606A33E;
	Sat,  7 Nov 2026 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aS+5Y+tW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1011F0089F;
	Sat,  7 Nov 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061151;
	bh=Og01ubOU30pN0mMV1Bg1T1liCYORyINQvun7VdHO+Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aS+5Y+tW+3wnzQEm96GbZG/8zfOWC4uXtG7TSM8PXnCLi4oJJOSkAgjpIXCLb3tdA
	 RZeSOlk6V9LcWm5FkjDEjg39mrkTV8KO8U1ZxdWsvh53+XzKe6Ko9d1yfKTm1+87sq
	 tkf3aCd+7nhFV38CDicO/Drsnsk7EukFatuzPXTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0419/1536] ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA
Date: Sat,  7 Nov 2026 08:40:35 -0500
Message-ID: <20261107135009.343091174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d26f76f4de2b7..e1cb5a95c1374 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7944,6 +7944,7 @@ enum {
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
+	ALC256_FIXUP_ASUS_PM3406CHA,
 	ALC269_FIXUP_SKU_IGNORE,
 	ALC269_FIXUP_ASUS_G73JW,
 	ALC269_FIXUP_ASUS_N7601ZM_PINS,
@@ -8339,6 +8340,14 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -11277,6 +11286,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
-- 
2.53.0



