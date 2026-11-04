Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831178;
	b=P7iiTh9VRn/6WpOU43mGSk5D0RvBi+eOJtiW5KWAV7Egt7CsaekjXSAFkPriN4oIqRhg
	 FMHVgdH+ML6BJODZkrbSfqdbZRbAwyx45lczaFZTNUZIMd9Fmn7Yr125pJ9+CDGj74qKF
	 tRV+aZ0kFnfhQdy4rLfg6HaMppXoWjGtfxuKorusMAAT2yzXoO/YaXQVZjfDdQKbP7uWy
	 xt6U+1YmrG7zlfrs7AicqNPiM6wgB/iOSOK0usGRUxb4W5BwZkc+CCDALnzq0q1Vx8Ccn
	 q7BVQUDEVs/3tqKqAVBk9+kCx/VSwQ8hH/A2TQre2omutQKJAxYS5+k3E3aglopZgtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lT39qBndpQUj4AeYQsLNgGzcOw1/V4ylSFj03H93Imo=;
	b=uS3wBG2wCjKwwMy2ySyOlLbGzK8WFLKmXn82jniWfsTTn70sTtgX0yt9U9A0Bac6Apgc
	 S3mt690yqrfBofr8pWXe6VgOnz2I5sY+Io8tbVVNqMUs8pGlOAyqSfeBy9LfiU7xIKAL1
	 k2TJA7+8xsPBTJYERPm6xWTZFdARAxQ5M0yBJlscSjnSDtIX5bJ1H+4qPoPhCYyXoE2C1
	 os68aIsfKaHIPgZMV4e1X3xORk1od2lyHopyTAcUPZuaGdJSfmAKpcgx8weS4xJRkzNRB
	 2X3vR8j9fXk+KPU/0lixWFh4mwIjHJikPg/qMnVsNQdeOiG1C7VVDDXRYniMAtuzDpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wx87GUWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BD7606A332;
	Wed,  4 Nov 2026 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wx87GUWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4041F00919;
	Wed,  4 Nov 2026 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831177;
	bh=lT39qBndpQUj4AeYQsLNgGzcOw1/V4ylSFj03H93Imo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wx87GUWnKn7MtCnLY0y450ZP07fLWkWb3FSKVrEXuNCYrP99dpnOScAhOoIyTqBZk
	 7eiPr65FbGPaBabQWTo8LjNUZD6jaUewt69+B+QZjvN30Qlw6rTbyHMWPRImtfLPdm
	 6gS2KOn2XBoBZskNYYuSbckg5Nc8o2Q0PwmdLZFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Gajdos <matuszpd@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0508/1005] ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers
Date: Wed,  4 Nov 2026 16:04:01 -0500
Message-ID: <20261104211058.167317261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8dcba375bd4a3..be80d9d14e0ad 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2379,6 +2379,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



