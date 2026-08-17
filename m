Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B0E3B8D78;
	Mon, 17 Aug 2026 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976615; cv=none; b=uGUgeP1+cGNRRi4eUSROckOcIt+xF0Oh4ZNppMsjDCjpQvU2SSOhCcQ5vm4JG9MQ105+4euzJfPD2qaFBJK7F0SXu7z5IEz180b2wRiCUHchQACw/7+EcwKNQkIOvqtgU9MVoyL3KebSgPt7UHRY83Q1yPE5H19sT+z1fjaGa18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976615; c=relaxed/simple;
	bh=n6hxcGMvGP8PTes70Zb/xO6j475nz14VwMlTXhN3EAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKgMqHp5oLnq6akxJMTId7NIRiQ4vX9OY1s6Zq6Z6BjGR3kSxF/eun9QNFpRbf599qvCRSpycD4gXSCclTg+D3PrH3OHXCjpxxSCs/Zu8F1knSsA4qYJ07fVX9mkr4V749KeXl30m/ynGkJk5o//cDZJhhWKNkCc55gkEDMBcvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBsrTr6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBsrTr6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79E61F000E9;
	Mon, 17 Aug 2026 14:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976614;
	bh=o/lfgpli0qrL1Q6H5LuWmbpA3tpnqyrLSO4VhqERzh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBsrTr6OTxQrRDH+CfRFsk3FD5Mf/X+ordF5rQLOFkpXM7BXryDz0rohW2sEHo5uc
	 Vrw5GP4hqhN78s8tZ1XYfCG2JsPJUGgFZOC3M4BqzkkNr+agGyadD4Tk3ePcy9N1lh
	 B/Ezl5AXzp8Usi3ayVCm2Xq2xms3l0XEQvcUabD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvador Blaya <tiniebla6@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/456] ALSA: usb-audio: Skip DSD quirk for Musical Fidelity M6s DAC
Date: Mon, 17 Aug 2026 15:27:14 +0200
Message-ID: <20260817132541.765978402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index acfad876362772..9cb0e24004db60 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1947,6 +1947,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
+		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2b53, 0x0023, /* Fiero SC-01 (firmware v1.0.0 @ 48 kHz) */
-- 
2.53.0



