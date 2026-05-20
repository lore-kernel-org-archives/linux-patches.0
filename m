Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3803BCD2A;
	Wed, 20 May 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295493; cv=none; b=PFDnrHSMOrwt8P4EJ6ns5vqRivdsiX2GFCw4WrtTLCo62qpCXKDIH/oIfZVIYs5Yt95besRppCqVSowKJZ9qHoZmRKmK1cgRmZWf8Sc1czpbMjO3uG9IX2PmGFZj8TX01VwiCGQtMyKs/7JbazF7tL6OmwGo59JCah4HOFnYBM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295493; c=relaxed/simple;
	bh=lVhXZK72qh+Be/D7KF8De3Fr1EnjQWYDwZN0hezIzkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1KZbOQHnAT4D8IpAuupDamkeCNy8cYAgPRMEiekDE4v0E8j7MYk8sueolJ5ez2hNNAnhOB9fhUjLA12eegs29SzgREbr5EdNWBQZiZ4UQROI2FpqAWb97WHPSRcrLng3hqbgzxnjeQsKVKPlxpm7SIsFsRZlHy39dojWlYOjyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRZYBK5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRZYBK5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7D31F000E9;
	Wed, 20 May 2026 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295492;
	bh=FD9t3FS2c8R3AsQ2vck8AxOu/WPDY9N2uflGkhuXUJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRZYBK5wHvYI2Tsye2+GfyHW+AGr2NLT4mX4wU15kI/f+SPLhZl2+YO9SHUjpFgY0
	 svq+FGZIz/OZ0MZHUyH5Z2kV00bTe6YEnuBoREpVFMDgTAOT4x4spHtFhXxMJgDGoi
	 FGlAsOtxr4Ra4+vaRjZXbI6Pr6BS1vU0honVkSiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0441/1146] ALSA: usb-audio: Exclude Scarlett 18i20 1st Gen from SKIP_IFACE_SETUP
Date: Wed, 20 May 2026 18:11:31 +0200
Message-ID: <20260520162158.179208266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a47306a74c31557b1e5cab54642950bbb20294cb ]

Same issue as the other 1st Gen Scarletts: QUIRK_FLAG_SKIP_IFACE_SETUP
causes distorted audio on the Scarlett 18i20 1st Gen (1235:800c).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: tucktuckg00se [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/ad0ozNnkcFrcjVQz@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 4cfa24c06fcdf..6f2a053d971c9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2435,6 +2435,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x800c, 0), /* Focusrite Scarlett 18i20 1st Gen */
 	DEVICE_FLG(0x1235, 0x8016, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-- 
2.53.0



