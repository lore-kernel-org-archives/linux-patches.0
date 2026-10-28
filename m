Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210871;
	b=E7tg6jn6a/XVJHXdTdbNIl2T0zEkSPaN/INLHySYxw0NgUc36vv52YK+1L3eFGOoxogr
	 jhdLgMTx2D+ftZwv/F/wPw+nqYIFH1iJefQv7jA6G4hsBuCiINwZieIE6yxHA7j3ym6il
	 OzJaZyjeNx7vfsRnentFhiGc3phiv/BHT3k7yxGXAUO1rmyEyfOu24C7Rg2otxIBtUxeU
	 86f9zSQD84GwnB8Ies6u6NYj3JeyE0OiK7i1ZEQvW6h9/0b3z2vIqfyd4iicg3q1RTMub
	 6rhNQNYGV/8EfvtGZBJZpZbpSpjFjE8DkBKZdhKp3kNFNnEBUy1B8aPcwbyNUSCZSMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFMvUmp/NIWERb8IUfdQOlSq+ysu2mkUop2fTzc+w+4=;
	b=QNIrdxB90AEJVbrlX+DHX912fXl5r0dXsQWOszJ3AjAuN5rRP6SpQUlzOWtQUhCFkeqS
	 RpVpSi0d9ragBsq3qgbjvOfHWXeFwtXf8JqLzscOQzlBYUAKmKMjhSElzo0PB/qugu+3O
	 MtBS/XNyMZVX5ET3dfuOoN3dyRFjlh9nxoy25CbSZd4JxfQGRb6bBahUzmyq2tsD5xNHI
	 Lo5yNfe5ifO4KH7+vS4h0bRd8V80xBpnePeXMdDCBklKGfEpLGSgulBtRINbvlwtPq+Xk
	 igoPd3a4y6t8SHIp2mOoELjfsbc7o0reLU0u9yQYo0XPBqKQxaAgMR8DL2Ge9K6rYNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKCnaWRV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D81E606A31C;
	Wed, 28 Oct 2026 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKCnaWRV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2931F01828;
	Wed, 28 Oct 2026 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210870;
	bh=HFMvUmp/NIWERb8IUfdQOlSq+ysu2mkUop2fTzc+w+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKCnaWRVuyNad0v1kkYxleo+ElKq24Sb1Ariu4P5I3uk4WKXAhtn3GFoS+X1BPgzc
	 uJm0gZ3cuAwUyCwBRD0C8IdR6znZN0xdEuu838taiLbR2TCDE9nXIrrpbMz/z4RjYb
	 BCeCrO7XMpOb4OVgBQcBPRlYvHa1wClEWBFv4NXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Faaris Ansari <faarisansari@googlemail.com>
Subject: [PATCH 5.15 134/571] ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices
Date: Wed, 28 Oct 2026 17:54:41 +0100
Message-ID: <20261028170011.197324620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a154f7b9f197b3d5e41fa3ad62083f5aa93b1fe8 ]

Faaris reported a problem with Audient EVO4 device and it turned out
to be a regression by the recent fix commit 87a6f2fa6e6c ("ALSA:
usb-audio: Propagate write errors in generic mixer put callbacks").
It exhibited that the hardware gives errors at accessing the mixer
unit 10 on certain channels, and the change above made it a fatal
error.

We had already a quirk for Audient iD14 to work around such errors
from the mixer controls, and we can simply apply the same for EVO4.
OTOH, it's highly possible that other Audient devices suffer from the
same issue; they must be using similar firmware, after all.

So, in this patch, we apply the quirk generically to all devices with
the vendor ID Audient (2708), instead.  Ignoring the control error
isn't usually less critical than overreaction to the firmware
misbehavior.

Fixes: 87a6f2fa6e6c ("ALSA: usb-audio: Propagate write errors in generic mixer put callbacks")
Reported-and-tested-by: Faaris Ansari <faarisansari@googlemail.com>
Closes: https://lore.kernel.org/CANBVYRCL=8QdLxGg4S6qrahrFtwJxhv-aSGpW7-1S=+iOe4ZGA@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260929144132.1521617-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 1278d8a3cc128..112b9d5410849 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1947,8 +1947,6 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
 		   QUIRK_FLAG_DSD_RAW),
-	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
-		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
 		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
@@ -2006,6 +2004,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x25ce, /* Mytek devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2708, /* Audient devices */
+		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	VENDOR_FLG(0x278b, /* Rotel? */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x292b, /* Gustard/Ess based devices */
-- 
2.53.0



