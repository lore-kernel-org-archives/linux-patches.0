Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ADA4DA55E;
	Mon, 20 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692023; cv=none; b=ZaRZ/4IaQlDN+8/fR3C+jRsB/MFbvUx9jWkii6mIxvUS5jvdg5cfRGH7XFj3QKwLq4Pj/HhLk1ZoXv8+at5Uetz/bNUZeJOlBYXioeXoS8xADdgbmGevhQR2mRqjJ3kMue/b/bikwHlS4zDWFrvloneG+gDRzYdEMFwDoH32KN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692023; c=relaxed/simple;
	bh=E3R1SziPVKzao+a9PFJz2aBzVbupWCLKdEnkj7arJOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXlws8gs8XzGoZnm/CDy7fzwKSShXv63avc0MVrD4RlrLlq92TCrhEdMt8bLP85rCTcp3tyt6ykJH30Dz7Q9iKnvRwXl0ES0j4PPyRYEmRMeX9ZDXrf/mgt3E0e3tKT2aKC8ALiucoFR5zWX6Isy7k/U8AcljC+1xEBaNJbqMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npsN2f4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npsN2f4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF573C2BCB6;
	Mon, 20 Apr 2026 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692023;
	bh=E3R1SziPVKzao+a9PFJz2aBzVbupWCLKdEnkj7arJOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npsN2f4+CBDTkfMMMqsqmAqkhhrl+5CPxiHF1zqcaI4PLeQmPlipvXtByP/sAXrkt
	 PA5biZGOSao2f+zJVN3aOYdeZ/kba2v3eg8WQOS2SxHYJ3DnsbCI12DnLO9U/1UZdB
	 f9lZxLWBY8WE5vYdpu4fvw2I4lmrPSBZmk1DRChg3vWE5lDAP9+PbZiQfjwdW6S/J0
	 sXFOkNMvKi/OL0Yz3YJcBsPf1r7tZ/W1ue5qoxVXGLFVcpj+8HefNlSnGwh3ESe4zm
	 YxzJd6q0gq3j+sTdkBF9yJeaCOl5dUgforEzUE5WPsvJ0zM5QbEpF+Z4aBTZjT26wZ
	 yBc5oXZbTU+4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 20 Apr 2026 09:22:03 -0400
Message-ID: <20260420132314.1023554-329-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 59f68dc1d8df3142cb58fd2568966a9bb7b0ed8a ]

Fixes lack of audio output on the ASUS ROG Flow Z13-KJP GZ302EAC model,
similar to the ASUS ROG Flow Z13 GZ302EA.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260313172503.285846-1-matthew.schwartz@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4b06cb48252e2..1959adb6c5189 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7065,6 +7065,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS G513PI/PU/PV", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x14f2, "ASUS VivoBook X515JA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1503, "ASUS G733PY/PZ/PZV/PYV", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1514, "ASUS ROG Flow Z13 GZ302EAC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.53.0

