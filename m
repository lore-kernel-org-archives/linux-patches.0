Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7479473C9F;
	Fri,  7 Aug 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117257; cv=none; b=T+C8bsltE1q2nWigmN2YnCLt8tP7P631Zh9DGsXT0R8Jx/vU9zoJowGYZPRApvbO+0kw7Hn+YNM2QwgcdcMaW/TuvWy6j7RScgkbgF9nr/myhTW2ZXCiG+ObXRNh2nLFhsIAeAPF+aavMmrmqdnMBtiqB8OSgEhA8DUfVtCaHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117257; c=relaxed/simple;
	bh=MDrcgPTmORhJFcsiI3azFQNj3TJQRLW0mC90inJiZiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qqq5WOhs7oshdogkq/PjrpEAeqlaPZIvxJnyMBfHLhHrOy0kqv9tj9jgFlP3kTH/pI4QIo8ZlM7Qjl5XESeMrxBaf9VGHGjKengsD2iLOMNWP0EgAIYxmcs8wqbYiQA296lSvIta8YLALo3bklfatfXZ4LrjVn9pafSiU5Ox8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLqq1b2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLqq1b2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A22F1F000E9;
	Fri,  7 Aug 2026 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117256;
	bh=weN3uLA1JVEIsiogZBKsM5YiIUpJOwaNvFDhDtGqJNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLqq1b2y9JR6IwpaLldkuuZgFGY12JqLLxNIgNLNG1gMKMHwcJ8tvAJZX4Eb10vB+
	 0CjUiLRLKWJBd0Dn+9oGwV/dag/oi3J/d92db0Pa/6Fk9+aDPmxsn1vhcZKzCwG3HP
	 E1gwf0jNFtYDkcLL1gFlLf1DYfxknaQVAx0R7xrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 253/438] ALSA: hda/realtek: Add quirk for TongFang X6SP45xU
Date: Fri,  7 Aug 2026 16:37:29 +0200
Message-ID: <20260807143433.391287436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

commit 26a94400ffa4fcbeff32e23abebb83a1a20eb401 upstream.

TongFang X6KK45xU and X6SP45xU have actually different PCI IDs. This patch
Adds the missing PCI ID to fix headphone detection and clarifies the
naming.

Fixes: d595255241e5 ("ALSA: hda/realtek: Add quirk for TongFang X6xx45xU")
Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260724190109.169889-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7858,7 +7858,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


