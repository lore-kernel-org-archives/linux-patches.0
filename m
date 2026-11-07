Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061108;
	b=CebLgGMNZyT3xKgPJU6XzyEilDGG9O0pT/3w0mKLv1jS/Cw7fghIVLEXlgKGiLfbHuVg
	 lCta/8JyWje+FQh9bdZTGVYo8szC/qk39tZL13x/aEx81rzZZr/Md8tizuOidRmIxzvwp
	 yEUDEXHnWlfI97FYMunRdi/9FFbtdgfVid3h8Zocwdn+66bxoLHyw69yq3Ml9EgHSx6/k
	 aKmj3eGmYI3eiT1whVsZjAURIeuy/ocgWTZMeasNp/V5QJ7yXpVfTOu9vSlLOnRVGWG2U
	 f7s838AHQ15LE7+TUFB0ML39ZTMIisX7oafTjHBYhF4cS1PeDuZXBMhdTByW8vHxiEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VbOQu3e12HGlWXQTpQuQt6QmpuMlVeJ/VubWfhLCo8o=;
	b=ajRKpRaeKONFg+Y3h02nFhSpfYGDQlDdaC8OtKdcyyyRQWUjFPUh20diiJTdJt7eSd0x
	 iEv5A197uQOKaEFrdxkEQdBZNxq4TTl1weGCvjtLN79kskeVY8WfQ7aM/oF9rWC1ZcN34
	 Z8utLytST3j7t5jh2SDCE11qpzAYXW0Y5zethap4OCmfLl6ZVlsvbzSJpcpyf46Dv9pYI
	 bvTQ2PUsRUGJdULTmsypDf1EaVyKwRe8Ob5PG05tUPtKIV9RvtWaNiKc9ETzZn8DdAFD0
	 FHAOeZRESllpEaKEfJb1uS52S/OLlHJc2njQ/CG6Ewp1jBkcaJXxFStEcyje9qPWSJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1pqE4fU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D43606A332;
	Sat,  7 Nov 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1pqE4fU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C822A1F008A2;
	Sat,  7 Nov 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061108;
	bh=VbOQu3e12HGlWXQTpQuQt6QmpuMlVeJ/VubWfhLCo8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1pqE4fUMURJnZOkJdRoIqzMBk6wYJkRu5ralLD1DTp0VOQgVq3gMLMOEqC35ovau
	 rCMj6+2E84WcAXyFR03b6q9dpaUBhXs4Vd02zrnj7ARq3/LXpPEPHdynf/HSC2jZ2C
	 RhsvjH8YPV9kib7hP9IkN6noytWCfMcY7RpkVve0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0426/1536] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Sat,  7 Nov 2026 08:40:42 -0500
Message-ID: <20261107135009.531220909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc8d755256f2e..f224e41209e86 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2367,6 +2367,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



