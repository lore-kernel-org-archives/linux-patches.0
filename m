Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020065;
	b=lSiYP8WTakiuVfJUX39qGUNlgtGE5ZBzvZSSQzmtEQo8j0uBhAPhWkuvZndg2UKz6kmB
	 4gkt6oHVNMC6x9H72x6oELkPqRRluXo1gyngNy/NQRbtTL2mXLF+T+Xce6e7qIQHjucTZ
	 em27+3lF/txYoJOmhlYooIwN/umO1YEpqB8x0i7QJEhLzAPnZFW0/u5uAOLKTEiLBwQ1L
	 Q6kdIU7XzyNL53VU2h1DmdRyQMSZQPoxwpSV4suBwq5SWfnovJAr34iUQu+a9jlD7cs/t
	 cSdG6fGGc8fJXItVdqQLZ34lBr3mFVXVI3eaZi2hik9SvzkazEl6uSNzRq4lzsq22XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pa/TkyPw3cXc3/sTs9IpCTXSVJL/685ViGu8yhL1FDM=;
	b=ZN/UUyR37ghdxn2Sgb1tD8grMIbcDRMC2sLTUu52yXd0BA6mmtXllNGkLKxBSIA8XMt+
	 kCsfeQZuEo8hiDugsWepYd/a0ZOe+T5wPqarxNtGXaqnnhlZ5WMUMFVPVUwOaUEEuhqjJ
	 w0evfbXphEbl/DT4WfWTl1OzkZ6ujUsKycMwcLOIAwa9VTJtjtnmtSPeNaXhRChprSLk6
	 34llVNbrAYaAErcDYo66cYwP7bjCXwux1RKPbTWpXzFDX+9jK3rl2tJPMf5+JsDu+ICHN
	 e19MLSLoUUHdQp2DFg7VpU8CPdjvR8qA4obF/wIrrpBwxtYZ/1JD1Id8vT3AYeP91Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iPEqcqgs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6B5606A331;
	Wed, 18 Nov 2026 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iPEqcqgs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8DF1F000CA;
	Wed, 18 Nov 2026 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020065;
	bh=pa/TkyPw3cXc3/sTs9IpCTXSVJL/685ViGu8yhL1FDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPEqcqgsCxYoye8SCA3aiOOeADnACKJNaEyO3Y8PXBIDB1AQnLUNVID8ouEw/B3yQ
	 zQICttevbHVcw7IIhgTOEc8b6RhJvVSw48P5gv/LDzXKoIpitP5udnXalutwNKmyJo
	 kczSYz1WHQu2oFn6ETWxUF4aWOGr+G8ACGHu+1XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1818/2651] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:50:58 +0100
Message-ID: <20261118150352.647505446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 55ecf87586c4d..359197aa60760 100644
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
index 1a2148b42e716..d2298bf6518a2 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1200,8 +1200,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
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



