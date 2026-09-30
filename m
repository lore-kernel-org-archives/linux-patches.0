Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD043BC68E;
	Wed, 30 Sep 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794752; cv=none; b=T4UDFlCgp+etnO2J5FlQH41pkQoDsjh7PsqAn9n/DjTFMzTbYWlzYhUiZXIVpH+5BFeOtp0S8q4tFdjtG7Au2+nqOZRwE9gS8QhxRTSC5e2VVm0sp+3farA884kk5bdyxheLPgY99+0PNFAWCe9tD+bkLqJ87Cj7Ot2Mh5N615k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794752; c=relaxed/simple;
	bh=iiw7FL/6GNcp5c3658LGk+XJJG+DI9lzwYL9SE0q+WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRrFzpBcKWC27hTb/0s3HhIijQWfmSIrWGdNLuc0qemWG6KGG/iH48fVwFAewQFZnTbTrVa68LqUQw41etz8d3yYvTx09OHDv7b1UFa3ZqqlESE61hKWkfQleagxs1y2MwV538HOMFMa/rr5aZI34vz+NfTjBo8at4J0sM0N6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXFt0SjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXFt0SjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8AA1F000FF;
	Wed, 30 Sep 2026 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794751;
	bh=wjShtiKGr+ZhBQZ5xYCfEiqo8H7wcY0TETSFtTKFriE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXFt0SjKh0DPBsJKG+Jd5lzHyjiN/xNeFdWI1egcByi6VzrA4Sud6dgks7mz2KGbp
	 sTWEama070jXFfIBhtNkgfHawHosf0bMXY+2qRNxn+zu+3d1IlYHEvxmbuH66x91R7
	 EOHS+F/V4LtdC2TbI9kB8hBcm0bH+9xaESbXBmGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0319/1193] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Wed, 30 Sep 2026 17:16:43 +0200
Message-ID: <20260930152441.225391113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Daniel C. Ribeiro <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index aaa3ea577a59b..edfdf1625a671 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2165,6 +2165,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0



