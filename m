Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1B7367B8F;
	Fri,  9 Oct 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557165; cv=none; b=uLaFYEdxWcEvCMehz8abRKRycpqkXu0woYQ40FbqWpf0MkiWZYDLohzYB0QTWJNWh79cStQasarOYXE5/TZhODHkT9hWqtiMT8N6P6vYF8YjJ7l7z1DAlCldb8df0bRd3SYZiPrDhEcC8Mc+aTbSgp9ZKvdxoH89rGc3o68o91Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557165; c=relaxed/simple;
	bh=bR2727LVUBfi5KuHzpVJNUXK3ty0W7idqWlKunvA1O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC4BvW2eWnuYNJ0zB7umEyD3aerRBCPfC1faASDPgiIFMEpzTnuxJlC3HNh5qHMk4Vv779lSN9ziZfN6cfgjgh9Gf6V3d0hHhC+V4s3NzhQfpJ9B6noEGMXh+ti4k3HLIIzqxbiZ96OzsVWivr+TaDfD1wLewJsU5Cu1A7EDFhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrzGnIgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrzGnIgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4AD1F000FF;
	Fri,  9 Oct 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557164;
	bh=EKcgR1GH7STdS0r2JLmX8z9pWoeSks7EqerRpgBGblc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrzGnIgVGLujvWlD5SdAhpjbk/+Qic9aI9GH6mLPDH13TXBUxNknKc1ReKTMLanTD
	 BqSVK/q1o2bnQF/JZ3Bl1BBatc3omcq+q9hJeis7iN/+zFgiTcnwVSe1PQpyj4GaaL
	 jq9v1HuGAeKy3XRX5fxcsOMGWjM45pS/y9Jq6PZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Gawlik <jakubgawlik13@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 272/428] ALSA: hda/realtek: Add micmute LED quirk for Acer Swift SFG16-72
Date: Fri,  9 Oct 2026 16:10:09 +0200
Message-ID: <20261009140952.066056855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Jakub Gawlik <jakubgawlik13@gmail.com>

commit 819f6aacbb1d1621c6a62721e708835fe1fb75d8 upstream.

The Acer Swift SFG16-72 (1025:173b) uses the ALC245 codec, but its
mic-mute LED is not enabled by default. Apply the existing
ALC245_FIXUP_ACER_MICMUTE_LED quirk to enable the mic-mute LED.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Jakub Gawlik <jakubgawlik13@gmail.com>
Link: https://patch.msgid.link/20260930145839.374762-1-jakubgawlik13@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6975,6 +6975,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x173b, "Acer Swift SFG16-72", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1758, "Acer Nitro ANV15-41", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),


