Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061632;
	b=SV3YXF03eE5NzMYGofITM6yFx/gquf0MN212t33pvubRngitIMNXbBOTKX0H8/dcCa6/
	 HwjPxWQxGpU2monuxNwAbUclGy775vuKfLroDjpE//EGaLmYl0mPWGofPX0M9q3IhSspm
	 op7ljQ8Xtm5heNrb6kvPtytCa3W/Uf+OwauFgQLp9N6ldns/4yBMpm9lCWGRbEkaE3aOH
	 kUmTmj+xDhk9q3a4M3ldGMMi0yZvTRaSuHS3ryQXz+thYfec1W/04yrh74Qwg2gRDUEfY
	 x5YLQ1cTyg6MLgfME6v6xP2UYfjxJx9bFnkF8FMVW8qeO3rIugX/1SpNHUcLVyDGZEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yWCXEYTqdHIZ6j2GSYU6WfgdycA/4pSaH01huKQW5GQ=;
	b=DRSY7SHb0tQa1LBw/OT4ZJINZ2MluvaA9LBSUUpmKQPakc+1sKEzByJyMjESTEqBAW20
	 Rk1SIyE+OeEXCq5EtcwsteAr4JD0nHAXv1ZW+ks8XjsDPN+O9UTUY1KywnNip4hKc7F6v
	 zWckaiTx7dXgAVCEhErZRUg7aKtJ4vVeZKWMFh+2TEH/tbU4LeTGgNmXRZKO/N5sov+fI
	 fJWyJX458PnGOP3AoCA7zOQVQ7D1fOn8N8vsa0ODOIsLxKfOrjylCv4c0kz8UGmzujqEr
	 Zhdt7JSECuAXIYbhocSPeVuo00NjvCOKEhpD5iQtPPzdZdJ9SMMw46/BTYSWwMAHBBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fd4Pbmfn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1508E606A333;
	Thu, 19 Nov 2026 04:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fd4Pbmfn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6421F000C5;
	Thu, 19 Nov 2026 04:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061631;
	bh=yWCXEYTqdHIZ6j2GSYU6WfgdycA/4pSaH01huKQW5GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fd4PbmfnEcIrC6kCHj1lHEe9m+VYRIO9XTDGh599hlhsMfZhEJF20a9nvPuUXch3y
	 T45WRCEm0L+HbM6TZ+yc8DltTky6xmpJU4koRt1zPAASQPH60l0/3f6dePJ/KygkUi
	 2k5gTld6AuFd/ObaOU8+GMIQqBk/XZibrNtQ9NYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1622/1848] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150027.473898029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fd644a31c824c..5fbf084b8a133 100644
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
index 7b6902bf0fd12..322dd71b60e9a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1120,8 +1120,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
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



