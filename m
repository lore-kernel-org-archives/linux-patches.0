Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC99C320CD9;
	Thu, 16 Jul 2026 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210590; cv=none; b=DTk2aVv7ms9XlLnviVgQK+iO9mnfV9i6u6AslJwcc+E73c6XDjhb6miujGmFAfF5uAEx3YGcu79kLL9uZBbY0DV70tBbJ3lcGb8Rm5RMKRzrcYgasUzZZ8QfVoIIC389u4U5/eLbOYK8sCx6L9yvwAm+ymhHnth5Ui4mm1v5Mdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210590; c=relaxed/simple;
	bh=HoiMamcCDXsRRpKkIAcbfij+pz2X+SvHwgm15tkyRvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCbiovBC+M50wisxTyoP0BhMvqx319xGvNhB8UrqK0VyZWvfK02tFPqyig8HhObcalJd6qJYP2UwrUrF72qzJtpZoT3bvwkpv5Veq8UKD5sTzYX0pE88b54VaM/TSplGo1dXAsIu/pThiO7q/wW2nm5v92skoexhnU1aKpdaSqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bz70aNjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz70aNjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434291F000E9;
	Thu, 16 Jul 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210589;
	bh=SXHJ1GLfBBmkXklhbRiB7E35zzCWcyScu9AC/XlPR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bz70aNjgTyBqAA5gOt/WL4m5CarQlkPG7IsS0oGP+u/RWfaTy6O3iaEiHDMBzkcpn
	 cXqIiMYMBMrtnPrGaBP4v0x1uQtnGTdo+zuw47QYoTqmqsh06Od+DoVtbFkkXJp9+T
	 MZIkKduHpZn4Dwhs7L/34GVe2R6Yr/MvbWLpNWsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 106/480] ALSA: hda/realtek: Fix noisy mic for Clevo V6xxAW
Date: Thu, 16 Jul 2026 15:27:33 +0200
Message-ID: <20260716133047.004846847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -7290,6 +7290,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1558, 0x51b3, "Clevo NS70AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5700, "Clevo X560WN[RST]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x6480, "Clevo V6xxAW", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f2, "Clevo NH79EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


