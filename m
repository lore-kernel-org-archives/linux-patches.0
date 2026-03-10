Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3C13806C1;
	Tue, 10 Mar 2026 11:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140782; cv=none; b=NJZ0p5NgLYs98KXOmNx2n64YAfcwHI0DUZ9ZfgkI8wew9VlTjmjgky/qJZUMq0dpvTRVdH/ROYnxzAqHIhEXn52Mik9ZqQ2za7Q6bHFd6EYLD5q7xRC6d+dnWm32vieVpYxuvmoFQfbeWU79dcp0mw3sNgypJvuV+l8QRFei6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140782; c=relaxed/simple;
	bh=yNlAUKXZO4Sg5GaBf2UmSd2nUvOcfHcZEPY45nBMeRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM7d/CGEq721//5jMC9vaxb8CEprW9TgNvwqhnlSTBimzPnpF33nMpdyPWtW2oKnNRFT42ZvcARGe9muwRofQ4OC7Mu01/r6zJNls3gz0Bzi19z3m9zriozXiVPLGps87+LSirj85PDwKHlW+u+8eC0yz171kQlix29XMiduy40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXIQEnB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXIQEnB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF8FC19423;
	Tue, 10 Mar 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140782;
	bh=yNlAUKXZO4Sg5GaBf2UmSd2nUvOcfHcZEPY45nBMeRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXIQEnB2aXPyDySyqvQlLd8Vb7o7EcCb+Dbyk352aSU8f+rlUd0eigf7KC+9AYcqc
	 NTbtxQ3688sSHz/qR/xP+GWSDx1p05EdNWvNRoF5LauFxktgaLufo8pO8Od7MYwOjK
	 BCqCQWq4O9myhaHRaZFqg0ndhchHHI+Z5qCBI6CYm1+k6dhfVkRuI4fwReTbe3VgPs
	 hl30phFDymD3e9IKWCutpV+EH2cskSsrWeIR9fNvN9lMrU6WwUf6FMbsk7ZMJ8OvGg
	 yTTurrcgYqWOLbwFD5exH7k3Ie6wDLn3Lg46PE6IRIhv0eziO1bfY+Zhw+f7Qi2MhW
	 w0cBgr5IaB7HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 017/311] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Tue, 10 Mar 2026 07:01:04 -0400
Message-ID: <3fc64e0aaa72a20bed4ebd8951c89cfadf474e62.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit a8cc55bf81a45772cad44c83ea7bb0e98431094a ]

Remove QUIRK_FLAG_VALIDATE_RATES for Focusrite. With the previous
commit, focusrite_valid_sample_rate() produces correct rate tables
without USB probing.

QUIRK_FLAG_VALIDATE_RATES sends SET_CUR requests for each rate (~25ms
each) and leaves the device at 192kHz. This is a problem because that
rate: 1) disables the internal mixer, so outputs are silent until an
application opens the PCM and sets a lower rate, and 2) the Air and
Safe modes get disabled.

Fixes: 5963e5262180 ("ALSA: usb-audio: Enable rate validation for Scarlett devices")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/09b9c012024c998c4ca14bd876ef0dce0d0b6101.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 86c329632e396..9cc5165510182 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2422,7 +2422,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   QUIRK_FLAG_VALIDATE_RATES),
+		   0),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
-- 
2.51.0

