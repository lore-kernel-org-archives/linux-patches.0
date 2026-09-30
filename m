Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7B519DFC;
	Wed, 30 Sep 2026 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792793; cv=none; b=Z0gPS8CxA77APy0Vdm+QVECdz1xRtqcRLyA2WISm12gdrNv4jPtRZG0WZEZbWQnoADj00YyxJX2YHx4ffavaW7iqkUe2nzGaylypLszJfk789TJpsyHL/gZDcZVqyrN3M6iA/QxT21ZH3cqV03JhjDfsrnOFPcH4rF2BqerEX5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792793; c=relaxed/simple;
	bh=sRtVaZJd0U54E2TgX9RmwjH08AiYmPeKyllFvzWWWhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7GVX8HOa1rURwCtJO7HiMEGCcT43o1IaNKmELd92ndp+Bqc3HhNcwMsy1z2rfHiZCMZ7tg2R7LR8s4yTcQ5ggs35B5ttJqzTG6yDtfxghdjkDGcnKVt5mwfnSu5cLgQbKTt/1X+ID+OPODPCa2/VcL1ColeFXb3Uy+LrcHYrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sutz6CuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sutz6CuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DCE1F000FF;
	Wed, 30 Sep 2026 18:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792792;
	bh=9v4u/Nj3V8KvytdIxdwMLoH8sGCpRbajvYpslopLzsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sutz6CuYMQCv72kzlXurKSJyrM178ZPJjDKEZBjdtHqMdUBDFddGsugDEBcONt4yT
	 EmvbU0kD0pOOA//g4s3LeIO8qbMn3ifGgOFUu1+ia/zy4iQKt+lE0hLbY/D/NJErhP
	 eDVhP8mh5PHTWs/Y/ZVOEJw5FPoUM3vJOdWRAu1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/395] ALSA: hda/realtek: Limit Star Labs internal mic boost
Date: Wed, 30 Sep 2026 17:24:26 +0200
Message-ID: <20260930152340.698350537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 186d4adbb40138e7cb7cffc87a81e95630ced123 ]

The 30 dB internal mic boost is too high for laptops, especially with fans. Limit Star Labs internal mic boost to 10 dB.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/be87292613b24150d6321adac102b4b25d00e9e6.1785532385.git.sean@starlabs.systems
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index aab2456bacaf6..5cc6c2d64e1af 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3986,6 +3986,7 @@ enum {
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
+	ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST,
 	ALC233_FIXUP_STARLABS_STARFIGHTER,
 	ALC294_FIXUP_BASS_SPEAKER_15,
 	ALC283_FIXUP_DELL_HP_RESUME,
@@ -6467,6 +6468,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+	},
 	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_starlabs_starfighter,
@@ -7699,6 +7704,7 @@ static const struct hda_quirk alc269_fixup_vendor_tbl[] = {
 	SND_PCI_QUIRK_VENDOR(0x104d, "Sony VAIO", ALC269_FIXUP_SONY_VAIO),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo XPAD", ALC269_FIXUP_LENOVO_XPAD_ACPI),
 	SND_PCI_QUIRK_VENDOR(0x19e5, "Huawei Matebook", ALC255_FIXUP_MIC_MUTE_LED),
+	SND_PCI_QUIRK_VENDOR(0x2145, "Star Labs", ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST),
 	{}
 };
 
-- 
2.53.0



