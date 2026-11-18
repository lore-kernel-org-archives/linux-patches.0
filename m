Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041510;
	b=mLC1BGn9e8fsjLzblBiROiiY+ywE7mDvX15omwVapOSaKnwpKaQtAiGaCzj0gLazUfCo
	 FVgFf8Vdu2syseddcQZnZmitZtRMilZsIkgSvQk9ZHgnKWwOUOM0DPo5vjllq1FnOqA4G
	 3x5udxEVzuOsqlF0Q7+olR9q3PML4iW8R3awquFzEt0dGl7O9f55cPtoMkhHLEC63fqmU
	 H026QhfluHEvr0VKnCM2BJ0pfTwIajwywr2TiazIE8H+6gSbWnznhT3/pGVVrT4HAEVaK
	 vHLkv3WINNwOSTAtquk0wbjx3UpUONi1misQHDJLkLXuJIhi90iM4uZWB5WOeeDCGbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0eODmmG1ZFd5/DZLi+KD6lj1ltq97VmqG1h2bhW87Js=;
	b=yJIQb8zf3o8EWG60sZ9cqqVSvm5/H0LMQLSOswRpx/42rrXDz7dl5lFyTuY7ltp6Yjf4
	 k22mF1ZaBkV3vnINCJAZohSF6BLwMm2FhM7FZRT8VXQcoCHJ/sZg7pRGKxulVbPduSOT4
	 FVzm1tHvvJXSwwF+Ctw+3fcaFE4ezj8z/+nc/fBhXtpybiD9lLfGNdfmq1fDGSEt4DIEr
	 psshn8UnLoXssycilCYU+5vuGWWiwfmVHo3nF5VJXazFhSBCvBmkv0odeADOFuZIaghoH
	 4gAlnoDPeso9tekWTqNSRE4XSmtBJomLbzjaxq8BWlmSJt2Xi4vqmUwBfcVQFisFfxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adNombyv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D16606A32C;
	Wed, 18 Nov 2026 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adNombyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7661F000C4;
	Wed, 18 Nov 2026 22:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041510;
	bh=0eODmmG1ZFd5/DZLi+KD6lj1ltq97VmqG1h2bhW87Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adNombyvf835DUDaYiwWpT7eTypSs+TpZKEK7TURHk2Ax5XBPrlZGmYP8yxO1Ffk8
	 WkOAiNmPP712POXv6oit9IwMu0WvwmRgtg0jyyAqAHGTPKt6w7vj3QiMfEnFWsbGHE
	 V2Tx5c5rvzfCUuQUvlAeMnZdZmOEGngsHoRIVQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2838/3318] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:57:40 +0100
Message-ID: <20261118150445.761580920@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 42570787e815d..44b5ef55b03aa 100644
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



