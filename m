Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37DB4B7A54;
	Thu, 17 Sep 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667985; cv=none; b=q0bAQjhfOkSgu9nhO5hup34yIyqYCMBSXB3DWzmcDF914bEqTE/qBT37OFDMyyEWzNJ+j+rK/NyO+Vw6sIbVc09XamXyOZiKLWqQ+SKKOH6ZOKKrbElUF6fiO9JZ8LBF7mCUxxsMEhhMebRoBS1tHYFy1k+GU1+W1hHfGSK0Goo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667985; c=relaxed/simple;
	bh=P/k31y71UVuSes89RksSqGPRB0UKnZrSaQ2gRdXqJ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+haHmfpFaiLv6snwZCZd3g1Bu7NgGZScxdfTj96Fo2IBvDh0asew6OdzuswnmfXV17G9TlOa5z4ENUJa2ux0w9Sy4ypHDIEbDEGuEw59RsSmpn2KI12UT6ZR6zYcakQY3KAlgikUjX2Q8eYHt91afsI4oVxXG97Vy9uymnhmoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiSm2hEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiSm2hEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA03F1F000FF;
	Thu, 17 Sep 2026 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667982;
	bh=wk0T64LGC9YhwjzqMG1xuwgEgCoHY+TdA12Jfe98cOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiSm2hEHXccb8JVw9FGKd+9BINzVHL+8AKdXwBSsEZoBSk8wDkXgyeviNmXnSJmyf
	 nug0qvMBiD72toJDHef355jQmNBNNqZG/ma9AEbN80Qi/uUpSCMfwBvQpk4zJjpx9M
	 okrtFh7kEHoafa2j6usC0axPWdpdyB68cvDyCi40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>,
	Moritz Baron <moritz.baron@stud.uni-hannover.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0274/1102] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8
Date: Thu, 17 Sep 2026 16:03:37 +0100
Message-ID: <20260917151546.487618366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Moritz Baron <moritz.baron@stud.uni-hannover.de>

[ Upstream commit 853e10ec445984e99b3c7f6375f4e185614b842a ]

The Lenovo Yoga Pro 7 14IRH8 (ALC287 codec, subsystem ID 0x17aa:0x38b1)
has bass speakers on pin 0x17 that are not routed through a DAC with
volume control. This causes the bass speakers to play at full volume
regardless of the volume slider position.

Apply ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN which corrects the DAC
routing for pin 0x17, enabling proper volume control. This is the same
fix used for other Yoga Pro 7 models with identical audio topology
(14APH8, 14AHP9, 14ASP10, 14IAH10).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217949

Co-developed-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Moritz Baron <moritz.baron@stud.uni-hannover.de>
Link: https://patch.msgid.link/20260609141648.60608-1-moritz.baron@stud.uni-hannover.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9a56c60601c82..cce7e2e5f6e67 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11526,6 +11526,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	/* Yoga Pro 7 14IRH8 shares PCI SSID 17aa:3852 with Yoga 7 14ITL5;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38b1, "Lenovo Yoga Pro 7 14IRH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
-- 
2.53.0



