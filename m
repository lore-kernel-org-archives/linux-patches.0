Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3011DFF4;
	Mon,  1 Apr 2024 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991116; cv=none; b=MA17B26mWGltQfRciWCiHIvRSTD2dp4WpgEkfrzSK6UbQKZKE66ybckNZNW4MI9jZgDpU7YcSBDWAYzRBwh4kJZwi4SG8mdNikLjIj6pvaGgk6oXd0S493LipgV+Gut9ttCR//YqdmK8RqwW1AnAyFN8qL6LT2jnAVeZwiwfkOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991116; c=relaxed/simple;
	bh=+G9di90xkZzHopMTHpEMtKM/o25gdd6+l5D5FjxloVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q63WFN9+OCU06fvECZqHJTCtEAtedyvyvG0sxVVqgR3uhELaTgKAiqS7cgPyhTQu69cFxWTw3h+RBal6anzLpanthiO8lSFdpxvXxAs8Bni8C1AaG5cC3iIRc7gUf3ORvFvNsscbtlpz6zxf0unJ17h0fpGz7+Cj9Nx9wItthy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/jpoRaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/jpoRaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7BFC433F1;
	Mon,  1 Apr 2024 17:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991115;
	bh=+G9di90xkZzHopMTHpEMtKM/o25gdd6+l5D5FjxloVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/jpoRaAWUW5OPmt3zh3alN4884TrMB6Jd4bQfZnL7rTu7cTCkhrsDn0fXDdUfi8p
	 RYUPTp3Ztzr0diKw0tn0qgJoUhJANhQUoysYzP2zrYzEN3p3xfireN56yZKyDfMAib
	 vzYAyI/UEhRVBHUD/bhVudpsVK1woFuEgltcQqDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 167/272] ALSA: hda/realtek - Add Headset Mic supported Acer NB platform
Date: Mon,  1 Apr 2024 17:45:57 +0200
Message-ID: <20240401152535.968719738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 34ab5bbc6e82214d7f7393eba26d164b303ebb4e upstream.

It will be enable headset Mic for Acer NB platform.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/fe0eb6661ca240f3b7762b5b3257710d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10750,6 +10750,8 @@ static const struct snd_hda_pin_quirk al
  *   at most one tbl is allowed to define for the same vendor and same codec
  */
 static const struct snd_hda_pin_quirk alc269_fallback_pin_fixup_tbl[] = {
+	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1025, "Acer", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),


