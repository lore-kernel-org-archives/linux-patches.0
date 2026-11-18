Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051517;
	b=TGSt0/DVUwAa3zUczDTFi0mvEY+oM7aHbwmE0DGY9QcT2dmZZLjQ/9UU3dBXfA2odePD
	 r2SnTR7VRsb4erUUcKzlS2WBX/BFNpk9EIrYhq1J65l8+iDybPQExSr3b58oG96NDRD3I
	 ReWEPuFddfo0h+dM6Lvw/dymZ7su56Z8DE9ZOubjNtAPXXKQOOD8VzP1BCLwKgtXaB0up
	 ts8vuhjNAOglGKDJ8VemaPnd4mnFHqyaXsWXSHrPc4rfauw5PZ4a5/9tCx2Zh/g3CbCoc
	 wn+AkVLozTzA8Yancnv2uaSYdu1m99RDjhJlAslI72SiOvwlxlwViabWxPGdphURkCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K092MN8EYMq2sf/CQEOrUEdds/87ZDMpJ10SpAxamD8=;
	b=fKSKUKAwXDo+XVz9IfVXf5lZbvodfLjkKyMnYF51SMVvd7/bzcz0ZbaDPTwaDCe9ZjY4
	 rRhERb1T//rbd+cyjZ9HhMNdf+UW7WdfrCcuTa2I5WTpa5K+hHV98GMMkac2AzxnL4E+M
	 2UzQKtFO9jlGV6DVqkKtUnUlDTwhhsRTle7VeUtxU4Qqy629J7HXRHiqVMvlscYNR5zpB
	 f0o65iKCOMW0Oqubt9KXeWfIXlXnPwKMhIJx9Tyxl4GUCikTMNpvPA34ybZaxX1kFGDe4
	 TTaB8+rU+rb+Vbq+FhXODCP2EUP/uDe2bsspV/7MSG8NBrrp6SHP550IzNYv7EkufZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tV1jda77;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D157606A31C;
	Thu, 19 Nov 2026 01:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tV1jda77
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C27B1F000C5;
	Thu, 19 Nov 2026 01:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051516;
	bh=K092MN8EYMq2sf/CQEOrUEdds/87ZDMpJ10SpAxamD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tV1jda77MBsLYq3vkaQE3mh/2F4IzeOZsNkTBLVuUFjMZWL1bR3XdQ6X9CchxeW5B
	 4lh5wKGbznemsRMKBWiy6ErlGbsnitQgsnO1rp0SC+ID0CCSb6gAngyXJ5tTCMMTp5
	 VLjDUvXj9MVHkZNzqSQndoDoRfytTYwKXAxLwdvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0236/2214] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Wed, 18 Nov 2026 15:31:52 +0100
Message-ID: <20261118150019.646106644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>

[ Upstream commit 4c0ec35e011309bd7091053ad5bbc01420967a66 ]

The M-Audio Venom (0763:2084) does not answer any GET_CUR request
of its feature units, hanging up the USB microcontroller and
"responding" with timeouts. So the mixer building lasts around 47
seconds, and the device does not stream at all.

The same GET_CUR requests issued through libusb (with no kernel
driver bound) complete correctly and blazingly fast. So it seems
to only happen during the initial probe.

I defined an explicit composite quirk to bypass the mixer creation,
as it is not needed (the synth already comes with volume controls).

With both this and the device flag applied, the synth works
flawlessly.

Signed-off-by: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
Link: https://patch.msgid.link/20260824140211.17003-3-fandrade@frba.utn.edu.ar
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 40de1c6fafb8b..941d9bef67e4b 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2435,6 +2435,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/*
+	 * M-Audio Venom
+	 *
+	 * The AudioControl interface times out on every GET_CUR request,
+	 * which adds around 47 seconds to the card registration and
+	 * freezes the device, blocking streaming.
+	 * Using an explicit composite quirk to skip the mixer entirely.
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2084),
+	QUIRK_DRIVER_INFO {
+		.vendor_name = "M-Audio",
+		.product_name = "Venom",
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_IGNORE(0) },
+			{ QUIRK_DATA_STANDARD_AUDIO(1) },
+			{ QUIRK_DATA_STANDARD_AUDIO(2) },
+			{ QUIRK_DATA_STANDARD_MIDI(3) },
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 
 /* Casio devices */
 {
-- 
2.53.0



