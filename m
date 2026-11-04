Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830843;
	b=lVcqf9nVTnYVy5yl/1nxJJoaXF+tmp5VrnJ+LcatkaZF+6x11RUmKtccLOfk3uAG2tbI
	 lsSLUkUelx206lOMFseLvINUkSn6isNJD01sa2d8HJW4n5gZGNDT3kv151Pc6/nV2COpF
	 7k0yNikPAHCvYr4gC+8FtRYt/e+zmI8uzc9z4gzCv2Zx2H941nE55eTYPaMjDT1K+8T61
	 vc55KOOB3pLJHUfFmyA8od0UfHf6CE6CdxzKkvmex0j+05EDc1Y2KirBGoVhG8grYsalB
	 J5sK3klspO/qjRiDR3K+2fYsEwGANGFsfOP0RkYOwydERqMd1Mupk8ARX6hf7TfmVAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tU6bAsY2ybQFcKAIY8apwLs99ZW2ZoDNbOrSMWXHKVA=;
	b=PncpueKzJ4zbYDWzKJXEN0Eqo3j4LBgNdxISrhLE5fRz5ko/GuV8deH+ChE8TXFkMA+o
	 kFaZjgBmduqHId4sag+0EpXZj5sy8BeXFeuy9XRIuMNQs3yEu834K54D660Kggy/ner5m
	 5AsOs3jCP09xZOiMjd0AC8q+YfRzzIr0d688+i5mbP9otJOAdOpNOJT0seFBZWruk2Cp9
	 MAfpEcETRGCZO0/Tt3VWpaUB1hiHyaaWQKqXECzzWPCTBDHqTsJ13enPe388gd0TCfESS
	 E3PVUnelWsZq11FYK3+appVkISw66biXAUqYVqV8DBWCaWa8MywhKY9cqoAyJG+v/mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEulV4Ob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE82C606CA19;
	Wed,  4 Nov 2026 22:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEulV4Ob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D39E1F0093A;
	Wed,  4 Nov 2026 22:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830842;
	bh=tU6bAsY2ybQFcKAIY8apwLs99ZW2ZoDNbOrSMWXHKVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEulV4ObLgIrVrbQvCLC7OI94xK07vlEMa1su7F6t0vPW8Ey9R1cHf2BD4ZOD9rNw
	 XCrkoelia9ZMNbwKR2kUZPKbFll0rcEkWszc1LCIJa2h9jp0Zk4Mwz92GsxWly5sfR
	 8H6y5daqeztQjxSDTlaKSz1AclIG4T0j2lIOo59w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0355/1005] ALSA: hda/conexant: Add pin config quirk for Huawei Matebook
Date: Wed,  4 Nov 2026 16:01:28 -0500
Message-ID: <20261104211054.018019743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit d152afd1cd7a69c752236b6e825c4e62a74788eb ]

The headphone jack is not detected on this Huawei Matebook (Conexant
SN6140 codec). The BIOS incorrectly marks Pin 0x18 as [N/A], causing
the driver to report hp_outs=0 and no "Headphones" output appears.

Override the pin configuration for NID 0x18 to set it as a headphone
jack, which restores proper detection and audio routing.

Link: https://github.com/thesofproject/sof/issues/10687
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-4-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 56d6fbdd9b06d..ef40f1cb1158e 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -298,6 +298,7 @@ enum {
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
 	CXT_FIXUP_ACER_SWIFT_HP,
+	CXT_FIXUP_HUAWEI_MATEBOOK_HP,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -1043,6 +1044,13 @@ static const struct hda_fixup cxt_fixups[] = {
 			{ }
 		},
 	},
+	[CXT_FIXUP_HUAWEI_MATEBOOK_HP] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x03211020 }, /* Headphone */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk cxt5045_fixups[] = {
@@ -1143,6 +1151,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad/Ideapad", CXT_FIXUP_LENOVO_XPAD_ACPI),
+	SND_PCI_QUIRK(0x19e5, 0x3289, "Huawei Matebook", CXT_FIXUP_HUAWEI_MATEBOOK_HP),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
 	SND_PCI_QUIRK(0x1d05, 0x3012, "MECHREVO Wujie 15X Pro", CXT_FIXUP_HEADSET_MIC),
-- 
2.53.0



