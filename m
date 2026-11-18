Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034393;
	b=L8HbRoh9D9r4bzsMKmRjSjegfhsK/m4+1oKC0VZu+LGeP0b3xWJT8FmkoFqRC27Jr2cb
	 CH9JwlA73EbR9SeQmLP1iavxoRuGnzBv6FElWq/acZ8WTgClC4EPrJLMfY6y9aq9Yel5t
	 jCzg82cQu98FFujLYWrUkggKeYFP9cfWwjiwR9tke4lZhhB0r5/9FaAI9HZkvTaoFHG6O
	 O8+6TFITFuJ6Fdum7EedhW898rNX0l45dzmXkCSxq/QLMMiVsHu6MIdbxRRRBme3vUdpJ
	 ry67NPEyVaj/vlOSz1qoEYwmwtuj4RJMzj/tBUTljndJ2sTPQ70f2uouBX1i5or95qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rYr4b9NEzLo8gBEtWkk+wvp61MX4ZZuCrnYlXyCGuk=;
	b=nXcq/jyoFl7JEnYu3AlC/v2gR98zcD/uSQGF3mzXN2pRbD2mIngru/qso8j9Ljc2+XD3
	 vw2mIhTwzH1vPmkIya9IcutPTt1upsOpTM9GGwavJ2kiab/V2T4Yn7ero5Fo2LdI5fXR9
	 H2KyrlSqUueTEYxVIM90LXAq++mCKAIYkX+j7SQwgeanZCUaCbLU/yiS77y/HDMBWN0GX
	 SwszSA8GcmZ1X3WfAg51iIsIwQkTROtUGSqNam/jbQ7b2OUvJ7224tNUqOLe3NX92qhdw
	 gIz/6o3zhya6tmi2lX4j7KLwqjY9O73OPc+cGau1M0Kqenu2J3pgRDBpuQMnbe6j7FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6EM0QBJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F9F606A31C;
	Wed, 18 Nov 2026 20:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6EM0QBJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231FF1F000C5;
	Wed, 18 Nov 2026 20:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034392;
	bh=/rYr4b9NEzLo8gBEtWkk+wvp61MX4ZZuCrnYlXyCGuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6EM0QBJoZBfDuB1kpiaeOu7eH/1W6/6q1rEAOr5AOGL+M2og+M54DwET/excvDKn
	 9hOUoKIfcVNiMeWMjhsQeiE4a4jHuwIJ0bEvV3wiJEZwRj+VFYbuGoYpFEIQHYNPf5
	 IutKXa5gWXA/leDKdoPCUzgX8AXoP4ZlfpaO05fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0353/3318] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Wed, 18 Nov 2026 15:16:15 +0100
Message-ID: <20261118150326.669690441@linuxfoundation.org>
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
index 598ca38be9676..5ae20ef3c6232 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2267,6 +2267,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



