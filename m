Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5B7357D11;
	Wed, 30 Sep 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786811; cv=none; b=p6qv9JE3G1fpk/swTXysHa9I76NS4snD3YocBGl8G4UYK0t0UztfKGCDH/nmTLpI68IUkkVa7RQV6vwl+0AvvGntqFixOIewugGszRu+pYawYAFGr4/qsl7tk+Hz5fzdwTcE9bGdw/UrKYVCn/SNU3LOVKpGnTRmm38kPanJGZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786811; c=relaxed/simple;
	bh=Tuv8d/x45Kg5s3DXy+foI6Ygrf/5YR9hxSvMEY/LeMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrMJ6tikfci8oP97Lh4lV6DERgjQk2qlKG+28p3Mz+t4LalTODuF4stPZD+oxVyRWUTyKxHgJy0vqNfc+57Gy0/ouWKjDUqntvpomeshDq+F2p50RAnoL14xGMcpICVndYkmaZwz8tgFGaTscvUraB9fcjATd5iAPh66EBYHEfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6qp+GEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6qp+GEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E011F00893;
	Wed, 30 Sep 2026 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786809;
	bh=ETqAisvXKLlA3QFK7ULreTxdjK8HpYq1exUINtcsNwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6qp+GEymVbSouIhdVB+knjIO/izZME7hJLIPDYmTdXdMPbgRwBKqp9FD2y/j6m1n
	 0Es2tlvPcCZDja1aYtOV7VNoPdBnnJbRnXRHfGSqJW3P0hlYBVE0FzbaoV1IIejabZ
	 XfToTPE59vPRn67CY6Dm7WrxhtgjAHgXy34hAmnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/457] ALSA: hda/realtek: Add StarFighter HDA SSID
Date: Wed, 30 Sep 2026 17:21:48 +0200
Message-ID: <20260930152346.104258815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit cd401c70df472d3eddd0b6b055726a03c212181a ]

Support the new StarFighter HDA SSID while keeping the existing SSID chained to the same quirk until the new match reaches backports.

Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/06865eaedf3de8dff199e9aa7e86cd135572f20f.1785532385.git.sean@starlabs.systems
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index aa2a63d9a63e8..1e0612c39c89b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6763,6 +6763,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc233_fixup_starlabs_starfighter,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_STARLABS_LIMIT_INT_MIC_BOOST,
 	},
 	[ALC294_FIXUP_BASS_SPEAKER_15] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8090,6 +8092,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0x2145, 0x0001, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.53.0



