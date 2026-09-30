Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC744FB9C3;
	Wed, 30 Sep 2026 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788918; cv=none; b=ootCm3QvqJL/61rvraK8eZqzZa8PqjQyYFNEMMq4sdAgO205ingaxSq/NNt66inKcHvbjWKxcWnQWYdnHG0n7Eu8ZM96X8iZxgYhOvGeX6u5IaXSXMIHQHPiTqqtc1AEfB+8JM++U6GI2hTJ8h2lNVTdADt/9YBVNOoST8vy/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788918; c=relaxed/simple;
	bh=GWTPx6hM2D1HthSQASbM9p/2U58aPz5Ph1rgG8Doo18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gecsRfPYoq1ipCYNlSEyL0jQZmm7QQLOVdYH7lpBGlJ2d/C98wgc+gf/HeQkOsJVLBzNLF1K3FiUZD6m2Wshani6lH3X90Lx3NOLepP6Qj0vG/8p8TE5hKjvQOnKFL2JU5I+jjFOAnpn1MsafnCLRuDRRwikSyzyp5gS+ClGMvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppNPgphG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppNPgphG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155761F000FF;
	Wed, 30 Sep 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788917;
	bh=t/Sjl1/LtPTEqJ4pL/duSoZjs+t7p0NqbUKCPGrbatk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppNPgphGrrfTQ/OesJ8R8fFFsBV82lHZcHHFKmicSPi2fZMuI5ZFnYgkB9LHyqKVy
	 lpiz8PSBYt63Cgm4UBOMFjV8yTIT2u1Qv1qASK8k0jGR0JA1EGaFWy4hJQSk5PNMbd
	 IKy1gEaBHdsFv/nmBCmjBlS7xzLJ0iMHQJAMsGXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/877] ALSA: hda/realtek: Add StarFighter HDA SSID
Date: Wed, 30 Sep 2026 17:20:04 +0200
Message-ID: <20260930152421.031737327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit cd401c70df472d3eddd0b6b055726a03c212181a ]

Support the new StarFighter HDA SSID while keeping the existing SSID chained to the same quirk until the new match reaches backports.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/06865eaedf3de8dff199e9aa7e86cd135572f20f.1785532385.git.sean@starlabs.systems
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e9913767b0b84..72d540182f8d0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10660,6 +10660,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_starlabs_starfighter,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST,
 	},
 	[ALC294_FIXUP_BASS_SPEAKER_15] = {
 		.type = HDA_FIXUP_FUNC,
@@ -11698,6 +11700,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x2145, 0x0001, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.53.0



