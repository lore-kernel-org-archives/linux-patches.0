Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36FC1F8924;
	Tue,  3 Dec 2024 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242572; cv=none; b=KPf2E6JJNIP9fAjMRsgHskm+V4mT30rqw8ZiCxNFWBgLToDMawIpJq5WCpSTgtZnJ+Cmp2UuhCm2m4D1solbn5jzgA7KQD8NByAOKZhkPJqggxYwQofwg//DP4tQ1adwFMkgcz2SpkdUM1etiB/UoRTniWfD/1Zb5hhTRWL0TBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242572; c=relaxed/simple;
	bh=ZTnzsIAwmX9CBtkIXxpTaApL89RQeK+PDzlSdHqvQLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPrz4F0HCl0yuSkdZnj2V5CR0061mxzbadqjHgomi+rdeQ/T4aZg5tQ4jro9f0tfiS9rQ0wafCS85jq+FVkYhP+K0rBpT8q8gerMu2j221MAg+VT80gSJj1XF5geG4yRbAp3iFgFQzgs/oghOJnk9exGqjYTzt5Vaizn/TpXerQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ9TyLNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ9TyLNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F68BC4CED6;
	Tue,  3 Dec 2024 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242572;
	bh=ZTnzsIAwmX9CBtkIXxpTaApL89RQeK+PDzlSdHqvQLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQ9TyLNYlys5N+QOfPMzP1/gmcsyTHIc/+DAGWix89fQsZR2E5lnlnS1kEAj/afs/
	 sd510byeVegvepLwz8+zg2NwNMXWidgJ+5VwM79DPxxHqSdrpZPpuJkEQvGED2pyPs
	 5lvVR8HjdxXkd9FcJcKLdwuesXbr3pe1jJruVfI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 744/826] ALSA: hda/realtek: Enable speaker pins for Medion E15443 platform
Date: Tue,  3 Dec 2024 15:47:51 +0100
Message-ID: <20241203144812.785454729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 31917b7bd892de730ab67b215c62aeeea778112e upstream.

Speaker has no sound for Medion E15443.
Added another speaker pins for Medion E15443 platform.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/eac4f3aca2ab45e59ccd207a90ee60e9@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7773,6 +7773,7 @@ enum {
 	ALC287_FIXUP_LENOVO_SSID_17AA3820,
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
+	ALC233_FIXUP_MEDION_MTL_SPK,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -10147,6 +10148,13 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
 	},
+	[ALC233_FIXUP_MEDION_MTL_SPK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x90170110 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -11013,6 +11021,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),


