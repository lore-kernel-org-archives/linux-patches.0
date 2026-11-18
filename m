Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038693;
	b=2Evmdj9BoJQTFOZBeifC/Pv1En0of+pEZv5mDcbDOcYWpPbnR3/vzQFXVN0cgjfjAkYD
	 7PJdsfa+Z6WulhiUwxFMGk2h+Y2LuyQfD6Wh11vXQ4g9j5bayV7OBQnhXGkH9o6q0/L+W
	 IQF/PfkYiP5pNuyWInQHC7KwK3HtUtc3mIOdTzlQkXom8oCRxn6cCZ5Q1mGanfyEpblLN
	 uFtM0IVutdzV/dbwlgLVDWDWGzR6jcZiDNXHSDrZNNgUqkIwwURKOLGRKkF7BJUlsyEt9
	 dohazueveY9UdVURd88iQ8Fy+mgRgD6DYAopDtaXCD6THF9h3y/ggpFVA6fpW6S71UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MC7s4tOtt8LdRSNwtLf8e4xvCDY1E7qlQ9/NHRkjLJ4=;
	b=lMJWyA+rHeco76QuDUMKqsn3y9S3hDtLrpRRHEykojLs8OJdBiKc5IoDS3oYROvJni9h
	 KslJEjKhg1dHKWYegN/Mxx3fODDBZRNzZ6+JZu38D2MtcAfAd1b4VdoCADU25ejdRNzdf
	 p+bhhaVaExGmWQvFQpbfmcJ7TSobeTePtiLNx6oRyWGDcTSzLQCog/oKp6sy1lbkmvZbI
	 1tpZPTzKUFT+PSkc4CadBpF8f4o8W29DtiouWqHe4fzsbgZwCJxYLTk2kPBXjVzLx6M5d
	 SVPQCKGG/4n5vT2EsgNjaqnBc1E4fnzLxFMHG+3/tfnAqRqbDjQ0A9eLkcnmBLb3Hng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3VuzpWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506E606A31C;
	Wed, 18 Nov 2026 21:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3VuzpWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9F01F000C4;
	Wed, 18 Nov 2026 21:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038693;
	bh=MC7s4tOtt8LdRSNwtLf8e4xvCDY1E7qlQ9/NHRkjLJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3VuzpWzyUsSZY3yewdz2C92KKUlXdkV++5JqOS6oLWzygGU2swCYop1fvJoz6ieR
	 hXXCl3fpZ7IlymVM00ZVa1kqdOVDlpgnOnKRInJTPf9jVSFryziu5X2wolDPkw3eAE
	 D4O5zzrm73v9ewwpNqQdvSjKly5dgBf1EVdWetP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1827/3318] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150416.673439107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

[ Upstream commit 874323b68c93c6808e034dc0113681e822e6fb42 ]

The C200 (046d:0802) reports a mic capture volume range of
1536..7680 with a resolution of 1 (6144 steps), triggering
"Warning! Unlikely big volume step count (=6144), linear volume or
wrong cval->res?" at probe and exposing a uselessly fine-grained
mixer control.  This is the same firmware behavior as the other
UVC-era Logitech webcams already carrying QUIRK_FLAG_MIC_RES_384
(C500, C600, C210, C270, C310, C510, C525, ...), so apply the same
quirk: CTL_MSG_DELAY_1M (which the Logitech VENDOR_FLG would provide
if the device-specific entry did not short-circuit the lookup) plus
MIC_RES_384.

Verified on real hardware: with the quirk the warning disappears and
the driver logs "set resolution quirk: cval->res = 384".

Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261008230844.11246-1-olivier.kaloudoff@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 302736f271932..321eaaf9fa334 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2060,6 +2060,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x045e, 0x070f, /* MS LifeChat LX-3000 Headset */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x046d, 0x0802, /* Logitech Webcam C200 */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0807, /* Logitech Webcam C500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0808, /* Logitech Webcam C600 */
-- 
2.53.0



