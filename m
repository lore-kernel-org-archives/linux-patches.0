Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031772;
	b=fIL6EvWdOgl4/DNOKrs0tUqIXKJvwWgifxShoZ4JukC/tTsC41JOmHEWf6HzIcB1HUJF
	 ZhBOflBzVlrAgEP5iufYrJa6ZIhJAHjNc522fb4gZF4zcuhl/1lcQ/3nEV8s/W4WFbVhG
	 9sBqvBjkRaBoSBdie058KcH6g7fs6LXmGIe9nxQkSVrifsj3diSm0Z87HrxEp+e6/+kk5
	 dpqVMHm00UtMO5y3J2Nw1ZOjOzNHmtu1WsOTaILqEIEbOAMhLqKHd3Ac/TDg2l4G9xKHZ
	 PQwmKZWu4/b5f3WxbY9uReOyc40lNABwoV4swGAC+XfNuD9UJmj20IqAiP3sZpBpumQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7U2M97KC1TZC3OQ/g66nrLbhoGMQWSgAczFsI6xipYo=;
	b=caAyd+S/MrGNzVnx89SD5bitVNuFkSiqoXHgPdI1Xy5PPzy83TizPsusN1M3N85qB8Bl
	 EiVjGZD1PtT9xqHnvQrRkTTa2FbEXxlQj024ZwOtA4kanVCFCsEXoQt8S/vlSuEvURHJV
	 4MXZaRdVXgW2wrpGiONdroM1xPRrWVNRyY0QRTxHzGmi0/lUdxxL3tNJBCRgJ6bQJkdvj
	 KCiQf2v01462KNwpXBOpMuAsataheHZYPiBZ8U9PBCM+OHMzfngsPgFNvT4+zv4MoZrOO
	 CJkq/+v2v2ZBv2DpiTXvdGLaMnh/v5TANISDRG8e2KzIZoLOTyjiovOufnVrVBUHeYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwRVbPTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F96606A332;
	Wed, 18 Nov 2026 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwRVbPTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC761F000CB;
	Wed, 18 Nov 2026 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031772;
	bh=7U2M97KC1TZC3OQ/g66nrLbhoGMQWSgAczFsI6xipYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwRVbPTbFO/Gslm7a4mVt1a9fEzHtHHB2/ylV6zwUaZ0xJhMNi6XcIemEGMpDV5Ef
	 mehJL0OgoYCiP+Y7fu0Tbg/ZkoRIcyrERWV+zm3QUB3KVCDDLkTdQa6ZbFz/5uLeDB
	 y9R8vekZwllbjW5ODlsZ5h7oc0grFUPYs7ar7rjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1175/1756] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:55:02 +0100
Message-ID: <20261118150056.725852029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 8ff1161ac5aa02f3261e00f07d6212be2b12384b ]

In some cases (system32 and compat64) due to incorrect assignment wrong
value is being reported. Fix it.

Fixes: 3ddee7f88aaf ("ALSA: Avoid using timespec for struct snd_pcm_status")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261013164256.4949-1-amade@asmblr.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_compat.c | 4 ++--
 sound/core/pcm_native.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index c1c64da2eabd0..865939ce971ea 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -219,8 +219,8 @@ static int snd_pcm_status_user_compat64(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status.audio_tstamp_data,
 		.audio_tstamp_sec = status.audio_tstamp_sec,
 		.audio_tstamp_nsec = status.audio_tstamp_nsec,
-		.driver_tstamp_sec = status.audio_tstamp_sec,
-		.driver_tstamp_nsec = status.audio_tstamp_nsec,
+		.driver_tstamp_sec = status.driver_tstamp_sec,
+		.driver_tstamp_nsec = status.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status.audio_tstamp_accuracy,
 	};
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index ed9d8877f2635..4d0e3dd36c57f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1173,8 +1173,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status64.audio_tstamp_data,
 		.audio_tstamp_sec = status64.audio_tstamp_sec,
 		.audio_tstamp_nsec = status64.audio_tstamp_nsec,
-		.driver_tstamp_sec = status64.audio_tstamp_sec,
-		.driver_tstamp_nsec = status64.audio_tstamp_nsec,
+		.driver_tstamp_sec = status64.driver_tstamp_sec,
+		.driver_tstamp_nsec = status64.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status64.audio_tstamp_accuracy,
 	};
 
-- 
2.53.0



