Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA80443E45;
	Thu, 30 Jul 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427182; cv=none; b=tfeGSYrappIqKnLikQFPIGzt8yPGkCELIszdU2bEIqRE814ac+lnM08niSbv5qU7U/aBp4t/nnsu5oNDFitHFAKDONUUjUpMBvmSqrj0wAIw4xIGVPJnI47leKzZNzzRLzbaP6Ul5rRNzjIC3o/E8Q7hRliHHjmbmaf89POLd/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427182; c=relaxed/simple;
	bh=3D2459oVL98hZg5JoVNIdX+OFc7DpCich4vCHcPgGxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/cScsX7SLZ0K9qFRvYpCgiwFY2sougepzXs1BpvhXHoqp59JmQFL2uc79IXfWuvYkxLw3ZX+sZ41lvNc7Vb6mT40H2DjprIieT6WK0PQKykmyiYnHwgBkNXBM57OXhCoDGe5TRM5x/U5bq+dwiJBZPHbzn7MV7XB82PEF1QMoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8ds7DqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8ds7DqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3B41F000E9;
	Thu, 30 Jul 2026 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427180;
	bh=zsrA5drvCROV+5aSt2qqT3zZ5yjnHaf+sVB0dgACDG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8ds7DqS3ixRqfTxDu90ZS2dPho/UTfjG8fZR2Znjj8R2HM7otbsrIpEyisGmott6
	 hBU+O2x45nJbJEDpnq+mvX8+smcX7JKBqxAv335Rs/JwabGkoX8muTVrWxZNUmrARa
	 d56mntusTOaHy+WI9IB2ITSTeb++hFf5e0oE1BgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvador Blaya <tiniebla6@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/484] ALSA: usb-audio: Skip DSD quirk for Musical Fidelity M6s DAC
Date: Thu, 30 Jul 2026 16:09:35 +0200
Message-ID: <20260730141425.132615911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed625d5bbe9ab0..8d77662d344f79 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2269,6 +2269,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



