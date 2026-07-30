Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CA04457AD;
	Thu, 30 Jul 2026 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425518; cv=none; b=oQBbdY9MppCFuKh2inR1Srjc7cGmidpOjPpV23wp5kB3FuR5FWa/n/l5viK3e3e+GzTmKXpNW0/r4yDQCNCq35GTbtu7Q/D0Ct+rMsDWdzAZKse0ijiAwiFEk/nuhN2oY+KaFCg+AZ+KnK+0We9G9vlEgN9CB9peaO+Li0dwESA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425518; c=relaxed/simple;
	bh=TdLILWskzNOaHSOTw2t5TyYuy3B41kWLDGaF9QjKfDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEGJbkoOGoqMu4AvT/3vTJVsFJ7G49WQLnTFVXSEhu6D2qsWz3XEX1X3HVwLJ4cRy4bPjqnenSuEIhHXIwpHKtxQzV6zFGY9zIyoPc25U31TRHCTezehj4wA/Pr0WlhfLk3LdC6cCs/lfIEBCpKvDEaA3ZzSeQ9JonrBqgtTVG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHfB9p42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHfB9p42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80D31F000E9;
	Thu, 30 Jul 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425517;
	bh=z5e+0XGgWi40kVefY3+yu1atiocrTCfJmvdohmj4KO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHfB9p42S6npcQzxJMjUvwK3SMh4al8VZCxDcIw0+kBBz0KVtcS9zvUyV+Mg2U8JO
	 0/OWWYEW+QsbM3wCMa367HaULpFEyMjwmFaOiVm0/gMyYGJXUIw1G2wHmZTaBXd9Jp
	 8ACmipcqtyJ4Vle501MIKraqKVmH+dHEB1ostlss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvador Blaya <tiniebla6@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/602] ALSA: usb-audio: Skip DSD quirk for Musical Fidelity M6s DAC
Date: Thu, 30 Jul 2026 16:08:02 +0200
Message-ID: <20260730141437.887334694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 93b47e66cc6d6c6382d44b44f5e7f6fc3a7b38c3 ]

Salvador reported that the recent fix for applying the DSD quirk to
Musical Fidelity devices broke for his M6s DAC model (2772:0502).

Although this is basically a firmware bug, the model in question is
fairly old, and no further firmware update can be expected, so it'd be
better to address in the driver side.

As an ad hoc workaround, skip the DSD quirk for this device by adding
an empty quirk entry of 2772:0502; this essentially skips the later
DSD quirk entry by the match with the vendor 2772.

Fixes: da3a7efff64e ("ALSA: usb-audio: Update for native DSD support quirks")
Reported-by: Salvador Blaya <tiniebla6@gmail.com>
Closes: https://lore.kernel.org/CAOdyq+qFaqCh=tK_wNnA64hv5pQuA1Y09ANxQ=xK8yR-t4mf9Q@mail.gmail.com
Tested-by: Salvador Blaya <tiniebla6@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260709095614.1418838-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 489dd84e20967c..ea2ec3507521ef 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2369,6 +2369,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
+		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2a70, 0x1881, /* OnePlus Technology (Shenzhen) Co., Ltd. BE02T */
-- 
2.53.0



