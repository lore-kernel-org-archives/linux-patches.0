Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F01351C2E;
	Wed,  8 Apr 2026 18:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673008; cv=none; b=CgIwzSzyALnUGHAyuQpWdCkX9R8M3m8wngx55YuMily/Aprmhesq9IQDb9Rg0lKVWg0+1+kYMCuG8nvHjOAJXo5V+1T0nUebd4YnfPbi3F23VinOcKtyNKbfbZ1JC5Z2ZZxAPOXYuhPMkl9K85fPt20aS2pQ6WiUE9OC8Ssu+po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673008; c=relaxed/simple;
	bh=aMu+O5Po24nSsEvmBmuNDUr0uWhkdT9QpPSvGFlQuF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U88QRxAO8wh/S+l22emStY1ElZCzRiYCrmQt6kRnEGPfhPaCB8VlmCYma60DUiofz1vlqBCGJ1ZgNdenopWYuYFhma9ttG+OdkzYQatwcFvG0zfRLkLe5cMaL+keV7cOlnESWZ8MjiKmN+AosJGqtOOoiu1X+uAJ0IA93hYObcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvdJ3QZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvdJ3QZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D32BC19425;
	Wed,  8 Apr 2026 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673008;
	bh=aMu+O5Po24nSsEvmBmuNDUr0uWhkdT9QpPSvGFlQuF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvdJ3QZcAYEWzUlLmdOvf6CLBoJ7XBseAi5Zb4Mz7oZX34G2mqy5lXuBokN1oqqQu
	 /bNYgwU6eF8h7HHUi8XIYRHVYZVsPf/0+FdJA7NCl3avUCcNx15uuA8kYrlGDTRnNk
	 J9xR3ir72nVJbcXwDR0PP7nqMNqtNC/MILMpQ7Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/277] ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen (8016) from SKIP_IFACE_SETUP
Date: Wed,  8 Apr 2026 20:00:50 +0200
Message-ID: <20260408175936.286894938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a0dafdbd1049a8ea661a1a471be1b840bd8aed13 ]

Same issue as the other 1st Gen Scarletts: QUIRK_FLAG_SKIP_IFACE_SETUP
causes distorted audio on this revision of the Scarlett 2i2 1st Gen
(1235:8016).

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: lukas-reineke [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/acytr8aEUba4VXmZ@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 2c01412a225ef..9f585dbc770cb 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2424,6 +2424,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_VALIDATE_RATES),
 	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x800a, 0), /* Focusrite Scarlett 2i4 1st Gen */
+	DEVICE_FLG(0x1235, 0x8016, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	DEVICE_FLG(0x1235, 0x801c, 0), /* Focusrite Scarlett Solo 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
-- 
2.53.0



