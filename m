Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049840;
	b=3yt+RFhmmWrqIxQkgCFAyR/oayJi+hbIi1x+O23ZY7sVzvJMb6qSA8CMfrAbrQQYeGdL
	 XHFu6h9IrpTQOgab9krWEkObgHjr4LWJ49WCZam7XvaODozeznMr0yATGaUj8Jbl9unoJ
	 ta+jSTnv1NawJoTCznieEnUgeelCT8phufRKyF2lT9Y0lU2JIIauVFyEMBq/b//+MJtIi
	 yrMMgp2GPotDea5LF51Dk7T/uvNMm/5b57ZOMFd2d8BC89UUVaezg/r8Y00kQq5YJY+g1
	 dT2rPX6VDvGaxMzRcFS6vr/SbC55E4plcHHtFqW86VIGkBLZYZ6yB8JiqR14nsSF5XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JMOKo77APHEuS5/IlCYIRfPmvEroIBsv0quTYl4SR9A=;
	b=1yqArKxIJdhuHMiXb262ff2IjLxajoRPr5XK2LyTvrtZ8jvpeBj6RdB5TjmTxlDrU82c
	 xbI3A6t4maO8WZHaggPc+2d0XB8YrseAY5AxH4FOiR9ZgpyYbqmq8sdUnDXFQaUXM9LLG
	 YV6rcYmf7valzr7PIIRJ+mj6Xw3N00+fQlDSEn/on5xkz9cVeSaLX9zx1/b+T/wu3SZS1
	 cj9N8uQXjnwD2gk/Hdj4UIAa5M5AzF1CNpwh4WOG81OzYJLgx5jS2b0dzl5vY8mlvWgHq
	 PP2Qh8ZjtnP6yYg8S71bH4JBnyln8j3gFz5iyRL5Pc9owCqHUlbDRl1UZgRTEGcmwVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqIb9WVp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7110606A325;
	Thu, 19 Nov 2026 00:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqIb9WVp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0576F1F000C4;
	Thu, 19 Nov 2026 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049840;
	bh=JMOKo77APHEuS5/IlCYIRfPmvEroIBsv0quTYl4SR9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqIb9WVpVZ9r9i6UDrFBCQVwczM3WAD1DZxUpD6B+SGgbqyM9YCrhd4AOGBoouO4t
	 lDTi6WvQop5zTbiork+25NYKRe0Vuc4dVYeNEFx1fmHNi+HD53xqWzQcXqS7Jsaiy2
	 c2RFr23g6aubc4cmMSKXLDLk1o+NytitMoBfnw38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2454/2857] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150329.924551532@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c96483091f30a..dcf07ab6d3b7e 100644
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
index 9e87aa2518411..a0d63453ec739 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1154,8 +1154,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
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



