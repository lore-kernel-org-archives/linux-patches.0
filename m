Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051567;
	b=HV3U9yv+Fw6Snk+JW8oGLIdXtoby6+ma2V0xiGt6la/H4dZ1l/VuXNIzoH3/ct6fqF3Y
	 k69DSlKNqXeFq4tWXGWKTUCWwaG2u3w5tesU+Q086nVyHTsrL53ld693t8CP7UfujmDLX
	 VT119NENufzIQBabp5yrLOJJWkw8+ZdeAty9agBQhH88sLh1+4YihE4gY+83dR6xtBLmU
	 naXxVWF6qvwXzG8n1FyWwb5WT9mswLqeyoP38Gcanxe1N5YXPpGGHe0LoF0ko1g5eUHVV
	 mFyG2C8SLIjPTosGAC8uKanQB2kC+il69IOTWSPl0QZW3iUS5JodyHPsvNT4Uht+Xtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v0gSr1HH7Nt5lr01OkhkQ9QZ9NTjFzppzutq5VbDxaI=;
	b=d8+XflgU2DP5RHNVXriqV+AizU3TbBUQpqYwR7teSNTOUz3Kwpi3bIGTty/I6uoJBcuo
	 xy4OFGXU6SwMcvaiVqwZQrTvXZ/NYHISH55LI9oiV4pZw0w7O4Ewmly0EATHzObmeSVGW
	 gf9ylMMeSe5hoJXuTYsFXCkfcIA3phhtd4TuMcYqBrcVApBv3wZ2A7FP17zPG0qPWDt8Z
	 2cneFZZftoF0nfnFH/Pc0BeQ2P7yNpccYuVo9VW5jIjQXUckaLFbO+zpGdP1IL4d95wzO
	 qcCdU6ssfip61MECS3gcAE4oZ9lVmdma28vtIXOB9Q8OIIj3aDH5FtX5UyWe4mFhVYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCjFn375;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18E3606A325;
	Thu, 19 Nov 2026 01:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCjFn375
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438D31F000C4;
	Thu, 19 Nov 2026 01:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051566;
	bh=v0gSr1HH7Nt5lr01OkhkQ9QZ9NTjFzppzutq5VbDxaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCjFn375O0ne0eGDvtXWvvf2+sRcQ+YS3Eya/2fyNbDYt/GGA70CNwg3zRTyAU0Zd
	 J4oEcrMGwHsE4q5HRrB03UzRP6x6PhSkkNpgnj/3O6jmgYhzcRKUYgVh2+fat3oBZx
	 XjZEGOgRpcQefWQrZd7akKRmSr4NFkWMSzCTr+00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0252/2214] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Wed, 18 Nov 2026 15:32:08 +0100
Message-ID: <20261118150020.227710177@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matus Gajdos <matuszpd@gmail.com>

[ Upstream commit 4e1462e7cd6a9b920f441842726cc2b9d232673e ]

The Cambridge Audio streamer advertises the UAC2 RAW_DATA format on
altsetting 2 of its playback interface, but without the DSD_RAW quirk
flag the driver exposes it only as a SPECIAL format that cannot be
used.

Add QUIRK_FLAG_DSD_RAW for the device (USB ID 22e8:ca10), so the
altsetting is exposed as DSD_U32_BE, enabling native DSD64/128/256
playback.

Tested with: gst-launch-1.0 filesrc location=file.dsf ! \
                            avdemux_dsf ! dsdconvert ! \
                            alsasink device=hw:2,0

Signed-off-by: Matus Gajdos <matuszpd@gmail.com>
Link: https://patch.msgid.link/20261002125237.82188-1-matuszpd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 112b9d5410849..8a99f44653456 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1943,6 +1943,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x21b4, 0x0232, /* Ayre QX-5 Twenty */
 		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x22e8, 0xca10, /* Cambridge Audio streamers */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x2522, 0x0007, /* LH Labs Geek Out HD Audio 1V5 */
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
-- 
2.53.0



