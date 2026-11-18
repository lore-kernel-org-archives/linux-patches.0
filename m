Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043693;
	b=puW89wARIFVj+wfgpELJi65q/V8bNAoD4j6AL4zIONG67g5hIzXcSDa/tRVBFBeM4K/V
	 z7H3BRWt1xeJJfCx0bUHI62QzvcV8PdJb2dEPvq54fTAy/oyUAJiyT9gyey8iQZLyQIUU
	 MUJ27dKHZ8yeIsfkXykJ2Zjh0/mum2IqixWOzF+zg57BSmOCvtqGJ1k/iylAG19UU5/IS
	 832zqyAXub+GbeDICLfOl+C9rTON/dfk3U9NHAN3symoeN7qpu2ovRI7b1dIUG7ZEUAPO
	 9V9nBTscz0HhVCw5ougyjAgZ3CtP+IIHbW8J/Qt0m6CgJp+Miorcb9bCxQmG0Z7baqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aNz1e/L3S4sIguPim2IWxO99vQBYW+8T3g6kPw8OSp4=;
	b=KULP0NCM6wEgZBKtpjJMSrQEV15gEphgc+m2TPbO6+/aRZggMTfs2Auk/mgQqw7HnAzG
	 p3pb5uZi04jd/q/YqZcH+WlodxyYkVJzPFACiA9KY7HBY5gDlvRRfpRyTEUtk6y+UZwiy
	 vQ8+KJW6ozwNxWQ9t6Xq7T1CBxnMaRxyXvHc7OtWFeBRq/Y4EUyD2I/DJ4HrgrGlnH5Vg
	 9NDzGJWJS1+2gpXw1WXkm7QcOXiUbV/VpyKO9urZcb0/7gy7C237O+tdI8UQ05KOX9i1B
	 lfmzKqkukQCC4d/0vsOfcXb4dCxduQDbWW2gciSRKuK1WDDf90Oc1Zm9arVzzkiQNAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa3YnkS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20FD606A320;
	Wed, 18 Nov 2026 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa3YnkS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381341F000C4;
	Wed, 18 Nov 2026 23:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043693;
	bh=aNz1e/L3S4sIguPim2IWxO99vQBYW+8T3g6kPw8OSp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qa3YnkS72H+z7AztCNprtdrHMmv6JKYTNiuoezK6+NpnjaMehq7crQYndXT1uLBXS
	 26ivV0k9gRyshoVERR/v8zgX3CigaS6KDRbqLc6BI2YHCsXiV7zOl8jvxk7ZeZYU8j
	 kBOD4WXM590ga0gnaZk6mBQpul9QsTrdKqAHsgn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0301/2857] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Wed, 18 Nov 2026 15:22:15 +0100
Message-ID: <20261118150212.255479946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2f37a09a8a80..6dc54fd449f78 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2259,6 +2259,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



