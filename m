Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4892475F7;
	Thu, 16 Jul 2026 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209199; cv=none; b=mej1AoHJa7A68qakGxoJZXL8pbeKroYwoaU/Zlv8ysGmk9IPRloZkFynn5oj/Yd5bFPf8ilNvLwQu1Lmi0WgIEdgYVm3jyGzswNfmVwco1Qmp4bHys4WOzK2e/xyDA+LZ8lgQDMWxyxezcOgPV3bGSLrqOCJ2b/5qGOtMVNrvL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209199; c=relaxed/simple;
	bh=ed7DHEFxkzQpWAcFJpulMGU013L4iBgVlFnyDGBetb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv/eBsPu7eRD+bxi4sUAJk8XyPGGPqIepVXrwe+LfI/jAePPdOS3FklNI1huX83VFdM1j3eFF/CNnhfIUYP5r6ytno5buBsXbMmEt2HEhX8+xDLH2ZkeC1bZOzs24lriVhIgjDSgyyFdhGMPCpNKSBowknWQvcsgJSrZxNmnOK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6hGpuJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6hGpuJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4574D1F000E9;
	Thu, 16 Jul 2026 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209197;
	bh=tbQZAP5oqddh3/Q5ragNU4CFRAInIjMcPfbTSOTgsUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6hGpuJ2syVLLaqCnt3NJ9xBPcRetXEylqONDmBcrHZJ1BhitMwiF4pxVoaH0MCV5
	 YO7MbT5I4m9qaVXspeyXJyUZWnyQAwZ3Exa/2pK88elDsVi8eenvmFA1NawnB6U1So
	 FG3Fam8+zg3DXyqctrKpv4I/SlaYae9PuE1c6EUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 094/518] ALSA: hda/realtek: Fix noisy mic for Clevo V6xxAW
Date: Thu, 16 Jul 2026 15:26:02 +0200
Message-ID: <20260716133049.921052882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit 493765b8e922a506e09e22e80b6cc9ff05e8295b upstream.

Add a PCI quirk to reduce the volume of the internal microphone to prevent
extremely noisy signal.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260519155047.106096-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7567,6 +7567,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1558, 0x51b3, "Clevo NS70AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5700, "Clevo X560WN[RST]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x6480, "Clevo V6xxAW", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f2, "Clevo NH79EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


